//
//  LessonModels.swift
//  Learn-Phonics
//
//  Created by Koki Iwaki on 2026/02/04.
//

import Foundation

enum LessonCategory: String, Codable, CaseIterable, Identifiable {
    case th = "TH"
    var id: String { rawValue }
}

enum THSound: String, Codable, CaseIterable, Identifiable {
    case theta = "θ"   // /θ/ think
    case eth   = "ð"   // /ð/ this
    var id: String { rawValue }

    var displayTitle: String {
        switch self {
        case .theta: return "/θ/ (think)"
        case .eth:   return "/ð/ (this)"
        }
    }

    var jpHint: String {
        switch self {
        case .theta: return "無声音：息だけで擦る"
        case .eth:   return "有声音：喉も震わせる"
        }
    }
}

struct MinimalPair: Identifiable, Codable, Hashable {
    let id: UUID
    let correct: String
    let commonMistake: String
    let noteJP: String?

    init(correct: String, commonMistake: String, noteJP: String? = nil) {
        self.id = UUID()
        self.correct = correct
        self.commonMistake = commonMistake
        self.noteJP = noteJP
    }
}

struct PracticePhrase: Identifiable, Codable, Hashable {
    let id: UUID
    let text: String
    let noteJP: String?

    init(_ text: String, noteJP: String? = nil) {
        self.id = UUID()
        self.text = text
        self.noteJP = noteJP
    }
}

struct THLesson: Identifiable, Codable, Hashable {
    let id: UUID
    let sound: THSound
    let overviewJP: String
    let mouthTipJP: String
    let minimalPairs: [MinimalPair]
    let phrases: [PracticePhrase]

    init(sound: THSound,
         overviewJP: String,
         mouthTipJP: String,
         minimalPairs: [MinimalPair],
         phrases: [PracticePhrase]) {
        self.id = UUID()
        self.sound = sound
        self.overviewJP = overviewJP
        self.mouthTipJP = mouthTipJP
        self.minimalPairs = minimalPairs
        self.phrases = phrases
    }
}
