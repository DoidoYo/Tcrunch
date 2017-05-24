//
//  ContainerViewController.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/23/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class ContainerViewController: UIViewController, ContainerViewControllerDelegate {
    
    var slideMenuController: SlideMenuViewController?
    var centerController: UIViewController?
    
    var showingSlideMenu: Bool = false
    
    var CORNER_RADIUS: CGFloat = 4
    var SLIDE_TIMING: CGFloat = 0.25
    var PANEL_WIDTH: CGFloat = 130
    
    let STUDENT_NAME_PROMPT = "What's your name?"
    let TEACHER_NAME_PROMPT = "What's your name? This is the name that students will see."
    
    override func viewDidLoad() {
        
        centerController = storyboard?.instantiateViewController(withIdentifier: "centerController")
        
        self.view.addSubview(centerController!.view)
        self.addChildViewController(centerController!)
        centerController?.didMove(toParentViewController: self)
        (centerController?.childViewControllers[0] as! AllclassesViewController).delegate = self
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        movePanelRight()
    }
    
    func getSlideView() -> UIView {
        if slideMenuController == nil {
            slideMenuController = storyboard?.instantiateViewController(withIdentifier: "slideController") as? SlideMenuViewController
            self.view.addSubview(slideMenuController!.view)
            self.view.sendSubview(toBack: slideMenuController!.view)
            
            self.addChildViewController(slideMenuController!)
            slideMenuController?.didMove(toParentViewController: self)
        }
        
        self.showingSlideMenu = true
        
        shadowCenterViewWithShadow(true, withOffset: -2)
        
        return slideMenuController!.view
    }
    
    func shadowCenterViewWithShadow(_ shadow: Bool, withOffset: Int) -> Void {
        if shadow {
            centerController?.view.layer.cornerRadius = CORNER_RADIUS
            centerController?.view.layer.shadowColor = UIColor.black.cgColor
            centerController?.view.layer.shadowOpacity = 0.8
            centerController?.view.layer.shadowOffset = CGSize(width: withOffset, height: withOffset)
        } else {
            centerController?.view.layer.cornerRadius = 0.0
        }
    }
    
    func movePanelRight() -> Void {
        let childView = self.getSlideView()
        UIView.animate(withDuration: TimeInterval(SLIDE_TIMING), animations: {
            self.centerController?.view.frame = CGRect(x: self.view.frame.width - self.PANEL_WIDTH, y: 0, width: self.view.frame.size.width, height: self.view.frame.height)
        }, completion: {
            (finished) in
            //finished
        })
        
    }
    
    func movePanelCenter() -> Void {
        
        UIView.animate(withDuration: TimeInterval(SLIDE_TIMING), animations: {
            self.centerController?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.height)
        }, completion: {
            (finished) in
            
            self.resetMainView()
            
        })
        
    }
    
    func resetMainView() -> Void {
        
        if slideMenuController != nil {
            self.slideMenuController?.view.removeFromSuperview()
            self.slideMenuController = nil
            
            self.showingSlideMenu = false
        }
        shadowCenterViewWithShadow(false, withOffset: 0)
    }
    
    func setCenterView(id:String) -> Void {
        
    }
    
    func setUser(_ user: User) {
        var prompt: String
        if user == User.STUDENT {
            prompt = STUDENT_NAME_PROMPT
            
        } else { //user == User.TEACHER
            prompt = TEACHER_NAME_PROMPT
            
        }
        
        //prompt name
        let promptVC = storyboard?.instantiateViewController(withIdentifier: "StudentNameView") as? StudentNameViewController
        self.view.addSubview(promptVC!.view)
        self.addChildViewController(promptVC!)
        promptVC?.setPrompt(prompt)
        promptVC?.didMove(toParentViewController: self)
    }
    
}

protocol ContainerViewControllerDelegate {
    func movePanelRight() -> Void
    func movePanelCenter() -> Void
    func setCenterView(id:String) -> Void
}

