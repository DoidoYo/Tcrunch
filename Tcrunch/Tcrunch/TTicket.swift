//
//  TTicket.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/24/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation

class TTicket {
    
    var anonymous: Bool?
    var className:String?
    var endTime:String?
    var id:String?
    var question:String?
    var startTime :String?
    var answerChoices:[String]?
    
    
    init(withDictionary obj: NSDictionary){
    
        if let ano = obj["anonymous"] as? Bool {
            self.anonymous = ano
        }
        if let className = obj["className"] as? String {
            self.className = className
        }
        if let endTime = obj["endTime"] as? String {
            self.endTime = endTime
        }
        if let id = obj["id"] as? String {
            self.id = id
        }
        if let question = obj["question"] as? String {
            self.question = question
        }
        if let startTime = obj["startTime"] as? String {
            self.startTime = startTime
        }
    }
}
