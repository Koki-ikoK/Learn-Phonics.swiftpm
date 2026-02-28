import SwiftUI

struct GeneralLessonView: View {
    let item: PhonemeItem

    private var lessonData: (overview: String, mouthTip: String) {
        switch item.symbol.lowercased() {
        case "f": return ("上の歯で下唇を軽く押さえ、隙間から息を摩擦させて出す無声音です。", "下唇の内側を上の歯に軽く当てるのがコツ！")
        case "v": return ("fと同じ口の形で、喉（声帯）を震わせて出す有声音です。", "唇を震わせるのではなく、喉から「ヴッ」と音を出します。")
        case "p": return ("閉じた唇を弾いて息を破裂させる無声音です。", "息を溜めて一気に「プッ」と出します。")
        case "b": return ("pと同じ口の形で喉を震わせる有声音です。", "唇を弾く瞬間に声を出します。")
        case "s": return ("歯を閉じ、舌先を歯茎に近づけて息を擦り出す無声音です。", "「スー」と鋭い息の音を作ります。")
        case "z": return ("sと同じ口の形で喉を震わせる有声音です。", "スマホのバイブレーションのように「ズー」と鳴らします。")
        case "l": return ("舌先を上の前歯の裏（歯茎）にピタッとつけて声を出す音です。", "日本語の「ラ」より舌をしっかり固定します。")
        case "r": return ("舌をどこにも触れさせず、少し丸めて喉の奥で響かせる音です。", "うがいをするような喉の開きを意識します。")
        case "m": return ("口を閉じて、鼻から音を抜く有声音です。", "唇をしっかり結んで「ムー」と響かせます。")
        case "n": return ("舌先を上の歯茎につけて、鼻から音を抜く有声音です。", "口は少し開けたまま舌で塞ぎます。")
        default: return ("/\(item.symbol)/ の発音の基礎を学ぶレッスンです。", "お手本の音声をよく聞いて、口の形を真似てみましょう。")
        }
    }

    var body: some View {
        ZStack {
            // 🌟 1. 背景：漆黒ではなく、深みのある「ミッドナイト」グラデーション
            Color(red: 0.05, green: 0.05, blue: 0.08)
                .ignoresSafeArea()
            
            RadialGradient(colors: [Color.orange.opacity(0.15), .clear],
                           center: .topTrailing, startRadius: 0, endRadius: 500)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    
                    // 🌟 2. ヒーローセクション：暗い背景で「発光」させる
                    VStack(spacing: 12) {
                        ZStack {
                            // 背景のグロー（光彩）
                            Circle()
                                .fill(Color.orange.opacity(0.2))
                                .frame(width: 160, height: 160)
                                .blur(radius: 30)
                            
                            Circle()
                                .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 120, height: 120)
                                .shadow(color: .orange.opacity(0.5), radius: 15)
                            
                            Text(item.symbol)
                                .font(.system(size: 64, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        Text("Example: \(item.word)")
                            .font(.title3.bold())
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 40)

                    // 🌟 3. 概要カード：ガラスのような透明感（UltraThinMaterial）
                    VStack(alignment: .leading, spacing: 16) {
                        Label("Pronunciation Guide", systemImage: "flame.fill")
                            .font(.headline)
                            .foregroundColor(.orange)
                        
                        Text(lessonData.overview)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(6)
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "mouth.fill")
                                .foregroundColor(.red)
                            Text(lessonData.mouthTip)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(24)
                    .background(.ultraThinMaterial) // 🌟 背景を透かす
                    .cornerRadius(28)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .padding(.horizontal)

                    // 🌟 4. アクションボタン：横並び
                                        HStack(spacing: 20) {
                                            NavigationLink {
                                                GeneralPhonicsQuizView(symbol: item.symbol)
                                                    .id(item.symbol)
                                            } label: {
                                                DarkSquareButton(icon: "ear.badge.waveform",
                                                                title: "Listening",
                                                                subtitle: "耳を鍛える",
                                                                color: .orange)
                                            }

                                            NavigationLink {
                                                let sym = item.symbol.lowercased()
                                                // 🌟 全てのAI対応音素をここに復活！
                                                if sym == "f" {
                                                    PhonicsAICheckView(targetSymbol: "fan")
                                                } else if sym == "v" {
                                                    PhonicsAICheckView(targetSymbol: "van")
                                                } else if sym == "θ" {
                                                    PhonicsAICheckView(targetSymbol: "think")
                                                } else if sym == "ð" {
                                                    PhonicsAICheckView(targetSymbol: "this")
                                                } else {
                                                    ContentUnavailableView("Training...", systemImage: "mic.badge.plus")
                                                        .preferredColorScheme(.dark)
                                                }
                                            } label: {
                                                // 🌟 名前を「AI Check」に戻し、アイコンもAIっぽく！
                                                DarkSquareButton(icon: "sparkles",
                                                                title: "AI Check",
                                                                subtitle: "発音をAI判定",
                                                                color: .red)
                                            }
                                        }
                                        .padding(.horizontal)
                }
                .padding(.bottom, 60)
            }
        }
        .navigationTitle("/\(item.symbol)/ Lesson")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark) // 🌟 この画面を強制的にダークモードにする
    }
}

// 🌑 ダークモード専用のスクエアボタン
struct DarkSquareButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 64, height: 64)
                
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                    .shadow(color: color.opacity(0.5), radius: 10)
            }
            
            VStack(spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(Color.white.opacity(0.05)) // 🌟 わずかに白い透明
        .cornerRadius(32)
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}
