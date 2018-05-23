//
//  TaskViewController.swift
//  TODO_APP_swift
//
//  Created by Shohei Ihaya on 2018/05/22.
//  Copyright © 2018年 Shohei Ihaya. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITextFieldDelegate {

    //MARK: Propeties
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var limitTextField: UITextField!

    var datePicker = UIDatePicker()
    var toolBar = UIToolbar()

    @IBOutlet weak var datePickerContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextField.delegate = self
        limitTextField.delegate = self

        setupDatePicker()
        setupUIToolBar()
        limitTextField.inputView = datePicker
        limitTextField.inputAccessoryView = toolBar

    }

    //MARK: datePicer
    func setupDatePicker() {
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(datePicker:)), for: .valueChanged)
    }

    @objc func datePickerValueChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        limitTextField.text = dateFormatter.string(from: datePicker.date)
    }

    //MARK: UIToolbar
    func setupUIToolBar() {
        toolBar = UIToolbar(frame: CGRect(x:0, y:0, width: view.frame.width, height: 40))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(sender:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
    }

    @objc func doneButtonPressed(sender: UIBarButtonItem) {
        limitTextField.resignFirstResponder()
    }

    // MARK: - UITextFieldDelegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case titleTextField:
            print("title")
        case limitTextField:
            print("title")
        default:
            fatalError("Unexpected textField is edited. \(textField)")
        }
        // Disable the Save button while editiong.
        //saveButton.isEnabled = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        titleTextField.resignFirstResponder()
        limitTextField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        //updateSaveButtonState()
        //navigationItem.title = textField.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
