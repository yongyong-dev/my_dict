//
//  ItemDetailView.swift
//  myDictionary
//
//  Created by 권용진 on 2/26/24.
//

import SwiftUI

struct ItemDetailView: View {
    var item: Item
    
    var body: some View {
        VStack {
            Text(item.name)
                .font(.title)
            Text(item.description)
                .padding()
            Spacer()
        }
        .navigationBarTitle(item.name)
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(item: Item(id: 1, name: "Sample Item", description: "Sample Description"))
    }
}
