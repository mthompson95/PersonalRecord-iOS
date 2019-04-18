//
//  SecondViewController.swift
//  Personal Record
//
//  Created by Michael Thompson on 2/1/19.
//  Copyright © 2019 Michael Thompson. All rights reserved.
//

import UIKit
import Firebase

class SecondViewController: UIViewController {

    var setNumber: Int = 10000
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        timePicker.setValue(false, forKeyPath: "highlightsToday")
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MMMM d, YYYY"
        todayDate.text = format.string(from: date)
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)
        tmrwDate.text = format.string(from: tomorrow ?? date)
        
        notificationSwitch.transform = CGAffineTransform(scaleX: 0.667, y: 0.667)
    }
    
    
    @IBOutlet weak var todayDate: UILabel!
    @IBOutlet weak var todayGood: UIButton!
    @IBOutlet weak var todayMeh: UIButton!
    @IBOutlet weak var todayBad: UIButton!
    @IBOutlet weak var journalEntry: UITextView!
    @IBOutlet weak var submitJournalEntry: UIButton!
    
    @IBOutlet weak var tmrwDate: UILabel!
    @IBOutlet weak var tmrwGood: UIButton!
    @IBOutlet weak var tmrwMeh: UIButton!
    @IBOutlet weak var tmrwBad: UIButton!
    @IBOutlet weak var reminderEntry: UITextField!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var timeForNotification: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var submitReminder: UIButton!
    
    
    // hide other day's buttons, send emoji button result to the DB
    @IBAction func selectTodayGood(_ sender: Any) {
        todayMeh.isHidden = true
        todayBad.isHidden = true
        todayGood.layer.borderWidth = 0
        todayGood.isEnabled = false
        
        db.collection(todayDate.text!).document("01 Outcome").setData([
            "Outcome \(setNumber)": "👍"
        ]) { err in
            if let err = err {
                print("Error adding outcome for \(self.todayDate.text!): \(err)")
            } else {
                print("Outcome added with ID: Good")
            }
        }
        
        let date = Date()
        let Y2K = Calendar.current.startOfDay(for: Date(timeIntervalSinceReferenceDate: 0))
        let daysSinceY2K = Calendar.current.dateComponents([.day], from: Y2K, to: date)
        
        db.collection("Outcomes").document("\(daysSinceY2K)").setData([
            "\(todayDate.text) \(setNumber)": "👍"
        ], merge: true) { err in
            if let err = err {
                print("Error adding \(self.todayDate.text) for Outcomes: \(err)")
            } else {
                print("Outcome day added with ID: \(daysSinceY2K)")
            }
        }
    }
    
    // hide other day's buttons, send emoji button result to the DB
    @IBAction func selectTodayMeh(_ sender: Any) {
        todayGood.isHidden = true
        todayBad.isHidden = true
        todayMeh.layer.borderWidth = 0
        todayMeh.isEnabled = false
        
        db.collection(todayDate.text!).document("01 Outcome").setData([
            "Outcome \(setNumber)": "😐"
        ]) { err in
            if let err = err {
                print("Error adding outcome for \(self.todayDate.text!): \(err)")
            } else {
                print("Outcome added with ID: Meh")
            }
        }
        
        let date = Date()
        let Y2K = Calendar.current.startOfDay(for: Date(timeIntervalSinceReferenceDate: 0))
        let daysSinceY2K = Calendar.current.dateComponents([.day], from: Y2K, to: date)
        
        db.collection("Outcomes").document("\(daysSinceY2K)").setData([
            "\(todayDate.text) \(setNumber)": "😐"
        ], merge: true) { err in
            if let err = err {
                print("Error adding \(self.todayDate.text) for Outcomes: \(err)")
            } else {
                print("Outcome day added with ID: \(daysSinceY2K)")
            }
        }
    }
    
    // hide other day's buttons, send emoji button result to the DB
    @IBAction func selectTodayBad(_ sender: Any) {
        todayGood.isHidden = true
        todayMeh.isHidden = true
        todayBad.layer.borderWidth = 0
        todayBad.isEnabled = false
        
        db.collection(todayDate.text!).document("01 Outcome").setData([
            "Outcome \(setNumber)": "👎"
        ]) { err in
            if let err = err {
                print("Error adding outcome for \(self.todayDate.text!): \(err)")
            } else {
                print("Outcome added with ID: Bad")
            }
        }
        
        let date = Date()
        let Y2K = Calendar.current.startOfDay(for: Date(timeIntervalSinceReferenceDate: 0))
        let daysSinceY2K = Calendar.current.dateComponents([.day], from: Y2K, to: date)
        
        db.collection("Outcomes").document("\(daysSinceY2K)").setData([
            "\(todayDate.text) \(setNumber)": "👎"
        ], merge: true) { err in
            if let err = err {
                print("Error adding \(self.todayDate.text) for Outcomes: \(err)")
            } else {
                print("Outcome day added with ID: \(daysSinceY2K)")
            }
        }
    }
    
    // hide other day's buttons, send emoji button result to the DB
    @IBAction func selectTmrwGood(_ sender: Any) {
        tmrwMeh.isHidden = true
        tmrwBad.isHidden = true
        tmrwGood.layer.borderWidth = 0
        tmrwGood.isEnabled = false
        
        db.collection(tmrwDate.text!).document("02 Prediction").setData([
            "Prediction \(setNumber)": "👍"
        ]) { err in
            if let err = err {
                print("Error adding prediction for \(self.tmrwDate.text!): \(err)")
            } else {
                print("Prediction added with ID: G")
            }
        }
        
        let date = Date()
        let Y2K = Calendar.current.startOfDay(for: Date(timeIntervalSinceReferenceDate: 0))
        let daysSinceY2K = Calendar.current.dateComponents([.day], from: Y2K, to: date)
        
        db.collection("Predictions").document("\(daysSinceY2K)").setData([
            "\(tmrwDate.text) \(setNumber)": "👍"
        ], merge: true) { err in
            if let err = err {
                print("Error adding \(self.todayDate.text) for Predictions: \(err)")
            } else {
                print("Prediction day added with ID: \(daysSinceY2K)")
            }
        }
    }
    
    // hide other day's buttons, send emoji button result to the DB
    @IBAction func selectTmrwMeh(_ sender: Any) {
        tmrwGood.isHidden = true
        tmrwBad.isHidden = true
        tmrwMeh.layer.borderWidth = 0
        tmrwMeh.isEnabled = false
        
        db.collection(tmrwDate.text!).document("02 Prediction").setData([
            "Prediction \(setNumber)": "😐"
        ]) { err in
            if let err = err {
                print("Error adding prediction for \(self.tmrwDate.text!): \(err)")
            } else {
                print("Prediction added with ID: Meh")
            }
        }
        
        let date = Date()
        let Y2K = Calendar.current.startOfDay(for: Date(timeIntervalSinceReferenceDate: 0))
        let daysSinceY2K = Calendar.current.dateComponents([.day], from: Y2K, to: date)
        
        db.collection("Predictions").document("\(daysSinceY2K)").setData([
            "\(tmrwDate.text) \(setNumber)": "😐"
        ], merge: true) { err in
            if let err = err {
                print("Error adding \(self.todayDate.text) for Predictions: \(err)")
            } else {
                print("Predictions day added with ID: \(daysSinceY2K)")
            }
        }
    }
    
    // hide other day's buttons, send emoji button result to the DB
    @IBAction func selectTmrwBad(_ sender: Any) {
        tmrwGood.isHidden = true
        tmrwMeh.isHidden = true
        tmrwBad.layer.borderWidth = 0
        tmrwBad.isEnabled = false
        
        db.collection(tmrwDate.text!).document("02 Prediction").setData([
            "Prediction \(setNumber)": "👎"
        ]) { err in
            if let err = err {
                print("Error adding prediction for \(self.tmrwDate.text!): \(err)")
            } else {
                print("Prediction added with ID: 06 Bad")
            }
        }
        
        let date = Date()
        let Y2K = Calendar.current.startOfDay(for: Date(timeIntervalSinceReferenceDate: 0))
        let daysSinceY2K = Calendar.current.dateComponents([.day], from: Y2K, to: date)
        
        db.collection("Predictions").document("\(daysSinceY2K)").setData([
            "\(tmrwDate.text) \(setNumber)": "👎"
        ], merge: true) { err in
            if let err = err {
                print("Error adding \(self.todayDate.text) for Predictions: \(err)")
            } else {
                print("Predictions day added with ID: \(daysSinceY2K)")
            }
        }
    }
    
    // submit journal entry to the DB, also makes entry readonly and submit is disabled
    @IBAction func submitEntryToDB(_ sender: Any) {
        journalEntry.isEditable = false
        submitJournalEntry.isHidden = true
        
        db.collection(todayDate.text!).document("07 Journal Entry").setData([
            "Entry \(setNumber)": journalEntry.text
        ]) { err in
            if let err = err {
                print("Error adding journal entry for \(self.todayDate.text!): \(err)")
            } else {
                print("Journal entry added with ID: 07 JE")
            }
        }
    }
    
    // closes picker, submits reminder, and notification if enabled
    @IBAction func closePickerOnSubmit(_ sender: Any) {
        if (notificationSwitch.isOn) {
            timePicker.isHidden = true
            timeForNotification.isHidden = true
            notificationSwitch.isOn = false
            let timeString = "\(timeForNotification.text!)"
            let afterAtSymbol = timeString.index(timeString.startIndex, offsetBy: 2)
            
            db.collection(tmrwDate.text!).document("08 Reminder with Notification").setData([
                "Reminder \(setNumber)": "\(reminderEntry.text!) @ \(timeString[afterAtSymbol...])",
                "Notification \(setNumber)": "\(timeString[afterAtSymbol...])"
            ], merge: true) { err in
                if let err = err {
                    print("Error adding reminder and notification for \(self.todayDate.text!): \(err)")
                } else {
                    print("Reminder and notification added with ID: 08 RwN")
                }
            }
            setNumber = setNumber + 1
        } else {
            db.collection(tmrwDate.text!).document("09 Reminder").setData([
                "Reminder \(setNumber)": reminderEntry.text ?? ""
            ], merge: true) { err in
                if let err = err {
                    print("Error adding reminder for \(self.todayDate.text!): \(err)")
                } else {
                    print("Reminder added with ID: 09 R")
                }
            }
            setNumber = setNumber + 1
        }
    }
    
    // updates timeForNotification label according to the picker
    @IBAction func liveUpdateTimeLabel(_ sender: Any) {
        let date = timePicker.date
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        let amPM = dateComponents.hour! < 12 ? " AM" : " PM"
        let formattedHr = (dateComponents.hour! % 12 == 0) ? 12 : 0
        let formattedMin = dateComponents.minute! < 10 ? "0" : ""
        
        timeForNotification.text =
            "@ " + String((dateComponents.hour! % 12) + formattedHr) + ":"
            + formattedMin + String(dateComponents.minute!)
            + amPM
    }
    
    // enable and disable timePicker according to notification button
    @IBAction func bringUpTimePicker(_ sender: Any) {
        switch notificationSwitch.isOn {
        case true:
            timePicker.isHidden = false
            timeForNotification.isHidden = false
        case false:
            timePicker.isHidden = true
            timeForNotification.isHidden = true
        }
    }
    
    // allows touches to make the keyboard disappear
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

