//
//  Task.swift
//  TODO_APP_swift
//
//  Created by Shohei Ihaya on 2018/05/21.
//  Copyright © 2018年 Shohei Ihaya. All rights reserved.
//

import UIKit

class Task {
    
    //MARK: Propeties
    var title: String
    var limit: NSDate?

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
}
