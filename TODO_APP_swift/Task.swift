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

    //MARK: Archiving path
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")

    //MARK: Types
    struct PropertyKey {
        static let title = "title"
        static let limit = "limit"
    }

    //MARK: Initialization
    init?(title: String, limit: NSDate?) {
        // title must not be empty
        guard !title.isEmpty else {
            return nil
        }
       
        // Initialize propeties
        self.title = title
        self.limit = limit
    }

    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(limit, forKey: PropertyKey.limit)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            return nil
        }

        let limit = aDecoder.decodeObject(forKey: PropertyKey.limit) as? NSDate

        self.init(title: title, limit: limit)
    }
}
