//
//  PhonemeSelectView.swift
//  Learn-Phonics
//
//  Created by Koki Iwaki on 2026/02/05.
//

import SwiftUI

struct PhonemeSelectView: View {
    let repo: THLessonRepository
    let store: ProgressStore

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {

                Card(title: "発音記号を選んで学ぶ", subtitle: "まずは TH（/ð/ と /θ/）から") {
                    Text("学びたい発音記号をタップしてレッスンへ。THは比較もできるよ。")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }

                VStack(spacing: 12) {
                    NavigationLink {
                        THLessonView(repo: repo, store: store, sound: .eth)
                    } label: {
                        PhonemeTile(
                            symbol: "/ð/",
                            title: "有声音（this）",
                            detail: "喉が震えるTH"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        THLessonView(repo: repo, store: store, sound: .theta)
                    } label: {
                        PhonemeTile(
                            symbol: "/θ/",
                            title: "無声音（think）",
                            detail: "息だけのTH"
                        )
                    }
                    .buttonStyle(.plain)
                }

                // 将来追加する音（SSCまでに増やす前提の「置き場所」）
                Card(title: "Coming Soon", subtitle: "SSCまでに追加しやすい枠") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("・/r/ と /l/")
                        Text("・/v/ と /b/")
                        Text("・/s/ と /ʃ/ (sh)")
                    }
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                }
            }
            .padding(16)
        }
        .navigationTitle("Phoneme")
    }
}

// NavigationLink のラベル用（ボタンを入れない）
private struct PhonemeTile: View {
    let symbol: String
    let title: String
    let detail: String

    var body: some View {
        HStack(spacing: 14) {
            Text(symbol)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .frame(width: 84, height: 64)
                .background(.ultraThinMaterial)
                .cornerRadius(16)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(.thinMaterial)
        .cornerRadius(18)
    }
}
