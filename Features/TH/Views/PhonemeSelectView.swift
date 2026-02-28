import SwiftUI

struct PhonemeSelectView: View {
    let repo: THLessonRepository
    let store: ProgressStore
    
    // Grid設定
    private let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 16)
    ]

    var body: some View {
        ZStack {
            // 🌟 1. ダーク・フェニックスの背景
            Color(red: 0.05, green: 0.05, blue: 0.08)
                .ignoresSafeArea()
            
            RadialGradient(colors: [Color.orange.opacity(0.15), .clear],
                           center: .topLeading, startRadius: 0, endRadius: 600)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // 1. ヘッダー
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phonics Training")
                            .font(.largeTitle)
                            .fontWeight(.black) // 少し太くして力強く
                            .foregroundColor(.white)
                        
                        Text("毎日少しずつ練習して、英語耳を作ろう。")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // 2. 今日のトレーニング（目立つカード）
                    NavigationLink {
                        let dailyTargets = ["fan", "van", "think", "this"]
                        let randomTarget = dailyTargets.randomElement() ?? "fan"
                        PhonicsAICheckView(targetSymbol: randomTarget)
                    } label: {
                        DailyTrainingCard()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)

                    // 個別トレーニングのヘッダー
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Individual Phoneme Training")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("苦手な音を選んで重点的に練習")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)

                    // 3. 発音記号カテゴリ一覧
                    ForEach(PhonemeCategory.allCases) { category in
                        let items = PhonemeData.all.filter { $0.category == category }
                        
                        if !items.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(category.rawValue)
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.8))
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
                .padding(.bottom, 60)
            }
        }
        .navigationTitle("Phonemes")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark) // 🌟 この画面全体を強制的にダークモードへ
    }
    
    @ViewBuilder
    private func destinationView(for item: PhonemeItem) -> some View {
        // 🌟 分岐をなくし、すべての音素を新しいダーク版の GeneralLessonView へ流す！
        GeneralLessonView(item: item)
    }
}

// 🌟 ダークモード用に調整したカード
struct PhonemeCard: View {
    let item: PhonemeItem
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                HStack {
                    symbolView
                    Spacer(minLength: 0)
                }
                
                if item.isAISupported {
                    aiCheckBadge
                } else {
                    recOnlyBadge
                }
            }
            
            Spacer(minLength: 0)
            
            HStack {
                Text("ex: \(item.word)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
                Spacer()
                Image(systemName: "chevron.right.circle.fill")
                    .foregroundColor(Color.white.opacity(0.2))
            }
        }
        .padding(16)
        .background(.ultraThinMaterial) // 🌟 すりガラス効果で背景のオレンジを少し透かす
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1) // うっすら光るフチ
        )
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
    }
    
    // MARK: - View Components
    private var symbolView: some View {
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            Text("/")
                .font(.system(size: 28, weight: .light, design: .rounded))
                .foregroundColor(.white.opacity(0.3))
            
            Text(item.symbol)
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Text("/")
                .font(.system(size: 28, weight: .light, design: .rounded))
                .foregroundColor(.white.opacity(0.3))
        }
    }
    
    private var aiCheckBadge: some View {
        HStack(spacing: 3) {
            Image(systemName: "sparkles")
                .font(.system(size: 10))
            Text("AI Check")
                .font(.system(size: 10, weight: .bold))
                .lineLimit(1)
                .fixedSize()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 6)
        .background(
            Capsule()
                .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
        .foregroundColor(.white)
    }
    
    private var recOnlyBadge: some View {
        Text("Rec Only")
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color.white.opacity(0.1))
            .foregroundColor(.white.opacity(0.5))
            .clipShape(Capsule())
    }
}

// DailyTrainingCard はそのまま（オレンジのグラデーションはダーク背景にめちゃくちゃ映えます）
struct DailyTrainingCard: View {
    @AppStorage("streakCount") private var streakCount = 0

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 56, height: 56)
                
                Image(systemName: streakCount > 0 ? "flame.fill" : "flame")
                    .font(.system(size: 30))
                    .foregroundColor(streakCount > 0 ? .white : .white.opacity(0.6))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("今日のトレーニング")
                    .font(.headline)
                    .foregroundColor(.white)
                
                if streakCount > 0 {
                    Text("\(streakCount)日連続達成中！この調子！")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                } else {
                    Text("まずは今日の1回目からスタート！")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            
            Spacer()
            
            Image(systemName: "bolt.fill")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding(8)
                .background(.white.opacity(0.2))
                .clipShape(Circle())
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color.orange, Color.red],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: .orange.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}
