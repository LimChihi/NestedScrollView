//
//  ContentView.swift
//  Example
//
//  Created by lim on 29/10/2024.
//

import SwiftUI
import NestedScrollView

struct ContentView: View {
    var body: some View {
        NestedScrollView {
            Color.blue.frame(height: 100)
        } content: {
            List {
                ForEach(0..<100) {
                    Text("item: \($0)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
