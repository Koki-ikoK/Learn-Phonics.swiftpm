import Foundation

enum THContent {
    static func makeRepository() -> InMemoryTHLessonRepository {
        let theta = THLesson(
            sound: .theta,
            overviewJP: "THの無声音 /θ/。息だけで“スー”と擦る音。日本語だと /s/ や /t/ に寄りやすい。",
            mouthTipJP: "舌先を上の前歯の間に軽く出す（or 前歯の裏に当てる）→ 息を擦る。声は出さない。",
            minimalPairs: [
                .init(correct: "think", commonMistake: "sink", noteJP: "sっぽくなると通じにくい"),
                .init(correct: "thin", commonMistake: "sin"),
                .init(correct: "thank", commonMistake: "tank"),
                .init(correct: "three", commonMistake: "free"),
                .init(correct: "thick", commonMistake: "tick"),
                .init(correct: "thumb", commonMistake: "sum")
            ],
            // ✅ Practiceは「単語」にする（ここが話す練習で使われる）
            phrases: [
                .init("think", noteJP: "無声音 /θ/"),
                .init("thin"),
                .init("thank"),
                .init("three"),
                .init("thick"),
                .init("thumb")
            ]
        )

        let eth = THLesson(
            sound: .eth,
            overviewJP: "THの有声音 /ð/。舌の位置は同じで、声（喉の震え）も乗せる。/d/ や /z/ に寄りやすい。",
            mouthTipJP: "舌先を前歯の間→ 息を擦りつつ“声も出す”。喉に手を当てて震えを確認。",
            minimalPairs: [
                .init(correct: "this", commonMistake: "dis", noteJP: "dに寄るのが定番ミス"),
                .init(correct: "they", commonMistake: "day"),
                .init(correct: "then", commonMistake: "den"),
                .init(correct: "those", commonMistake: "doze"),
                .init(correct: "these", commonMistake: "deez"),
                .init(correct: "there", commonMistake: "dare")
            ],
            // ✅ Practiceは「単語」にする
            phrases: [
                .init("this", noteJP: "有声音 /ð/"),
                .init("they"),
                .init("then"),
                .init("those"),
                .init("these"),
                .init("there")
            ]
        )

        return InMemoryTHLessonRepository(all: [eth, theta]) // /ð/→/θ/ の順
    }
}

