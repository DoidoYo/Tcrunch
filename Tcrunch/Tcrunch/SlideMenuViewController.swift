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
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ContainerViewControllerDelegate?
    var classesController: UIViewController?
    
    var classes: [TClass] = [TClass]()
    
    override func viewDidLoad() {
        //        nameLabel.text = helper
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        classes.append(TClass(courseCode: "dd", id: "dd", name: "testName"))
        
        //get associated classes to populate side menu
        
        
        //automaically open all classes
        
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
            delegate?.setCenterView(id: "someid")
        } else {
            //selected the all
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

