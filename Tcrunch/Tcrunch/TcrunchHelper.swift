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
    
    public static var user: Firebase.User?
    public static var user_name: String?
    public static var user_id:String?
    
    static var newTicketHandle:UInt?
    
    //get context
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let dbRef = Database.database().reference()
    

    //create class with unique
    public static func createNewClass(code: String, name: String, completion: @escaping (_ t:JoinClass) -> Void) {
        
        dbRef.child("classes").queryOrdered(byChild: "name").queryEqual(toValue: name).observeSingleEvent(of: .value, with: {
            snapshot in
            
            //check if unique name
            print(snapshot)
            let val1 = snapshot.value as? NSDictionary
            if val1 == nil {
                
                dbRef.child("classes").queryOrdered(byChild: "courseCode").queryEqual(toValue: code).observeSingleEvent(of: .value, with: {
                    snapshot2 in
                
                    //check if unique code
                    let val2 = snapshot2.value as? NSDictionary
                    if val2 == nil {
                        
                        //unique code + name
                        completion(JoinClass.DONE)
                        
                    } else {
                        completion(JoinClass.CODE_EXISTS)
                        print("Code already in use: \(code)")
                    }
                })
            } else {
                completion(JoinClass.NAME_EXISTS)
                print("Name already in use: \(name)")
            }
            
        })
        
    }
    
    public static func joinClass(code: String, completion: @escaping (_ re: JoinClass, _ tclass: TClass?) -> Void) {
        
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
                        UserDefaults.standard.set(TcrunchHelper.user_id, forKey: "user_id")
                    }
                    
                    let addClass = student.child(id)
                    addClass.setValue(["courseCode":tclass.courseCode, "id":tclass.id, "name":tclass.name, "teacher":tclass.teacher])
                    
                    //save
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    completion(JoinClass.DONE, tclass)
                } else {
                    
                    let classes = self.getClasses()
                    var tclass: TClass?
                    
                    for item in classes where item.id == id {
                        tclass = item
                    }
                    
                    
                    completion(JoinClass.ALREADY_JOINED, tclass)
                }
            } else {
                completion(JoinClass.ERROR, nil)
            }
            
        })
    }
    
    public static func clearTicketObserve() {
        let classes = self.getClasses()
        
        for item in classes {
            dbRef.child("tickets").child(item.id!).removeAllObservers()
        }
    }
    
    public static func getStudentTickets(FromClass tclass: TClass, completion: @escaping (_ answTickets:[TTicket],_ unanswTickets:[TTicket])->Void) {
        
        newTicketHandle = dbRef.child("tickets").child(tclass.id!).observe(.value, with: {
            (snapshot) in
            
            var answeredTickets: [TTicket] = []
            var unansweredTickets: [TTicket] = []
            var answeredTicketsId: [String] = []
            
            //get all tickets
            if let snap = snapshot.value as? NSDictionary {
                for (_,obj) in snap {
                    
                    let ticket = TTicket()
                    let obj = obj as! NSDictionary
                    if let anonymous = obj["anonymous"] as? Bool {
                        ticket.anonymous = anonymous
                    }
                    if let className_ = obj["className"] as? String {
                        ticket.className_ = className_
                    }
                    if let endTime = obj["endTime"] as? String {
                        ticket.endTime = endTime
                    }
                    if let id = obj["id"] as? String {
                        ticket.id = id
                    }
                    if let question = obj["question"] as? String {
                        ticket.question = question
                    }
                    if let startTime = obj["startTime"] as? CLongLong {
                        ticket.startTime = startTime
                    }
                    if let answerChoiceObj = obj["answerChoices"] as? [String] {
                        var choices: [String] = []
                        for choice in answerChoiceObj {
                            choices.append(choice)
                        }
                        let arrayData = NSKeyedArchiver.archivedData(withRootObject: choices)
                        ticket.answerChoices = arrayData
                    }
                    
                    ticket.tclass = tclass
                    
                    //tk check if time is acceptable, make a timed function that checks if ticket is avalable every minute
                    //ensure that past one can be cancelled--should be in AllClassesViewController
                    
                    
                    unansweredTickets.append(ticket)
                    
                }
            }
            dbRef.child("answered").child(TcrunchHelper.user_id!).observeSingleEvent(of: .value, with: {
                (snapshot2) in
                
                //get answered id
                if let snap2 = snapshot2.value as? NSDictionary {
                    for (_, tid) in snap2 {
                        answeredTicketsId.append(tid as! String)
                    }
                    
                    for item in unansweredTickets {
                        if answeredTicketsId.contains(item.id!) {
                            answeredTickets.append(item)
                            unansweredTickets.remove(at: unansweredTickets.index(where: {
                                tik in
                                if tik.id! == item.id {
                                    return true
                                }
                                return false
                            })!)
                        }
                    }
                    
                }
                
                completion(answeredTickets, unansweredTickets)
                
            })
            
        })
        
    }
    
    public static func observeAnswers(completion: @escaping(_ answeredId: [String])->Void) {
        if let user_id = TcrunchHelper.user_id {
            dbRef.child("answered").child(user_id).observe(.value, with: {
                snap in
                
                //get answered id
                var answeredTicketsId: [String] = []
                
                if let snap = snap.value as? NSDictionary {
                    for (_, tid) in snap {
                        answeredTicketsId.append(tid as! String)
                    }
                    
                }
                
                completion(answeredTicketsId)
            })
        }
    }
    
    public static func getResponse(FromTicket ticket: TTicket, completion: @escaping(_ resp: String)->Void) {
        dbRef.child("responses").child(ticket.id!).child(TcrunchHelper.user_id!).observeSingleEvent(of: .value, with: {
            snap in
            if let snap = snap.value as? NSDictionary {
                
                completion(snap["response"] as! String)
                
            }
        })
    }
    
    public static func set(Response: String, forTicket ticket: TTicket, completion: ()->Void) {
        
        let time = Date().timeIntervalSince1970.bitPattern
        dbRef.child("answered").child(TcrunchHelper.user_id!).childByAutoId().setValue(ticket.id!)
        
        dbRef.child("responses").child(ticket.id!).child(TcrunchHelper.user_id!).setValue(["author":TcrunchHelper.user_name!, "response": Response, "time":time])
        
        completion()
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
    
//    public static func createUser(username: String, password: String, completion: @escaping (_ resp: CAuthError?) -> Void) {
//        
//        Auth.auth().createUser(withEmail: username, password: password, completion: {
//            (_user, _error) in
//    
////            completion(_error)
//            self.user = _user
//            
//        })
//        
//        
//    }
    
}

enum CAuthError: String {
    case USER_ALREADY_EXISTS = "User Already Exists"
    case ERROR
}

enum JoinClass {
    case ERROR
    case DONE
    case ALREADY_JOINED
    case NAME_EXISTS
    case CODE_EXISTS
}
