//
//  ThirdViewController.swift
//  Personal Record
//
//  Created by Michael Thompson on 2/16/19.
//  Copyright © 2019 Michael Thompson. All rights reserved.
//

import UIKit
import CalendarView
import SwiftMoment
import Firebase

class ThirdViewController: UIViewController {

    var db: Firestore!

    var daySelected: Moment! {
        didSet {
            selectedDate.text = daySelected.format("MMMM d, yyyy")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    
        CalendarView.daySelectedBackgroundColor = UIColor.lightText
        CalendarView.dayTextColor = UIColor.white
        CalendarView.daySelectedTextColor = UIColor.black
        CalendarView.weekLabelTextColor = UIColor.white
        CalendarView.dayFont = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.light)
        
        let calendar = CalendarView(frame: CGRect(x: 0, y: 70, width: view.frame.width, height: 320))
        calendar.selectedDayOnPaged = nil
        
        daySelected = moment()
        calendar.delegate = self
        
        view.addSubview(calendar)
    }
    
    @IBOutlet weak var selectedDate: UILabel!
    
    @IBOutlet weak var listForSelectedDay: UITextView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ThirdViewController: CalendarViewDelegate {
    
    func calendarDidSelectDate(date: Moment) {
        self.daySelected = date
        self.listForSelectedDay.text = ""
        db.collection(selectedDate.text!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting \(self.selectedDate.text!)'s information: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if (!document.data().keys.description.contains("Reminder")) {
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
                            self.listForSelectedDay.text = self.listForSelectedDay.text + content
                        }
                    }
                }
            }
        }
        listForSelectedDay.flashScrollIndicators()
    }
    
    func calendarDidPageToDate(date: Moment) {
        self.daySelected = date
    }
    
}
