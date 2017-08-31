//
//  SegmentedViewController.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/21/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//tabbar functionality and swifching of views
class SegmentedViewController: UIViewController {
    
    @IBOutlet weak var segmentedView: UIView!
    
    @IBOutlet weak var teacherView: UIView!
    @IBOutlet weak var studentView: UIView!
    
    @IBOutlet weak var studentButton: UIButton!
    @IBOutlet weak var teacherButton: UIButton!
    
    var selectedUnderline: UIView?
    let selectedUnderlineHeight:CGFloat = 3
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBAction func studentButtonPress(_ sender: UIButton) {
        self.selectedUnderline?.frame = CGRect(x: sender.frame.origin.x, y: sender.frame.height - selectedUnderlineHeight, width: sender.frame.width, height: selectedUnderlineHeight)
        
        
        studentButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        teacherButton.setTitleColor(UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0), for: .normal)
        
        teacherView.isHidden = true
        studentView.isHidden = false
    }
    
    @IBAction func teacherButtonPress(_ sender: UIButton) {
        self.selectedUnderline?.frame = CGRect(x: sender.frame.origin.x, y: sender.frame.height - selectedUnderlineHeight, width: sender.frame.width, height: selectedUnderlineHeight)
        teacherButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        studentButton.setTitleColor(UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0), for: .normal)
        
        teacherView.isHidden = false
        studentView.isHidden = true
    }
    
    override func viewDidLoad() {
        
        
        
//        let email = "hello@gmail.com"
//        let pass = "test123"
//        
//        //fater login
//        Auth.auth().signIn(withEmail: email, password: pass, completion: {
//            (user, error) in
//            
//            TcrunchHelper.user = user
//            
//            if let err = error {
//                print("Login Error: \(err)")
//            } else {
//                //successful login
//                self.showTeacherScreen()
//                
//                
//            }
//            
//        })
        iniCustomSegmentedView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        studentButtonPress(studentButton)
    }
    
    func iniCustomSegmentedView() {
        //setup color of text
        studentButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        teacherButton.setTitleColor(UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0), for: .normal)
        //add underline
        selectedUnderline = UIView(frame: CGRect(x: studentButton.frame.origin.x, y: studentButton.frame.height - selectedUnderlineHeight, width: studentButton.frame.width, height:selectedUnderlineHeight))
        
        
        selectedUnderline!.backgroundColor = UIColor(red: 255/255, green: 76/255, blue: 137/255, alpha: 1.0)
        
        self.view.addSubview(selectedUnderline!)
        
    }
    
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    
    
    @IBAction func registerButtonPress(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {
            (user, error) in
            
            TcrunchHelper.user = user
            
            if let err = error {
                print("Register Error: \(err)")
            } else {
                //successful registration
                
                self.showTeacherScreen()
                
            }
            
        })
    }
    
    @IBAction func signinButtonPress(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {
            (user, error) in
            
            TcrunchHelper.user = user
            
            if let err = error {
                print("Login Error: \(err)")
            } else {
                //successful login
                self.showTeacherScreen()
                
                
            }
            
        })
        
    }
    
    
    @IBAction func forgotButtonPress(_ sender: Any) {
        
    }
    
    
    @IBAction func enterButtonPressed(_ sender: Any) {
        
        let ContainerVC = storyboard?.instantiateViewController(withIdentifier: "containerController") as? ContainerViewController
        
        ContainerVC?.setUser(User.STUDENT)
        
        self.show(ContainerVC!, sender: nil)
    }
    func showTeacherScreen() {
        let teacherVC = storyboard?.instantiateViewController(withIdentifier: "TeacherContainerVC")
        self.show(teacherVC!, sender: self)
    }
    
}

enum User {
    case STUDENT
    case TEACHER
}


