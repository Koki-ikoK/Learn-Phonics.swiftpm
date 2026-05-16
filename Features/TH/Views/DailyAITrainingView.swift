//
//  DailyAITrainingView.swift
//  Phonix
//
//  Created by Koki Iwaki on 2026/03/01.
//

import SwiftUI

struct DailyAITrainingView: View {
    @StateObject private var audioService = SoundAnalysisService()
    
    // 🌟 AI対応の音素プール（L/Rや母音を追加！）
    let targetPool = ["fan", "van", "think", "this", "light", "right", "cat", "cup", "hot"]
    @State private var currentTarget: String = ""
    @State private var correctCount = 0
    let totalQuestions = 3
    
    @State private var statusText = "マイクを準備中..."
    @State private var feedbackText = ""
    @State private var hasDetectedSound = false
    @State private var silenceCounter = 0
    
    @State private var isCheckFinished = false
    @State private var bestDetectedSound = ""
    @State private var showCompletion = false

    @AppStorage("streakCount") private var streakCount = 0
    @AppStorage("isDailyCompleted") private var isDailyCompleted = false
    @Environment(\.dismiss) var dismiss
    
    // 🌟 AIのラベルから表示用テキストへの変換マップ
    private let aiResultMapping: [String: String] = [
        "f-sound": "fan", "v-sound": "van", "think-sound": "think", "this-sound": "this",
        "l-sound": "l", "r-sound": "r",
        "ae-sound": "æ", "e-sound": "ɛ", "i-short-sound": "ɪ", "ah-sound": "ɑ",
        "uh-sound": "ʌ", "i-long-sound": "i", "u-long-sound": "u", "aw-sound": "ɔ",
        "u-short-sound": "ʊ", "schwa-sound": "ə", "ei-sound": "eɪ", "ai-sound": "aɪ",
        "ou-sound": "oʊ", "au-sound": "aʊ", "oi-sound": "ɔɪ"
    ]
    
    private var displaySymbol: String {
        if let matched = PhonemeData.all.first(where: { $0.word.lowercased() == currentTarget.lowercased() }) {
            return matched.symbol
        }
        return currentTarget
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                ProgressView(value: Double(correctCount), total: Double(totalQuestions))
                    .padding(.horizontal, 50)
                    .tint(.orange)
                
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
                    .font(.title3)
                    .fontWeight(.bold)
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
                    
                    if feedbackText.contains("完璧な発音です") {
                        if correctCount < totalQuestions {
                            Button("次の問題へ") { setupNextQuestion() }
                                .buttonStyle(.borderedProminent)
                                .tint(.green)
                                .controlSize(.large)
                        } else {
                            Button("トレーニング完了！") {
                                streakCount += 1
                                isDailyCompleted = true
                                dismiss()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)
                            .controlSize(.large)
                        }
                    } else {
                        Button(action: startSession) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                                .padding(25)
                                .background(Color.red)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
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
            
            if showCompletion {
                VStack {
                    Text("🔥 CLEAR! 🔥")
                        .font(.system(size: 60, weight: .black))
                        .foregroundColor(.orange)
                        .shadow(radius: 10)
                    Text("今日のトレーニング達成！")
                        .font(.title2).bold()
                }
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
        .onAppear { setupNextQuestion() }
        .onDisappear { audioService.stop() }
        .onChange(of: audioService.audioLevel) { level in handleAudioLevel(level) }
        .onChange(of: audioService.lastResult) { newValue in
            if audioService.isRunning && newValue != "noise" && newValue != "---" {
                bestDetectedSound = newValue
            }
        }
        .navigationTitle("今日のトレーニング (\(correctCount)/\(totalQuestions))")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func setupNextQuestion() {
        var nextTarget = targetPool.randomElement() ?? "fan"
        while nextTarget == currentTarget && targetPool.count > 1 {
            nextTarget = targetPool.randomElement() ?? "fan"
        }
        currentTarget = nextTarget
        startSession()
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
        isCheckFinished = false
        hasDetectedSound = false
        silenceCounter = 0
        feedbackText = ""
        bestDetectedSound = ""
        statusText = "発音してください！"
        // startSession() 内の呼び出し部分
        DispatchQueue.global(qos: .userInitiated).async {
            try? self.audioService.start()
        }
        
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
        
        // 🌟 正解判定（マッピングを考慮）
        let targetLabel = PhonemeData.all.first(where: { $0.word == currentTarget })?.symbol ?? currentTarget
        let detectedSymbol = aiResultMapping[finalResult] ?? finalResult
        
        // 正解の判定条件を緩和（シンボルまたは単語が一致すればOK）
        if detectedSymbol == targetLabel || finalResult.contains(currentTarget.lowercased()) {
            statusText = "✅ 正解！素晴らしい！"
            feedbackText = "ネイティブのような完璧な発音です！この口の形を覚えておきましょう。"
            correctCount += 1
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            
            if correctCount >= totalQuestions {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) { showCompletion = true }
            }
        } else {
            statusText = "❌ おしい！"
            feedbackText = generateAdvice(target: targetLabel, detected: detectedSymbol)
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
