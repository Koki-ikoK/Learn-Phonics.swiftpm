import SwiftUI

struct PhonemeSelectView: View {
    let repo: THLessonRepository
    let store: ProgressStore
    
    // Grid設定
    private let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // 1. ヘッダー
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phonics Training")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("毎日少しずつ練習して、英語耳を作ろう。")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // 2. 今日のトレーニング（目立つカード）
                Button {
                    print("Start Daily Training tapped")
                } label: {
                    DailyTrainingCard()
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)

                // ▼▼▼ 追加: ここで「モードが変わる」ことを宣言する ▼▼▼
                VStack(alignment: .leading, spacing: 4) {
                    Text("Individual Phoneme Training") // 個別音素トレーニング
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("苦手な音を選んで重点的に練習")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 16) // 上のカードとの間に少し余白を開ける
                // ▲▲▲ 追加ここまで ▲▲▲

                // 3. 発音記号カテゴリ一覧
                ForEach(PhonemeCategory.allCases) { category in
                    let items = PhonemeData.all.filter { $0.category == category }
                    
                    if !items.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(category.rawValue)
                                .font(.headline) // カテゴリ名は少し控えめに
                                .foregroundStyle(.secondary) // 色もグレーにして階層を下げる
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(items) { item in
                                    NavigationLink {
                                        destinationView(for: item)
                                    } label: {
                                        PhonemeCard(item: item)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.bottom, 40)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Phonemes")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // (以下、destinationView, DailyTrainingCard, PhonemeCard は変更なし)
    // ※ 下のコードが必要なら前回のものをそのまま使ってください
    @ViewBuilder
    private func destinationView(for item: PhonemeItem) -> some View {
        if item.symbol == "θ" {
            THLessonView(repo: repo, store: store, sound: .theta)
        } else if item.symbol == "ð" {
            THLessonView(repo: repo, store: store, sound: .eth)
        } else {
             ContentUnavailableView(
                 "Coming Soon",
                 systemImage: "hammer.fill",
                 description: Text("/\(item.symbol)/ のレッスンは準備中です。")
             )
        }
    }
}

// (DailyTrainingCard と PhonemeCard の定義は省略していません。前回のコードと同じ場所に置いてください)
struct DailyTrainingCard: View {
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle().fill(.white.opacity(0.2)).frame(width: 56, height: 56)
                Image(systemName: "flame.fill").font(.system(size: 30)).foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("今日のトレーニング").font(.headline).foregroundStyle(.white)
                Text("苦手な音を中心に3分間練習！").font(.caption).foregroundStyle(.white.opacity(0.9))
            }
            Spacer()
            Image(systemName: "play.circle.fill").font(.system(size: 32)).foregroundStyle(.white)
        }
        .padding(16)
        .background(LinearGradient(colors: [Color.orange, Color.red], startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(16)
        .shadow(color: .orange.opacity(0.4), radius: 8, x: 0, y: 4)
    }
}

struct PhonemeCard: View {
    let item: PhonemeItem
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("/").font(.system(size: 28, weight: .light, design: .rounded)).foregroundStyle(.tertiary)
                    Text(item.symbol).font(.system(size: 44, weight: .bold, design: .rounded)).foregroundStyle(.primary).lineLimit(1).minimumScaleFactor(0.4)
                    Text("/").font(.system(size: 28, weight: .light, design: .rounded)).foregroundStyle(.tertiary)
                }
                Spacer()
                if item.isAISupported {
                    HStack(spacing: 3) {
                        Image(systemName: "sparkles").font(.system(size: 10))
                        Text("AI Check").font(.system(size: 10, weight: .bold)).lineLimit(1).minimumScaleFactor(0.5).fixedSize(horizontal: true, vertical: false)
                    }
                    .padding(.vertical, 4).padding(.horizontal, 6)
                    .background(Capsule().fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .foregroundStyle(.white)
                } else {
                    Text("Rec Only").font(.caption2).fontWeight(.semibold).padding(.vertical, 4).padding(.horizontal, 8)
                    .background(Color.secondary.opacity(0.2)).foregroundStyle(.secondary).clipShape(Capsule())
                }
            }
            HStack {
                Text("ex: \(item.word)").font(.subheadline).foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "chevron.right.circle.fill").foregroundStyle(Color.secondary.opacity(0.3))
            }
        }
        .padding(16).background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(16).shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
