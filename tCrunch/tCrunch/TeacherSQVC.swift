//
//  TeacherSQVC.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 9/1/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class TeacherSQVC: UITableViewController {
    
    let questions = ["Understanding student comprehension", "Understanding student confusion", "Understanding student interests", "Evaluating course material", "Evaluating assignments and assessments", "Evaluating your teaching strategies", "Evaluating classroom communication"]
    
    var topShowing = [false,false,false,false,false,false,false]
    
    let tree = [["Explain today's most important concept briefly", "Name one important ting you learned today.", "what is one important thing you learned today?", "On a scale from 1 to 5, where 1 = 'I am lost' and 5 = 'I understand everything,' how well did you understand the lecture content today?"],["What was the most confusing concept from class today?", "What is one question you have from today's lecture?", "What is one concept you would like to review?", "If we were to take the test on the material today, which subject are you least confident about?"],["What are you most interested in learning about in this class?", "Do you think we should spend more or less time on material covered in class?", "Why are you taking this class?", "How engaged did you feel in class today?", "Does your participation in this class make you want to learn more outside of class?", "What are you most looking forward to this semester?"],["Which classroom activities do you find beneficial and worthwhile?", "What materials helped you the most in preparing for class?", "Do you think we are going too slow or quick over materialat this point of the semester", "What do other students say about this class?", "If you could get rid of one lecture so far which would it be? Why?", "The most confusing thing about this class is _______?", "If you could change one thing about this class what would it be?", "What do you think the purpose of this class is?", "Do you think that the time we spend working on application problems in class is valuable?"],["How many hours did you spend on your homework?", "How many hours did you spend preparing for lecture this week?", "What is one thing that I could do to improve homework assignments?", "What is one thing you like about tests given?", "What class preparation did you complete?", "What do you do to study for this course?", "If you could get rid of one assignment or test which would it be? Why?"],["I am trying out a new teaching strategy of using Youtube videos in the classroom. Do you think this improves your learning? Why/ why not?", "At the end of the year you will rate me on how effective of a teacher I was. How would you saw I am doing now?", "What is one way I could improve my teaching?", "Give an example of a good teaching strategy another teacher has used that I could implement to facilitate learning.", "What is one thing that I could do to improve your experience in this class?", "What has been your favorite aspect of the class thus far?"],["Have you come to office hours? If not, why not?", "How well do you agree with the statement, \"I feel comfortable approaching the professor with a problem or question that I have?\"", "Do you feel like you receive quality feedback on your assignments and/or tests", "One of the goals for this class includes class participation. How well do you think I have facilitated that?", "How might technology be used to improve the classroom experience?", "What is one question you would like to ask me?", "What teaching or learning technology applications could be utilized to improve the classroom experience? Explain."]]
    
    override func viewDidLoad() {
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationController!.navigationBar.topItem!.title = "Back"
        self.navigationItem.title = "Suggested Questions"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return questions.count * 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section % 2 == 0 {
            return 1
        } else {
            if topShowing[(section - 1) / 2] {
                return self.tree[section/2].count
            } else {
                return 0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.section % 2 == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "treeTop")
            
            let text = cell.viewWithTag(2) as! UILabel
            text.text = questions[indexPath.section/2]
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "treeBottom")
            
            let textView = cell.viewWithTag(1) as! UITextView
            
            textView.text = tree[(indexPath.section - 1) / 2][indexPath.row]
            textView.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isEven(indexPath.section) {
            topShowing[indexPath.section / 2] = !topShowing[indexPath.section / 2]
            tableView.reloadData()
        } else {
            //create ticket with question
            let ticketVC = storyboard?.instantiateViewController(withIdentifier: "TeacherNewTicketVC") as! TeacherNewTicketVC
            ticketVC.presetQuestion = tree[(indexPath.section - 1) / 2][indexPath.row]
            self.navigationController?.show(ticketVC, sender: self)
        }
        
    }
    
    func isEven(_ val:Int) -> Bool{
        if val % 2 == 0 {
            return true
        }
        return false
    }
    
}
