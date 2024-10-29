// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct NestedScrollView<Header: View, Content: View>: View {
    
    private let header: Header
    
    private let content: Content
    
    public init(@ViewBuilder header: () -> Header, @ViewBuilder content: () -> Content) {
        self.header = header()
        self.content = content()
    }
    
    public var body: some View {
        NestedScrollViewImp(
            header: header,
            content: content
        )
        .ignoresSafeArea()
    }
}
