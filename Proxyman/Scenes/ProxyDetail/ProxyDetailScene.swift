//
//  ProxyDetailScene.swift
//  Proxyman
//
//  Created by KY1VSTAR on 10.01.2021.
//

import SwiftUI

struct ProxyDetailScene: View {
    private let viewModel: ProxyDetailViewModel
    
    init(proxy: Proxy? = nil) {
        viewModel = .init(proxy: proxy)
    }
    
    var body: some View {
        ProxyDetailView()
            .environmentObject(viewModel)
    }
}
