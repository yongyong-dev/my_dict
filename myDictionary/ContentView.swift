//
//  ContentView.swift
//  myDictionary
//
//  Created by 권용진 on 2/26/24.
//

import SwiftUI

struct ContentView: View {
    @State private var items: [Item] = []
    @State private var isAddingItem = false
    @State private var newItemName = ""
    @State private var newItemDescription = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.id) { item in
                    NavigationLink(destination: ItemDetailView(item: item)) {
                        Text(item.name)
                    }
                }
                .onDelete(perform: deleteItem)
            }
            .navigationBarTitle("Dictionary")
            .navigationBarItems(trailing:
                                    Button(action: {
                self.isAddingItem = true
            }) {
                Image(systemName: "plus")
            }
            )
        }
        .sheet(isPresented: $isAddingItem) {
            AddItemView(isPresented: self.$isAddingItem, itemName: self.$newItemName, itemDescription: self.$newItemDescription, addItemAction: {
                    // Add item to the database
                ItemDatabase.shared.insertItem(name: self.newItemName, description: self.newItemDescription)
                    // Refresh item list
                self.fetchItemsFromDatabase()
                    // Reset input fields
                self.newItemName = ""
                self.newItemDescription = ""
            })
        }
        .onAppear {
                // Fetch items from the database when view appears
            self.fetchItemsFromDatabase()
        }
    }
    
    func fetchItemsFromDatabase() {
        self.items = ItemDatabase.shared.fetchItems()
    }
    
    func deleteItem(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { items[$0] }
        for item in itemsToDelete {
            ItemDatabase.shared.deleteItem(id: item.id!)
        }
        self.items.remove(atOffsets: offsets)
    }
}
