//
//  TeacherClassViewController.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 7/12/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class TeacherClassVC: UIViewController {
    
    var parentVC: TeacherContainerVC?
    var navLabel: UILabel?
    
    @IBOutlet weak var addClassButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        parentVC = self.parent?.parent as! TeacherContainerVC
        
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
        
    }
    
    @IBAction func slideButtonPressed(_ sender: UIBarButtonItem) {
        parentVC?.isSlideViewShowing = true
    }
    @IBAction func addClassButtonPressed(_ sender: Any) {
        parentVC?.showCreateClassVC()
    }
    @IBAction func optionsButtonPressed(_ sender: Any) {
    }
    
}
