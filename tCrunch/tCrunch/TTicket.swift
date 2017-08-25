//
//  TTicket.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 5/28/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import CoreData

class TTicket {
    
    var anonymous:Bool?
    var answer:String?
    var className_:String?
    var endTime:String?
    var id:String?
    var question:String?
    var startTime:CLongLong?
    
    var answerChoices:Data?
    
    var tclass:TClass?
    var tempClass:TClass_Temp?
    
}
