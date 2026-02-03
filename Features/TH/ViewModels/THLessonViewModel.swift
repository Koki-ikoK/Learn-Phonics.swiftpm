import Foundation

final class THLessonViewModel: ObservableObject {
    private let repo: THLessonRepository
    private let store: ProgressStore

    @Published var selectedSound: THSound = .eth
    @Published var progress: THProgress = THProgress()

    init(repo: THLessonRepository, store: ProgressStore) {
        self.repo = repo
        self.store = store
        self.progress = store.loadTHProgress(sound: selectedSound)
    }

    func lesson() -> THLesson {
        repo.lesson(for: selectedSound)
    }

    func select(_ sound: THSound) {
        selectedSound = sound
        progress = store.loadTHProgress(sound: sound)
    }

    func bumpPractice() {
        progress.practiceCount += 1
        store.saveTHProgress(progress, sound: selectedSound)
    }
}

