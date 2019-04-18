//
//  FourthViewController.swift
//  Personal Record
//
//  Created by Michael Thompson on 2/23/19.
//  Copyright © 2019 Michael Thompson. All rights reserved.
//

import UIKit
import Firebase

class FourthViewController: UIViewController {
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        // set goals list with current goals in DB
        db.collection("Goals").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting goals: \(err)")
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
                    
                    for num in 0..<keyStringArray.count {
                        let content = keyStringArray[num] + ": " + valueStringArray[num] + "\n\n"
                        self.listOfMoreGoals.text = self.listOfMoreGoals.text + content
                    }
                }
            }
        }
        
        // set event list with current events in DB
        db.collection("Events").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting events: \(err)")
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
                    
                    for num in 0..<keyStringArray.count {
                        let content = keyStringArray[num] + ": " + valueStringArray[num] + "\n\n"
                        self.eventsList.text = self.eventsList.text + content
                    }
                }
            }
        }
        listOfMoreGoals.flashScrollIndicators()
        eventsList.flashScrollIndicators()
        
        // turn date pickers white
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.setValue(false, forKeyPath: "highlightsToday")
        datePicker2.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker2.setValue(false, forKeyPath: "highlightsToday")
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var listOfMoreGoals: UITextView!
    @IBOutlet weak var goalInput: UITextField!
    @IBOutlet weak var submitGoal: UIButton!
    var setNumber = 10000
    
    // make goal input show up
    @IBAction func enableGoalInput(_ sender: Any) {
        listOfMoreGoals.isHidden = true
        datePicker.isHidden = false
        goalInput.isHidden = false
        submitGoal.isHidden = false
    }
    
    // submit goal to DB, both for the day its for, and also for an overall goals list
    @IBAction func sendGoaltoDB(_ sender: Any) {
        datePicker.isHidden = true
        goalInput.isHidden = true
        submitGoal.isHidden = true
        listOfMoreGoals.isHidden = false
        
        let date = datePicker.date
        let Y2K = Calendar.current.startOfDay(for: Date(timeIntervalSinceReferenceDate: 0))
        let daysSinceY2K = Calendar.current.dateComponents([.day], from: Y2K, to: date)
        let format = DateFormatter()
        format.dateFormat = "MMMM d, YYYY"
        let dateString = format.string(from: date)
        
        db.collection(dateString).document("10 Goal").setData([
            "Goal \(setNumber)": goalInput.text ?? ""
        ], merge: true) { err in
            if let err = err {
                print("Error adding goal for \(dateString): \(err)")
            } else {
                print("Goal added with ID: 10 G")
            }
        }
        
        db.collection("Goals").document("\(daysSinceY2K)").setData([
            "\(dateString) \(setNumber)": goalInput.text ?? ""
        ], merge: true) { err in
            if let err = err {
                print("Error adding \(dateString) for goals: \(err)")
            } else {
                print("Goal day added with ID: \(daysSinceY2K)")
            }
        }
        setNumber = setNumber + 1
    }
    
    // grab list of goals again to get any submitted ones
    @IBAction func refreshGoals(_ sender: Any) {
        listOfMoreGoals.text = ""
        db.collection("Goals").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting goals: \(err)")
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
                    
                    for num in 0..<keyStringArray.count {
                        let content = keyStringArray[num] + ": " + valueStringArray[num] + "\n\n"
                        self.listOfMoreGoals.text = self.listOfMoreGoals.text + content
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var datePicker2: UIDatePicker!
    @IBOutlet weak var submitEvent: UIButton!
    @IBOutlet weak var eventsList: UITextView!
    @IBOutlet weak var eventInput: UITextField!
    
    // make event input show up
    @IBAction func enableEventInput(_ sender: Any) {
        eventsList.isHidden = true
        datePicker2.isHidden = false
        eventInput.isHidden = false
        submitEvent.isHidden = false
    }
    
    // submit event to DB, both for the day its for, and also for an overall events list
    @IBAction func sendEventToDB(_ sender: Any) {
        datePicker2.isHidden = true
        eventInput.isHidden = true
        submitEvent.isHidden = true
        eventsList.isHidden = false
        
        let date = datePicker2.date
        let format = DateFormatter()
        let Y2K = Calendar.current.startOfDay(for: Date(timeIntervalSinceReferenceDate: 0))
        let daysSinceY2K = Calendar.current.dateComponents([.day], from: Y2K, to: date)
        format.dateFormat = "MMMM d, YYYY"
        let dateString = format.string(from: date)
        
        db.collection(dateString).document("11 Event").setData([
            "Event \(setNumber)": eventInput.text ?? ""
        ], merge: true) { err in
            if let err = err {
                print("Error adding event for \(dateString): \(err)")
            } else {
                print("Event added with ID: 11 E")
            }
        }
        
        db.collection("Events").document("\(daysSinceY2K)").setData([
            "\(dateString) \(setNumber)": eventInput.text ?? ""
        ], merge: true) { err in
            if let err = err {
                print("Error adding \(dateString) for events: \(err)")
            } else {
                print("Event day added with ID: \(daysSinceY2K)")
            }
        }
        setNumber = setNumber + 1
    }
    
    // grab list of events again to get any submitted ones
    @IBAction func refreshEvents(_ sender: Any) {
        self.eventsList.text = ""
        db.collection("Events").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting events: \(err)")
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
                    
                    for num in 0..<keyStringArray.count {
                        let content = keyStringArray[num] + ": " + valueStringArray[num] + "\n\n"
                        self.eventsList.text = self.eventsList.text + content
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
