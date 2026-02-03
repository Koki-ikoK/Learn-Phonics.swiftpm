//
//  RootView.swift
//  Learn-Phonics
//
//  Created by Koki Iwaki on 2026/02/04.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationStack {
            THHomeView()
                .navigationTitle("Phonics (JP)")
        }
    }
}
