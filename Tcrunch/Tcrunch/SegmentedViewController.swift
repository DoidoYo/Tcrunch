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
import Whisper

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
        if (emailTextField.text?.isEmpty)! {
            error(descripton: "Please enter an email.")
        } else if (passwordTextField.text?.isEmpty)! {
            error(descripton: "Please enter a password.")
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {
                (user, error) in
                
                TcrunchHelper.user = user
                
                if let err = error {
                    self.error(descripton: err.localizedDescription)
                } else {
                    //successful registration
                    self.showTeacherScreen()
                }
                
            })
        }
    }
    
    @IBAction func signinButtonPress(_ sender: Any) {
        
        if (emailTextField.text?.isEmpty)! {
            error(descripton: "Please enter an email.")
        } else if (passwordTextField.text?.isEmpty)! {
            error(descripton: "Please enter a password.")
        } else {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {
                (user, error) in
                
                TcrunchHelper.user = user
                
                if error != nil {
                    self.error(descripton: "Incorrect email or password.")
                } else {
                    //successful login
                    self.showTeacherScreen()
                    
                    
                }
                
            })
        }
    }
    
    func error(descripton: String, time: TimeInterval) {
        let announcement = Announcement(title: "Error", subtitle: descripton, image: #imageLiteral(resourceName: "cancel"), duration: time, action: {})//Announcement(title: "Error", subtitle: desc, image: #imageLiteral(resourceName: "cancel"))
        Whisper.show(shout: announcement, to: self.parent!, completion: {
            
        })
    }
    func error(descripton: String) {
        error(descripton: descripton, time: 2)
    }
    
    func check(description: String, time: TimeInterval) {
        let announcement = Announcement(title: "Success", subtitle: description, image: #imageLiteral(resourceName: "check"), duration: time, action: {})//Announcement(title: "Error", subtitle: desc, image: #imageLiteral(resourceName: "cancel"))
        Whisper.show(shout: announcement, to: self.parent!, completion: {
            
        })
    }
    
    
    @IBAction func forgotButtonPress(_ sender: Any) {
        let alertController = UIAlertController(title: "Reset Your Password", message: "Type in the email address you want to reset the password for and we'll send you instructions for resetting your password.", preferredStyle: .alert)
        
        var eTextField:UITextField!
        alertController.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "E-mail"
            textField.keyboardType = .emailAddress
            eTextField = textField
        })
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
        
        let resetAction = UIAlertAction(title: "Reset", style: .default, handler: {
            (action) in
            
            Auth.auth().sendPasswordReset(withEmail: eTextField.text!) {
                error in
                if let err = error {
                    self.error(descripton: err.localizedDescription, time:6)
                } else {
                    self.check(description: "The email was sent!", time: 6)
                }
            }
            
        })
        alertController.addAction(resetAction)
        
        self.present(alertController, animated: true)
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


