//
//  StudentNameViewController.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/23/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class StudentNameViewController: UIViewController {
    
    @IBOutlet weak var promptView: UIView!
    
    @IBOutlet weak var promptText: UITextView!
    @IBOutlet weak var responseTextField: UITextField!
    @IBAction func savePress(_ sender: Any) {
        print("RESPONSE: \(responseTextField.text)")
    }
    
    override func viewDidLoad() {
        
        promptView.layer.masksToBounds = false;
        promptView.layer.shadowColor = UIColor.black.cgColor
        promptView.layer.shadowOpacity = 0.4;
        promptView.layer.shadowRadius = 5;
        promptView.layer.shadowOffset = CGSize(width: 3, height: 10)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
}
