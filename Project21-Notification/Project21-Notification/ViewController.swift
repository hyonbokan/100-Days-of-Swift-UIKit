//
//  ViewController.swift
//  Project21-Notification
//
//  Created by dnlab on 2023/07/18.
//
import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
    }

    @objc func registerLocal(){
        // request authorization from the user to display notifications on the device.
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print("Yes")
            } else {
                print("No")
            }
        }
    }
    
    @objc func scheduleLocal(){
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        // Show the content of the notification
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early brid catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        //Using UUID().uuidString helps to generate a unique identifier that can be used as the identifier for the notification request. It is a standardized and widely accepted way to generate unique identifiers.
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        //Get the current instance of UNUserNotificationCenter
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        // By registering notification categories, you enable the system to display custom actions when presenting notifications to the user, allowing them to take specific actions directly from the notification interface.
        let reminder = UNNotificationAction(identifier: "reminder", title: "Remind me later", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, reminder], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    //User interaction with the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data recieved: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier")
                let ac = UIAlertController(title: "Default", message: "Default means the user just tapped the notification or selected 'open'", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            case "show":
                print("Show more information...")
                let ac = UIAlertController(title: "More information", message: "User selected 'tell me more...'", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            case "reminder":
                print("Reminder pending...")
                registerCategories()
                let content = UNMutableNotificationContent()
                content.title = "Reminder"
                content.body = "You need set a reminder. There is something important that requires your attention!"
                content.categoryIdentifier = "alarm"
                content.userInfo = ["customDataReminder": "reminder data"]
                content.sound = .default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content , trigger: trigger)
                center.add(request)
            default:
                break
            }
        }
        completionHandler()
    }
    
}

