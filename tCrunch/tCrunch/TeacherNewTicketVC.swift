//
//  TeacherNewTicketVC.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 8/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class TeacherNewTicketVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var classTextField: UITextField!
    var dateTextField: UITextField!
    var timeTextField: UITextField!
    var questionTextView: UITextView!

    var multipleChoiceButton: CheckButton?
    var anonymousButton: CheckButton?

    var selectedClass: TClass_Temp?
    
//    var _editTicket: TTicket?
    var editTicket: TTicket?
    
    var presetQuestion: String?
    
    var navRightButton:UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var multipleChoices = [MultipleChoice]()
    
    var editInitialized: [Bool] = [true,true,true,true]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //set size of JOIN CLASS Button text
        let fontSize:CGFloat = 13;
        let font:UIFont = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold)
        let attributes:[String : Any] = [NSFontAttributeName: font];
        
        //data is avalable
        if editTicket != nil {
            self.navigationItem.title = "Edit Ticket"
            
            let updateButton = UIBarButtonItem(title: "UPDATE", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.updateButtonPress(sender:)))
            updateButton.setTitleTextAttributes(attributes, for: .normal)
            let deleteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "trash"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.deleteButtonPressed(sender:)))
            
            navigationItem.rightBarButtonItems = [updateButton, deleteButton]
            
            tableView.reloadData()
            
        } else {
            //set size of JOIN CLASS Button text
            let fontSize:CGFloat = 13;
            let font:UIFont = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold)
            
            let attributes:[String : Any] = [NSFontAttributeName: font];
            
            navRightButton = UIBarButtonItem(title: "CREATE", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.navRightButtonPress(sender:)))
            
            navRightButton.setTitleTextAttributes(attributes, for: UIControlState.normal);
            
            self.navigationItem.title = "New Ticket"
            
            //create right button
            self.navigationItem.setRightBarButton(navRightButton, animated: true)
        }
        self.navigationController!.navigationBar.topItem!.title = "Back"
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
    
    //-----
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedClass = TcrunchHelper.teacherClasses[row]
        classTextField?.text = TcrunchHelper.teacherClasses[row].name!
    }
    func datePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        dateTextField?.text = dateFormatter.string(from: sender.date)
    }
    func timePickerChanged(_ sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        
        timeTextField?.text = timeFormatter.string(from: sender.date)
    }
    
    //------
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == classTextField {
            
            let picker = UIPickerView()
            picker.dataSource = self
            picker.delegate = self
            
            textField.inputView = picker
            
            
            if (classTextField.text?.isEmpty)! && TcrunchHelper.teacherClasses.count > 0{
                textField.text = TcrunchHelper.teacherClasses[0].name
                selectedClass = TcrunchHelper.teacherClasses[0]
            }
        } else if textField == timeTextField {
            
            let picker = UIDatePicker()
            picker.datePickerMode = .time
            picker.addTarget(self, action: #selector(timePickerChanged(_:)), for: .valueChanged)
//            timePickerChanged(picker)
            
            textField.inputView = picker
        } else if textField == dateTextField {
            
            let picker = UIDatePicker()
            picker.datePickerMode = .date
            picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
//            datePickerChanged(picker)
            
            textField.inputView = picker
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == timeTextField {
            timePickerChanged(textField.inputView as! UIDatePicker)
        } else if textField == dateTextField {
            datePickerChanged(textField.inputView as! UIDatePicker)
        }
    }
    
    func updateButtonPress(sender: UIBarButtonItem) {
        TcrunchHelper.deleteTicket(editTicket!)
        if let ticket = createTicket() {
            TcrunchHelper.create(Ticket: ticket, ForClass: selectedClass!, completion: {
                status in
                
                self.performSegue(withIdentifier: "unwindToTeacherClass", sender: self)
//                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func deleteButtonPressed(sender: UIBarButtonItem) {
        TcrunchHelper.deleteTicket(editTicket!)
        self.performSegue(withIdentifier: "unwindToTeacherClass", sender: self)
//        self.navigationController?.popViewController(animated: true)
    }
    //created button pressed
    func navRightButtonPress(sender: UIBarButtonItem) {
        if let ticket = createTicket() {
            TcrunchHelper.create(Ticket: ticket, ForClass: selectedClass!, completion: {
                status in
                
                self.performSegue(withIdentifier: "unwindToTeacherClass", sender: self)
//                self.navigationController?.popViewController(animated: true)
            })
        }
    }

    func createTicket() -> TTicket? {
        if !(dateTextField.text?.isEmpty)! && !(timeTextField.text?.isEmpty)! && !questionTextView.text.isEmpty {
            //get date
            let dFormatter = DateFormatter()
            dFormatter.dateFormat = "EEEE, MMM d, yyyy"
            let date = dFormatter.date(from: dateTextField.text!)
            
            //get time
            dFormatter.timeStyle = .short
            let time = dFormatter.date(from: timeTextField.text!)
            
            //combine both
            
            let cal = Calendar.current
            let dateComp = cal.dateComponents([.year, .month, .day], from: date!)
            let timeComp = cal.dateComponents([.hour, .minute], from: time!)
            
            var mergedComp = DateComponents()
            mergedComp.year = dateComp.year
            mergedComp.month = dateComp.month
            mergedComp.day = dateComp.day
            mergedComp.hour = timeComp.hour
            mergedComp.minute = timeComp.minute
            
            let mergedDate = cal.date(from: mergedComp)
            
            let unixTime = (mergedDate?.timeIntervalSince1970)! * 1000
            
            let ticket = TTicket()
            ticket.anonymous = anonymousButton?.isButtonChecked
            ticket.className_ = selectedClass?.name
            ticket.question = questionTextView.text
            ticket.startTime = CLongLong(unixTime)
            //            print()
            
            var stringChoices = [String]()
            
            for choice in multipleChoices {
                stringChoices.append(choice.text)
            }
            ticket.answerChoices = NSKeyedArchiver.archivedData(withRootObject: stringChoices)
            
            return ticket
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else if section == 1 {
            if let checked = multipleChoiceButton?.isButtonChecked, checked {
                if multipleChoices.count == 0 {
                    multipleChoices.append(MultipleChoice())
                }
                return multipleChoices.count
            } else {
                multipleChoices = [MultipleChoice]()
                return 0
            }
        } else if section == 2 {
            if let checked = multipleChoiceButton?.isButtonChecked, checked {
                return 1
            } else {
                return 0
            }
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
        if indexPath.section == 1 {
            return 40
        }
        if indexPath.section == 2 {
            return 30
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
                
                
                classTextField.delegate = self
                break
                
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "launchDate")!
                dateTextField = cell.viewWithTag(1) as! UITextField
                dateTextField.delegate = self
                
                if let unixTime = editTicket?.startTime, editInitialized[0] {
                    
                    editInitialized[0] = false
                    
                    let date = Date.init(timeIntervalSince1970: Double(unixTime)
                        / 1000)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                    
                    dateTextField?.text = dateFormatter.string(from: date)
                }
                
                
                break
                
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: "launchTime")!
                timeTextField = cell.viewWithTag(1) as! UITextField
                timeTextField.delegate = self
                
                if let unixTime = editTicket?.startTime, editInitialized[1] {
                    
                    editInitialized[1] = false
                    
                    let date = Date.init(timeIntervalSince1970: Double(unixTime)
                        / 1000)
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = .short
                    
                    timeTextField?.text = dateFormatter.string(from: date)
                }
                
                break
                
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: "question")!
                questionTextView = cell.viewWithTag(1) as! UITextView
                
                if let q = presetQuestion {
                    questionTextView.text = q
                }
                if let quest = editTicket?.question, editInitialized[2] {
                    
                    editInitialized[2] = false
                    
                    questionTextView.text = quest
                }
                
                break
            
            case 4:
                cell = tableView.dequeueReusableCell(withIdentifier: "checkmarks")!
                
                multipleChoiceButton = cell.viewWithTag(5) as? CheckButton
                anonymousButton = cell.viewWithTag(6) as? CheckButton
                
                multipleChoiceButton!.addTarget(self, action: #selector(tableButtonPressed(sender:)), for: .touchUpInside)
                anonymousButton!.addTarget(self, action: #selector(tableButtonPressed(sender:)), for: .touchUpInside)
                
                if let tik = editTicket, editInitialized[3] {
                    
                    editInitialized[3] = false
                    
                    if let data = tik.answerChoices {
                        let stringArray = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [String]
                        
                        if stringArray.count > 0 {
                            tableButtonPressed(sender: multipleChoiceButton!)
                        }
                        
                        multipleChoices = []
                        for ch in stringArray {
                            let mc = MultipleChoice()
                            mc.text = ch
                            multipleChoices.append(mc)
                        }
                    }
                    //toggle tick mark
                    if let anon = tik.anonymous, anon {
                        tableButtonPressed(sender: anonymousButton!)
                    }
                    
                }
                
                break
                
            case 5:
                break
                
            default:
                break
            }
        } else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "multipleChoice")!
            
            let text = cell.viewWithTag(1) as! UITextField
            text.delegate = self
            text.addTarget(self, action: #selector(textfieldMCChange(sender:)), for: .editingChanged)
            text.layer.setValue(indexPath.row, forKey: "index")
            text.placeholder = "Choice \(indexPath.row + 1)"
            text.text = multipleChoices[indexPath.row].text
            
            let closeButton = cell.viewWithTag(2) as! UIButton
            closeButton.layer.setValue(indexPath.row, forKey: "index")
            closeButton.addTarget(self, action: #selector(closeMCButtonPressed(sender:)), for: .touchUpInside)
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "addMC")!
            
            let addButton = cell.viewWithTag(1) as! UIButton
            addButton.addTarget(self, action: #selector(addMCButtonPressed(sender:)), for: .touchUpInside)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func textfieldMCChange(sender: UITextField) {
        if let index = sender.layer.value(forKey: "index") as? Int {
            multipleChoices[index].text = sender.text!
        }
    }
    
    func closeMCButtonPressed(sender: UIButton) {
        let index = sender.layer.value(forKey: "index") as! Int
        multipleChoices.remove(at: index)
        tableView.reloadData()
    }
    
    func addMCButtonPressed(sender: UIButton) {
        multipleChoices.append(MultipleChoice())
        tableView.reloadData()
    }
    
    func tableButtonPressed(sender: UIButton) {
        let button = sender as! CheckButton
        
        button.isButtonChecked = !button.isButtonChecked
        
        if sender == multipleChoiceButton {
            tableView.reloadData()
        }
        
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

enum Picker {
    case TIME
    case DATE
    case CLASS
}

class MultipleChoice {
    var text: String = ""
    var selected:Bool = false
}
