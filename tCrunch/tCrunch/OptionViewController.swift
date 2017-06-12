//
//  OptionViewController.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 6/11/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class OptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backView: UIView!
    
    var options: [Choices] = []
    
    var tap: UITapGestureRecognizer?
    
    var optionDelegate: ContainerOptionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.backPressed(_:)))
        backView.addGestureRecognizer(tap!)
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.reloadData()
        
        tableView.layer.masksToBounds = false;
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.4;
        tableView.layer.shadowRadius = 5;
        tableView.layer.shadowOffset = CGSize(width: 3, height: 10)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "option")
        cell?.textLabel?.text = options[indexPath.count].rawValue
        
        return cell!
    }
    
    func backPressed(_ sender: UITapGestureRecognizer) {
        optionDelegate?.hideOption()
    }
    
}

enum Choices: String {
    case LEAVE_CLASS = "Leave Class"
    case EDIT_DISPLAY_NAME = "Edit Display Name"
    case FAQ = "FAQ"
    case LOG_OUT = "Log Out"
    
}
