import Foundation
import SoundAnalysis
import AVFoundation
import CoreML
import Combine
import UIKit

// 🌟 結果を受け取る影武者（ここにデバッグ用のプリント文を追加しました！）
final class PhonicsResultsObserver: NSObject, SNResultsObserving, @unchecked Sendable {
    var onResult: (@Sendable (String) -> Void)?
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let res = result as? SNClassificationResult else { return }
        
        // 🌟 16時提出に向けた最強のデバッグ：AIが迷っている上位3つをコンソールに出す！
        print("--- 🤖 AIの脳内 ---")
        for classification in res.classifications.prefix(3) {
            let percent = Int(classification.confidence * 100)
            print("候補: \(classification.identifier) (自信: \(percent)%)")
        }
        print("-------------------")
        
        if let top = res.classifications.first {
            let identifier = top.identifier
            onResult?(identifier)
        }
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("❌ AI解析エラー: \(error.localizedDescription)")
    }
}

// メインのサービス
final class SoundAnalysisService: ObservableObject, @unchecked Sendable {
    @Published var lastResult: String = "---"
    @Published var isRunning = false
    @Published var audioLevel: Float = 0.0
    
    private var analyzer: SNAudioStreamAnalyzer?
    private var resultsRequest: SNClassifySoundRequest?
    private let analysisQueue = DispatchQueue(label: "com.example.AnalysisQueue")
    private let audioEngine = AVAudioEngine()
    private let observer = PhonicsResultsObserver()

    init() {
        setupAnalyzer()
        
        nonisolated(unsafe) let safeSelf = self
        observer.onResult = { identifier in
            DispatchQueue.main.async { safeSelf.lastResult = identifier }
        }
    }

    private func setupAnalyzer() {
        do {
            guard let dataAsset = NSDataAsset(name: "PhonicsModel") else { return }
            let tempDir = FileManager.default.temporaryDirectory
            let tempModelURL = tempDir.appendingPathComponent("PhonicsClassifier.mlmodel")
            
            if FileManager.default.fileExists(atPath: tempModelURL.path) {
                try FileManager.default.removeItem(at: tempModelURL)
            }
            try dataAsset.data.write(to: tempModelURL, options: .atomic)
            
            let compiledURL = try MLModel.compileModel(at: tempModelURL)
            let model = try MLModel(contentsOf: compiledURL)
            self.resultsRequest = try SNClassifySoundRequest(mlModel: model)
            print("✅ AIモデルのアプリ内コンパイル完了！")
        } catch {
            print("❌ モデル準備エラー: \(error.localizedDescription)")
        }
    }

    func start() throws {
        DispatchQueue.main.async { self.lastResult = "判定中..." }
        
        #if os(iOS)
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker])
        try? session.setActive(true, options: .notifyOthersOnDeactivation)
        #endif
        
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        guard format.sampleRate > 0 else { return }
        inputNode.removeTap(onBus: 0)
        
        let request = self.resultsRequest
        let safeObserver = self.observer
        
        self.analysisQueue.sync {
            let newAnalyzer = SNAudioStreamAnalyzer(format: format)
            if let req = request {
                try? newAnalyzer.add(req, withObserver: safeObserver)
            }
            self.analyzer = newAnalyzer
        }
        
        nonisolated(unsafe) let safeSelf = self
        
        inputNode.installTap(onBus: 0, bufferSize: 8192, format: format) { buffer, time in
            guard buffer.frameLength > 0, time.isSampleTimeValid, time.sampleTime >= 0 else { return }
            
            if let channelData = buffer.floatChannelData?[0] {
                let frames = UnsafeBufferPointer(start: channelData, count: Int(buffer.frameLength))
                var sum: Float = 0
                for frame in frames { sum += frame * frame }
                let rms = sqrt(sum / Float(frames.count))
                DispatchQueue.main.async { safeSelf.audioLevel = rms }
            }
            
            safeSelf.analysisQueue.async {
                safeSelf.analyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        DispatchQueue.main.async { self.isRunning = true }
    }

    func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        DispatchQueue.main.async { self.isRunning = false }
    }
}
