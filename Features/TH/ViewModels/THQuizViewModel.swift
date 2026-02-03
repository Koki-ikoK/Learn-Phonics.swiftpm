import Foundation

final class THQuizViewModel: ObservableObject {
    private let repo: THLessonRepository
    private let store: ProgressStore
    private let sound: THSound

    @Published var current: MinimalPair
    @Published var choices: [String]
    @Published var messageJP: String? = nil

    private var progress: THProgress

    init(repo: THLessonRepository, store: ProgressStore, sound: THSound) {
        self.repo = repo
        self.store = store
        self.sound = sound

        let lesson = repo.lesson(for: sound)
        let first = lesson.minimalPairs.first ?? MinimalPair(correct: "this", commonMistake: "dis")

        self.current = first
        self.choices = [first.correct, first.commonMistake].shuffled()

        self.progress = store.loadTHProgress(sound: sound)
    }

    func next() {
        let lesson = repo.lesson(for: sound)
        let picked = lesson.minimalPairs.randomElement() ?? MinimalPair(correct: "this", commonMistake: "dis")
        current = picked
        choices = [picked.correct, picked.commonMistake].shuffled()
        messageJP = nil
    }

    @discardableResult
    func answer(_ text: String) -> Bool {
        progress.quizTotalCount += 1
        let ok = (text == current.correct)
        if ok { progress.quizCorrectCount += 1 }

        store.saveTHProgress(progress, sound: sound)
        messageJP = ok ? "OK！" : "惜しい。舌の位置をもう一度チェック。"
        return ok
    }
}

