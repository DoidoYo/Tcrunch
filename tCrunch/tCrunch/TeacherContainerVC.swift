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
            let teacherNameVC = storyboard?.instantiateViewController(withIdentifier: "TeacherNameVC")
            
            self.view.addSubview(teacherNameVC!.view)
            self.addChildViewController(teacherNameVC!)
            self.didMove(toParentViewController: teacherNameVC!)
            
        }
        
        //init observers
        TcrunchHelper.observeTeacherClasses()
    }
    
    func setCurrentClass(_ tclass:TClass_Temp) {
        //tktk -- todo create functions in classVC
        classVC?.selectedClass = tclass
        
    }
    
    func setTeacherName(_ name: String) {
        UserDefaults.standard.set(name, forKey: "user_teacher_name")
        TcrunchHelper.user_name = name
    }
    
    func showCreateClassVC() {
        let newClassVC = storyboard?.instantiateViewController(withIdentifier: "TeacherNewClassVC")
        
        self.view.addSubview((newClassVC?.view)!)
        self.addChildViewController(newClassVC!)
        self.didMove(toParentViewController: newClassVC)
    }
    
//    TODO -- DELETE
//    func createClass(name: String, code: String) {
//        
//        //tk create new class
//        
//    }
    
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
