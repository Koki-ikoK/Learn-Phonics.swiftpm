import Foundation
import AVFoundation
import SoundAnalysis

// 🌟 @MainActor をつけることで、Swiftのデータ競合警告をすべて解消します
@MainActor
class SoundAnalysisService: NSObject, ObservableObject, SNResultsObserving {
    private let audioEngine = AVAudioEngine()
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    
    @Published var lastResult: String = "---"
    @Published var isRunning = false
    @Published var audioLevel: Float = 0
    
    var onResult: ((String) -> Void)?
    
    func start() throws {
            // 1. 二重起動を確実に防止
            if isRunning { stop() }
            
            let inputNode = audioEngine.inputNode
            
            // 🌟 重要：シミュレータのバグ対策
            // 0Hzのまま進むとクラッシュするため、準備ができるまで待つかデフォルト値を設定
            var inputFormat = inputNode.inputFormat(forBus: 0)
            
            if inputFormat.sampleRate == 0 {
                // もし0Hzだったら、標準的な44.1kHzで強制上書きしてクラッシュを防ぐ
                inputFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1) ?? inputFormat
            }
            
            // 2. アナライザーの初期化
            streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
            
            // 3. AIモデルのロード
            guard let modelURL = Bundle.main.url(forResource: "PhonicsModel", withExtension: "mlmodelc") else {
                print("❌ AIモデルが見つかりません")
                return
            }
            
            let model = try MLModel(contentsOf: modelURL)
            let request = try SNClassifySoundRequest(mlModel: model)
            
            try streamAnalyzer?.add(request, withObserver: self)
            
            // 4. マイクのタップ（録音開始）
            // 既存のタップがあれば削除
            inputNode.removeTap(onBus: 0)
            
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputFormat) { [weak self] buffer, time in
                self?.streamAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
                
                // 音量計算
                let samples = Array(UnsafeBufferPointer(start: buffer.floatChannelData![0], count: Int(buffer.frameLength)))
                let level = samples.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength)
                
                Task { @MainActor in
                    self?.audioLevel = level
                }
            }
            
            // 5. エンジン開始
            audioEngine.prepare() // 🌟 開始前に念入りに準備
            try audioEngine.start()
            
            self.isRunning = true
        }
    
    func stop() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        isRunning = false
        lastResult = "---"
        streamAnalyzer = nil
    }
    
    // AIが音を検出した時の処理
    nonisolated func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let res = result as? SNClassificationResult,
              let top = res.classifications.first else { return }
        
        if top.confidence > 0.3 {
            let label = top.identifier
            Task { @MainActor in
                self.lastResult = label
                self.onResult?(label)
            }
        }
    }
    
    nonisolated func request(_ request: SNRequest, didFailWithError error: Error) {
        print("❌ AI解析エラー: \(error.localizedDescription)")
    }
}
