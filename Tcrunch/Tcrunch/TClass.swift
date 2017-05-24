//
//  TClass.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation

class TClass {
    
    var courseCode: String
    var id:String
    var name : String
    
    init(courseCode code: String, id _id: String, name _name:String) {
        courseCode = code
        id = _id
        name = _name
    }
}
