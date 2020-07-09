//
//  Project.swift
//  SwiftUI_0708_GRDB2
//
//  Created by Kevin Chen on 2020/7/8.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import GRDB

struct Project {
    var id: Int64?
    var name: String
    var description: String?
    var due: Date?
    var isDraft: Bool
}

extension Project: Codable, FetchableRecord, MutablePersistableRecord {
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
