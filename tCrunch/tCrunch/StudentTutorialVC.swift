//
//  StudentTutorialVC.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 8/31/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class StudentTutorialVC: UIViewController {
    
    let descriptions = ["Welcome to Tcrunch! This is your dashboard. Here, you can see tickets from your class", "You can join a class by pressing the 'Join Class' button. Your teacher will provide you with the class code.", "View your classes in the navigation drawer.", "Click on an unaswered ticket to submit a response to it.", "Click on an answered ticket to view your response."]
    
    let images = [#imageLiteral(resourceName: "s_demo_1"), #imageLiteral(resourceName: "s_demo_2"), #imageLiteral(resourceName: "s_demo_3"), #imageLiteral(resourceName: "s_demo_4"), #imageLiteral(resourceName: "s_demo_5")]
    
    var count = 0
    
    var pageViewController: UIPageViewController!
    
    
    
}
