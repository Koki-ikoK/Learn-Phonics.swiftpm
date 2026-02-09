import SwiftUI

struct RootView: View {
    // ここはあなたの既存の生成方法に合わせてOK
    private let repo: THLessonRepository = THContent.makeRepository()

    // ここはあなたのプロジェクトにある ProgressStore の具体型に合わせてください
    // 例: UserDefaultsProgressStore() / InMemoryProgressStore() など
    private let store: any ProgressStore = UserDefaultsProgressStore()

    var body: some View {
        NavigationStack {
            PhonemeSelectView(repo: repo, store: store)
        }
        
        .navigationViewStyle(.stack)
    }
}

