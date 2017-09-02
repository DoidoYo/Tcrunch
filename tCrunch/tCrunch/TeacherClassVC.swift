//
//  TeacherClassViewController.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 7/12/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class TeacherClassVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SettingsLauncherDelegate, BWWalkthroughViewControllerDelegate {
    
    var parentVC: TeacherContainerVC?
    var navLabel: UILabel?
    
    var settings:[String] = ["Class Code", "Delete Class", "Change Name", "Suggested Questions", "FAQ", "Log Out"]
    
    lazy var sLauncher:SettingsLauncher = {
        let launcher = SettingsLauncher(settings: self.settings)
        launcher.delegate = self
        return launcher
    }()
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var _classes: [TClass_Temp] = []
    
    private var _selectedClass:TClass_Temp?
    var selectedClass: TClass_Temp? {
        get {
            return _selectedClass
        }
        set{
            _selectedClass = newValue
            
            
            setClassTitle((newValue?.name)!)
            getTickets()
            
            emptyLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var addClassButton: UIBarButtonItem!
    
    var tickets: [TTicket] = []
    
    var upcomingTickets: [TTicket] = []
    var launchedTickets: [TTicket] = []
    
    @IBOutlet weak var newTicketButton: UIButton!
    @IBAction func newTicketButtonPress(_ sender: Any) {
        let newTicketVC = storyboard?.instantiateViewController(withIdentifier: "TeacherNewTicketVC") as! TeacherNewTicketVC
        newTicketVC.selectedClass = selectedClass
//        print("sending class")
        self.navigationController?.show(newTicketVC, sender: self)
    }
    
    override func viewDidLoad() {
        parentVC = self.parent?.parent as! TeacherContainerVC
        
        //set size of JOIN CLASS Button text
        let fontSize:CGFloat = 13;
        let font:UIFont = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold)
        
        let attributes:[String : Any] = [NSFontAttributeName: font];
        
        addClassButton.setTitleTextAttributes(attributes, for: UIControlState.normal);
        
        
        setClassTitle(self.navigationItem.title!)
        
        
        //init observers
        TcrunchHelper.observeTeacherClasses(completion: {
            classes in
            
            if classes.count > 0 {
                
                if let sClass = self.selectedClass {
                    var found = false
                    for _class in classes {
                        if _class.name == sClass.name {
                            found = true
                        }
                    }
                    if !found{
                        self.selectedClass = classes[0]
                    }
                } else {
                    self.selectedClass = classes[0]
                }
                
                self.emptyLabel.isHidden = true
                self.emptyLabel.text = ""
            } else {
                //change things so that user knows there are no classes
                self.emptyLabel.isHidden = false
                self.emptyLabel.text = "You have no classes."
                self.setClassTitle("Tcrunch")
            }
            self._classes = classes
        })
        //check existing classes
        
        
        tableView.delegate = self
        tableView.dataSource = self
        //register custom cell
        tableView.register(UINib.init(nibName: "TicketCell", bundle: nil), forCellReuseIdentifier: "TicketCell")
        
        if let name = UserDefaults.standard.string(forKey: "user_teacher_name") {
            TcrunchHelper.user_name = name
        } else {
            showTutorial()
        }
        
    }
    func showTutorial() {
        let sub = UIStoryboard(name: "Tutorial", bundle: nil)
        walkthrough = sub.instantiateViewController(withIdentifier: "walkthroughvc") as? BWWalkthroughViewController
        
        let page_one = sub.instantiateViewController(withIdentifier: "TT1")
        let page_two = sub.instantiateViewController(withIdentifier: "TT2")
        let page_three = sub.instantiateViewController(withIdentifier: "TT3")
        let page_four = sub.instantiateViewController(withIdentifier: "TT4")
        let page_five = sub.instantiateViewController(withIdentifier: "TT5")
        let page_six = sub.instantiateViewController(withIdentifier: "TT6")
        let page_seven = sub.instantiateViewController(withIdentifier: "TT7")
        let page_eight = sub.instantiateViewController(withIdentifier: "TT8")
        
        // Attach the pages to the master
        walkthrough?.delegate = self
        walkthrough?.add(viewController:page_one)
        walkthrough?.add(viewController:page_two)
        walkthrough?.add(viewController:page_three)
        walkthrough?.add(viewController:page_four)
        walkthrough?.add(viewController:page_five)
        walkthrough?.add(viewController:page_six)
        walkthrough?.add(viewController:page_seven)
        walkthrough?.add(viewController:page_eight)
        
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
        
        if let name = UserDefaults.standard.string(forKey: "user_teacher_name") {
            TcrunchHelper.user_name = name
        } else {
            self.showTeacherNameDialog(cancel: false)
        }
        
    }
    
    lazy var firstTime: Bool = {
        if let nameSet = UserDefaults.standard.string(forKey: "teacherNameSet") {
            return true
        } else {
            return false
        }
    }()
    var actionToEnable : UIAlertAction?
    func showTeacherNameDialog(cancel:Bool) {
        let alertController = UIAlertController(title: "What's your name?", message: "This is the name that students will see.", preferredStyle: .alert)
        
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
            UserDefaults.standard.set(true, forKey: "teacherNameSet")
        }
        
        actionToEnable = UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            
            let textField = alertController.textFields![0] 
            
            UserDefaults.standard.set(textField.text!, forKey: "user_teacher_name")
            TcrunchHelper.user_name = textField.text!
            
        })
        actionToEnable?.isEnabled = false
        alertController.addAction(actionToEnable!)
        
        self.present(alertController, animated: true)
    }
    
    internal func settingsLauncher(SettingsSelected selected: String) {
        //class code
        if selected == settings[0] {
            
            let alertController = UIAlertController(title: "Class Code for \(selectedClass!.name!)", message: selectedClass?.courseCode, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true)
            
        } else if selected == settings[1] {
            //delete class
            
            let alertController = UIAlertController(title: "Delete \(selectedClass!.name!)?", message: "This action cannot be undone. All tickets and responses of this class will be deleted.", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                if let _class = self.selectedClass {
                    TcrunchHelper.deleteClass(_class)
                }
            }
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)

            self.present(alertController, animated: true)
            
        } else if selected == settings[2] {
            //change name
            self.showTeacherNameDialog(cancel: true)
            
        } else if selected == settings[3] {
            //suggested questions
            let sq = storyboard?.instantiateViewController(withIdentifier: "TeacherSQVC")
            
            self.navigationController?.show(sq!, sender: self)
            
        } else if selected == settings[4] {
            //faq
            let sb = UIStoryboard(name: "Tutorial", bundle: nil)
            let faq = sb.instantiateViewController(withIdentifier: "FAQVC") as! FAQViewController
            
            let parent = self.parent?.parent
            
            parent?.view.addSubview(faq.view)
            parent?.addChildViewController(faq)
            parent?.didMove(toParentViewController: faq)
        } else if selected == settings[5] {
            //log out
            parentVC?.logOut()
        }
    }
    func textChanged(_ sender:UITextField) {
        if (sender.text?.isEmpty)! {
            self.actionToEnable?.isEnabled = false
        } else {
           self.actionToEnable?.isEnabled = true
        }
    }
    
    private var nameTF: UITextField?
    private var codeTF: UITextField?
    func showCreateClassVC() {
        
        let alertController = UIAlertController(title: "Add a new class", message: "", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: {
            textField in
            
            self.nameTF = textField
            textField.placeholder = "Class Name"
            textField.addTarget(self, action: #selector(self.createClassTextChange(_:)), for: .editingChanged)
            
        })
        alertController.addTextField(configurationHandler: {
            textField in
            self.codeTF = textField
            textField.placeholder = "Class Code"
            textField.addTarget(self, action: #selector(self.createClassTextChange(_:)), for: .editingChanged)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        actionToEnable = UIAlertAction(title: "Create", style: .default, handler: {
            (action) in
            
            let textField = alertController.textFields![0] as! UITextField
            
            TcrunchHelper.createNewClass(code: self.codeTF!.text!, name: self.nameTF!.text!, completion: {
                back in
                
                print(back)
            })
            
        })
        actionToEnable?.isEnabled = false
        alertController.addAction(actionToEnable!)
        
        self.present(alertController, animated: true)
        
    }
    
    func createClassTextChange(_ sender: UITextField) {
        if !(nameTF?.text?.isEmpty)! && !(codeTF?.text?.isEmpty)! {
            actionToEnable?.isEnabled = true
        } else {
            actionToEnable?.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: true)
        }
        
    }
    
    //called every time slide view is hidden
    func viewWillBecomePrimary() {
        if TcrunchHelper.teacherClasses.count == 0 {
            newTicketButton.isHidden = true
        } else {
            newTicketButton.isHidden = false
        }
    }
    
    func setClassTitle(_ title:String) {
        //
        navLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 320, height: 40))
        navLabel?.textAlignment = .left
        navLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navLabel?.text = title
        self.navigationItem.titleView = navLabel
    }
    
    func getTickets() {
        TcrunchHelper.getTeacherTickets(FromClass: selectedClass!, completion: {
            tickets in
            
            if tickets.count == 0 && self._classes.count > 0 {
                self.emptyLabel.isHidden = false
                self.emptyLabel.text = "This class had no tickets yet."
            } else {
                self.emptyLabel.isHidden = true
                self.emptyLabel.text = ""
            }
            
            
            self.tickets = tickets
            self.selectedClass?.tickets = tickets
            self.sortTickets()
        })
    }

    func sortTickets() {
        let currentTime = Date.init().timeIntervalSince1970
        
        upcomingTickets = []
        launchedTickets = []
        
        for ticket in tickets {
            
            //set released ticket time
            let unixTime = Double(ticket.startTime!) / 1000
            
            let releaseDate = Date(timeIntervalSince1970: unixTime)
            let currentDate = Date.init()
            
            if releaseDate > currentDate {
                upcomingTickets.append(ticket)
            } else {
                launchedTickets.append(ticket)
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func slideButtonPressed(_ sender: UIBarButtonItem) {
        parentVC?.isSlideViewShowing = true
    }
    @IBAction func addClassButtonPressed(_ sender: Any) {
        self.showCreateClassVC()
    }
    
    @IBAction func optionsButtonPressed(_ sender: Any) {
        sLauncher.showSettings()
    }
    
    //table stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return upcomingTickets.count
        } else {
            return launchedTickets.count
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if upcomingTickets.count == 0 {
                return ""
            }
            return "UPCOMING"
        } else {
            if launchedTickets.count == 0 {
                return ""
            }
            return "LAUNCHED"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell") as? TicketCell
        
        var selectedList: [TTicket]!
        
        if indexPath.section == 0 {
            selectedList = upcomingTickets
        } else {
            selectedList = launchedTickets
        }
        
        //set question label
        cell?.questionText.text = selectedList[indexPath.row].question
        //set class name label
        cell?.classNameText.text = ""
        
        //set released ticket time
        let unixTime = Double(selectedList[indexPath.row].startTime!) / 1000
        let releaseDate = Date(timeIntervalSince1970: unixTime)
        let currentDate = Date.init()
        
        if indexPath.section == 0 {
            var sentence = dateformatter(from: currentDate, to: releaseDate)
            let wordToRemove = " ago"
            
            
            if let range = sentence.range(of: wordToRemove) {
                sentence.removeSubrange(range)
            }
            
            cell?.releaseTimeText.text = "Launching in \(sentence)"
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
        if indexPath.section == 0 {
            let ticketVC = storyboard?.instantiateViewController(withIdentifier: "TeacherNewTicketVC") as! TeacherNewTicketVC
            ticketVC.editTicket = upcomingTickets[indexPath.row]
            ticketVC.selectedClass = selectedClass
            
            self.navigationController?.show(ticketVC, sender: self)
        } else {
            
//            let mcString = NSKeyedUnarchiver.unarchiveObject(with: launchedTickets[indexPath.row].answerChoices! as Data) as! [String]
            
            //open OpenResponse question type
            let releasedTicketVC = storyboard?.instantiateViewController(withIdentifier: "TeacherReleasedTicketVC") as! TeacherReleasedTicketVC
            releasedTicketVC.parentVC = self
            releasedTicketVC.ticket = launchedTickets[indexPath.row]
            if let data = launchedTickets[indexPath.row].answerChoices {
                let mcString = NSKeyedUnarchiver.unarchiveObject(with: launchedTickets[indexPath.row].answerChoices! as Data) as! [String]
                releasedTicketVC.multipleChoice = mcString
            }
            self.navigationController?.show(releasedTicketVC, sender: self)
            
            
        }
    }
    
    @IBAction func unwindToTeacherClasse(segue: UIStoryboardSegue) {}
    
    
}
