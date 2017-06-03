//
//  AllclassesViewController.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AllclassesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var slideController: SlideMenuViewController?
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var containerDelegate: ContainerViewControllerDelegate?
    
    var answeredTicket: [TTicket] = []
    var unansweredTicket: [TTicket] = []
    
    var navLabel: UILabel?
    
    var tap: UITapGestureRecognizer?
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var addClassButton: UIBarButtonItem!
    @IBAction func addClassPressed(_ sender: Any) {
        let container = self.parent?.parent as! ContainerViewController
        container.showCodeDialog()
    }
    @IBAction func optionsPressed(_ sender: Any) {
    }
    @IBAction func menuPressed(_ sender: Any) {
        if slidePanelShowing == false {
            showPanel()
        } else {
            hidePanel()
        }
    }
    
    var slidePanelShowing:Bool = false
    
    func showPanel() {
        self.view.addGestureRecognizer(tap!)
        containerDelegate?.movePanelRight()
        slidePanelShowing = true
    }
    func hidePanel() {
        self.view.removeGestureRecognizer(tap!)
        containerDelegate?.movePanelCenter()
        slidePanelShowing = false
    }
    
    override func viewDidLoad() {
        //tap on this view while side view is showing
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        
        
        //set size of JOIN CLASS Button text
        let fontSize:CGFloat = 13;
        let font:UIFont = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold)
        
        let attributes:[String : Any] = [NSFontAttributeName: font];
        
        addClassButton.setTitleTextAttributes(attributes, for: UIControlState.normal);
        
        
        //
        navLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 320, height: 40))
        navLabel?.textAlignment = .left
        navLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navLabel?.text = self.navigationItem.title
        self.navigationItem.titleView = navLabel
        
        //setup table
        tableView.dataSource = self
        tableView.delegate = self
        
        let classes = TcrunchHelper.getClasses()
        if classes.count > 0 {
            loadClasses(classes)
        }
        
        //register custom cell
        tableView.register(UINib.init(nibName: "TicketCell", bundle: nil), forCellReuseIdentifier: "TicketCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: true)
        }
        
    }
    
    func tapped(_ sender: UITapGestureRecognizer) {
        if slidePanelShowing {
            hidePanel()
        }
    }
    
    var answerListenerAttached: Bool = false
    
    func attachAnswerListener() {
        //is called every time a question is answered, arranges tickets accordingly
        if !answerListenerAttached {
            answerListenerAttached = true
            TcrunchHelper.observeAnswers(completion: {
                answeredId in
                
                
                for item in self.unansweredTicket {
                    if answeredId.contains(item.id!) {
                        self.answeredTicket.append(item)
                        self.unansweredTicket.remove(at: self.unansweredTicket.index(where: {
                            tik in
                            if tik.id! == item.id {
                                return true
                            }
                            return false
                        })!)
                    }
                }
                
                self.tableView.reloadData()
                
            })
        }
    }
    
    func loadClasses(_ classes: [TClass]) {
        
        self.unansweredTicket = []
        self.answeredTicket = []
        
        TcrunchHelper.clearTicketObserve()
        
        navLabel?.text = "All Classes"
        
        for item in classes {
            TcrunchHelper.getStudentTickets(FromClass: item,completion: {
                (ansTicket, unansweTicket) in
                
                for item in unansweTicket {
                    if !self.unansweredTicket.contains(where: {
                        (tik) in
                        if tik.id == item.id {
                            return true
                        }
                        return false
                    }) {
                        self.unansweredTicket.append(item)
                    }
                }
                
                for item in ansTicket {
                    if !self.answeredTicket.contains(where: {
                        (tik) in
                        if tik.id == item.id {
                            return true
                        }
                        return false
                    }) {
                        self.answeredTicket.append(item)
                    }
                }
                
                self.tableView.reloadData()
                
                if self.answeredTicket.count == 0 && self.unansweredTicket.count == 0 {
                    self.emptyLabel.isHidden = false
                } else {
                    self.emptyLabel.isHidden = true
                }
            })
        }
        hidePanel()
        attachAnswerListener()
    }
    
    var hello = 1
    
    func loadClass(_ tclass: TClass) {
        //loading overlay?
        
        TcrunchHelper.clearTicketObserve()
        TcrunchHelper.getStudentTickets(FromClass: tclass,completion: {
            (ansTicket, unansweTicket) in
            
            self.unansweredTicket = unansweTicket
            self.answeredTicket = ansTicket
            
            self.navLabel?.text = tclass.name!
            
            self.tableView.reloadData()
            
            if self.answeredTicket.count == 0 && self.unansweredTicket.count == 0 {
                self.emptyLabel.isHidden = false
            } else {
                self.emptyLabel.isHidden = true
            }
        })
        attachAnswerListener()
    }
    
    //table stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return unansweredTicket.count
        } else {
            return answeredTicket.count
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if unansweredTicket.count == 0 {
                return ""
            }
            return "Not Answered"
        } else {
            if answeredTicket.count == 0 {
                return ""
            }
            return "Answered"
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell") as? TicketCell
        
        var selectedList = answeredTicket
        
        if indexPath.section == 0 {
            selectedList = unansweredTicket
        } else {
            selectedList = answeredTicket
        }
        
        cell?.questionText.text = selectedList[indexPath.row].question
        
        if navLabel?.text == "All Classes" {
            cell?.classNameText.text = selectedList[indexPath.row].className_
        } else {
            cell?.classNameText.text = ""
        }

        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let detailVC = storyboard?.instantiateViewController(withIdentifier: "StudentTicketDetailViewController") as? StudentTicketDetailViewController
//        
//        //pass data to detail vc
//        if indexPath.section == 0 {
//            detailVC?.customInit(detailType: DetailType.UNANSWERED, ticket: unansweredTicket[indexPath.row])
//        } else {
//            detailVC?.customInit(detailType: DetailType.ANSWERED, ticket: answeredTicket[indexPath.row])
//        }
//        
//        let backButton = UIBarButtonItem()
//        backButton.title = "Back"
//        navigationItem.backBarButtonItem = backButton
//        
//        self.navigationController?.show(detailVC!, sender: nil)
        
        let test = storyboard?.instantiateViewController(withIdentifier: "StudentTicketUnrespondedDetailViewController")
        self.navigationController?.show(test!, sender: nil)
    }
    
    
    
}

protocol AllclassesViewControllerDelegate {
    func addButtonPressed() -> Void
}
