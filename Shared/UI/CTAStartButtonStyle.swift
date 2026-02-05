import SwiftUI
import UIKit

struct CTAStartButtonStyle: ButtonStyle {
    let width: CGFloat
    let height: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        let name = configuration.isPressed ? "CTA_Start_Pressed" : "CTA_Start"

        return image(name)
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
            .clipShape(Capsule()) // 白い四角が見える時の保険
            .shadow(color: .black.opacity(configuration.isPressed ? 0.20 : 0.35),
                    radius: configuration.isPressed ? 10 : 18,
                    x: 0, y: configuration.isPressed ? 6 : 10)
            .scaleEffect(configuration.isPressed ? 0.985 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
            .contentShape(Rectangle())
    }

    // SwiftPM(.module) → main bundle の順に探す（どっちでも表示されるように）
    private func image(_ name: String) -> Image {
        if let ui = UIImage(named: name, in: .module, compatibleWith: nil) ?? UIImage(named: name) {
            return Image(uiImage: ui)
        }
        return Image(systemName: "rectangle.fill") // 万一のフォールバック
    }
}

