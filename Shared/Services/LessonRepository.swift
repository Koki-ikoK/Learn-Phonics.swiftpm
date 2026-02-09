//
//  LessonRepogitory.swift
//  Learn-Phonics
//
//  Created by Koki Iwaki on 2026/02/04.
//

import Foundation

protocol THLessonRepository {
    func lessons() -> [THLesson]
    func lesson(for sound: THSound) -> THLesson
}

final class InMemoryTHLessonRepository: THLessonRepository {
    private let all: [THLesson]

    init(all: [THLesson]) {
        self.all = all
    }

    func lessons() -> [THLesson] { all }

    func lesson(for sound: THSound) -> THLesson {
        all.first(where: { $0.sound == sound }) ?? all[0]
    }
}
