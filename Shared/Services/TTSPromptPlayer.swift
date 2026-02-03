//
//  TTSPromptPlayer.swift
//  Learn-Phonics
//
//  Created by Koki Iwaki on 2026/02/04.
//

import AVFoundation
import Foundation

protocol PromptPlayer {
    func speak(_ text: String)
}

final class TTSPromptPlayer: PromptPlayer {
    private let synth = AVSpeechSynthesizer()

    func speak(_ text: String) {
        let u = AVSpeechUtterance(string: text)
        u.voice = AVSpeechSynthesisVoice(language: "en-US")
        u.rate = 0.45
        u.pitchMultiplier = 1.0
        synth.stopSpeaking(at: .immediate)
        synth.speak(u)
    }
}
