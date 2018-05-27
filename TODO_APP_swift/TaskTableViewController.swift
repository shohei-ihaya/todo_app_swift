//
//  TaskTableViewController.swift
//  TODO_APP_swift
//
//  Created by Shohei Ihaya on 2018/05/21.
//  Copyright © 2018年 Shohei Ihaya. All rights reserved.
//

import UIKit
import os.log

class TaskTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Propeties
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var createTaskButton: UIButton!
    @IBOutlet weak var showTaskButton: UIButton!

    var tasks = [Task]()
    var tasksForTable = [Task]()


    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedTasks = loadTasks() {
            tasks += savedTasks
        }
        //loadSampleTasks()
        tableView.delegate = self
        tableView.dataSource = self

        // setup showTaskButton
        setupShowTaskButton()

        // setup uncompleted tasks for table view
        tasksForTable = tasks.filter { $0.completed == false}


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "createTask":
            os_log("New task is created.")
        case "editTask":
            guard let taskViewController = segue.destination as? TaskViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedCell = sender as? UITableViewCell else {
                fatalError("Unexpected sender \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedTask = tasksForTable[indexPath.row]
            taskViewController.task = selectedTask
        case "Completed tasks":
            os_log("completed tasks button is selected.")
        case "Working tasks":
            os_log("working tasks button is selected.")
        default:
            fatalError("Unexpected segue \(segue)")
        }

    }

    @IBAction func unwindToTaskList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? TaskViewController, let task = sourceViewController.task {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {

                let taskBeforeEdit = tasksForTable[selectedIndexPath.row]
                if let index = tasks.index(of: taskBeforeEdit) {
                    tasks[index] = task
                }
                tasksForTable[selectedIndexPath.row] = task

                if taskBeforeEdit.completed == task.completed {
                  tableView.reloadRows(at: [selectedIndexPath], with: .none)
                } else if task.completed {
                    showCompletedTasks()
                } else {
                    showUnCompletedTasks()
                }
            } else {
                let newIndexPath = IndexPath(row: tasksForTable.count, section: 0)

                tasksForTable.append(task)
                tasks.append(task)
                if task.completed {
                    showCompletedTasks()
                } else {
                    showUnCompletedTasks()
                }
            }
            saveTasks()
        }
    }

    func setupShowTaskButton() {
        showTaskButton.addTarget(self, action: #selector(showTaskButtonPressed(sender:)), for: .touchUpInside)
    }

    @objc func showTaskButtonPressed(sender: UIButton) {
        if showTaskButton.titleLabel?.font == UIFont(name: "FontAwesome", size: 40) {
            showTaskButton.titleLabel?.font = UIFont(name: "Font Awesome 5 free", size: 40)
            showUnCompletedTasks()
        } else {
            showTaskButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 40)
            showCompletedTasks()
        }
    }

    func showUnCompletedTasks() {
        let unCompletedTasks = tasks.filter { $0.completed == false}
        tasksForTable = unCompletedTasks
        tableView.reloadData()
    }

    func showCompletedTasks() {
        let CompletedTasks = tasks.filter { $0.completed == true}
        tasksForTable = CompletedTasks
        tableView.reloadData()
    }

    @IBAction func createNewTask(sender: UIButton) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksForTable.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TaskTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskTableViewCell else {
            fatalError("The dequeud cell is not an instance of TaskTableViewCell")
        }

        let task = tasksForTable[indexPath.row]

        cell.taskTitle.text = task.title

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        if let limit = task.limit {
            cell.taskLimit.text = dateFormatter.string(from: limit as Date)
        } else {
            cell.taskLimit.text = nil
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let index = tasks.index(of: tasksForTable[indexPath.row]) {
                tasks.remove(at: index)
            }
            tasksForTable.remove(at: indexPath.row)
            saveTasks()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Methods
    /*
    private func loadSampleTasks() {
        let date: NSDate = NSDate()
        guard let task = Task(title: "first", limit: date, completed: true) else {
           fatalError("Instantize Task was failed")
        }

        tasks.append(task)
    }
 */

    private func saveTasks() {
       let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tasks, toFile: Task.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Tasks successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save tasks", log: OSLog.default, type: .debug)
        }
    }

    private func loadTasks() -> [Task]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Task.ArchiveURL.path) as? [Task]
    }
}
