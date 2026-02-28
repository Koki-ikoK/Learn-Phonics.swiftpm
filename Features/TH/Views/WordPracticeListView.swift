//
//  WordPracticeListView.swift
//  Learn-Phonics
//
//  Created by Koki Iwaki on 2026/03/01.
//

import SwiftUI

struct WordPracticeListView: View {
    // 練習したい単語や発音記号のリスト
    let practiceItems = ["f", "v", "θ", "fan", "van", "think", "this"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("今日の練習メニュー")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(practiceItems, id: \.self) { item in
                        // 🌟 ここで先ほどの PhonicsAICheckView に移動します
                        NavigationLink(destination: PhonicsAICheckView(targetSymbol: item)) {
                            VStack(spacing: 10) {
                                Text(item)
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Image(systemName: "play.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity, minHeight: 120)
                            .background(Color.blue.gradient)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Daily Task")
    }
}
