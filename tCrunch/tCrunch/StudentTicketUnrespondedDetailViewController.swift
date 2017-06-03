//
//  StudentTicketUnrespondedDetailViewController.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 5/28/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class StudentTicketUnrespondedDetailViewController: UITableViewController {
    
    
    @IBOutlet weak var responseTextView: UITextView!
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 2 {
            return 27
        } else if indexPath.row == 1 {
            return UITableViewAutomaticDimension
        } else {
            if responseTextView.frame.height >= 100 {
                responseTextView.isScrollEnabled = true
                return 100
            }
            
            let fixedWidth = responseTextView.frame.size.width
            responseTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let newSize = responseTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = responseTextView.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//            textView.frame = newFrame;
            
            return newFrame.height
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
