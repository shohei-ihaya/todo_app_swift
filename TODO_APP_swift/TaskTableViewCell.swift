//
//  TaskTableViewCell.swift
//  TODO_APP_swift
//
//  Created by Shohei Ihaya on 2018/05/21.
//  Copyright © 2018年 Shohei Ihaya. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    //MARK: Propeties
    @IBOutlet private weak var taskTitle: UILabel!
    @IBOutlet private weak var taskLimit: UILabel!

    func prepare(task: Task) {
        taskTitle.text = task.title
        taskLimit.text = task.limit.map { dateFormatter.string(from: $0) }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
