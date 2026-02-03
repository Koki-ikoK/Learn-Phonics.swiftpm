import SwiftUI

struct THQuizView: View {
    private let repo: THLessonRepository
    private let store: ProgressStore
    private let sound: THSound
    private let tts = TTSPromptPlayer()

    @StateObject private var vm: THQuizViewModel

    init(repo: THLessonRepository, store: ProgressStore, sound: THSound) {
        self.repo = repo
        self.store = store
        self.sound = sound
        _vm = StateObject(wrappedValue: THQuizViewModel(repo: repo, store: store, sound: sound))
    }

    var body: some View {
        VStack(spacing: 14) {
            Card(title: "聞いて選ぶ", subtitle: sound.displayTitle) {
                Text("再生して、どっちかタップ。")
                    .foregroundStyle(.secondary)

                PrimaryButton(title: "再生", systemImage: "play.fill") {
                    tts.speak(vm.current.correct)
                }
            }

            Card(title: "選択", subtitle: nil) {
                ForEach(vm.choices, id: \.self) { choice in
                    PrimaryButton(title: choice, systemImage: nil) {
                        _ = vm.answer(choice)
                    }
                }
                if let msg = vm.messageJP {
                    Text(msg)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 6)
                }
            }

            Spacer()

            PrimaryButton(title: "次へ", systemImage: "arrow.right") {
                vm.next()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .padding(16)
        .navigationTitle("Quiz")
    }
}

