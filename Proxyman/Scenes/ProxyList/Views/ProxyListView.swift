//
//  ProxyListView.swift
//  Proxyman
//
//  Created by KY1VSTAR on 10.01.2021.
//

import SwiftUI

struct ProxyListView: View {
    @EnvironmentObject
    private var viewModel: ProxyListViewModel
    @State
    private var isAddActive = false
    
    var body: some View {
        List {
            ForEach(viewModel.state.proxies, id: \.id) { item in
                NavigationLink(
                    destination: ProxyDetailScene(proxy: item),
                    label: {
                        ProxyListItemView(item: item)
                    }
                )
            }
            .onDelete {
                $0.forEach {
                    let item = viewModel.state.proxies[$0]
                    viewModel.emit(.remove(item))
                }
            }
        }
        .navigationBarItems(trailing: Button(action: {
            isAddActive = true
        }, label: {
            Image(systemName: "plus.circle.fill")
                .imageScale(.large)
        }))
        .background(
            NavigationLink(
                destination: ProxyDetailScene(),
                isActive: $isAddActive
            ) { EmptyView() }
            .hidden()
        )
        .onAppear { viewModel.emit(.load) }
    }
}

struct ProxyListView_Previews: PreviewProvider {
    static var previews: some View {
        ProxyListView()
    }
}
