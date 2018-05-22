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
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskLimit: NSDate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
