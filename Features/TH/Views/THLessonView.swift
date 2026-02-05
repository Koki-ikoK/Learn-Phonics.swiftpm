import SwiftUI

struct THLessonView: View {
    private let repo: THLessonRepository
    private let store: ProgressStore
    private let sound: THSound

    @StateObject private var vm: THLessonViewModel

    init(repo: THLessonRepository, store: ProgressStore, sound: THSound) {
        self.repo = repo
        self.store = store
        self.sound = sound
        _vm = StateObject(wrappedValue: THLessonViewModel(repo: repo, store: store, sound: sound))
    }

    var body: some View {
        let lesson = vm.lesson()

        ScrollView {
            VStack(spacing: 14) {

                Card(title: sound.displayTitle, subtitle: sound.jpHint) {
                    Text("正答率: \(Int(vm.progress.accuracy * 100))%  / 練習: \(vm.progress.practiceCount)回")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Card(title: "概要", subtitle: nil) {
                    Text(lesson.overviewJP)
                    Divider().padding(.vertical, 6)
                    Text("口のコツ: \(lesson.mouthTipJP)")
                        .foregroundStyle(.secondary)
                }

                // 画面遷移：NavigationLink ラベル内に Button を入れない
                NavigationLink {
                    THQuizView(repo: repo, store: store, sound: sound)
                } label: {
                    NavButtonLikeRow(icon: "ear", title: "聞き分けクイズ")
                }
                .buttonStyle(.plain)

                NavigationLink {
                    THPracticeView(repo: repo, store: store, sound: sound)
                } label: {
                    NavButtonLikeRow(icon: "mic", title: "話す練習（録音）")
                }
                .buttonStyle(.plain)
            }
            .padding(16)
        }
        .navigationTitle("Lesson")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct NavButtonLikeRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
            Text(title).fontWeight(.semibold)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
        .background(.thinMaterial)
        .cornerRadius(16)
    }
}

