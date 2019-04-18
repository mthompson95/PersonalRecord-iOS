//
//  FirstViewController.swift
//  Personal Record
//
//  Created by Michael Thompson on 2/1/19.
//  Copyright © 2019 Michael Thompson. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {

    var db: Firestore!
    var currentMonth: String = ""
    var currentYear:  String = ""
    var currentDay:   String = ""
    var thumbsUp = 0
    var neutral = 0
    var thumbsDown = 0
    var weekUp = 0
    var weekNeutral = 0
    var weekDown = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up Firestore
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        // set up today's date in the header
        let date = Date()
        let format = DateFormatter()
        let format2 = DateFormatter()
        let format3 = DateFormatter()
        let format4 = DateFormatter()
        format.dateFormat = "MMMM d, YYYY"
        format2.dateFormat = "MMMM"
        format3.dateFormat = "YYYY"
        format4.dateFormat = "d"
        todayDate.text = format.string(from: date)
        self.currentMonth = format2.string(from: date)
        self.currentYear = format3.string(from: date)
        self.currentDay = format4.string(from: date)
        
        // set up week side of tally label
        db.collection("Outcomes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting \(self.todayDate.text!)'s information: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if (document.data().keys.description.contains(self.currentMonth)) {
                        var valueStringArray: [String] = []
                        
                        for value in document.data().values {
                            let valuesFirstCharacter = "\(value)".index("\(value)".startIndex, offsetBy: 0)
                            let valuesLastCharacter = "\(value)".index("\(value)".endIndex, offsetBy: 0)
                            let valueString = "\(value)"[valuesFirstCharacter..<valuesLastCharacter]
                            valueStringArray.append("\(valueString)")
                        }
                        
                        let amount = valueStringArray.count
                        for num in 0..<amount {
                            if (valueStringArray[num] == "👍") {
                                self.thumbsUp = self.thumbsUp + 1
                            } else if (valueStringArray[num] == "😐") {
                                self.neutral = self.neutral + 1
                            } else if (valueStringArray[num] == "👎") {
                                self.thumbsDown = self.thumbsDown + 1
                            }
                        }
                    }
                }
            }
        }
        
        let dateNow = Date()
        let Y2K = Calendar.current.startOfDay(for: Date(timeIntervalSinceReferenceDate: 0))
        let daysSinceY2K = Calendar.current.dateComponents([.day], from: Y2K, to: dateNow)
        let now1 = "\(daysSinceY2K.day! - 1)"
        let now2 = "\(daysSinceY2K.day! - 2)"
        let now3 = "\(daysSinceY2K.day! - 3)"
        let now4 = "\(daysSinceY2K.day! - 4)"
        let now5 = "\(daysSinceY2K.day! - 5)"
        let now6 = "\(daysSinceY2K.day! - 6)"
        let now7 = "\(daysSinceY2K.day! - 7)"
        
        db.collection("Outcomes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting \(self.todayDate.text!)'s information: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if (document.documentID.contains(now1) ||
                        document.documentID.contains(now2) ||
                        document.documentID.contains(now3) ||
                        document.documentID.contains(now4) ||
                        document.documentID.contains(now5) ||
                        document.documentID.contains(now6) ||
                        document.documentID.contains(now7)) {

                        var valueStringArray: [String] = []

                        for value in document.data().values {
                            let valuesFirstCharacter = "\(value)".index("\(value)".startIndex, offsetBy: 0)
                            let valuesLastCharacter = "\(value)".index("\(value)".endIndex, offsetBy: 0)
                            let valueString = "\(value)"[valuesFirstCharacter..<valuesLastCharacter]
                            valueStringArray.append("\(valueString)")
                        }

                        let amount = valueStringArray.count
                        for num in 0..<amount {
                            if (valueStringArray[num] == "👍") {
                                self.weekUp = self.weekUp + 1
                            } else if (valueStringArray[num] == "😐") {
                                self.weekNeutral = self.weekNeutral + 1
                            } else if (valueStringArray[num] == "👎") {
                                self.weekDown = self.weekDown + 1
                            }
                        }
                    }
                }
            }
        }
        
        // set up Prediction label
        self.predictionForToday.text = ""
        db.collection(todayDate.text!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting \(self.todayDate.text!)'s information: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if (document.data().keys.description.contains("Outcome")) {
                        var keyStringArray: [String] = []
                        var valueStringArray: [String] = []
                        
                        for key in document.data().keys {
                            let keyBeginning = "\(key)".index("\(key)".startIndex, offsetBy: 0)
                            let keyEnding = "\(key)".index("\(key)".endIndex, offsetBy: -6)
                            let keyString = "\(key)"[keyBeginning..<keyEnding]
                            keyStringArray.append("\(keyString)")
                        }
                        
                        for value in document.data().values {
                            let valuesFirstCharacter = "\(value)".index("\(value)".startIndex, offsetBy: 0)
                            let valuesLastCharacter = "\(value)".index("\(value)".endIndex, offsetBy: 0)
                            let valueString = "\(value)"[valuesFirstCharacter..<valuesLastCharacter]
                            valueStringArray.append("\(valueString)")
                        }
                        
                        self.predictionForToday.text = keyStringArray.last! + "   " + valueStringArray.last!
                        break
                    } else if (document.data().keys.description.contains("Prediction")) {
                        var keyStringArray: [String] = []
                        var valueStringArray: [String] = []
                        
                        for key in document.data().keys {
                            let keyBeginning = "\(key)".index("\(key)".startIndex, offsetBy: 0)
                            let keyEnding = "\(key)".index("\(key)".endIndex, offsetBy: -6)
                            let keyString = "\(key)"[keyBeginning..<keyEnding]
                            keyStringArray.append("\(keyString)")
                        }
                        
                        for value in document.data().values {
                            let valuesFirstCharacter = "\(value)".index("\(value)".startIndex, offsetBy: 0)
                            let valuesLastCharacter = "\(value)".index("\(value)".endIndex, offsetBy: 0)
                            let valueString = "\(value)"[valuesFirstCharacter..<valuesLastCharacter]
                            valueStringArray.append("\(valueString)")
                        }
                        
                        self.predictionForToday.text = keyStringArray.last! + "   " + valueStringArray.last!
                        
                    }
                }
            }
        }
        
        // set up Reminders label
        self.remindersForToday.text = ""
        db.collection(todayDate.text!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting \(self.todayDate.text!)'s information: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if (document.data().keys.description.contains("Reminder") && !document.data().keys.description.contains("Notification")) {
                        var keyStringArray: [String] = []
                        var valueStringArray: [String] = []
                        
                        for key in document.data().keys {
                            let keyBeginning = "\(key)".index("\(key)".startIndex, offsetBy: 0)
                            let keyEnding = "\(key)".index("\(key)".endIndex, offsetBy: -6)
                            let keyString = "\(key)"[keyBeginning..<keyEnding]
                            keyStringArray.append("\(keyString)")
                        }
                        for value in document.data().values {
                            let valuesFirstCharacter = "\(value)".index("\(value)".startIndex, offsetBy: 0)
                            let valuesLastCharacter = "\(value)".index("\(value)".endIndex, offsetBy: 0)
                            let valueString = "\(value)"[valuesFirstCharacter..<valuesLastCharacter]
                            valueStringArray.append("\(valueString)")
                        }
                        
                        let amount = (keyStringArray.count > 3) ?  3 : keyStringArray.count
                        for num in 0..<amount {
                            let content = keyStringArray[num] + ": " + valueStringArray[num] + "\n"
                            self.remindersForToday.text = self.remindersForToday.text! + content
                        }
                    }
                }
            }
        }
        
        // set up goals and events coming up label
        db.collection("Goals").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting \(self.todayDate.text!)'s information: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var keyStringArray: [String] = []
                    var valueStringArray: [String] = []
                        
                    for key in document.data().keys {
                        let keyBeginning = "\(key)".index("\(key)".startIndex, offsetBy: 0)
                        let keyEnding = "\(key)".index("\(key)".endIndex, offsetBy: -6)
                        let keyString = "\(key)"[keyBeginning..<keyEnding]
                        keyStringArray.append("\(keyString)")
                    }
                    for value in document.data().values {
                        let valuesFirstCharacter = "\(value)".index("\(value)".startIndex, offsetBy: 0)
                        let valuesLastCharacter = "\(value)".index("\(value)".endIndex, offsetBy: 0)
                        let valueString = "\(value)"[valuesFirstCharacter..<valuesLastCharacter]
                        valueStringArray.append("\(valueString)")
                    }
                    
                    let amount = (keyStringArray.count > 5) ?  5 : keyStringArray.count
                    for num in 0..<amount {
                        let content = keyStringArray[num] + ": " + valueStringArray[num] + "\n"
                        self.goalsEventsComingUp.text = self.goalsEventsComingUp.text! + content
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var todayDate: UILabel!
    
    @IBOutlet weak var predictionForToday: UILabel!
    
    @IBOutlet weak var remindersForToday: UILabel!
    
    @IBOutlet weak var goalsEventsComingUp: UILabel!
    
    @IBOutlet weak var WeekOrMonthTally: UISegmentedControl!
    
    @IBOutlet weak var TallyLabel: UILabel!
    
    @IBAction func lengthChanged(_ sender: Any) {
        switch WeekOrMonthTally.selectedSegmentIndex
        {
        case 0: // Week
            TallyLabel.text = "\(weekUp) 👍\n\(weekNeutral) 😐\n\(weekDown) 👎\nin the past week"
        case 1: // Month
            TallyLabel.text = "\(thumbsUp) 👍\n\(neutral) 😐\n\(thumbsDown) 👎\nout of \(currentDay) days"
        default:
                TallyLabel.text = ""
        }
    }
    
    @IBOutlet weak var Quote: UILabel!
    
    @IBOutlet weak var QuoteScroller: UIPageControl!
    
    @IBAction func quoteChanged(_ sender: Any) {
        switch QuoteScroller.currentPage
        {
        case 0:
            Quote.text = "This is an inspirational quote"
        case 1:
            Quote.text = "This is the second quote"
        case 2:
            Quote.text = "This is quote #3"
        case 3:
            Quote.text = "Still checking? You're on #4"
        case 4:
            Quote.text = "Last one! That's it. I'm stretching this quote out to see how long it can be without running into the control at the bottom. Alright, this seems good enough. ✌️"
        default:
            Quote.text = "Not sure when this would show up 🤷‍♂️"
        }
    }
}

