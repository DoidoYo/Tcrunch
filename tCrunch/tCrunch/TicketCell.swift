//
//  TicketCell.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 5/28/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class TicketCell: UITableViewCell {
    
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var releaseTimeText: UILabel!
    @IBOutlet weak var classNameText: UILabel!
    
    let newHeight: CGFloat = 90.0
    var oldFrame:CGRect?
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            oldFrame = self.frame
            var frame = newFrame
            let newWidth = frame.width * 0.95 // get 80% width here
            let width_space = (frame.width - newWidth) / 2
            let height_space = (frame.height - self.newHeight) / 2
            frame.size.width = newWidth
            frame.size.height = newHeight
            frame.origin.x += width_space
            frame.origin.y += height_space
            
            
            super.frame = frame
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //makes cell clickable
        questionText.isUserInteractionEnabled = false
        self.selectionStyle = .none
        
        
        
        layer.cornerRadius = 3.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 1.0
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.masksToBounds = false
    }
    
}
