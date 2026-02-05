import SwiftUI
import UIKit

struct CTAImageButtonStyle: ButtonStyle {
    let normalImageName: String
    let pressedImageName: String

    // いったん安全な値に落とす（見えること優先）
    var capInsets: EdgeInsets = .init(top: 20, leading: 120, bottom: 20, trailing: 120)

    func makeBody(configuration: Configuration) -> some View {
        let name = configuration.isPressed ? pressedImageName : normalImageName

        return configuration.label
            .background(background(for: name))
            .clipShape(Capsule()) // ←白い四角背景を切る
            .shadow(
                color: .black.opacity(configuration.isPressed ? 0.18 : 0.32),
                radius: configuration.isPressed ? 10 : 18,
                x: 0,
                y: configuration.isPressed ? 6 : 10
            )
            .scaleEffect(configuration.isPressed ? 0.985 : 1.0)
            .opacity(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }

    private let height: CGFloat = 86
    private let width: CGFloat = 520   // ここで大きさ決める（iPadなら 480〜620 くらい）

    @ViewBuilder
    private func background(for name: String) -> some View {
        Image(name, bundle: .module)
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
    }



    private func loadUIImage(named name: String) -> UIImage? {
        // SwiftPM Resources（.module） → Main bundle の順で探す
        if let ui = UIImage(named: name, in: .module, compatibleWith: nil) {
            return ui
        }
        return UIImage(named: name)
    }
}

