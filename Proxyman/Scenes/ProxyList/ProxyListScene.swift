//
//  ProxyListScene.swift
//  Proxyman
//
//  Created by KY1VSTAR on 10.01.2021.
//

import SwiftUI

struct ProxyListScene: View {
    private let viewModel = ProxyListViewModel()
    
    var body: some View {
        ProxyListView()
            .environmentObject(viewModel)
    }
}
