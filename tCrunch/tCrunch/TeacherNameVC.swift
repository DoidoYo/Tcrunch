//
//  TeacherNameVC.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 7/31/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class TeacherNameVC: UIViewController {
    
    @IBOutlet weak var responseText: UITextField!
    
    @IBOutlet weak var promptView: UIView!
    @IBAction func saveButtonPress(_ sender: Any) {
    
        if !(responseText.text?.isEmpty)! {
            
            let parent = self.parent as! TeacherContainerVC
            
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    
    }
    
    override func viewDidLoad() {
        
        promptView.layer.masksToBounds = false;
        promptView.layer.shadowColor = UIColor.black.cgColor
        promptView.layer.shadowOpacity = 0.4;
        promptView.layer.shadowRadius = 5;
        promptView.layer.shadowOffset = CGSize(width: 3, height: 10)
        
        responseText.becomeFirstResponder()
    }
    
}
