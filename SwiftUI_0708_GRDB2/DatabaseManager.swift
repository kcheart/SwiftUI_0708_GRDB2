//
//  DatabaseManager.swift
//  SwiftUI_0708_GRDB2
//
//  Created by Kevin Chen on 2020/7/8.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import GRDB

var dbQueue: DatabaseQueue!

class DatabaseManager {

    static func setup(for application: UIApplication) throws {
        let databaseURL = try FileManager.default
            .url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")

        dbQueue = try DatabaseQueue(path: databaseURL.path)
        
        try migrator.migrate(dbQueue)
        
        for _ in  0..<4 {
            addTestData()
        }
    }

    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        
        do {
            try dbQueue.erase()
        } catch {
            print("error erasing db: \(error)")
        }
        
        #endif
        
        migrator.registerMigration("createProject") { db in
            try db.create(table: "project") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull()
                t.column("description", .text)
                t.column("due", .date)
            }
        }
        
        migrator.registerMigration("v2") { db in
            try db.alter(table: "project") { t in
                t.add(column: "isDraft", .boolean).notNull().defaults(to: true)
            }

            try db.rename(table: "project", to: "collection")
        }
        
        return migrator
    }
    
    static func addTestData() {
        do {
            try dbQueue.write { db in
                var project = Project(
                    name: "Getting started with GRDB",
                    description: "A blog post",
                    due: Date().addingTimeInterval(24 * 60 * 60),
                    isDraft: false
                )
                
                try! project.insert(db)
                
                print(project)
            }
        } catch {
            print("\(error)")
        }
    }
}
