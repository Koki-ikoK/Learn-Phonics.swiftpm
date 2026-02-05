import Foundation
import AVFoundation

@MainActor
final class AudioRecorderService: NSObject, ObservableObject {

    // 録音状態（外からは読み取りだけ）
    @Published private(set) var isRecording: Bool = false

    // 波形表示用（0.0〜1.0 の配列）
    @Published private(set) var levels: [Float] = []

    private var recorder: AVAudioRecorder?
    private var meterTimer: Timer?

    // 録音ファイルのURL（必要ならUI側で利用）
    var recordingURL: URL? { recorder?.url }
    @MainActor
    deinit {
        meterTimer?.invalidate()
    }

    /// 録音開始
    func startRecording() throws {
        // すでに録音中なら何もしない
        if isRecording { return }

        let session = AVAudioSession.sharedInstance()

        // allowBluetooth は allowBluetoothHFP に置き換え（警告対策）
        try session.setCategory(.playAndRecord,
                                mode: .default,
                                options: [.defaultToSpeaker, .allowBluetoothHFP])
        try session.setActive(true)

        // 一時ファイルに保存
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("recording.m4a")

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        let r = try AVAudioRecorder(url: url, settings: settings)
        r.delegate = self
        r.isMeteringEnabled = true
        r.prepareToRecord()
        r.record()

        recorder = r
        isRecording = true

        levels.removeAll()
        startMetering()
    }

    /// 録音停止
    func stopRecording() {
        guard isRecording else { return }

        stopMetering()
        recorder?.stop()
        recorder = nil
        isRecording = false
    }

    // MARK: - Metering

    private func startMetering() {
        meterTimer?.invalidate()

        // 20fpsくらい（0.05秒）
        meterTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self else { return }
            guard let r = self.recorder, r.isRecording else { return }

            r.updateMeters()

            // dB: -160...0 くらい
            let db = r.averagePower(forChannel: 0)

            // 見た目用に -60...0 を 0...1 にマッピング
            let minDB: Float = -60
            let clamped = max(minDB, min(0, db))
            let normalized = (clamped - minDB) / (0 - minDB)   // 0...1

            self.levels.append(normalized)

            // 配列が無限に増えないように上限をかける
            let maxCount = 120
            if self.levels.count > maxCount {
                self.levels.removeFirst(self.levels.count - maxCount)
            }
        }

        meterTimer?.tolerance = 0.02
    }

    private func stopMetering() {
        meterTimer?.invalidate()
        meterTimer = nil
    }
}

// MARK: - AVAudioRecorderDelegate
extension AudioRecorderService: AVAudioRecorderDelegate {

    nonisolated func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        Task { @MainActor in
            self.stopRecording()
        }
    }

    nonisolated func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        Task { @MainActor in
            self.stopRecording()
        }
    }
}

