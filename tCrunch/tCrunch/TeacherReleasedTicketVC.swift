//
//  TeacherReleasedTicketVC.swift
//  tCrunch
//
//  Created by Gabriel Fernandes on 8/27/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import Charts
import Whisper

class TeacherReleasedTicketVC: UITableViewController, SettingsLauncherDelegate, MFMailComposeViewControllerDelegate {
    
    var parentVC: TeacherClassVC?
    
    var ticket: TTicket?
    var responses: [TResponse] = []
    
    var questionCell: UITableViewCell?
    var responseLabel: UILabel?
    
    var multipleChoice: [String]?
    
    var barChartView: BarChartView?
    
    var settings: [String] = ["Email Ticket Data", "Delete Ticket"]
    
    lazy var settingsLauncher: SettingsLauncher = {
        let sl = SettingsLauncher(settings: self.settings)
        sl.delegate = self
        return sl
    }()
    
    internal func settingsLauncher(SettingsSelected selected: String) {
        if selected == settings[0] { //Email Ticket Data
            
            //create csv and send email
            let fileName = "TicketData.csv"
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            
            var csvText: String = "Class,\(parentVC!.selectedClass!.name!)\n"
            csvText += "Question Text, \(ticket!.question!)\n"
            
            var date = Date.init(timeIntervalSince1970: Double(ticket!.startTime!) / 1000)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
            
            csvText += "Launch Time, \"\(dateFormatter.string(from: date))\"\n"
            
            csvText += "# Response, \(responses.count)\n"
            
            csvText += "USER, RESPONSE, TIME\n"
            
            for resp in responses {
                date = Date.init(timeIntervalSince1970: Double(resp.time!) / 1000)
                csvText += "\(resp.author!),\(resp.response!),\"\(dateFormatter.string(from: date))\"\n"
            }
            
            do {
                try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                
                if MFMailComposeViewController.canSendMail() {
                    let emailController = MFMailComposeViewController()
                    emailController.mailComposeDelegate = self
                    emailController.setToRecipients([]) //I usually leave this blank unless it's a "message the developer" type thing
                    emailController.setSubject("Tcrunch: Your ticket data")
                    emailController.setMessageBody("Your ticket data is attached.", isHTML: false)
                    
                    emailController.addAttachmentData(NSData(contentsOf: path!)! as Data, mimeType: "text/csv", fileName: fileName)
                    
                    present(emailController, animated: true, completion: nil)
                    
                } else {
                    let announcement = Announcement(title: "Error", subtitle: "Please set up your email account first.", image: #imageLiteral(resourceName: "cancel"), duration: 6, action: {})
                    Whisper.show(shout: announcement, to: self.parent!, completion: {
                        
                    })
                }
                
            } catch {
                print("Failed to create file")
                print("\(error)")
            }
            
        } else if selected == settings[1] { //Delete Ticket
            
            let alertController = UIAlertController(title: "Are you sure you want to delete this ticket?", message: "This action cannot be undone.", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
                
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
                (action) in
                
                TcrunchHelper.deleteTicket(self.ticket!)
                self.navigationController!.popViewController(animated: true)
                
            })
            alertController.addAction(deleteAction)
            
            self.present(alertController, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        let optionButton = UIBarButtonItem(image: #imageLiteral(resourceName: "dots_icon"), style: .plain, target: self, action: #selector(optionButtonPressed(_:)))
        self.navigationItem.setRightBarButton(optionButton, animated: true)
        
        tableView.estimatedRowHeight = 50
        
        self.navigationItem.title = parentVC?.selectedClass?.name
        self.navigationController!.navigationBar.topItem!.title = "Back"
        
        TcrunchHelper.getResponseFor(ticket: ticket!, completion: {
            responses in
            self.responses = responses
            
            if let label = self.responseLabel {
                label.text = "\(responses.count) Responses"
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        TcrunchHelper.removeResponseHandle()
    }
    
    func optionButtonPressed(_ sender: UIBarButtonItem) {
        settingsLauncher.showSettings()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return responses.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "questionCell")!
                let text = cell.viewWithTag(1) as! UITextView
                text.text = ticket?.question
            } else if indexPath.row == 1 {
                cell = tableView.dequeueReusableCell(withIdentifier: "dateCell")!
                let label = cell.viewWithTag(1) as! UILabel
                
                let date = Date.init(timeIntervalSince1970: Double(ticket!.startTime!) / 1000)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
                
                label.text = dateFormatter.string(from: date)
                
            } else if indexPath.row == 2 {
                cell = tableView.dequeueReusableCell(withIdentifier: "numberResponseCell")!
                responseLabel = cell.viewWithTag(1) as? UILabel
                responseLabel?.text = "\(responses.count) Responses"
            }
        } else if indexPath.section == 1 {
            if multipleChoice == nil {
                //show table rows with written responses
                cell = tableView.dequeueReusableCell(withIdentifier: "studentResponseCell")!
                
                let studentLabel = cell.viewWithTag(1) as! UILabel
                studentLabel.text = responses[indexPath.row].author
                
                let responseTextView = cell.viewWithTag(2) as! UITextView
                responseTextView.text = responses[indexPath.row].response
                
                let timeLabel = cell.viewWithTag(3) as! UILabel
                
                let date = Date.init(timeIntervalSince1970: Double(responses[indexPath.row].time!) / 1000)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "E MM/dd h:mm a"
                
                timeLabel.text = dateFormatter.string(from: date)
            } else {
                //show bar graph
                cell = tableView.dequeueReusableCell(withIdentifier: "chartResponseCell")!
//                cell.backgroundColor = UIColor.blue
                barChartView = (cell.viewWithTag(1) as! BarChartView)
                
                updateChart()
            }
        }
        
        return cell
    }
    
    func updateChart() {
        if responses.count > 0 {
            var dataEntries: [BarChartDataEntry] = []
            for i in 0..<multipleChoice!.count {
                var count = 0
                for item in responses {
                    if item.response == multipleChoice?[i] {
                        count += 1
                    }
                }
                dataEntries.append(BarChartDataEntry(x: Double(i), y: Double(count)))
//                chartDataSets
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "yuh")
            chartDataSet.colors = ChartColorTemplates.colorful()
            
            let chartData = BarChartData(dataSet: chartDataSet)
            barChartView?.data = chartData
            
            let stringArray = NSKeyedUnarchiver.unarchiveObject(with: (ticket?.answerChoices)! as Data) as! [String]
            
            barChartView?.xAxis.valueFormatter = IndexAxisValueFormatter(values: stringArray)
            
            barChartView?.xAxis.granularity = 1
            barChartView?.legend.enabled = false
            
            barChartView?.scaleYEnabled = false
            barChartView?.scaleXEnabled = false
            barChartView?.pinchZoomEnabled = false
            barChartView?.doubleTapToZoomEnabled = false
            barChartView?.highlighter = nil
            barChartView?.rightAxis.enabled = false
            barChartView?.xAxis.drawGridLinesEnabled = false
            barChartView?.rightAxis.enabled = false
            barChartView?.chartDescription?.text = ""
            
            barChartView?.leftAxis.axisMinimum = 0
            
            barChartView?.scaleXEnabled = false
            barChartView?.scaleYEnabled = false
            
            barChartView?.animate(xAxisDuration: 0.0, yAxisDuration: 0.5)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if multipleChoice != nil {
            if indexPath.section == 1 && indexPath.row == 0 {
                return 300
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
