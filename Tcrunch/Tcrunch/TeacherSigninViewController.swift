//
//  SigninViewController.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/21/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class TeacherSigninViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func registerPressed(_ sender: Any) {
        
    }
    
    @IBAction func signinPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {
            (user, error) in
            
            print(user!)
            print(error!)
            
        print(Database.database().reference().child("classes").child("-Ke6lQso8ynV62BeP584").observeSingleEvent(of: .value, with: {
                (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["courseCode"] as? String ?? ""
            print(username)
            }))
            
        })
        
    
    }
    
    
    
}
