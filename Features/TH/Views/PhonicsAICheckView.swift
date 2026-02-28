import SwiftUI

struct PhonicsAICheckView: View {
    @StateObject private var audioService = SoundAnalysisService()
    let targetSymbol: String
    
    @State private var statusText = "マイクを準備中..."
    @State private var feedbackText = ""
    @State private var hasDetectedSound = false
    @State private var silenceCounter = 0
    @State private var isCheckFinished = false
    @State private var bestDetectedSound = ""

    var body: some View {
        VStack(spacing: 30) {
            Text("「 \(targetSymbol) 」")
                .font(.system(size: 70, weight: .bold, design: .rounded))
                .foregroundColor(.blue)
            
            Button(action: {
                print("🔊 お手本音声を再生します: \(targetSymbol)")
            }) {
                Label("お手本を聴く", systemImage: "speaker.wave.2.circle.fill")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            
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
                        .background(Color.green)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
            } else {
                // 🌟 ここが超絶進化！直感的な「マイクON/OFF」UI！
                VStack(spacing: 15) {
                    // 🔴 録音中を示す赤いランプ（ONの時だけ点滅）
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
                    
                    // 🎙 マイクアイコン（待機中=赤、音検知=緑、停止=グレー）
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
        .onChange(of: audioService.audioLevel) { level in
            handleAudioLevel(level)
        }
        .onChange(of: audioService.lastResult) { newValue in
            if audioService.isRunning {
                if newValue != "noise" && newValue != "---" && newValue != "判定中..." {
                    bestDetectedSound = newValue
                }
            }
        }
        .navigationTitle("発音チェック")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func handleAudioLevel(_ level: Float) {
        guard audioService.isRunning else { return }
        
        // 🌟 感度アップ！0.03 -> 0.015 に変更（もっと敏感にするなら 0.01 に！）
        if level > 0.015 {
            hasDetectedSound = true
            silenceCounter = 0
            statusText = "🗣️ 音声を聴き取っています..."
        } else if hasDetectedSound {
            silenceCounter += 1
            // 音が途切れてから判定が終わるまでの時間を少しゆったりに（15 -> 20）
            if silenceCounter > 20 {
                stopAndAnalyze()
            }
        }
    }
    
    private func startSession() {
        isCheckFinished = false
        hasDetectedSound = false
        silenceCounter = 0
        feedbackText = ""
        bestDetectedSound = ""
        statusText = "発音してください！"
        try? audioService.start()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if !hasDetectedSound && audioService.isRunning {
                audioService.stop()
                statusText = "音声が検出できませんでした"
                feedbackText = "マイクに近づいて、もう一度大きな声で発音してみてください。"
                isCheckFinished = true
            }
        }
    }
    
    private func stopAndAnalyze() {
        audioService.stop()
        isCheckFinished = true
        
        let finalResult = bestDetectedSound.isEmpty ? audioService.lastResult : bestDetectedSound
        
        if finalResult == targetSymbol {
            statusText = "✅ 正解！素晴らしい！"
            feedbackText = "ネイティブのような完璧な発音です！この口の形を覚えておきましょう。"
        } else {
            statusText = "❌ おしい！"
            feedbackText = generateAdvice(target: targetSymbol, detected: finalResult)
        }
    }
    
    // 🌟 先ほどの最強アドバイス生成器（incとnoiseの翻訳入り！）
    private func generateAdvice(target: String, detected: String) -> String {
        let intro: String
        if detected == "inc" {
            intro = "お手本とは違う音（カタカナ英語など）に聞こえました。実はこれ、日本人にとって非常に起こりやすい発音のクセなんです！"
        } else if detected == "noise" {
            return "声がうまく認識できず、雑音として判定されてしまいました。もう少しマイクに近づいて、はっきりと発音してみてください！"
        } else {
            intro = "「\(detected)」に近く聞こえました。実はこれ、日本人にとって非常に起こりやすい発音のクセなんです！"
        }

        if target == "f" || target == "fan" {
            return "\(intro)\n日本語の「フ」や「ハ」に引っ張られず、上の歯で下唇を軽く押さえて、隙間から強く息を「フッ」と摩擦させてみてください。"
        } else if target == "v" || target == "van" {
            return "\(intro)\n日本語の「バ」行になりがちです。fの口の形のまま、唇を弾かずに喉を震わせ「ヴッ」と濁音を出してみてください。"
        } else if target == "θ" || target == "think" {
            return "\(intro)\n日本語の「サ」行になってしまっています。上下の歯で舌先を軽く挟んで、息だけを「スー」と抜くのがポイントです。"
        } else if target == "ð" || target == "this" {
            return "\(intro)\n日本語の「ザ」や「ダ」行になりがちです。舌先を軽く挟んだ状態から、喉を震わせて音を出してみてください。"
        } else {
            return intro
        }
    }
}
