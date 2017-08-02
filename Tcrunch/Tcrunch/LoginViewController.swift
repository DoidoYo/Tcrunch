//
//  LoginViewController.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/21/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        self.view.backgroundColor = UIColor.green
        
        // 2
        gradientLayer.frame = self.view.bounds
        
        // 3
        let color1 = UIColor(red: 0/255, green: 156/255, blue: 226/255, alpha: 1.0).cgColor as CGColor
        let color2 = UIColor(red: 175/255, green: 230/255, blue: 255/255, alpha: 1.0).cgColor as CGColor
        gradientLayer.colors = [color1, color2]
        
        // 4
        gradientLayer.locations = [0.5, 1]
        
        // 5
        //self.view.layer.addSublayer(gradientLayer)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
}
