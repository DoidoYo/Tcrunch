//
//  TeacherNew.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 7/27/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class TeacherNewClassVC: UIViewController {
    
    @IBOutlet weak var promptView: UIView!
    
    @IBOutlet weak var promptText: UITextView!
    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var classCodeTextField: UITextField!
    @IBAction func cancelPress(_ sender: Any) {
        destroy()
    }
    @IBAction func savePress(_ sender: Any) {
        
        if !(classNameTextField.text?.isEmpty)! && !(classCodeTextField.text?.isEmpty)!{
            
            //save
            let parentVC = self.parent as! TeacherContainerVC
            
            parentVC.createClass(name: classNameTextField.text!, code: classCodeTextField.text!)
            
            //destroy
            
            destroy()
        }
    }
    
    private func destroy() {
        self.didMove(toParentViewController: self.parent)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    var delegate:NameViewControllerDelegate?
    
    override func viewDidLoad() {
        
        promptView.layer.masksToBounds = false;
        promptView.layer.shadowColor = UIColor.black.cgColor
        promptView.layer.shadowOpacity = 0.4;
        promptView.layer.shadowRadius = 5;
        promptView.layer.shadowOffset = CGSize(width: 3, height: 10)
        
        classNameTextField.becomeFirstResponder()
    }
    
    func setPrompt(_ prompt: String) {
        promptText.text = prompt
        
        
        let fixedWidth = promptText.frame.size.width
        promptText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = promptText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = promptText.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        promptText.frame = newFrame;
        
        
    }
    
}
