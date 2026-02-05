import Foundation

final class THLessonViewModel: ObservableObject {
    private let repo: THLessonRepository
    private let store: ProgressStore

    let sound: THSound
    @Published var progress: THProgress

    init(repo: THLessonRepository, store: ProgressStore, sound: THSound) {
        self.repo = repo
        self.store = store
        self.sound = sound
        self.progress = store.loadTHProgress(sound: sound)
    }

    func lesson() -> THLesson {
        repo.lesson(for: sound)
    }

    func bumpPractice() {
        progress.practiceCount += 1
        store.saveTHProgress(progress, sound: sound)
    }
}

