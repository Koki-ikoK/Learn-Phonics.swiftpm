import SwiftUI
import AVFoundation

struct THPracticeView: View {
    private let repo: THLessonRepository
    private let store: ProgressStore
    private let sound: THSound

    private let tts = TTSPromptPlayer()

    @StateObject private var practiceVM: THPracticeViewModel
    @StateObject private var recorder = AudioRecorderService()

    // 再生が途中で止まらないように保持
    @State private var audioPlayer: AVAudioPlayer?

    init(repo: THLessonRepository, store: ProgressStore, sound: THSound) {
        self.repo = repo
        self.store = store
        self.sound = sound
        _practiceVM = StateObject(wrappedValue: THPracticeViewModel(repo: repo, sound: sound, player: TTSPromptPlayer()))
    }


    var body: some View {
        let lesson = practiceVM.lesson()
        let phrase = lesson.phrases[practiceVM.phraseIndex]

        ScrollView {
            VStack(spacing: 14) {
                Card(title: "フレーズ", subtitle: sound.displayTitle) {
                    Text(phrase.text)
                        .font(.title3)
                        .fontWeight(.semibold)

                    if let note = phrase.noteJP {
                        Text(note).foregroundStyle(.secondary)
                    }

                    HStack(spacing: 10) {
                        PrimaryButton(title: "お手本", systemImage: "speaker.wave.2.fill") {
                            practiceVM.speakCurrent()
                        }
                        PrimaryButton(title: "次", systemImage: "arrow.right") {
                            practiceVM.nextPhrase()
                        }
                    }
                }

                Card(title: "録音", subtitle: "まずは録音→再生で練習を成立させる") {
                    WaveformView(levels: recorder.levels)

                    HStack(spacing: 10) {
                        if recorder.isRecording {
                            PrimaryButton(title: "停止", systemImage: "stop.fill") {
                                recorder.stop()
                            }
                        } else {
                            PrimaryButton(title: "録音", systemImage: "mic.fill") {
                                do { try recorder.start() } catch { print(error) }
                            }
                        }

                        PrimaryButton(title: "再生", systemImage: "play.fill") {
                            guard let url = recorder.lastRecordingURL else { return }
                            audioPlayer = try? AVAudioPlayer(contentsOf: url)
                            audioPlayer?.prepareToPlay()
                            audioPlayer?.play()
                        }
                    }
                }
            }
            .padding(16)
        }
        .navigationTitle("Practice")
    }
}

