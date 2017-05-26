//
//  TcrunchHelper.swift
//  Tcrunch
//
//  Created by Gabriel Fernandes on 5/21/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase

class TcrunchHelper {
    
    public static var user: User?
    public static var user_name: String?
    public static var user_id:String?
    
    static var newTicketHandle:UInt?
    
    //get context
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let dbRef = Database.database().reference()
    
    public static func joinClass(code: String, completion: @escaping (_ re: JoinClass, _ id: String?) -> Void) {
        
        dbRef.child("classes").queryOrdered(byChild: "courseCode").queryEqual(toValue: code).queryLimited(toFirst: 1).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let val1 = snapshot.value as? NSDictionary {
                
                let val = val1[val1.allKeys[0]] as! NSDictionary
                
                let courseCode = val["courseCode"] as! String
                let id = val["id"] as! String
                let name = val["name"] as! String
                let teacher = val["teacher"] as! String
                
                
                //check if user already is in class
                let repeatedClass = getClasses().contains(where: {
                    (t) in
                    if t.id == id {
                        return true
                    }
                    return false
                })
                
                //if not register, then register and save
                if !repeatedClass {
                    let tclass = TClass(context: context)
                    tclass.courseCode = courseCode
                    tclass.id = id
                    tclass.name = name
                    tclass.teacher = teacher
                    
                    var student:DatabaseReference
                    if let stu_id = TcrunchHelper.user_id {
                        student = dbRef.child("students").child(stu_id)
                    } else {
                        student = dbRef.child("students").childByAutoId()
                        TcrunchHelper.user_id = student.key
                    }
                    
                    let addClass = student.child(id)
                    addClass.setValue(["courseCode":tclass.courseCode, "id":tclass.id, "name":tclass.name, "teacher":tclass.teacher])
                    
                    //save
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    completion(JoinClass.DONE, id)
                } else {
                    completion(JoinClass.ALREADY_JOINED, id)
                }
            } else {
                completion(JoinClass.ERROR, nil)
            }
            
        })
    }
    
    public static func getStudentTickets(FromClass: String, completion: @escaping (_ answTickets:[TTicket],_ unanswTickets:[TTicket])->Void) {
        
        if let handle = newTicketHandle {
            dbRef.removeObserver(withHandle: handle)
        }
        
        newTicketHandle = dbRef.child("tickets").child(FromClass).observe(.value, with: {
            (snapshot) in
            
            dbRef.child("answered").child(TcrunchHelper.user_id!).observeSingleEvent(of:.value, with: {
                (snapshot2) in
                
                //get answered id
                var answeredTicketsId: [String] = []
                if let snap2 = snapshot2.value as? NSDictionary {
                    for (_, tid) in snap2 {
                        answeredTicketsId.append(tid as! String)
                    }
                }
                
                //get all tickets
                var tik = [TTicket]()
                if let snap = snapshot.value as? NSDictionary {
                    
                    for (_,obj) in snap {
                        
                        let ticket = TTicket(withDictionary: obj as! NSDictionary)
                        
                        tik.append(ticket)
                        
                    }
                    
                }
                
                print("test")
                
                var answeredTickets: [TTicket] = []
                var unansweredTickets: [TTicket] = []
                
                for item in tik {
                    if answeredTicketsId.contains(item.id!) {
                        answeredTickets.append(item)
                    } else {
                        unansweredTickets.append(item)
                    }
                }
                
                completion(answeredTickets, unansweredTickets)
            })
        })
        
        
    }
    
    public static func getClasses() -> [TClass] {
        do {
            return try context.fetch(TClass.fetchRequest())
        } catch {
            return [TClass]()
        }
    }
    
    public static func deleteClass(_ cls: TClass) {
        context.delete(cls)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    static func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    
}

enum JoinClass {
    case ERROR
    case DONE
    case ALREADY_JOINED
}
