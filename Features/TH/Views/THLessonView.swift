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

    // 🌟 追加：ここで、AIに渡す正解データ（think か this）を決定する！
    private var expectedMLClass: String {
        switch sound {
        case .theta: return "think"
        case .eth: return "this"
        }
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

                NavigationLink {
                    THQuizView(repo: repo, store: store, sound: sound)
                } label: {
                    NavButtonLikeRow(icon: "ear", title: "聞き分けクイズ")
                }
                .buttonStyle(.plain)

                // 🌟 最大の変更点：THPracticeViewを消し去り、直接AIテスト画面へ放り込む！
                NavigationLink {
                    PhonicsAICheckView(targetSymbol: expectedMLClass)
                } label: {
                    // ついでにボタンの見た目も少し「テストっぽく」カッコよく変更！
                    NavButtonLikeRow(icon: "mic.badge.plus", title: "AI発音テストに挑戦！")
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
