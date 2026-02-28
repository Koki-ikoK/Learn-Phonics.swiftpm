import SwiftUI
import AVFoundation

struct THPracticeView: View {
    private let repo: THLessonRepository
    private let store: ProgressStore
    private let sound: THSound

    private let tts = TTSPromptPlayer()

    @StateObject private var practiceVM: THPracticeViewModel
    @State private var audioPlayer: AVAudioPlayer?

    init(repo: THLessonRepository, store: ProgressStore, sound: THSound) {
        self.repo = repo
        self.store = store
        self.sound = sound
        _practiceVM = StateObject(wrappedValue: THPracticeViewModel(repo: repo, sound: sound, player: TTSPromptPlayer()))
    }

    // 🌟 PhonicsAICheckViewに渡すための正解データ
    private var expectedMLClass: String {
        switch sound {
        case .theta: return "think"
        case .eth: return "this"
        }
    }

    var body: some View {
        let lesson = practiceVM.lesson()
        let phrase = lesson.phrases[practiceVM.phraseIndex]

        ScrollView {
            VStack(spacing: 24) { // 少し隙間を広げて見やすく
                Card(title: "単語", subtitle: sound.displayTitle) {
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

                // 🌟 ここから下が大変身！ごちゃごちゃした録音機能を消して、専用のテスト画面へ繋ぐボタンに！
                VStack(spacing: 10) {
                    Text("学習が終わったらテストに挑戦！")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    NavigationLink(destination: PhonicsAICheckView(targetSymbol: expectedMLClass)) {
                        HStack {
                            Image(systemName: "mic.badge.plus")
                                .font(.title)
                            Text("AI発音テストを始める")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
            .padding(16)
        }
        .navigationTitle("Practice")
    }
}
