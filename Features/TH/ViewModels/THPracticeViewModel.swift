import Foundation

final class THPracticeViewModel: ObservableObject {
    private let repo: THLessonRepository
    private let sound: THSound
    private let player: PromptPlayer

    @Published var phraseIndex: Int = 0

    init(repo: THLessonRepository, sound: THSound, player: PromptPlayer) {
        self.repo = repo
        self.sound = sound
        self.player = player
    }

    func lesson() -> THLesson { repo.lesson(for: sound) }

    func speakCurrent() {
        let phrases = lesson().phrases
        guard phrases.indices.contains(phraseIndex) else { return }
        player.speak(phrases[phraseIndex].text)
    }

    func nextPhrase() {
        let count = lesson().phrases.count
        phraseIndex = (phraseIndex + 1) % max(count, 1)
    }
}

