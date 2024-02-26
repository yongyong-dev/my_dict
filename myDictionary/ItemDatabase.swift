//
//  ItemDatabase.swift
//  myDictionary
//
//  Created by 권용진 on 2/26/24.
//

import SQLite
import Foundation

struct Item {
    var id: Int64?
    var name: String
    var description: String
}

class ItemDatabase {
    static let shared = ItemDatabase()
    
    private let db: Connection
    let itemsTable = Table("items")
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let description = Expression<String>("description")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        do {
            db = try Connection("\(path)/items.sqlite3")
            createTable()
        } catch {
            fatalError("Error creating database connection: \(error)")
        }
    }
    
    private func createTable() {
        do {
            try db.run(itemsTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(name)
                table.column(description)
            })
        } catch {
            fatalError("Error creating table: \(error)")
        }
    }
    
    func fetchItems() -> [Item] {
        do {
            let items = try db.prepare(itemsTable)
            return items.map { row in
                Item(id: row[id], name: row[name], description: row[description])
            }
        } catch {
            fatalError("Error fetching items: \(error)")
        }
    }
    
    func insertItem(name: String, description: String) {
        let insert = itemsTable.insert(self.name <- name, self.description <- description)
        do {
            try db.run(insert)
        } catch {
            fatalError("Error adding item: \(error)")
        }
    }
    
    func deleteItem(id: Int64) {
        let item = itemsTable.filter(self.id == id)
        do {
            try db.run(item.delete())
        } catch {
            fatalError("Error deleting item: \(error)")
        }
    }
}
