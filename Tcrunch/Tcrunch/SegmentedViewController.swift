//
//  SegmentedViewController.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/21/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class SegmentedViewController: UIViewController {
    
    @IBOutlet weak var segmentedView: UIView!
    
    @IBOutlet weak var teacherView: UIView!
    @IBOutlet weak var studentView: UIView!
    
    var selectedUnderline: UIView?
    let selectedUnderlineHeight:CGFloat = (1/20)
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var studentButton: UIButton!
    @IBAction func studentButtonPress(_ sender: Any) {
        self.selectedUnderline?.frame.origin.x = studentButton.frame.origin.x
        studentButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        teacherButton.setTitleColor(UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0), for: .normal)
        
        teacherView.isHidden = true
        studentView.isHidden = false
    }
    
    @IBOutlet weak var teacherButton: UIButton!
    @IBAction func teacherButtonPress(_ sender: Any) {
        self.selectedUnderline?.frame.origin.x = teacherButton.frame.origin.x
        teacherButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        studentButton.setTitleColor(UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0), for: .normal)
        
        teacherView.isHidden = false
        studentView.isHidden = true
    }
    
    override func viewDidLoad() {
        
        initStudentView()
        createSelectedUnderline()
    }
    
    
    func initStudentView() {
//        enterButton.layer.cornerRadius = 8.0;
        enterButton.layer.masksToBounds = false;
//        enterButton.layer.borderWidth = 1.0;
        
        enterButton.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
        enterButton.layer.shadowOpacity = 0.8;
        enterButton.layer.shadowRadius = 2;
        enterButton.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    func createSelectedUnderline() {
        //setup color of text
        studentButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        teacherButton.setTitleColor(UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0), for: .normal)
        //add underline
        selectedUnderline = UIView(frame: CGRect(x: studentButton.frame.origin.x, y: studentButton.frame.height - studentButton.frame.height * selectedUnderlineHeight, width: studentButton.frame.width, height: studentButton.frame.height * selectedUnderlineHeight))
        
        selectedUnderline!.backgroundColor = UIColor(red: 255/255, green: 76/255, blue: 137/255, alpha: 1.0)
        
        self.view.addSubview(selectedUnderline!)
        
    }
    
}
