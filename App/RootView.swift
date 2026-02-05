import SwiftUI

struct RootView: View {
    private let repo: THLessonRepository = THContent.makeRepository()
    private let store: any ProgressStore = UserDefaultsProgressStore() // ←具体型に置換

    var body: some View {
        NavigationStack {
            PhonemeSelectView(repo: repo, store: store)
        }
    }
}

