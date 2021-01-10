//
//  ProxyListItemView.swift
//  Proxyman
//
//  Created by KY1VSTAR on 10.01.2021.
//

import SwiftUI

struct ProxyListItemView: View {
    let item: Proxy
    
    var body: some View {
        Text(String(describing: item))
    }
}

struct ProxyListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProxyListItemView(item: .preview())
    }
}
