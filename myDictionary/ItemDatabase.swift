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
    private let dbURL: URL
    
    let itemsTable = Table("items")
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let description = Expression<String>("description")
    
    private init() {
            // 데이터베이스 파일의 URL 설정
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("items.sqlite3")
        self.dbURL = fileURL
        
            // Connection 설정
        do {
            db = try Connection(dbURL.path)
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
    
    func exportDatabase(to destinationURL: URL) throws {
            // 데이터베이스 파일을 목적지 URL로 복사합니다.
        try FileManager.default.copyItem(at: dbURL, to: destinationURL)
    }
    
    func importDatabase(from sourceURL: URL) throws {
            // 기존 데이터베이스 파일이 있으면 삭제합니다.
        if FileManager.default.fileExists(atPath: dbURL.path) {
            try FileManager.default.removeItem(at: dbURL)
        }
            // 소스 URL의 파일을 데이터베이스 파일로 복사합니다.
        try FileManager.default.copyItem(at: sourceURL, to: dbURL)
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
