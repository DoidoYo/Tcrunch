//
//  TeacherSlideViewController.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 7/12/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class TeacherSlideVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var classes: [TClass_Temp] = []
    
    override func viewDidLoad() {
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        emailLabel.text = TcrunchHelper.user_name
        nameLabel.text = TcrunchHelper.user?.email
        
        classes = TcrunchHelper.teacherClasses
        self.tableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //todo
//        print(classes.count)
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherClassCell")!
        cell.textLabel!.text = classes[indexPath.row].name
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let parentVC = self.parent as! TeacherContainerVC
        
        parentVC.setCurrentClass(classes[indexPath.row])
        parentVC.isSlideViewShowing = false
    }
    
    func hide() {
        
        
    }
    
}
