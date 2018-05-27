//
//  TaskViewController.swift
//  TODO_APP_swift
//
//  Created by Shohei Ihaya on 2018/05/22.
//  Copyright © 2018年 Shohei Ihaya. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    //MARK: Propeties
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var limitTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    @IBOutlet weak var taskDescriptionTextViewPlaceholder: UILabel!

    var datePicker = UIDatePicker()
    var toolBar = UIToolbar()
    let dateFormatter = DateFormatter()

    var task: Task?

    @IBOutlet weak var datePickerContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextField.delegate = self
        limitTextField.delegate = self
        taskDescriptionTextView.delegate = self

        // Prepare for task limit field
        setupDateFormatter()
        setupDatePicker()
        setupUIToolBar()
        limitTextField.inputView = datePicker
        limitTextField.inputAccessoryView = toolBar


        // If task is existed(will be edited), prepare values of it.
        if let task = task {
            titleTextField.text = task.title
            limitTextField.text = dateFormatter.string(for: task.limit)
            if let detailDescription = task.detailDescription {
                taskDescriptionTextViewPlaceholder.isHidden = true
                taskDescriptionTextView.text = detailDescription
            }
        }
        // Prepare complete button
        setupCompleteButton()

    }

    //MARK: datePicer
    func setupDatePicker() {
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(datePicker:)), for: .valueChanged)
    }

    @objc func datePickerValueChanged(datePicker: UIDatePicker) {
        limitTextField.text = dateFormatter.string(from: datePicker.date)
    }

    //MARK: UIToolbar
    func setupUIToolBar() {
        toolBar = UIToolbar(frame: CGRect(x:0, y:0, width: view.frame.width, height: 40))
        let clearButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(clearButtonPressed(sender:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(sender:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([clearButton, flexibleSpace, doneButton], animated: true)
    }

    @objc func clearButtonPressed(sender: UIBarButtonItem) {
        limitTextField.text = nil
        limitTextField.resignFirstResponder()
    }

    @objc func doneButtonPressed(sender: UIBarButtonItem) {
        limitTextField.resignFirstResponder()
    }

    //MARK: complete button
    func setupCompleteButton() {
        completeButton.addTarget(self, action: #selector(completeButtonPressed(sender:)), for: .touchUpInside)
        if task?.completed ?? false {
            setCompleteButtonToComplete()
        }
    }

    @objc func completeButtonPressed(sender: UIButton) {
        if completeButton.titleLabel?.font == UIFont(name: "FontAwesome", size: 50) {
            setCompleteButtonToUnComplete()
        } else {
            setCompleteButtonToComplete()
        }
    }

    func setCompleteButtonToComplete() {
        completeButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 50)
        completeButton.setTitleColor(UIColor.green, for: UIControlState.normal)
    }

    func setCompleteButtonToUnComplete() {
        completeButton.titleLabel?.font = UIFont(name: "Font Awesome 5 free", size: 50)
        completeButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
    }

    // MARK: - UITextFieldDelegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editiong.
        saveButton.isEnabled = false

        // When date picker tapped, input its value into limitTextField.
        if (textField === limitTextField) {
          limitTextField.text = dateFormatter.string(from: datePicker.date)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        titleTextField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let title = titleTextField.text ?? ""
        saveButton.isEnabled = !title.isEmpty
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        taskDescriptionTextViewPlaceholder.isHidden = true
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if taskDescriptionTextView.text.isEmpty {
            taskDescriptionTextViewPlaceholder.isHidden = false
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if taskDescriptionTextView.isFirstResponder {
            taskDescriptionTextView.resignFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let button = sender as? UIButton, button === saveButton else {
            return
        }

        let title = titleTextField.text ?? ""
        var limit: NSDate?
        if let limitStr = limitTextField.text, !limitStr.isEmpty {
            limit = dateFormatter.date(from: limitStr)! as NSDate
        }
        let completed: Bool
        if completeButton.titleLabel?.font == UIFont(name: "FontAwesome", size: 50) {
            completed = true
        } else {
            completed = false
        }

        let detailDescription = taskDescriptionTextView.text

        task = Task(title: title, limit: limit, completed: completed, detailDescription: detailDescription)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: Private
    private func setupDateFormatter() {
      dateFormatter.dateStyle = .medium
    }

}
