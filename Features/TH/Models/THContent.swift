//
//  THContent.swift
//  Learn-Phonics
//
//  Created by Koki Iwaki on 2026/02/04.
//

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
                .init(correct: "three", commonMistake: "free"),
                .init(correct: "thick", commonMistake: "tick")
            ],
            phrases: [
                .init("I think three things.", noteJP: "ゆっくりでOK"),
                .init("Think thin thoughts.")
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
                .init(correct: "those", commonMistake: "doze")
            ],
            phrases: [
                .init("This is the one.", noteJP: "the /ðə/ も一緒に練習"),
                .init("They think that this is theirs.")
            ]
        )

        return InMemoryTHLessonRepository(all: [eth, theta]) // /ð/→/θ/ の順で成果出やすい
    }
}
