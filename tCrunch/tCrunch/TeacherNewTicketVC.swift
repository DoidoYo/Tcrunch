//
//  TeacherNewTicketVC.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 8/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class TeacherNewTicketVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var classPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    var classTextField: UITextField!
    var dateTextField: UITextField!
    var timeTextField: UITextField!

    var multipleChoiceButton: CheckButton!
    var anonymousButton: CheckButton!
    
    var selectedClass: TClass_Temp?
    
    var navRightButton = UIBarButtonItem()
    
    @IBOutlet weak var tableView: UITableView!
    
    var multipleChoices = [MultipleChoice]()
    
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        classPicker.isHidden = true
        classPicker.delegate = self
        classPicker.dataSource = self
       
        datePicker.isHidden = true
        datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
        timePicker.isHidden = true
        timePicker.addTarget(self, action: #selector(timePickerChanged(sender:)), for: .valueChanged)
        
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        //create right button
        self.navigationItem.setRightBarButton(navRightButton, animated: true)
        //set size of JOIN CLASS Button text
        let fontSize:CGFloat = 13;
        let font:UIFont = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold)
        
        let attributes:[String : Any] = [NSFontAttributeName: font];
        
        navRightButton.setTitleTextAttributes(attributes, for: UIControlState.normal);
        navRightButton.title = "CREATE"
        
        self.navigationItem.title = "New Ticket"
        
        self.navigationController!.navigationBar.topItem!.title = "Back"
        
        //button press event
        navRightButton.action = #selector(self.navRightButtonPress(sender:))
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        classTextField.text = TcrunchHelper.teacherClasses[row].name
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TcrunchHelper.teacherClasses[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TcrunchHelper.teacherClasses.count
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func timePickerChanged(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        
        timeTextField.text = timeFormatter.string(from: sender.date)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == classTextField {
            classPicker.isHidden = false
        } else if textField == dateTextField {
            datePicker.isHidden = false
            datePickerChanged(sender: datePicker)
        } else if textField == timeTextField {
            timePicker.isHidden = false
            timePickerChanged(sender: timePicker)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        datePicker.isHidden = true
        timePicker.isHidden = true
        classPicker.isHidden = true
    }
    
    //created button pressed
    func navRightButtonPress(sender: UIBarButtonItem) {
        print("clicked")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else if section == 1 {
            return multipleChoices.count
        } else if section == 2 {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 3 {
            return 120
        }
        if indexPath.section == 0 && indexPath.row == 4 {
            return 40
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: "class")!
                classTextField = cell.viewWithTag(1) as! UITextField
                classTextField.text = selectedClass?.name
                
                for i in 0 ..< TcrunchHelper.teacherClasses.count {
                    if  TcrunchHelper.teacherClasses[i].name == selectedClass?.name {
                        classPicker.selectRow(i, inComponent: 0, animated: false)
                    }
                }
                
                classTextField.delegate = self
                break
                
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "launchDate")!
                dateTextField = cell.viewWithTag(1) as! UITextField
                dateTextField.delegate = self
                break
                
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: "launchTime")!
                timeTextField = cell.viewWithTag(1) as! UITextField
                timeTextField.delegate = self
                break
                
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: "question")!
                break
            
            case 4:
                cell = tableView.dequeueReusableCell(withIdentifier: "checkmarks")!
                
                let multipleChoiceButton = cell.viewWithTag(5) as! UIButton
                let anonymousButton = cell.viewWithTag(6) as! UIButton
                
                multipleChoiceButton.addTarget(self, action: #selector(tableButtonPressed(sender:)), for: .touchUpInside)
                anonymousButton.addTarget(self, action: #selector(tableButtonPressed(sender:)), for: .touchUpInside)
                
                break
                
            case 5:
                break
                
            default:
                break
            }
        } else if indexPath.section == 1 {
            
        } else {
            
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableButtonPressed(sender: UIButton) {
        let button = sender as! CheckButton
        
        button.isButtonChecked = !button.isButtonChecked
        
        //toggle tick mark
        if button.isButtonChecked {
            button.setImage(#imageLiteral(resourceName: "radio_selected"), for: .normal)
        } else {
            button.setImage(#imageLiteral(resourceName: "radio_unselected"), for: .normal)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

class MultipleChoice {
    var text: String?
    var selected:Bool = false
}
