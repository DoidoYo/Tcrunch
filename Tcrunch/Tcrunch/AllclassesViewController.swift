//
//  AllclassesViewController.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class AllclassesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var slideController: SlideMenuViewController?
    
    @IBOutlet weak var tableView: UITableView!
    var containerDelegate: ContainerViewControllerDelegate?
    
    var answeredTicket: [TTicket] = []
    var unansweredTicket: [TTicket] = []
    
    @IBOutlet weak var addClassButton: UIBarButtonItem!
    @IBAction func addClassPressed(_ sender: Any) {
        let container = self.parent?.parent as! ContainerViewController
        container.showCodeDialog()
    }
    @IBAction func optionsPressed(_ sender: Any) {
    }
    @IBAction func menuPressed(_ sender: Any) {
        if slidePanelShowing == false {
            containerDelegate?.movePanelRight()
            slidePanelShowing = true
        } else {
            containerDelegate?.movePanelCenter()
            slidePanelShowing = false
        }
    }
    
    var slidePanelShowing:Bool = false
    
    override func viewDidLoad() {
        //tap on this view while side view is showing
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.view.addGestureRecognizer(tap)
        
        //set size of JOIN CLASS Button text
        let fontSize:CGFloat = 13;
        let font:UIFont = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold)
        
        let attributes:[String : Any] = [NSFontAttributeName: font];
        
        addClassButton.setTitleTextAttributes(attributes, for: UIControlState.normal);
        
        
        //
        let navLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 320, height: 40))
        navLabel.textAlignment = .left
        navLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navLabel.text = self.navigationItem.title
        self.navigationItem.titleView = navLabel
        
        //setup table
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func tapped(_ sender: UITapGestureRecognizer) {
        if slidePanelShowing {
            containerDelegate?.movePanelCenter()
            slidePanelShowing = false
        }
    }
    
    func loadClass(_ id:String) {
        //loading overlay?
        
        unansweredTicket = []
        answeredTicket = []
        
        TcrunchHelper.getStudentTickets(FromClass: id, completion: {
            (ansTicket, unansweTicket) in
            
            self.unansweredTicket = unansweTicket
            self.answeredTicket = ansTicket
            
            
            self.tableView.reloadData()
        })
        
        
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
            return "Not Answered"
        } else {
            return "Answered"
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "test")
        
        var selectedList = answeredTicket
        
        if indexPath.section == 0 {
            selectedList = unansweredTicket
        } else {
            selectedList = answeredTicket
        }
        
        cell?.textLabel?.text = selectedList[indexPath.row].question
        
        return cell!
    }
    
}

protocol AllclassesViewControllerDelegate {
    func addButtonPressed() -> Void
}
