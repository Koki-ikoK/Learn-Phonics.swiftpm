//
//  PhonemeQuizData.swift
//  Phonix
//
//  Created by Koki Iwaki on 2026/03/01.
//
import Foundation

// 🌟 これが足りていないため「Cannot find type 'PhonemeQuizData'」が出ています
struct PhonemeQuizData: Identifiable {
    let id = UUID()
    let symbol: String        // 発音記号
    let targetWord: String    // 正解の単語
    let dummyWords: [String]  // ひっかけの単語リスト
}
struct QuizRepository {
    static let allQuizzes: [String: [PhonemeQuizData]] = [
        // --- Monophthongs (短母音・長母音) ---
        "æ": [
            PhonemeQuizData(symbol: "æ", targetWord: "cat", dummyWords: ["cut", "cot"]),
            PhonemeQuizData(symbol: "æ", targetWord: "bat", dummyWords: ["but", "bought"]),
            PhonemeQuizData(symbol: "æ", targetWord: "bag", dummyWords: ["bug", "bog"])
        ],
        "ɛ": [
            PhonemeQuizData(symbol: "ɛ", targetWord: "bed", dummyWords: ["bad", "bud"]),
            PhonemeQuizData(symbol: "ɛ", targetWord: "desk", dummyWords: ["disk", "dusk"]),
            PhonemeQuizData(symbol: "ɛ", targetWord: "pen", dummyWords: ["pan", "pin"])
        ],
        "ɪ": [
            PhonemeQuizData(symbol: "ɪ", targetWord: "sit", dummyWords: ["seat", "set"]),
            PhonemeQuizData(symbol: "ɪ", targetWord: "ship", dummyWords: ["sheep", "shop"]),
            PhonemeQuizData(symbol: "ɪ", targetWord: "hit", dummyWords: ["heat", "hat"])
        ],
        "ɑ": [
            PhonemeQuizData(symbol: "ɑ", targetWord: "hot", dummyWords: ["hat", "hut"]),
            PhonemeQuizData(symbol: "ɑ", targetWord: "box", dummyWords: ["backs", "bucks"]),
            PhonemeQuizData(symbol: "ɑ", targetWord: "stop", dummyWords: ["step", "stomp"])
        ],
        "ʌ": [
            PhonemeQuizData(symbol: "ʌ", targetWord: "cup", dummyWords: ["cap", "cop"]),
            PhonemeQuizData(symbol: "ʌ", targetWord: "luck", dummyWords: ["lock", "look"]),
            PhonemeQuizData(symbol: "ʌ", targetWord: "duck", dummyWords: ["dock", "dark"])
        ],
        "i": [
            PhonemeQuizData(symbol: "i", targetWord: "see", dummyWords: ["sit", "set"]),
            PhonemeQuizData(symbol: "i", targetWord: "meet", dummyWords: ["met", "mat"]),
            PhonemeQuizData(symbol: "i", targetWord: "key", dummyWords: ["gay", "guy"])
        ],
        "u": [
            PhonemeQuizData(symbol: "u", targetWord: "blue", dummyWords: ["blew", "blow"]),
            PhonemeQuizData(symbol: "u", targetWord: "moon", dummyWords: ["main", "men"]),
            PhonemeQuizData(symbol: "u", targetWord: "pool", dummyWords: ["pull", "paul"])
        ],
        "ɔ": [
            PhonemeQuizData(symbol: "ɔ", targetWord: "thought", dummyWords: ["that", "those"]),
            PhonemeQuizData(symbol: "ɔ", targetWord: "saw", dummyWords: ["so", "say"]),
            PhonemeQuizData(symbol: "ɔ", targetWord: "call", dummyWords: ["coal", "kill"])
        ],
        "ʊ": [
            PhonemeQuizData(symbol: "ʊ", targetWord: "book", dummyWords: ["back", "buck"]),
            PhonemeQuizData(symbol: "ʊ", targetWord: "foot", dummyWords: ["food", "fat"]),
            PhonemeQuizData(symbol: "ʊ", targetWord: "good", dummyWords: ["god", "gold"])
        ],
        "ə": [
            PhonemeQuizData(symbol: "ə", targetWord: "about", dummyWords: ["abut", "abet"]),
            PhonemeQuizData(symbol: "ə", targetWord: "sofa", dummyWords: ["safe", "soft"]),
            PhonemeQuizData(symbol: "ə", targetWord: "banana", dummyWords: ["bonanza", "bandage"])
        ],
        
        // --- Diphthongs (二重母音) ---
        "eɪ": [
            PhonemeQuizData(symbol: "eɪ", targetWord: "say", dummyWords: ["sigh", "see"]),
            PhonemeQuizData(symbol: "eɪ", targetWord: "plate", dummyWords: ["plot", "plait"]),
            PhonemeQuizData(symbol: "eɪ", targetWord: "main", dummyWords: ["mine", "mean"])
        ],
        "aɪ": [
            PhonemeQuizData(symbol: "aɪ", targetWord: "sky", dummyWords: ["ski", "skip"]),
            PhonemeQuizData(symbol: "aɪ", targetWord: "high", dummyWords: ["he", "hay"]),
            PhonemeQuizData(symbol: "aɪ", targetWord: "night", dummyWords: ["neat", "not"])
        ],
        "oʊ": [
            PhonemeQuizData(symbol: "oʊ", targetWord: "go", dummyWords: ["get", "got"]),
            PhonemeQuizData(symbol: "oʊ", targetWord: "boat", dummyWords: ["boot", "bought"]),
            PhonemeQuizData(symbol: "oʊ", targetWord: "show", dummyWords: ["she", "shoe"])
        ],
        "aʊ": [
            PhonemeQuizData(symbol: "aʊ", targetWord: "cow", dummyWords: ["core", "car"]),
            PhonemeQuizData(symbol: "aʊ", targetWord: "house", dummyWords: ["horse", "hiss"]),
            PhonemeQuizData(symbol: "aʊ", targetWord: "now", dummyWords: ["no", "new"])
        ],
        "ɔɪ": [
            PhonemeQuizData(symbol: "ɔɪ", targetWord: "boy", dummyWords: ["buy", "bye"]),
            PhonemeQuizData(symbol: "ɔɪ", targetWord: "coin", dummyWords: ["cone", "corn"]),
            PhonemeQuizData(symbol: "ɔɪ", targetWord: "join", dummyWords: ["June", "Jane"])
        ],
        
        // --- R-Controlled Vowels (R音性母音) ---
        "ɝ": [
            PhonemeQuizData(symbol: "ɝ", targetWord: "bird", dummyWords: ["bad", "board"]),
            PhonemeQuizData(symbol: "ɝ", targetWord: "work", dummyWords: ["walk", "woke"]),
            PhonemeQuizData(symbol: "ɝ", targetWord: "nurse", dummyWords: ["nice", "nose"])
        ],
        "ɑr": [
            PhonemeQuizData(symbol: "ɑr", targetWord: "car", dummyWords: ["core", "care"]),
            PhonemeQuizData(symbol: "ɑr", targetWord: "star", dummyWords: ["store", "stay"]),
            PhonemeQuizData(symbol: "ɑr", targetWord: "park", dummyWords: ["pork", "peak"])
        ],
        "ɔr": [
            PhonemeQuizData(symbol: "ɔr", targetWord: "door", dummyWords: ["dare", "deer"]),
            PhonemeQuizData(symbol: "ɔr", targetWord: "born", dummyWords: ["barn", "burn"]),
            PhonemeQuizData(symbol: "ɔr", targetWord: "sport", dummyWords: ["spurt", "spare"])
        ],
        "ɛr": [
            PhonemeQuizData(symbol: "ɛr", targetWord: "hair", dummyWords: ["here", "her"]),
            PhonemeQuizData(symbol: "ɛr", targetWord: "chair", dummyWords: ["cheer", "char"]),
            PhonemeQuizData(symbol: "ɛr", targetWord: "bear", dummyWords: ["beer", "bar"])
        ],
        "ɪr": [
            PhonemeQuizData(symbol: "ɪr", targetWord: "ear", dummyWords: ["air", "are"]),
            PhonemeQuizData(symbol: "ɪr", targetWord: "fear", dummyWords: ["fair", "far"]),
            PhonemeQuizData(symbol: "ɪr", targetWord: "clear", dummyWords: ["clerk", "clair"])
        ],
        
        // --- Fricatives (摩擦音) ---
        "θ": [
            PhonemeQuizData(symbol: "θ", targetWord: "think", dummyWords: ["sink", "pink"]),
            PhonemeQuizData(symbol: "θ", targetWord: "thin", dummyWords: ["sin", "tin"]),
            PhonemeQuizData(symbol: "θ", targetWord: "bath", dummyWords: ["bass", "bat"])
        ],
        "ð": [
            PhonemeQuizData(symbol: "ð", targetWord: "this", dummyWords: ["miss", "hiss"]),
            PhonemeQuizData(symbol: "ð", targetWord: "mother", dummyWords: ["brother", "other"]),
            PhonemeQuizData(symbol: "ð", targetWord: "weather", dummyWords: ["wetter", "western"])
        ],
        "f": [
            PhonemeQuizData(symbol: "f", targetWord: "fan", dummyWords: ["pan", "van"]),
            PhonemeQuizData(symbol: "f", targetWord: "leaf", dummyWords: ["leap", "least"]),
            PhonemeQuizData(symbol: "f", targetWord: "fish", dummyWords: ["dish", "wish"])
        ],
        "v": [
            PhonemeQuizData(symbol: "v", targetWord: "van", dummyWords: ["ban", "fan"]),
            PhonemeQuizData(symbol: "v", targetWord: "vest", dummyWords: ["best", "west"]),
            PhonemeQuizData(symbol: "v", targetWord: "vase", dummyWords: ["base", "case"])
        ],
        "s": [
            PhonemeQuizData(symbol: "s", targetWord: "sea", dummyWords: ["she", "tea"]),
            PhonemeQuizData(symbol: "s", targetWord: "sink", dummyWords: ["think", "zinc"]),
            PhonemeQuizData(symbol: "s", targetWord: "bus", dummyWords: ["buzz", "but"])
        ],
        "z": [
            PhonemeQuizData(symbol: "z", targetWord: "zoo", dummyWords: ["too", "do"]),
            PhonemeQuizData(symbol: "z", targetWord: "buzz", dummyWords: ["bus", "butt"]),
            PhonemeQuizData(symbol: "z", targetWord: "lazy", dummyWords: ["lady", "lately"])
        ],
        "ʃ": [
            PhonemeQuizData(symbol: "ʃ", targetWord: "she", dummyWords: ["sea", "see"]),
            PhonemeQuizData(symbol: "ʃ", targetWord: "ship", dummyWords: ["sip", "chip"]),
            PhonemeQuizData(symbol: "ʃ", targetWord: "cash", dummyWords: ["catch", "cats"])
        ],
        "ʒ": [
            PhonemeQuizData(symbol: "ʒ", targetWord: "vision", dummyWords: ["mission", "visit"]),
            PhonemeQuizData(symbol: "ʒ", targetWord: "measure", dummyWords: ["mesher", "major"]),
            PhonemeQuizData(symbol: "ʒ", targetWord: "pleasure", dummyWords: ["player", "pledge"])
        ],
        "h": [
            PhonemeQuizData(symbol: "h", targetWord: "hat", dummyWords: ["at", "cat"]),
            PhonemeQuizData(symbol: "h", targetWord: "hit", dummyWords: ["it", "bit"]),
            PhonemeQuizData(symbol: "h", targetWord: "who", dummyWords: ["too", "do"])
        ],
        
        // --- Plosives (破裂音) ---
        "p": [
            PhonemeQuizData(symbol: "p", targetWord: "pen", dummyWords: ["ben", "ten"]),
            PhonemeQuizData(symbol: "p", targetWord: "cup", dummyWords: ["cub", "cut"]),
            PhonemeQuizData(symbol: "p", targetWord: "apple", dummyWords: ["amble", "able"])
        ],
        "b": [
            PhonemeQuizData(symbol: "b", targetWord: "bat", dummyWords: ["pat", "mat"]),
            PhonemeQuizData(symbol: "b", targetWord: "cab", dummyWords: ["cap", "cat"]),
            PhonemeQuizData(symbol: "b", targetWord: "big", dummyWords: ["pig", "dig"])
        ],
        "t": [
            PhonemeQuizData(symbol: "t", targetWord: "ten", dummyWords: ["den", "pen"]),
            PhonemeQuizData(symbol: "t", targetWord: "eight", dummyWords: ["ate", "aid"]),
            PhonemeQuizData(symbol: "t", targetWord: "bat", dummyWords: ["bad", "back"])
        ],
        "d": [
            PhonemeQuizData(symbol: "d", targetWord: "den", dummyWords: ["ten", "pen"]),
            PhonemeQuizData(symbol: "d", targetWord: "bed", dummyWords: ["bet", "bell"]),
            PhonemeQuizData(symbol: "d", targetWord: "dog", dummyWords: ["log", "bog"])
        ],
        "k": [
            PhonemeQuizData(symbol: "k", targetWord: "cat", dummyWords: ["gat", "bat"]),
            PhonemeQuizData(symbol: "k", targetWord: "back", dummyWords: ["bag", "bat"]),
            PhonemeQuizData(symbol: "k", targetWord: "cook", dummyWords: ["hook", "look"])
        ],
        "ɡ": [ // 注意：あなたのデータにある U+0261 (ɡ) に合わせています
            PhonemeQuizData(symbol: "ɡ", targetWord: "get", dummyWords: ["bet", "set"]),
            PhonemeQuizData(symbol: "ɡ", targetWord: "bag", dummyWords: ["back", "bat"]),
            PhonemeQuizData(symbol: "ɡ", targetWord: "gap", dummyWords: ["cap", "map"])
             ],
        
        // --- Affricates (破擦音) ---
        "tʃ": [
            PhonemeQuizData(symbol: "tʃ", targetWord: "check", dummyWords: ["shack", "deck"]),
            PhonemeQuizData(symbol: "tʃ", targetWord: "watch", dummyWords: ["wash", "what"]),
            PhonemeQuizData(symbol: "tʃ", targetWord: "chair", dummyWords: ["share", "hair"])
        ],
        "dʒ": [
            PhonemeQuizData(symbol: "dʒ", targetWord: "job", dummyWords: ["rob", "sob"]),
            PhonemeQuizData(symbol: "dʒ", targetWord: "bridge", dummyWords: ["breathe", "bright"]),
            PhonemeQuizData(symbol: "dʒ", targetWord: "jam", dummyWords: ["ham", "am"])
        ],
        
        // --- Nasals (鼻音) ---
        "m": [
            PhonemeQuizData(symbol: "m", targetWord: "man", dummyWords: ["nan", "pan"]),
            PhonemeQuizData(symbol: "m", targetWord: "ham", dummyWords: ["han", "hang"]),
            PhonemeQuizData(symbol: "m", targetWord: "come", dummyWords: ["cone", "code"])
        ],
        "n": [
            PhonemeQuizData(symbol: "n", targetWord: "now", dummyWords: ["low", "how"]),
            PhonemeQuizData(symbol: "n", targetWord: "sun", dummyWords: ["sung", "sum"]),
            PhonemeQuizData(symbol: "n", targetWord: "nine", dummyWords: ["mine", "line"])
        ],
        "ŋ": [
            PhonemeQuizData(symbol: "ŋ", targetWord: "sing", dummyWords: ["sin", "sink"]),
            PhonemeQuizData(symbol: "ŋ", targetWord: "song", dummyWords: ["son", "sun"]),
            PhonemeQuizData(symbol: "ŋ", targetWord: "wing", dummyWords: ["win", "wink"])
        ],
        
        // --- Approximants (接近音) ---
        "l": [
            PhonemeQuizData(symbol: "l", targetWord: "light", dummyWords: ["right", "night"]),
            PhonemeQuizData(symbol: "l", targetWord: "glass", dummyWords: ["grass", "class"]),
            PhonemeQuizData(symbol: "l", targetWord: "fly", dummyWords: ["fry", "free"])
        ],
        "r": [
            PhonemeQuizData(symbol: "r", targetWord: "right", dummyWords: ["light", "night"]),
            PhonemeQuizData(symbol: "r", targetWord: "red", dummyWords: ["led", "bed"]),
            PhonemeQuizData(symbol: "r", targetWord: "pray", dummyWords: ["play", "pay"])
        ],
        "w": [
            PhonemeQuizData(symbol: "w", targetWord: "wet", dummyWords: ["set", "get"]),
            PhonemeQuizData(symbol: "w", targetWord: "west", dummyWords: ["best", "vest"]),
            PhonemeQuizData(symbol: "w", targetWord: "wine", dummyWords: ["line", "fine"])
        ],
        "j": [
            PhonemeQuizData(symbol: "j", targetWord: "yes", dummyWords: ["less", "mess"]),
            PhonemeQuizData(symbol: "j", targetWord: "year", dummyWords: ["ear", "near"]),
            PhonemeQuizData(symbol: "j", targetWord: "yellow", dummyWords: ["hello", "mellow"])
        ]
    ]
    
    static func getQuiz(for symbol: String, excluding lastWord: String? = nil) -> PhonemeQuizData {
            let key = symbol.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard let pool = allQuizzes[key], !pool.isEmpty else {
                // データがない場合の安全策（apple）
                return PhonemeQuizData(symbol: symbol, targetWord: "apple", dummyWords: ["maple", "purple"])
            }
            
            // 前回と違う単語の候補を作る
            let candidates = pool.filter { $0.targetWord != lastWord }
            
            // 候補があればそこから、なければ（1つしかない場合など）全体からランダムに返す
            return candidates.randomElement() ?? pool.randomElement()!
        }
    }

