//
//  Task.swift
//  TODO_APP_swift
//
//  Created by Shohei Ihaya on 2018/05/21.
//  Copyright © 2018年 Shohei Ihaya. All rights reserved.
//

import UIKit

class Task: NSObject, NSCoding {
    //MARK: Propeties
    var title: String
    var limit: NSDate?
    var completed: Bool

    //MARK: Archiving path
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")

    //MARK: Types
    struct PropertyKey {
        static let title = "title"
        static let limit = "limit"
        static let completed = "completed"
    }

    //MARK: Initialization
    init?(title: String, limit: NSDate?, completed: Bool) {
        // title must not be empty
        guard !title.isEmpty else {
            return nil
        }
       
        // Initialize propeties
        self.title = title
        self.limit = limit
        self.completed = completed
    }

    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(limit, forKey: PropertyKey.limit)
        aCoder.encode(completed, forKey: PropertyKey.completed)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            return nil
        }

        let limit = aDecoder.decodeObject(forKey: PropertyKey.limit) as? NSDate

        let completed = aDecoder.decodeBool(forKey: PropertyKey.completed)

        self.init(title: title, limit: limit, completed: completed)
    }
}
