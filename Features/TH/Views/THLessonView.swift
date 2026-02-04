import SwiftUI

struct THLessonView: View {
    private let repo: THLessonRepository
    private let store: ProgressStore

    @StateObject private var vm: THLessonViewModel

    init(repo: THLessonRepository, store: ProgressStore) {
        self.repo = repo
        self.store = store
        _vm = StateObject(wrappedValue: THLessonViewModel(repo: repo, store: store))
    }

    var body: some View {
        let lesson = vm.lesson()

        ScrollView {
            VStack(spacing: 14) {

                Card(title: "TH", subtitle: "日本人がつまずきやすい /θ/ と /ð/") {
                    Text("正答率: \(Int(vm.progress.accuracy * 100))%  / 練習: \(vm.progress.practiceCount)回")
                        .font(.subheadline)
                }

                Card(title: "音を選ぶ", subtitle: "まずは /ð/ (this) → /θ/ (think) の順がおすすめ") {
                    Picker("Sound", selection: Binding(
                        get: { vm.selectedSound },
                        set: { vm.select($0) }
                    )) {
                        ForEach(THSound.allCases) { s in
                            Text(s.displayTitle).tag(s)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text(vm.selectedSound.jpHint)
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
                    THQuizView(repo: repo, store: store, sound: vm.selectedSound)
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "ear")
                        Text("聞き分けクイズ").fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)

                NavigationLink {
                    THPracticeView(repo: repo, store: store, sound: vm.selectedSound)
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "mic")
                        Text("話す練習（録音）").fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)

            }
            .padding(16)
        }
        .navigationTitle("TH Lesson")
    }
}

