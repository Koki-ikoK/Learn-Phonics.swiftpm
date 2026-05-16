import SwiftUI

struct PhonicsAICheckView: View {
    @StateObject private var audioService = SoundAnalysisService()
    let targetSymbol: String // ここには "cat" や "fan" などの単語が入ってきます
    
    // AIのラベルから表示用記号への変換マップ
    private let aiResultMapping: [String: String] = [
        "f-sound": "f", "v-sound": "v", "think-sound": "θ", "this-sound": "ð",
        "l-sound": "l", "r-sound": "r", "ae-sound": "æ", "e-sound": "ɛ",
        "i-short-sound": "ɪ", "ah-sound": "ɑ", "uh-sound": "ʌ", "i-long-sound": "i",
        "u-long-sound": "u", "aw-sound": "ɔ", "u-short-sound": "ʊ", "schwa-sound": "ə",
        "ei-sound": "eɪ", "ai-sound": "aɪ", "ou-sound": "oʊ", "au-sound": "aʊ", "oi-sound": "ɔɪ"
    ]
    
    private var displaySymbol: String {
        if let matched = PhonemeData.all.first(where: { $0.word.lowercased() == targetSymbol.lowercased() }) {
            return matched.symbol
        }
        return targetSymbol
    }
    
    @State private var statusText = "マイクを準備中..."
    @State private var feedbackText = ""
    @State private var hasDetectedSound = false
    @State private var silenceCounter = 0
    @State private var isCheckFinished = false
    @State private var bestDetectedSound = ""

    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.2))
                    .frame(width: 180, height: 180)
                    .blur(radius: 30)
                Circle()
                    .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 140, height: 140)
                    .shadow(color: .red.opacity(0.5), radius: 15, x: 0, y: 10)
                Text(displaySymbol)
                    .font(.system(size: 70, weight: .black, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding(.top, 20)
            .padding(.bottom, 50)
            
            Text(statusText)
                .font(.headline)
                .foregroundColor(isCheckFinished ? .primary : (hasDetectedSound ? .green : .red))
                .animation(.easeInOut, value: statusText)

            if isCheckFinished {
                VStack(alignment: .leading, spacing: 10) {
                    Text("🤖 AIの判定結果")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(feedbackText)
                        .font(.body)
                        .bold()
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Button(action: startSession) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .padding(25)
                        .background(Color.red)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
            } else {
                VStack(spacing: 15) {
                    HStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 12, height: 12)
                            .opacity(audioService.isRunning && !hasDetectedSound ? 1.0 : 0.0)
                            .animation(audioService.isRunning ? Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true) : .default, value: audioService.isRunning)
                        
                        Text(audioService.isRunning ? "マイクON (録音中)" : "マイクOFF")
                            .font(.subheadline)
                            .foregroundColor(audioService.isRunning ? .red : .gray)
                            .bold()
                    }
                    Image(systemName: "mic.fill")
                        .font(.system(size: 60))
                        .foregroundColor(audioService.isRunning ? (hasDetectedSound ? .green : .red) : .gray)
                        .scaleEffect(hasDetectedSound ? 1.3 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: hasDetectedSound)
                }
            }
        }
        .onAppear { startSession() }
        .onDisappear { audioService.stop() }
        .onChange(of: audioService.lastResult) { newValue in
                    // 🌟 シンプルに「雑音以外」の最新判定を記録するだけに戻す
                    if audioService.isRunning && newValue != "noise" && newValue != "---" {
                        bestDetectedSound = newValue
                    }
                }
        .navigationTitle("発音チェック")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func handleAudioLevel(_ level: Float) {
        guard audioService.isRunning else { return }
        if level > 0.015 {
            hasDetectedSound = true
            silenceCounter = 0
            statusText = "🗣️ 音声を聴き取っています..."
        } else if hasDetectedSound {
            silenceCounter += 1
            if silenceCounter > 20 { stopAndAnalyze() }
        }
    }
    
    private func startSession() {
            // UI状態のリセット
            isCheckFinished = false
            hasDetectedSound = false
            silenceCounter = 0
            feedbackText = ""
            bestDetectedSound = ""
            statusText = "発音してください！"
            
            // 🌟 バックグラウンドでマイクを起動し、UIフリーズを防ぐ
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try self.audioService.start()
                } catch {
                    print("マイク起動失敗: \(error)")
                }
            }
        }
    
    private func stopAndAnalyze() {
        audioService.stop()
        isCheckFinished = true
        
        let finalResult = bestDetectedSound.isEmpty ? audioService.lastResult : bestDetectedSound
        
        // 正解の記号を取得 (例: cat -> æ)
        let targetSymbolActual = PhonemeData.all.first(where: { $0.word == targetSymbol })?.symbol ?? targetSymbol
        // AIが判定した音を記号に変換 (例: ae-sound -> æ)
        let detectedSymbol = aiResultMapping[finalResult] ?? finalResult
        
        if detectedSymbol == targetSymbolActual {
            statusText = "✅ 正解！素晴らしい！"
            feedbackText = "ネイティブのような完璧な発音です！この口の形を覚えておきましょう。"
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            statusText = "❌ おしい！"
            feedbackText = generateAdvice(target: targetSymbolActual, detected: detectedSymbol)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
    
    private func generateAdvice(target: String, detected: String) -> String {
        if detected == "noise" { return "もう少しはっきりと発音してみてください！" }
        let intro = "「\(detected)」に近く聞こえました。これは日本人にとって非常に起こりやすいクセです！"

        switch target {
        case "f": return "\(intro)\n上の歯で下唇を軽く押さえて、隙間から「フッ」と息を漏らしてみてください。"
        case "v": return "\(intro)\nfの口の形のまま、喉を震わせて「ヴッ」と濁音を出してみましょう。"
        case "θ": return "\(intro)\n舌先を上下の歯で軽く挟み、その隙間から息を「スー」と抜いてください。"
        case "ð": return "\(intro)\n舌を挟んだ状態から、喉を震わせて音を出してみてください。"
        case "l": return "\(intro)\n舌先を上の前歯の付け根にしっかりと押し当てて、音を出してみてください。"
        case "r": return "\(intro)\n舌をどこにも触れさせず、口の奥にグッと引いて、こもった音を出すのがコツです。"
        case "æ": return "\(intro)\n「あ」と「え」を同時に言うイメージで、口を左右に平たく開けてみてください。"
        case "ɑ": return "\(intro)\nあくびをする時のように、口を縦に大きく開けて「あー」と発音しましょう。"
        case "ʌ": return "\(intro)\n喉の奥から短く、鋭く「アッ」と弾くように発音するのがポイントです。"
        default: return intro
        }
    }
}
