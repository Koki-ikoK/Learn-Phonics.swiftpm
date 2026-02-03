//
//  THHomeView.swift
//  Learn-Phonics
//
//  Created by Koki Iwaki on 2026/02/04.
//

import SwiftUI

struct THHomeView: View {
    private let repo = THContent.makeRepository()
    private let store = UserDefaultsProgressStore()

    var body: some View {
        NavigationStack {
            List {
                Section("Focus") {
                    NavigationLink("TH (/θ/ /ð/)", destination: THLessonView(repo: repo, store: store))
                }
            }
            .navigationTitle("Home")
        }
    }
}
