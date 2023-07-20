//
//  DetailViewController.swift
//  MileStoneProject19-21-NotesApp
//
//  Created by dnlab on 2023/07/19.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var textField: UITextView!
    var detailNote: Note?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load data
        let defaults = UserDefaults.standard
        
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                detailNote = try jsonDecoder.decode(Note.self, from: savedNotes)
            } catch {
                print("Failed to load data!")
            }
        }
        
        guard let currentNote = detailNote else { return }
        title = currentNote.title
        textField.text = currentNote.body
        
        // MUST add textField delegate
        textField.delegate = self
        
        // Keyboard observer - top
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        // Keyboard observer - bottom
    }
    // Trigger save when there are changes in the text field
    func textViewDidEndEditing(_ textView: UITextView) {
        save()
    }
    
    // save data func
    func save() {
        guard let currentNote = detailNote else { return }
        currentNote.body = textField.text ?? ""
        
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(currentNote){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        } else {
            print("Failed to save data!")
        }
    }
    
    
    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textField.contentInset = .zero
        } else {
            textField.contentInset = UIEdgeInsets(top: 0,
                                               left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
                                               right: 0)
            textField.scrollIndicatorInsets = textField.contentInset
            
            let selectedRange = textField.selectedRange
            textField.scrollRangeToVisible(selectedRange)
        }
    }
}
