//
//  ContentView.swift
//  Example
//
//  Created by lim on 29/10/2024.
//

import SwiftUI
import NestedScrollView

struct ContentView: View {
    
    @State var isPresented: Bool = false
    
    var body: some View {
        if isPresented {
            Color.yellow.frame(height: 100)
        }
        NestedScrollView {
            Color.blue.frame(height: 100)
                .onTapGesture {
                    binding.wrappedValue.toggle()

                }
        } content: {
            List {
                if isPresented {
                    Color.red.frame(height: 100)
                }
                ForEach(0..<100) {
                    Text("item: \($0)")
                        .onTapGesture {
                            binding.wrappedValue.toggle()

                        }
                }
            }
        }
    }
    
    
    var binding: Binding<Bool> {
        Binding.init {
            isPresented
        } set: { newValue in
            isPresented = newValue
        }

        
    }
}

#Preview {
    ContentView()
}
