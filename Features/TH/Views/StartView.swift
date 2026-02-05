import SwiftUI

struct StartView: View {
    let repo: THLessonRepository
    let store: any ProgressStore

    var body: some View {
        GeometryReader { geo in
            // iPad想定：画面幅の65%、最大720px
            let buttonW = min(720, geo.size.width * 0.65)
            let buttonH: CGFloat = 96

            ZStack {
                // 背景（好きなままでOK）
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.12, blue: 0.22),
                        Color(red: 0.06, green: 0.22, blue: 0.22),
                        Color(red: 0.10, green: 0.10, blue: 0.14)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 18) {
                    Spacer()

                    Text("Learn Phonics")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("このアプリは phonics を学習することで日本人の英語力を上げるために開発しています。")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    Spacer(minLength: 10)

                    // ✅ Startボタン（押下で画像切替、サイズはbuttonWで確実に拡大）
                    NavigationLink {
                        PhonemeSelectView(repo: repo, store: store)
                    } label: {
                        Color.clear
                            .frame(width: buttonW, height: buttonH)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(CTAStartButtonStyle(width: buttonW, height: buttonH))
                    .accessibilityLabel("Start")
                    .padding(.bottom, 56)

                    Spacer(minLength: 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

