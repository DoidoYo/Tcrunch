//
//  CourseCodeViewController.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/24/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class CourseCodeViewController: UIViewController {
    
    var delegate:CourseCodeViewControllerDelegate?
    
    
    @IBOutlet weak var promptView: UIView!
    @IBOutlet weak var responseTextField: UITextField!
    
    @IBAction func cancelPress(_ sender: Any) {
        closeView()
    }
    
    @IBAction func joinPressed(_ sender: Any) {
        if let code = responseTextField.text, code != "" {
            delegate?.codeReceived(code)
            
            closeView()
        }
    }
    
    override func viewDidLoad() {
        promptView.layer.masksToBounds = false;
        promptView.layer.shadowColor = UIColor.black.cgColor
        promptView.layer.shadowOpacity = 0.4;
        promptView.layer.shadowRadius = 5;
        promptView.layer.shadowOffset = CGSize(width: 3, height: 10)
        
        responseTextField.becomeFirstResponder()
    }
    
    func closeView() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
}

protocol CourseCodeViewControllerDelegate {
    func codeReceived(_ code:String) ->Void
}
