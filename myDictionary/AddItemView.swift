//
//  AddItemView.swift
//  myDictionary
//
//  Created by 권용진 on 2/26/24.
//

import SwiftUI

struct AddItemView: View {
    @Binding var isPresented: Bool
    @Binding var itemName: String
    @Binding var itemDescription: String
    var addItemAction: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Name")) {
                    TextField("Enter item name", text: $itemName)
                }
                Section(header: Text("Item Description")) {
                    TextField("Enter item description", text: $itemDescription)
                }
            }
            .navigationBarTitle("Add Item")
            .navigationBarItems(trailing:
                                    Button("Save") {
                self.addItemAction()
                self.isPresented = false
            }
            )
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(isPresented: .constant(true), itemName: .constant(""), itemDescription: .constant(""), addItemAction: {})
    }
}
