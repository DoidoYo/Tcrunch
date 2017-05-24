//
//  TitleMoveButton.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class TitleMoveField: UITextField {
    
    let NORMAL_UNDERLINE_WIDTH:CGFloat = 1.5
    let SELECTED_UNDERLINE_WIDTH:CGFloat = 2.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        
        let bottomBorder = UIView(frame: CGRect(x: 0, y: frame.height - NORMAL_UNDERLINE_WIDTH, width: frame.width, height: NORMAL_UNDERLINE_WIDTH))
        bottomBorder.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        print("yeee")
        
        self.addSubview(bottomBorder)
    }
    
}
