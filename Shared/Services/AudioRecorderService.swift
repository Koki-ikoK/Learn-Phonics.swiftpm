//
//  AudioRecorderService.swift
//  Learn-Phonics
//
//  Created by Koki Iwaki on 2026/02/04.
//

import AVFoundation
import Foundation

final class AudioRecorderService: NSObject, ObservableObject, AVAudioRecorderDelegate {
    @Published private(set) var isRecording: Bool = false
    @Published private(set) var levels: [Float] = []   // waveform用（簡易）
    @Published private(set) var lastRecordingURL: URL?

    private var recorder: AVAudioRecorder?
    private var meterTimer: Timer?

    func start() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowBluetooth])
        try session.setActive(true)

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("recording-\(UUID().uuidString).m4a")

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        let r = try AVAudioRecorder(url: url, settings: settings)
        r.isMeteringEnabled = true
        r.delegate = self
        r.record()

        recorder = r
        isRecording = true
        levels = []
        lastRecordingURL = nil

        meterTimer?.invalidate()
        meterTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self, let recorder = self.recorder else { return }
            recorder.updateMeters()
            let db = recorder.averagePower(forChannel: 0)
            let normalized = Self.normalize(db: db)
            self.levels.append(normalized)
            if self.levels.count > 120 { self.levels.removeFirst(self.levels.count - 120) }
        }
    }

    func stop() {
        recorder?.stop()
        meterTimer?.invalidate()
        meterTimer = nil
        isRecording = false
        lastRecordingURL = recorder?.url
        recorder = nil
    }

    private static func normalize(db: Float) -> Float {
        // db (-60〜0) → 0〜1（ざっくり）
        let clamped = max(-60, min(0, db))
        return (clamped + 60) / 60
    }
}
