//
//  File.swift
//  NestedScrollView
//
//  Created by lim on 29/10/2024.
//

import UIKit
import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

struct NestedScrollViewImp<Header: View, Content: View>: UIViewControllerRepresentable {
    
    private let header: Header
    
    private let content: Content
    
    init(header: Header, content: Content) {
        self.header = header
        self.content = content
    }
    
    func makeUIViewController(context: Context) -> NestedScrollViewController<Header, Content> {
        NestedScrollViewController(header: header, content: content)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // empty
    }
    
}


final class NestedScrollViewController<Header: View, Content: View>: UIViewController, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
    
    private let header: Header
    
    private let content: Content
    
    private var headerView: UIView!
    
    private var contentViewController: UIViewController!
    
    private var observation: NSKeyValueObservation?
    
    weak var contentScrollView: UIScrollView? {
        didSet {
            guard let contentScrollView, contentScrollView != oldValue else {
                return
            }
            scrollViewDidChange()
        }
    }
    
    init(header: Header, content: Content) {
        self.header = header
        self.content = content
        self.headerView = nil
        self.contentViewController = nil
        self.contentScrollView = nil
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateContentSize()
    }
    
    private func setupUI() {
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        let headerConfig = UIHostingConfiguration {
            header
        }.margins(.all, 0)
        headerView = headerConfig.makeContentView()
        headerView.frame = CGRect(origin: .zero, size: headerView.sizeThatFits(view.bounds.size))
        scrollView.addSubview(headerView)

        contentViewController = UIHostingController(rootView: content            .introspect(.scrollView, on: .iOS(.v16...)) { scrollview in
            self.contentScrollView = scrollview
        })
        addChild(contentViewController)
        contentViewController.view.frame = CGRect(origin: CGPoint(x: 0, y: headerView.frame.height), size: contentViewController.view.sizeThatFits(view.bounds.size))

        scrollView.addSubview(contentViewController.view)
    }

    
    private func scrollViewDidChange() {
        guard let contentScrollView else { return }
        contentScrollView.isScrollEnabled = false
        
        self.observation = contentScrollView.observe(\.contentSize, options: [.new, .initial]) { [weak self] (scrollView, changeValue) in
            Task { @MainActor in
                self?.updateContentSize()
            }
        }
    }
    
    private func updateContentSize() {
        let contentHeight: CGFloat
        if let contentScrollView {
            contentHeight = contentScrollView.contentSize.height
        } else {
            contentHeight = contentViewController.view.bounds.height
        }
        scrollView.contentSize = CGSize(
            width: view.frame.width,
            height: headerView.bounds.height + contentHeight
        )
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let contentScrollView else { return }
        
        let diffOffset = max(scrollView.bounds.origin.y - headerView.frame.height, 0)
        contentScrollView.frame.origin = CGPoint(x: 0, y: diffOffset)
        contentScrollView.contentOffset = CGPoint(x: 0, y: diffOffset)
    }
    
}
