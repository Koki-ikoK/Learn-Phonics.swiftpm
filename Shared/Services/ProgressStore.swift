//
//  ProgressStore.swift
//  Learn-Phonics
//
//  Created by Koki Iwaki on 2026/02/04.
//

import Foundation

struct THProgress: Codable {
    var quizCorrectCount: Int = 0
    var quizTotalCount: Int = 0
    var practiceCount: Int = 0

    var accuracy: Double {
        guard quizTotalCount > 0 else { return 0 }
        return Double(quizCorrectCount) / Double(quizTotalCount)
    }
}

protocol ProgressStore {
    func loadTHProgress(sound: THSound) -> THProgress
    func saveTHProgress(_ progress: THProgress, sound: THSound)
}

final class UserDefaultsProgressStore: ProgressStore {
    private let defaults = UserDefaults.standard

    private func key(_ sound: THSound) -> String {
        "progress.th.\(sound.rawValue)"
    }

    func loadTHProgress(sound: THSound) -> THProgress {
        guard let data = defaults.data(forKey: key(sound)),
              let progress = try? JSONDecoder().decode(THProgress.self, from: data)
        else { return THProgress() }
        return progress
    }

    func saveTHProgress(_ progress: THProgress, sound: THSound) {
        let data = try? JSONEncoder().encode(progress)
        defaults.set(data, forKey: key(sound))
    }
}
