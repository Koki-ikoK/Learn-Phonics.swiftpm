//
//  GeneralLessonView.swift
//  Learn-Phonics
//
//  Created by Koki Iwaki on 2026/03/01.
//

import SwiftUI

struct GeneralLessonView: View {
    let item: PhonemeItem // あなたの作ったデータモデル

    // 🌟 魔法の辞書：記号に合わせて概要とコツを自動で切り替える！
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
        ScrollView {
            VStack(spacing: 14) {
                // 📝 概要カード
                Card(title: "概要", subtitle: nil) {
                    Text(lessonData.overview)
                    Divider().padding(.vertical, 6)
                    Text("口のコツ: \(lessonData.mouthTip)")
                        .foregroundStyle(.secondary)
                }

                // 🎧 聞き分けクイズ（TH以外はすべて準備中！）
                NavigationLink {
                    ContentUnavailableView(
                        "Coming Soon",
                        systemImage: "ear.badge.waveform",
                        description: Text("/\(item.symbol)/ の聞き分けクイズは現在開発中です！\nアップデートをお待ちください。")
                    )
                } label: {
                    GeneralNavButtonRow(icon: "ear", title: "聞き分けクイズ")
                }
                .buttonStyle(.plain)

                // 🎙 AI発音テスト（f, v は飛べる！それ以外は準備中！）
                NavigationLink {
                    if item.symbol.lowercased() == "f" {
                        PhonicsAICheckView(targetSymbol: "fan")
                    } else if item.symbol.lowercased() == "v" {
                        PhonicsAICheckView(targetSymbol: "van")
                    } else {
                        ContentUnavailableView(
                            "Coming Soon",
                            systemImage: "mic.badge.plus",
                            description: Text("/\(item.symbol)/ のAI発音判定モデルは現在トレーニング中です！\nアップデートをお待ちください。")
                        )
                    }
                } label: {
                    GeneralNavButtonRow(icon: "mic.badge.plus", title: "AI発音テストに挑戦！")
                }
                .buttonStyle(.plain)
            }
            .padding(16)
        }
        .navigationTitle("/\(item.symbol)/ Lesson")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// ボタンのデザイン部品（このファイル専用）
struct GeneralNavButtonRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
            Text(title).fontWeight(.semibold)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
        .background(.thinMaterial)
        .cornerRadius(16)
    }
}
