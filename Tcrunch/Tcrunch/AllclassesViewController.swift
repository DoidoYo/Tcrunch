//
//  AllclassesViewController.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class AllclassesViewController: UIViewController {
    
    var slideController: SlideMenuViewController?
    
    var delegate: ContainerViewControllerDelegate?
    
    @IBOutlet weak var addClassButton: UIBarButtonItem!
    @IBAction func addClassPressed(_ sender: Any) {
    }
    @IBAction func optionsPressed(_ sender: Any) {
    }
    @IBAction func menuPressed(_ sender: Any) {
        if slidePanelShowing == false {
            delegate?.movePanelRight()
            slidePanelShowing = true
        } else {
            delegate?.movePanelCenter()
            slidePanelShowing = false
        }
    }
    
    var slidePanelShowing:Bool = false
    
    override func viewDidLoad() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        
        self.view.addGestureRecognizer(tap)
        
        //set size of JOIN CLASS Button text
        let fontSize:CGFloat = 13;
        let font:UIFont = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold)
        
        let attributes:[String : Any] = [NSFontAttributeName: font];
        
        addClassButton.setTitleTextAttributes(attributes, for: UIControlState.normal);
        
        
        //
        let navLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 320, height: 40))
        navLabel.textAlignment = .left
        navLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navLabel.text = self.navigationItem.title
        self.navigationItem.titleView = navLabel
        
        
    }
    
    func tapped(_ sender: UITapGestureRecognizer) {
        if slidePanelShowing {
            delegate?.movePanelCenter()
            slidePanelShowing = false
        }
    }
    
}
