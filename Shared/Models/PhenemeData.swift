import Foundation

// カテゴリを詳細化して、学習しやすい順序に整理
enum PhonemeCategory: String, CaseIterable, Identifiable, Codable {
    case monophthong = "短母音・長母音 (Monophthongs)"
    case diphthong = "二重母音 (Diphthongs)"
    case rControlled = "R音性母音 (R-Controlled)"
    case fricative = "摩擦音 (Fricatives)"
    case plosive = "破裂音 (Plosives)"
    case affricate = "破擦音 (Affricates)"
    case nasal = "鼻音 (Nasals)"
    case approximant = "接近音 (Approximants)"
    
    var id: String { rawValue }
}

struct PhonemeItem: Identifiable, Hashable, Codable {
    var id: String { symbol } // シンボルを一意のIDとする
    let symbol: String       // 発音記号
    let word: String         // 代表単語
    let category: PhonemeCategory
    let isAISupported: Bool  // AI判定機能の有無
}

struct PhonemeData {
    static let all: [PhonemeItem] = [
        // MARK: - Monophthongs (短母音・長母音)
        PhonemeItem(symbol: "æ", word: "cat", category: .monophthong, isAISupported: false),
        PhonemeItem(symbol: "ɛ", word: "bed", category: .monophthong, isAISupported: false),
        PhonemeItem(symbol: "ɪ", word: "sit", category: .monophthong, isAISupported: false),
        PhonemeItem(symbol: "ɑ", word: "hot", category: .monophthong, isAISupported: false),
        PhonemeItem(symbol: "ʌ", word: "cup", category: .monophthong, isAISupported: false),
        PhonemeItem(symbol: "i", word: "see", category: .monophthong, isAISupported: false),
        PhonemeItem(symbol: "u", word: "blue", category: .monophthong, isAISupported: false),
        PhonemeItem(symbol: "ɔ", word: "thought", category: .monophthong, isAISupported: false),
        PhonemeItem(symbol: "ʊ", word: "book", category: .monophthong, isAISupported: false),
        PhonemeItem(symbol: "ə", word: "about", category: .monophthong, isAISupported: false), // Schwa

        // MARK: - Diphthongs (二重母音)
        PhonemeItem(symbol: "eɪ", word: "say", category: .diphthong, isAISupported: false),
        PhonemeItem(symbol: "aɪ", word: "sky", category: .diphthong, isAISupported: false),
        PhonemeItem(symbol: "oʊ", word: "go", category: .diphthong, isAISupported: false),
        PhonemeItem(symbol: "aʊ", word: "cow", category: .diphthong, isAISupported: false),
        PhonemeItem(symbol: "ɔɪ", word: "boy", category: .diphthong, isAISupported: false),

        // MARK: - R-Controlled Vowels (R音性母音)
        PhonemeItem(symbol: "ɝ", word: "bird", category: .rControlled, isAISupported: false),
        PhonemeItem(symbol: "ɑr", word: "car", category: .rControlled, isAISupported: false),
        PhonemeItem(symbol: "ɔr", word: "door", category: .rControlled, isAISupported: false),
        PhonemeItem(symbol: "ɛr", word: "hair", category: .rControlled, isAISupported: false),
        PhonemeItem(symbol: "ɪr", word: "ear", category: .rControlled, isAISupported: false),

        // MARK: - Fricatives (摩擦音)
        // ここだけAI対応(TH)があるので true になっています
        PhonemeItem(symbol: "θ", word: "think", category: .fricative, isAISupported: true),
        PhonemeItem(symbol: "ð", word: "this", category: .fricative, isAISupported: true),
        
        PhonemeItem(symbol: "f", word: "fan", category: .fricative, isAISupported: false),
        PhonemeItem(symbol: "v", word: "van", category: .fricative, isAISupported: false),
        PhonemeItem(symbol: "s", word: "sea", category: .fricative, isAISupported: false),
        PhonemeItem(symbol: "z", word: "zoo", category: .fricative, isAISupported: false),
        PhonemeItem(symbol: "ʃ", word: "she", category: .fricative, isAISupported: false),
        PhonemeItem(symbol: "ʒ", word: "vision", category: .fricative, isAISupported: false),
        PhonemeItem(symbol: "h", word: "hat", category: .fricative, isAISupported: false),

        // MARK: - Plosives (破裂音)
        PhonemeItem(symbol: "p", word: "pen", category: .plosive, isAISupported: false),
        PhonemeItem(symbol: "b", word: "bat", category: .plosive, isAISupported: false),
        PhonemeItem(symbol: "t", word: "ten", category: .plosive, isAISupported: false),
        PhonemeItem(symbol: "d", word: "den", category: .plosive, isAISupported: false),
        PhonemeItem(symbol: "k", word: "cat", category: .plosive, isAISupported: false),
        PhonemeItem(symbol: "ɡ", word: "get", category: .plosive, isAISupported: false),

        // MARK: - Affricates (破擦音)
        PhonemeItem(symbol: "tʃ", word: "check", category: .affricate, isAISupported: false),
        PhonemeItem(symbol: "dʒ", word: "job", category: .affricate, isAISupported: false),

        // MARK: - Nasals (鼻音)
        PhonemeItem(symbol: "m", word: "man", category: .nasal, isAISupported: false),
        PhonemeItem(symbol: "n", word: "now", category: .nasal, isAISupported: false),
        PhonemeItem(symbol: "ŋ", word: "sing", category: .nasal, isAISupported: false),

        // MARK: - Approximants (接近音)
        PhonemeItem(symbol: "l", word: "light", category: .approximant, isAISupported: false),
        PhonemeItem(symbol: "r", word: "right", category: .approximant, isAISupported: false),
        PhonemeItem(symbol: "w", word: "wet", category: .approximant, isAISupported: false),
        PhonemeItem(symbol: "j", word: "yes", category: .approximant, isAISupported: false),
    ]
}
