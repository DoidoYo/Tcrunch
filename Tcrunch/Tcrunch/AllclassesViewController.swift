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
import Whisper

class AllclassesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SettingsLauncherDelegate, BWWalkthroughViewControllerDelegate {
    
    var slideController: SlideMenuViewController?
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var containerDelegate: ContainerViewControllerDelegate?
    
    var settings: [String] = ["Leave Class", "Edit Display Name", "FAQ", "Log Out"]
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher(settings: self.settings)
        launcher.delegate = self
        return launcher
    }()
    
    var answeredTicket: [TTicket] = []
    var unansweredTicket: [TTicket] = []
    
    var _class: TClass?
    
    var navLabel: UILabel?
    
    var tap: UITapGestureRecognizer?
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var addClassButton: UIBarButtonItem!
    @IBAction func addClassPressed(_ sender: Any) {
        showJoinClassDialoge()
    }
    
    @IBAction func optionsPressed(_ sender: Any) {
        settingsLauncher.showSettings()
    }
    
    internal func settingsLauncher(SettingsSelected selected: String) {
        if selected == settings[0] { //Leave Class
            let classes = TcrunchHelper.getClasses()
            if _class != nil{
                for c in classes {
                    if c.id == _class?.id {
                        context.delete(c)
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        containerDelegate?.setCenterViewAll(TcrunchHelper.getClasses())
                    }
                }
            }
        } else if selected == settings[1] { //Edit Display Name
            showNameDialog(cancel: true)
        } else if selected == settings[2] { //FAQ
            
            let sb = UIStoryboard(name: "Tutorial", bundle: nil)
            let faq = sb.instantiateViewController(withIdentifier: "FAQVC") as! FAQViewController
            
            let parent = self.parent?.parent
            
            parent?.view.addSubview(faq.view)
            parent?.addChildViewController(faq)
            parent?.didMove(toParentViewController: faq)
            
            
        } else if selected == settings[3] { //Log Out
            self.performSegue(withIdentifier: "unwindToLogin", sender: self)
        }
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
//        self.view.addGestureRecognizer(tap!)
        containerDelegate?.movePanelRight()
        slidePanelShowing = true
    }
    func hidePanel() {
//        self.view.removeGestureRecognizer(tap!)
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
        
        if let name = UserDefaults.standard.string(forKey: "user_name") {
            TcrunchHelper.user_name = name
        } else {
            showTutorial()
        }
        
    }
    
    func showTutorial() {
        let sub = UIStoryboard(name: "Tutorial", bundle: nil)
        walkthrough = sub.instantiateViewController(withIdentifier: "walkthroughvc") as? BWWalkthroughViewController
        
        let page_one = sub.instantiateViewController(withIdentifier: "ST1")
        let page_two = sub.instantiateViewController(withIdentifier: "ST2")
        let page_three = sub.instantiateViewController(withIdentifier: "ST3")
        let page_four = sub.instantiateViewController(withIdentifier: "ST4")
        let page_five = sub.instantiateViewController(withIdentifier: "ST5")
        
        // Attach the pages to the master
        walkthrough?.delegate = self
        walkthrough?.add(viewController:page_one)
        walkthrough?.add(viewController:page_two)
        walkthrough?.add(viewController:page_three)
        walkthrough?.add(viewController:page_four)
        walkthrough?.add(viewController:page_five)
        
        let parent = self.parent?.parent
        parent?.view.addSubview((walkthrough?.view)!)
        parent?.addChildViewController(walkthrough!)
        parent?.didMove(toParentViewController: walkthrough)
    }
    var walkthrough:BWWalkthroughViewController?
    func walkthroughCloseButtonPressed() {
        walkthrough?.view.removeFromSuperview()
        walkthrough?.removeFromParentViewController()
        walkthrough?.didMove(toParentViewController: self)
        
        if let name = UserDefaults.standard.string(forKey: "user_name") {
            TcrunchHelper.user_name = name
        } else {
            self.showNameDialog(cancel:false)
        }
        
    }
    
    func showJoinClassDialoge() {
        let alertController = UIAlertController(title: "Join a class", message: "", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Course Code"
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        actionToEnable = UIAlertAction(title: "Join", style: .default, handler: {
            (action) in
            
            let textField = alertController.textFields![0]
            
            TcrunchHelper.joinClass(code: textField.text!, completion: {
                (re, tclass) in
                print(re)
                if re == JoinClass.DONE || re == JoinClass.ALREADY_JOINED{
                    self.loadClass(tclass!)
                } else {
                    let announcement = Announcement(title: "Error", subtitle: "Class not found!", image: #imageLiteral(resourceName: "cancel"), duration: 3, action: {})
                    Whisper.show(shout: announcement, to: self.parent!, completion: {
                        
                    })
                }
            })
        })
        actionToEnable?.isEnabled = false
        alertController.addAction(actionToEnable!)
        
        self.present(alertController, animated: true)
    }
    
    lazy var firstTime: Bool = {
        if let nameSet = UserDefaults.standard.string(forKey: "studentNameSet") {
            return true
        } else {
            return false
        }
    }()
    var actionToEnable : UIAlertAction?
    public func showNameDialog(cancel:Bool) {
        //prompt name
        let alertController = UIAlertController(title: "", message: "What's your full name?", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Your name"
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            
        })
        
        if cancel {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
        } else {
            firstTime = false
            UserDefaults.standard.set(true, forKey: "studentNameSet")
        }
        
        actionToEnable = UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            
            let textField = alertController.textFields![0]
            
            TcrunchHelper.user_name = textField.text!
            UserDefaults.standard.set(textField.text!, forKey: "user_name")
        })
        actionToEnable?.isEnabled = false
        alertController.addAction(actionToEnable!)
        
        self.present(alertController, animated: true)
    }
    func textChanged(_ sender:UITextField) {
        if (sender.text?.isEmpty)! {
            self.actionToEnable?.isEnabled = false
        } else {
            self.actionToEnable?.isEnabled = true
        }
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
        
        _class = nil
        
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
        
        if classes.count == 0 {
            self.tableView.reloadData()
            emptyLabel.isHidden = false
        }
    }
    
    var hello = 1
    
    func loadClass(_ tclass: TClass) {
        //loading overlay?
        
        _class = tclass
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell") as? TicketCell
        
        var selectedList = answeredTicket
        
        if indexPath.section == 0 {
            selectedList = unansweredTicket
        } else {
            selectedList = answeredTicket
        }
        
        //set question label
        cell?.questionText.text = selectedList[indexPath.row].question
        //set class name label
        if navLabel?.text == "All Classes" {
            cell?.classNameText.text = selectedList[indexPath.row].className_
        } else {
            cell?.classNameText.text = ""
        }
        
        //set released ticket time
        let unixTime = Double(selectedList[indexPath.row].startTime!) / 1000
        _ = Date.init().timeIntervalSince1970
        
        let releaseDate = Date(timeIntervalSince1970: unixTime)
        let currentDate = Date.init()
        
        _ = releaseDate.timeIntervalSince(currentDate)
        
        if releaseDate > currentDate {
            return UITableViewCell()
        } else {
            cell?.releaseTimeText.text = "Released \(dateformatter(from: releaseDate, to: currentDate))"
        }
        
        return cell!
    }
    
    func dateformatter(from: Date, to: Date) -> String {
        
        let date1:Date = from // Same you did before with timeNow variable
        let date2: Date = to
        
        let calender:Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1, to: date2)
//        print(components)
        var returnString:String = ""
//        print(components.second)
        
        if let year = components.year, year >= 1 {
            returnString = "\(year) " + (year > 1 ? "years" : "year") + " ago"
        } else if let month = components.month, month >= 1 {
            returnString = "\(month) " + (month > 1 ? "months" : "month") + " ago"
        } else if let day = components.day, day >= 1 {
            returnString = "\(day) " + (day > 1 ? "days" : "day") + " ago"
        } else if let hour = components.hour, hour >= 1 {
            returnString = "\(hour) " + (hour > 1 ? "hours" : "hour") + " ago"
        } else if let min = components.minute, min >= 1 {
            returnString = "\(min) " + (min > 1 ? "mins" : "min") + " ago"
        } else if let sec = components.second, sec < 60 {
            returnString = "Just Now"
        }
        
        return returnString
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let test = storyboard?.instantiateViewController(withIdentifier: "StudentTicketUnrespondedDetailViewController") as! StudentTicketUnrespondedDetailViewController
        
        //unanswered section
        if indexPath.section == 0 {
            test.ticket = unansweredTicket[indexPath.row]
        } else {
            //answered section
            test.ticket = answeredTicket[indexPath.row]
        }
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
        
        self.navigationController?.show(test, sender: nil)
        
    }
}

protocol AllclassesViewControllerDelegate {
    func addButtonPressed() -> Void
}
