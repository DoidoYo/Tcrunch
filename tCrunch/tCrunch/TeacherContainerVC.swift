//
//  TeacherContainerController.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 7/12/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class TeacherContainerVC: UIViewController {
    
    var darkLayer: UIView? = nil
    var darkLayerTap: UITapGestureRecognizer?
    
    
    
    var slideVC: TeacherSlideVC? = nil
    var classVC: TeacherClassVC? = nil
    
    private var _isSlideViewShowing = false
    var isSlideViewShowing: Bool {
        set {
            _isSlideViewShowing = newValue
            
            // true
            if newValue {
                showSlideVC()
            } else {
                //false
                hideSlideVC()
            }
            
        }
        
        get {
            return self._isSlideViewShowing
        }
    }
    
    var firstTime = true
    override func viewDidLoad() {
        
        //isntantiate nav VC
        let navVC = storyboard?.instantiateViewController(withIdentifier: "TeacherNavigationVC")
        self.view.addSubview(navVC!.view)
        self.addChildViewController(navVC!)
        self.didMove(toParentViewController: navVC!)
        
        classVC = navVC?.childViewControllers[0] as! TeacherClassVC
       
        //teacher name stuff
        if let name = UserDefaults.standard.string(forKey: "user_teacher_name") {
            TcrunchHelper.user_name = name
        } else {
            self.showTeacherNameDialog()
            firstTime = false
        }
    }
    
    func setCurrentClass(_ tclass:TClass_Temp) {
        //tktk -- todo create functions in classVC
        classVC?.selectedClass = tclass
        
    }
    
    var actionToEnable : UIAlertAction?
    func showTeacherNameDialog() {
        let alertController = UIAlertController(title: "What's your name?", message: "This is the name that students will see.", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Your name"
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            
        })
        
        if !firstTime {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
        }
        
        actionToEnable = UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            
            let textField = alertController.textFields![0] as! UITextField
            
            UserDefaults.standard.set(textField.text!, forKey: "user_teacher_name")
            TcrunchHelper.user_name = textField.text!
            
        })
        actionToEnable?.isEnabled = false
        alertController.addAction(actionToEnable!)
        
        self.present(alertController, animated: true)
    }
    func textChanged(_ sender:UITextField) {
        if (sender.text?.isEmpty)! {
            self.actionToEnable?.isEnabled = false
        } else {
            self.actionToEnable?.isEnabled = true
        }
    }
    
    
    private var nameTF: UITextField?
    private var codeTF: UITextField?
    func showCreateClassVC() {
        
        let alertController = UIAlertController(title: "Add a new class", message: "", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: {
            textField in
            
            self.nameTF = textField
            textField.placeholder = "Class Name"
            textField.addTarget(self, action: #selector(self.createClassTextChange(_:)), for: .editingChanged)
            
        })
        alertController.addTextField(configurationHandler: {
            textField in
            self.codeTF = textField
            textField.placeholder = "Class Code"
            textField.addTarget(self, action: #selector(self.createClassTextChange(_:)), for: .editingChanged)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        actionToEnable = UIAlertAction(title: "Create", style: .default, handler: {
            (action) in
            
            let textField = alertController.textFields![0] as! UITextField
            
            TcrunchHelper.createNewClass(code: self.codeTF!.text!, name: self.nameTF!.text!, completion: {
                back in
                
                print(back)
            })
            
        })
        actionToEnable?.isEnabled = false
        alertController.addAction(actionToEnable!)
        
        self.present(alertController, animated: true)
        
    }
    
    func createClassTextChange(_ sender: UITextField) {
        if !(nameTF?.text?.isEmpty)! && !(codeTF?.text?.isEmpty)! {
            actionToEnable?.isEnabled = true
        } else {
            actionToEnable?.isEnabled = false
        }
    }
    
//    TODO -- DELETE
//    func createClass(name: String, code: String) {
//        
//        //tk create new class
//        
//    }
    
    func logOut() {
        self.performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    private func showSlideVC() {
        
        //set dark layer to 100% transparent + add tap event
        darkLayer = UIView(frame: self.view.frame)
        darkLayer?.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.0)
        darkLayerTap = UITapGestureRecognizer(target: self, action: #selector(self.darkLayerTap(_:)))
        darkLayer?.addGestureRecognizer(darkLayerTap!)
        
        // tap = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        
        //instantiate SlideVC + configure frame width
        slideVC = storyboard?.instantiateViewController(withIdentifier: "TeacherSlideVC") as? TeacherSlideVC
        let oldFrame = slideVC!.view.frame
        let newFrame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: (4/6)*oldFrame.width, height: oldFrame.height)
        slideVC?.view.frame = newFrame
        
        //set slideVC data - TODO
        
        
        //add dark layer behind slide
        self.view.addSubview(darkLayer!)
        //Add SlideVC to view
        self.view.addSubview(slideVC!.view)
        self.addChildViewController(slideVC!)
        self.didMove(toParentViewController: slideVC)
        
        //set inital position of slide vc
        slideVC?.view.frame.origin.x -= self.view.frame.width
        
        UIView.animate(withDuration: 0.4, animations: {
        
            self.darkLayer?.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6)
            self.slideVC?.view.frame.origin.x = 0
            
        }, completion: {
            done in
            
        })
        
    }
    
    private func hideSlideVC() {
        UIView.animate(withDuration: 0.4, animations: {
            
            self.darkLayer?.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.0)
            self.slideVC?.view.frame.origin.x -= self.view.frame.width
            
            self.classVC?.viewWillBecomePrimary()
            
        }, completion: {
            done in
            
            //deinit slide vc stuff
            self.slideVC?.removeFromParentViewController()
            self.slideVC?.view.removeFromSuperview()
            self.slideVC?.didMove(toParentViewController: self)
            
            self.darkLayer?.removeGestureRecognizer(self.darkLayerTap!)
            self.darkLayer?.removeFromSuperview()
            
        })
    }
    
    func darkLayerTap(_ sender: UITapGestureRecognizer) {
        if isSlideViewShowing {
            hideSlideVC()
        }
    }
    
    //IDK If needed -----
//    private func toggleSlideVC() {
//        if isSlideViewShowing {
//            hideSlideVC()
//        } else {
//            showSlideVC()
//        }
//    }
    
    
}
