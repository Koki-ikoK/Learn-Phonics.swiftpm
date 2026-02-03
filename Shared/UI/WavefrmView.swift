//
//  WavefrmView.swift
//  Learn-Phonics
//
//  Created by Koki Iwaki on 2026/02/04.
//

import SwiftUI

struct WaveformView: View {
    let levels: [Float]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let count = max(levels.count, 1)
            let step = w / CGFloat(count)

            Path { p in
                for (i, lv) in levels.enumerated() {
                    let x = CGFloat(i) * step
                    let barH = max(2, CGFloat(lv) * h)
                    p.addRect(CGRect(x: x, y: (h - barH) / 2, width: max(1, step * 0.7), height: barH))
                }
            }
            .fill(.primary.opacity(0.35))
        }
        .frame(height: 64)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.primary.opacity(0.12)))
    }
}
