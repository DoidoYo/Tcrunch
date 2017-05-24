//
//  ButtonShadow.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class ButtonShadow: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //        enterButton.layer.cornerRadius = 8.0;
        layer.masksToBounds = false;
        //        enterButton.layer.borderWidth = 1.0;
        
        layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
        layer.shadowOpacity = 0.8;
        layer.shadowRadius = 2;
        layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
}
