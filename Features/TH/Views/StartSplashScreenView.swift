import SwiftUI

struct StartSplashScreenView: View {
    @Binding var isActive: Bool
    
    @State private var sceneIndex = 0
    @State private var textOpacity: Double = 0.0
    @State private var startTextScale: CGFloat = 1.0
    
    // 🌟 タイマー管理用のタスクを保持する変数
    @State private var timerTask: Task<Void, Never>? = nil
    
    // ストーリーの内容（普遍的なメッセージ版）
    private let stories = [
        "私たちは何年も英語を学びますが、\n『正しく発音する』機会にはなかなか恵まれません。",
        "『thirty』と勇気を出して伝えても、聞き取ってもらえない。\nそんな経験が、学習の自信を奪ってしまうこともあります。",
        "日本の教育に足りていないのは、\n文字と音を論理的に結びつける『フォニックス』でした。",
        "フォニックスを学ぶことで、カタカナ発音を卒業し、\n自信を持って世界とつながる力を手に入れる。",
        "あなたの発音を、より伝わりやすく。\nAIフォニックス学習アプリ『Phonix』開始。"
    ]
    
    var body: some View {
        ZStack {
            // 背景：深みのあるグラデーション
            LinearGradient(colors: [Color(red: 0.1, green: 0, blue: 0.2), .black],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // 🌟 シングルのIDでアニメーションを管理
                iconView
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                    .id("icon_\(sceneIndex)")

                // 🌟 ストーリーテキスト
                Text(stories[sceneIndex])
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineSpacing(8)
                    .opacity(textOpacity)
                    .animation(.easeIn(duration: 0.8), value: textOpacity)
                    .id("text_\(sceneIndex)")
                
                Spacer()
                
                // 🌟 下部の操作案内
                if sceneIndex == stories.count - 1 {
                    // 🚩 最終シーン：大きく強調された Tap to Start
                    Button {
                        launchApp()
                    } label: {
                        VStack(spacing: 12) {
                            Text("Tap to Start")
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            
                            Image(systemName: "chevron.compact.down")
                                .font(.title)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(.vertical, 25)
                        .padding(.horizontal, 50)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.15))
                                .overlay(Capsule().stroke(Color.white.opacity(0.3), lineWidth: 2))
                        )
                        .scaleEffect(startTextScale)
                    }
                    .onAppear {
                        // 鼓動のようなパルスアニメーション
                        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                            startTextScale = 1.1
                        }
                    }
                } else {
                    // 途中のシーン：タップを促す案内
                    Text("Tap to next / skip...")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.4))
                }
                
                Spacer().frame(height: 40)
            }
        }
        .contentShape(Rectangle()) // 画面全体でタップを検知
        .onAppear {
            print("🚀 [System] アプリ起動：ストーリーを開始します。")
            textOpacity = 1.0
            startTimer()
        }
        .onTapGesture {
            print("☝️ [User] 画面がタップされました。")
            nextScene()
        }
    }
    
    // 🌟 アイコン表示のロジック
    @ViewBuilder
    private var iconView: some View {
        switch sceneIndex {
        case 0:
            Image(systemName: "book.closed.fill")
                .font(.system(size: 100)).foregroundColor(.gray)
        case 1:
            Image(systemName: "mic.slash.fill")
                .font(.system(size: 100)).foregroundColor(.red)
        case 2:
            Image(systemName: "key.horizontal.fill")
                .font(.system(size: 100)).foregroundColor(.yellow)
        case 3:
            Image(systemName: "sparkles")
                .font(.system(size: 100)).foregroundColor(.blue)
        default:
            // 自作の不死鳥アイコン
            Image("AppIconImage")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .cornerRadius(45)
                .shadow(color: .purple.opacity(0.6), radius: 20)
        }
    }
    
    // 🌟 ログ付き自動遷移タイマー管理
    private func startTimer() {
        // 古いタイマーがあれば確実にキャンセルする
        timerTask?.cancel()
        print("🕒 [Timer] 前のタイマーを破棄：Scene \(sceneIndex)")

        timerTask = Task {
            print("⏳ [Timer] 3秒のカウントダウン開始...")
            
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            
            // タスクがキャンセル（タップによる遷移）されていない場合のみ実行
            if !Task.isCancelled && sceneIndex < stories.count - 1 {
                await MainActor.run {
                    print("⏰ [Timer] 3秒経過：自動遷移を実行します。")
                    nextScene()
                }
            }
        }
    }
    
    private func nextScene() {
        if sceneIndex < stories.count - 1 {
            print("🎬 [Scene] 移動：\(sceneIndex) -> \(sceneIndex + 1)")
            
            // 遷移が始まったらタイマーを止める
            timerTask?.cancel()
            
            withAnimation(.easeInOut(duration: 0.5)) {
                sceneIndex += 1
                textOpacity = 0.0
            }
            
            // 少し遅れてテキストをフェードイン
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                textOpacity = 1.0
            }
            
            // 次のシーンのタイマーをセット
            startTimer()
        } else {
            print("🏁 [Scene] 最終シーン：ユーザーのタップ入力を待機中。")
        }
    }
    
    private func launchApp() {
        print("🔥 [System] Phonix 起動！メイン画面へ遷移します。")
        timerTask?.cancel() // 念のためキャンセル
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            isActive = true
        }
    }
}
