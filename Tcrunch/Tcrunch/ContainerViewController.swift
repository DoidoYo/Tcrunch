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
    var ticketVC: AllclassesViewController?
    
    var showingSlideMenu: Bool = false
    
    var CORNER_RADIUS: CGFloat = 4
    var SLIDE_TIMING: CGFloat = 0.25
    var PANEL_WIDTH: CGFloat = 130
    
    let STUDENT_NAME_PROMPT = "What's your name?"
    let TEACHER_NAME_PROMPT = "What's your name? This is the name that students will see."
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var darkView:UIView?
    
    override func viewDidLoad() {
        
        centerController = storyboard?.instantiateViewController(withIdentifier: "centerController")
        
        self.view.addSubview(centerController!.view)
        self.addChildViewController(centerController!)
        centerController?.didMove(toParentViewController: self)
        ticketVC = centerController?.childViewControllers[0] as? AllclassesViewController
        ticketVC?.containerDelegate = self
        
        darkView = UIView(frame: centerController!.view.frame)
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
            
            let oldFrame = slideMenuController!.view.frame
            let newFrame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: (4/6)*oldFrame.width, height: oldFrame.height)
            
            slideMenuController?.view.frame = newFrame
            
            self.addChildViewController(slideMenuController!)
            slideMenuController?.didMove(toParentViewController: self)
        }
        slideMenuController?.containerVC = self
        
        self.showingSlideMenu = true
        (centerController?.childViewControllers[0] as! AllclassesViewController).slidePanelShowing = true
        
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
        _ = self.getSlideView()
        self.view.sendSubview(toBack: centerController!.view)
        
        self.centerController?.view.addSubview(self.darkView!)
        self.darkView!.addGestureRecognizer(self.ticketVC!.tap!)
        
        slideMenuController?.view.frame.origin.x -= slideMenuController!.view.frame.width
        UIView.animate(withDuration: TimeInterval(SLIDE_TIMING), animations: {
            self.slideMenuController?.view.frame.origin.x = 0
            self.darkView?.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6)
        }, completion: {
            (finished) in
            //finished
        })
        
    }
    
    func movePanelCenter() -> Void {
        
        UIView.animate(withDuration: TimeInterval(SLIDE_TIMING), animations: {
            self.slideMenuController?.view.frame.origin.x -= self.slideMenuController!.view.frame.width
            self.darkView?.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.0)
        }, completion: {
            (finished) in
            
            self.darkView?.removeFromSuperview()
            self.darkView?.removeGestureRecognizer(self.ticketVC!.tap!)
            self.resetMainView()
            
        })
        
    }
    
    func resetMainView() -> Void {
        
        if slideMenuController != nil {
            self.slideMenuController?.view.removeFromSuperview()
            self.slideMenuController = nil
            
            self.showingSlideMenu = false
            
            let ticketVC = (centerController?.childViewControllers[0] as! AllclassesViewController)
            ticketVC.slidePanelShowing = false
            ticketVC.view.removeGestureRecognizer(ticketVC.tap!)
        }
        shadowCenterViewWithShadow(false, withOffset: 0)
    }
    
    func setCenterViewClass(_ tclass: TClass) -> Void {
        ticketVC?.loadClass(tclass)
    }
    
    func setCenterViewAll(_ classes:[TClass]) {
        ticketVC?.loadClasses(classes)
    }
    
    func setUser(_ user: User) {
//        var prompt: String
        if user == User.STUDENT {
//            prompt = STUDENT_NAME_PROMPT
            TcrunchHelper.user_id = UserDefaults.standard.string(forKey: "user_id")
            
        } else { //user == User.TEACHER
//            prompt = TEACHER_NAME_PROMPT
            
        }
    }
    
//    func actionForOption(_ choice: Choices) {
//        hideOption()
//        switch choice {
//        case Choices.EDIT_DISPLAY_NAME:
//            
//            ticketVC?.showNameDialog()
//            break
//            
//        case Choices.FAQ:
//            
//            break
//            
//        case Choices.LEAVE_CLASS:
//
//            let classes = TcrunchHelper.getClasses()
//            
//            if ticketVC?._class != nil{
//                for c in classes {
//                    if c.id == ticketVC?._class?.id {
//                        context.delete(c)
//                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
//                        
//                        setCenterViewAll(TcrunchHelper.getClasses())
//                    }
//                }
//            }
//            
//            break
//            
//        case Choices.LOG_OUT:
//            self.performSegue(withIdentifier: "unwindToLogin", sender: self)
//            
//            break
//            
//        default:
//            print("Option selection error!")
//        }
//    }
    
}

protocol ContainerViewControllerDelegate {
    func movePanelRight() -> Void
    func movePanelCenter() -> Void
    func setCenterViewClass(_ tclass: TClass) -> Void
    func setCenterViewAll(_ classes:[TClass]) -> Void
}

