//
//  TeacherClassViewController.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 7/12/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class TeacherClassVC: UIViewController {
    
    var parentVC: TeacherContainerVC?
    var navLabel: UILabel?
    
    private var _selectedClass:TClass_Temp?
    var selectedClass: TClass_Temp? {
        get {
            return _selectedClass
        }
        set{
            setClassTitle((newValue?.name)!)
            _selectedClass = newValue
        }
    }
    
    @IBOutlet weak var addClassButton: UIBarButtonItem!
    
    @IBOutlet weak var newTicketButton: UIButton!
    @IBAction func newTicketButtonPress(_ sender: Any) {
        let newTicketVC = storyboard?.instantiateViewController(withIdentifier: "TeacherNewTicketVC") as! TeacherNewTicketVC
        newTicketVC.selectedClass = selectedClass
//        print("sending class")
        self.navigationController?.show(newTicketVC, sender: self)
    }
    
    override func viewDidLoad() {
        parentVC = self.parent?.parent as! TeacherContainerVC
        
        //set size of JOIN CLASS Button text
        let fontSize:CGFloat = 13;
        let font:UIFont = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold)
        
        let attributes:[String : Any] = [NSFontAttributeName: font];
        
        addClassButton.setTitleTextAttributes(attributes, for: UIControlState.normal);
        
        
        setClassTitle(self.navigationItem.title!)
        
    }
    
    //called every time slide view is hidden
    func viewWillBecomePrimary() {
        if TcrunchHelper.teacherClasses.count == 0 {
            newTicketButton.isHidden = true
        } else {
            newTicketButton.isHidden = false
        }
    }
    
    func setClassTitle(_ title:String) {
        //
        navLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 320, height: 40))
        navLabel?.textAlignment = .left
        navLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navLabel?.text = title
        self.navigationItem.titleView = navLabel
    }
    
    @IBAction func slideButtonPressed(_ sender: UIBarButtonItem) {
        parentVC?.isSlideViewShowing = true
    }
    @IBAction func addClassButtonPressed(_ sender: Any) {
        parentVC?.showCreateClassVC()
    }
    @IBAction func optionsButtonPressed(_ sender: Any) {
    }
    
}
