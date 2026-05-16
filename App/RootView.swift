import SwiftUI

struct RootView: View {
    // 既存のデータ準備
    private let repo: THLessonRepository = THContent.makeRepository()
    private let store: any ProgressStore = UserDefaultsProgressStore()

    // 🌟 16時提出用の秘密兵器：スタート画面を表示中かどうかを管理
    @State private var showMainView = false

    var body: some View {
        ZStack {
            if showMainView {
                // 🚀 メインの学習画面（フェードインで登場）
                NavigationStack {
                    PhonemeSelectView(repo: repo, store: store)
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95))) // ヌルッと登場
            } else {
                // ✨ カッコいいスタート画面
                // 前のステップで作った StartSplashScreenView を呼び出す
                StartSplashScreenView(isActive: $showMainView)
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showMainView)
    }
}
