//
//  SlideMenuViewController.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class SlideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var containerVC: ContainerViewController?
    
    var classes: [TClass] = []
    
    override func viewDidLoad() {
        
        //tableview stuff
        tableView.delegate = self
        tableView.dataSource = self
        
        classes = TcrunchHelper.getClasses()
        
        
        //set name of user on slide tab
        nameLabel.text = TcrunchHelper.user_name
        
        //load classes from phone storage
        
        
        emailLabel.text = TcrunchHelper.user_name
        nameLabel.text = "Tcrunch"
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return classes.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            containerVC!.setCenterViewClass(classes[indexPath.row])
            containerVC!.movePanelCenter()
        } else {
            //selected the all
            containerVC?.setCenterViewAll(classes)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
        if indexPath.section == 0 {
        cell = tableView.dequeueReusableCell(withIdentifier: "classCell")!
        cell!.textLabel!.text = classes[indexPath.row].name
        
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "allclasses")!
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    
}

