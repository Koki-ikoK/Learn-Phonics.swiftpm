import SwiftUI
import AVFoundation

struct GeneralPhonicsQuizView: View {
    let symbol: String
    
    @State private var currentData: PhonemeQuizData?
    @State private var choices: [String] = []
    @State private var message = "音声を聴いて正しい単語を選ぼう"
    @State private var isCorrect: Bool? = nil
    
    @Environment(\.dismiss) var dismiss
    private let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        VStack(spacing: 30) {
            if let data = currentData {
                // 🌟 発音記号を「光る丸いアイコン」に変更（AIチェック画面と完全統一！）
                                ZStack {
                                    // 背景のぼんやりした光彩（グロー効果）
                                    Circle()
                                        .fill(Color.orange.opacity(0.2))
                                        .frame(width: 180, height: 180)
                                        .blur(radius: 30)
                                    
                                    // メインの丸い背景（不死鳥グラデーション）
                                    Circle()
                                        .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .frame(width: 140, height: 140)
                                        .shadow(color: .orange.opacity(0.5), radius: 15, x: 0, y: 10)
                                    
                                    // アイコンの中の記号
                                    Text(data.symbol)
                                        .font(.system(size: 70, weight: .black, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 20)

                Button(action: playSound) {
                    VStack {
                        Image(systemName: "speaker.wave.3.fill")
                            .font(.system(size: 50))
                        Text("音声を聴く")
                            .font(.headline)
                    }
                    .padding(40)
                    .background(Circle().fill(Color.orange.opacity(0.1)))
                }

                VStack(spacing: 15) {
                    ForEach(choices, id: \.self) { choice in
                        Button(action: { checkAnswer(choice) }) {
                            Text(choice)
                                .font(.title2).bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(buttonColor(for: choice))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                        .disabled(isCorrect == true)
                    }
                }
                .padding(.horizontal)
            }

            Text(message)
                .font(.headline)
                .foregroundColor(isCorrect == false ? .red : .secondary)

            if isCorrect == true {
                HStack(spacing: 20) {
                    Button("別の問題へ") {
                        withAnimation { setupQuiz() }
                    }
                    .buttonStyle(.bordered)
                    
                    Button("完了") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
        }
        .navigationTitle("Listening Quiz")
        .onAppear(perform: setupQuiz)
    }

    private func setupQuiz() {
        let lastWord = currentData?.targetWord
        let newData = QuizRepository.getQuiz(for: symbol, excluding: lastWord)
        
        self.currentData = newData
        self.isCorrect = nil
        self.message = "音声を聴いて正しい単語を選ぼう"
        
        var allChoices = newData.dummyWords
        allChoices.append(newData.targetWord)
        self.choices = allChoices.shuffled()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            playSound()
        }
    }

    private func playSound() {
        guard let word = currentData?.targetWord else { return }
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }

    private func checkAnswer(_ choice: String) {
        guard let data = currentData else { return }
        if choice == data.targetWord {
            isCorrect = true
            message = "正解！🎉「\(data.targetWord)」でした。"
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            isCorrect = false
            message = "おしい！それは「\(choice)」だよ。"
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }

    private func buttonColor(for choice: String) -> Color {
        if let isCorrect = isCorrect, choice == currentData?.targetWord {
            return .green
        }
        return .orange
    }
}
