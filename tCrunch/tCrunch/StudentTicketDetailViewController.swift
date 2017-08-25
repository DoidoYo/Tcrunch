//
//  File.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 5/26/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class StudentTicketDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var navRightButton = UIBarButtonItem()
    var navTitle: UILabel?
    
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var responseText: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: StudentTicketDetailViewControllerDelegate?
    
    var tableData: [String:Bool] = [:]
    var tableCells: [UITableViewCell] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var detailType: DetailType?
    var question: String?
    var answer: String?
    var ticket: TTicket?
    var tickertPersistent: TTicketPersistent?
    
    override func viewDidLoad() {
        
        self.navigationItem.setRightBarButton(navRightButton, animated: true)
        self.navigationItem.title = "Response"
        
        //button press event
        navRightButton.action = #selector(self.navRightButtonPress(sender:))
        
        
        
        //actual initialization stuff
        //for Question
        questionText.text = ticket?.question
        
        var classes:[TTicketPersistent] = []
        do {
            classes = try context.fetch(TTicketPersistent.fetchRequest())
        } catch {
            //something
        }
        
        for item in classes {
            if item.id == self.ticket?.id {
                self.tickertPersistent = item
            }
        }
        
        if detailType == DetailType.ANSWERED {
            navRightButton.title = ""
            
            responseText.text = tickertPersistent?.answer
            
        } else {
            navRightButton.title = "Submit"
            responseText.becomeFirstResponder()
        }
        
        
        //init stuff for answer
        if let choices = ticket!.answerChoices, tickertPersistent?.answer == nil {
            let stringArray = NSKeyedUnarchiver.unarchiveObject(with: choices as Data) as! [String]  //tk unrar choices
            //add items to dictionary
            for item in stringArray {
                tableData[item] = false
            }
            
            tableView.delegate = self
            tableView.dataSource = self
            //show table not text
            responseText.isHidden = true
            tableView.isHidden = false
            
            tableView.reloadData()
        } else {
            //show text not table
            responseText.isHidden = false
            tableView.isHidden = true
        }
        
    }
    
    func customInit(detailType: DetailType, ticket:TTicket) {
        self.detailType = detailType
        self.ticket = ticket
    }
    
    func navRightButtonPress(sender: UIBarButtonItem) {
        if !responseText.isHidden {
            if responseText.text != "" {
                TcrunchHelper.set(Response: responseText.text, forTicket: ticket!, completion: {
                    delegate?.responseSubmitted(tclass: ticket!.tclass!)
                    self.navigationController?.popViewController(animated: true)
                    saveTicket(response: responseText.text)
                })
            }
        } else {
            var response = ""
            for (key,val) in tableData {
                if val {
                    response = key
                }
            }
            if response != "" {
                TcrunchHelper.set(Response: response, forTicket: ticket!, completion: {
                    delegate?.responseSubmitted(tclass: ticket!.tclass!)
                    self.navigationController?.popViewController(animated: true)
                    saveTicket(response: response)
                })
            }
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // remove selected from visible cells and from dictionary (or watever) -- TODO
        for cell in tableView.visibleCells {
            let imgView = cell.viewWithTag(1) as! UIImageView
            imgView.image = #imageLiteral(resourceName: "radio_unselected")
            let label = cell.viewWithTag(2) as! UILabel
            
            tableData[label.text!] = false
        }
        
        //add selected image to selected cell
        let cell = tableView.cellForRow(at: indexPath)
        let imgView = cell?.viewWithTag(1) as! UIImageView
        let label = cell?.viewWithTag(2) as! UILabel
        imgView.image = #imageLiteral(resourceName: "radio_selected")
        //add true or watever to storage -- TODO
        tableData[label.text!] = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "test")
        
        //        let view = cell?.viewWithTag(1) as! UIImageView
        let text = cell?.viewWithTag(2) as! UILabel
        
        text.text = Array(tableData.keys)[indexPath.row]
        
        if detailType == DetailType.ANSWERED {
            //make cell unselectable
            
        }
        
        cell?.selectionStyle = .none
        
        return cell!
    }
    
    
    
    
}

protocol StudentTicketDetailViewControllerDelegate {
    func responseSubmitted(tclass:TClass) -> Void
}

enum DetailType {
    case ANSWERED
    case UNANSWERED
}
