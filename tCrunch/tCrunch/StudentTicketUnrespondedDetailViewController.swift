//
//  StudentTicketUnrespondedDetailViewController.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 5/28/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Whisper

class StudentTicketUnrespondedDetailViewController: UITableViewController {
    
    var ticket: TTicket?
    
    var responseCell: UITableViewCell?
    
    var choice_answer: [String:Bool] = [:]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tickertPersistent: TTicketPersistent?
    
    var isEditable:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let arr = ticket?.answerChoices {
            let choices = NSKeyedUnarchiver.unarchiveObject(with: arr as Data) as! [String]
            for item in choices {
                choice_answer[item] = false
            }
        }
        
        
        //get stored ticket information if it exists
        var classes:[TTicketPersistent] = []
        do {
            classes = try context.fetch(TTicketPersistent.fetchRequest())
        } catch {
            //something
        }
        
        for item in classes {
            if item.id == self.ticket?.id {
                self.tickertPersistent = item
                isEditable = false
                
            }
        }
        
        //set title
        self.navigationItem.title = "Answer"
        
        if isEditable {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(self.submitPressed(sender:)))
            self.navigationItem.title = "Response"
        }
        
        
    }
    
    func submitPressed(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Are you sure you want to submit?", message: "You may not edit your response.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(cancelAction)
        
        let actionToEnable = UIAlertAction(title: "Yes", style: .default, handler: {
            (action) in
            
            
            if self.choice_answer.count > 0 {
                var answer: String = ""
                print("----------------------")
                for item in self.choice_answer {
                    if item.value {
                        answer = item.key
                    }
                }
                if answer != "" {
                    TcrunchHelper.set(Response: answer, forTicket: self.ticket!, completion: {
                        self.navigationController!.popViewController(animated: true)
                        self.saveTicket(response: answer)
                    })
                } else {
                    let announcement = Announcement(title: "Warning", subtitle: "Please select an answer choice.", image: #imageLiteral(resourceName: "cancel"), duration: 3, action: {})
                    Whisper.show(shout: announcement, to: self.parent!, completion: {
                        
                    })
                }
                
                
            } else {
                let cellText = self.responseCell?.viewWithTag(1) as! UITextView
                if cellText.text != "" {
                    print(cellText.text)
                    TcrunchHelper.set(Response: cellText.text, forTicket: self.ticket!, completion: {
                        self.navigationController!.popViewController(animated: true)
                        self.saveTicket(response: cellText.text)
                    })
                } else {
                    let announcement = Announcement(title: "Warning", subtitle: "Please answer the question.", image: #imageLiteral(resourceName: "cancel"), duration: 3, action: {})
                    Whisper.show(shout: announcement, to: self.parent!, completion: {
                        
                    })
                }
            }
            
        })
        alertController.addAction(actionToEnable)
        
        self.present(alertController, animated: true)
        
    }
    
    func saveTicket(response: String) {
        let persistentTicket = TTicketPersistent(context: context)
        persistentTicket.anonymous = (ticket?.anonymous)!
        persistentTicket.answerChoices = ticket?.answerChoices as NSData?
        persistentTicket.className_ = ticket?.className_
        persistentTicket.endTime = ticket?.endTime
        persistentTicket.startTime = "\(ticket?.startTime)"
        persistentTicket.question = ticket?.question
        persistentTicket.id = ticket?.id
        persistentTicket.tclass = ticket?.tclass
        persistentTicket.answer = response
        //save
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 || indexPath.row == 2 {
                return 27
            } else if indexPath.row == 1 {
                return UITableViewAutomaticDimension
            }
            
        } else {
            
            if choice_answer.count > 0 {
                
                return 44
                
            } else {
                let responseTextView = responseCell?.viewWithTag(1) as! UITextView
                
                if responseTextView.frame.height >= 100 {
                    responseTextView.isScrollEnabled = true
                    return 100
                }
                
                let fixedWidth = responseTextView.frame.size.width
                responseTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
                let newSize = responseTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
                var newFrame = responseTextView.frame
                newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
                
                return newFrame.height
            }
            
        }
        print("error returning height!")
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
            case 0:
                return tableView.dequeueReusableCell(withIdentifier: "question")!
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "questionText")
                (cell?.viewWithTag(1) as! UITextView).text = ticket?.question
                return cell!
            case 2:
                return tableView.dequeueReusableCell(withIdentifier: "answer")!
            default:
                print("No cell returned!")
                return UITableViewCell()
            }
            
        } else {
            
            if choice_answer.count > 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "answerChoice")
                
                let textView = cell?.viewWithTag(2) as! UILabel
                let imgView = cell?.viewWithTag(1) as! UIImageView
                
                textView.text = Array(self.choice_answer.keys)[indexPath.row]
                
                if self.tickertPersistent?.answer == textView.text {
                    imgView.image = #imageLiteral(resourceName: "radio_selected")
                    choice_answer[textView.text!] = true
                }
                
                if !isEditable {
                    cell?.selectionStyle = .none
                }
                
                return cell!
                
            } else {
                
                responseCell = tableView.dequeueReusableCell(withIdentifier: "answerText")
                let textView = responseCell?.viewWithTag(1) as! UITextView
                
                textView.isEditable = isEditable
                textView.text = tickertPersistent?.answer
                
                if !textView.isFirstResponder {
                    textView.becomeFirstResponder()
                }
                
                return responseCell!
                
            }
            
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            if choice_answer.count > 0 {
                return choice_answer.count
            } else {
                return 1
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditable {
            if indexPath.section == 1 {
                let cells = tableView.visibleCells
                for cell in cells {
                    if tableView.indexPath(for: cell)?.section == 1 {
                        let imgView = cell.viewWithTag(1) as! UIImageView
                        imgView.image = #imageLiteral(resourceName: "radio_unselected")
                        
                        let textView = cell.viewWithTag(2) as! UILabel
                        choice_answer[textView.text!] = false
                    }
                }
                let selectedCell = tableView.cellForRow(at: indexPath)
                let imgView = selectedCell?.viewWithTag(1) as! UIImageView
                imgView.image = #imageLiteral(resourceName: "radio_selected")
                
                let textView = selectedCell?.viewWithTag(2) as! UILabel
                choice_answer[textView.text!] = true
                
                if let selected = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: selected, animated: true)
                }
            }
        }
    }
    
}
