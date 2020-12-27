//
//  ContentView.swift
//  Proxyman
//
//  Created by KY1VSTAR on 25.12.2020.
//

import SwiftUI
import Combine

var cancellables = [AnyCancellable]()

struct ContentView: View {
    var body: some View {
        Button("Add proxy") {
            addProxy()
        }
    }
    
    private func addProxy() {
        let proxy = Proxy(
            displayName: "Charles",
            configuration: .manual(.init(
                type: .http,
                serverAddress: "192.168.0.110",
                serverPort: 27016
            ))
        )
        
        DefaultProxyRepository.shared
            .saveProxy(proxy)
            .sink {
                print($0)
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
