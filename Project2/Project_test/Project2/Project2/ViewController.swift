//
//  ViewController.swift
//  Project2
//
//  Created by dnlab on 2023/06/09.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet var button1: UIButton!
    
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score  = 0
    var highestScore = 0
    var correctAnwer = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        // Request authorization
//        let center = UNUserNotificationCenter.current()
//
//        center.requestAuthorization(options: [.alert, .badge, .sound]) {
//            granted, error in
//            if granted {
//                print("Permisson granted!")
//            } else {
//                print("Permisson denided")
//            }
//        }
        registerCategories()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showScore))
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        
//        button1.layer.borderWidth = 1
//        button2.layer.borderWidth = 1
//        button3.layer.borderWidth = 1
//        You are adding the border to the button. What you need is to add the border to the button's imageView property. Make sure to set its images before adding the borders:
        button1.imageView?.layer.borderWidth = 1
        button2.imageView?.layer.borderWidth = 1
        button3.imageView?.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        let defaults = UserDefaults.standard
        
        if let savedScore = defaults.object(forKey: "highestScore") as? Data {
            if let decodedScore = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: savedScore) {
                highestScore = decodedScore.intValue
            }
        }
        
        
//        askQuestion(action: nil)
        askQuestion()

    }
    func resetGame(action: UIAlertAction! = nil) {
        score = 0
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnwer = Int.random(in: 0...2)
//        print(correctAnwer)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnwer].uppercased() + " | Your score: \(score)"
        
        if score >= 5 {
            gameOver(messageToPlayer: "You won! Congrats!")
        } else if score < -3 {
            gameOver(messageToPlayer: "You lost! Too bad... Try again...")
        }

    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var AlertTitle: String
        // SpringWithDamping adds bounce effect, but it needs to be paired with scale up or down. If we need just a quick bounce effect when the button is tapped, have .identity inside the 'animation'  block. If we need the button stay shrunken, have .identity inside the 'finished in' block
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            sender.transform = .identity
       }) //{ finished in
//            sender.transform = .identity
//        }
        if sender.tag == correctAnwer {
            AlertTitle = "Correct"
            score += 1
            if score > highestScore {
                highestScore = score
                saveScore()
                print("High Score: \(highestScore)")
            }
        } else {
            AlertTitle = "Incorrect. The correct answer is the flag #\(correctAnwer + 1)"
            score -= 1
        }
        
        
        
        // title and score is passed to UIAlertController from buttonTapped
        let ac = UIAlertController(title: AlertTitle, message: "Your score is \(score)", preferredStyle: .alert)
        // create action when the button in the alert message is tapped
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present(ac, animated: true)
        // Go to identifier and change the tag of the UIImage
    }
    
    @objc func showScore() {
        let scoreAlert = UIAlertController(title: "Score", message: "Your score is \(highestScore)", preferredStyle: .alert)
        scoreAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        
        present(scoreAlert, animated: true)
    }
    func gameOver(messageToPlayer: String){
        let gameOver = UIAlertController(title: "Game Over!", message: messageToPlayer, preferredStyle: .alert)
        gameOver.addAction(UIAlertAction(title: "OK", style: .default, handler: resetGame))
        present(gameOver, animated: true)
    }
    
    func saveScore() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: highestScore, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "highestScore")
        }
    }
    
    // Day 73 Challenge - Notification
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.delegate = self
        // Authorization
            center.requestAuthorization(options: [.alert, .badge, .sound]) {
                granted, error in
                    if granted {
                        print("Permisson granted!")
                    } else {
                        print("Permisson denided")
                    }
                }
        // Creating categories
        let openApp = UNNotificationAction(identifier: "open", title: "Play the game!", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "alert", actions: [openApp], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
        
        // Creating content
        let content = UNMutableNotificationContent()
        content.title = "Project-2 Flag Game"
        content.body = "It's been a while. Let's play again!"
        content.categoryIdentifier = "alert"
        content.userInfo = ["customData": "Some data..."]
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)

    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data recieved: \(customData)")
            
            switch response.actionIdentifier{
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier - App launched")
            default:
                break
            }
        }
        completionHandler()
    }
    
}

