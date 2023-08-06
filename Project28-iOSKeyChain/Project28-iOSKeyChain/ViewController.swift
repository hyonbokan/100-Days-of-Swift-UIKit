//
//  ViewController.swift
//  Project28-iOSKeyChain
//
//  Created by dnlab on 2023/08/04.
//
import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!
    
    var password = "123456"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
        
        print("Initial password: \(password)")
        password = KeychainWrapper.standard.string(forKey: "Password") ?? "empty"
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        //error
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        // add ui action to trigger password alert
                        ac.addAction(UIAlertAction(title: "Use password", style: .default, handler: self?.passwordAlert))
                        // add ui alert action to set new password and save it in keychain
                        ac.addAction(UIAlertAction(title: "New password", style: .default, handler: self?.newPasswordAlert))
                        self?.present(ac, animated: true)
                        
                    }
                }
                
            }
        } else {
            // no biometry
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
        }
    }
    
    func passwordAlert(action: UIAlertAction){
        let ac = UIAlertController(title: "Input your password", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let checkPassword = UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac] _ in
            if ac?.textFields?[0].text == self?.password {
                self?.unlockSecretMessage()
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "The password is incorrect!", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(errorAlert, animated: true)
            }
        }
        ac.addAction(checkPassword)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func newPasswordAlert(action: UIAlertAction) {
        let ac = UIAlertController(title: "Set new password", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let setNewPassword = UIAlertAction(title: "Set", style: .default){
            [weak self, weak ac] _ in
            let newPassword = ac?.textFields?[0].text
            self?.password = newPassword ?? "none"
            print("new password: \(self?.password)")
        }
        ac.addAction(setNewPassword)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret text"
//        var savedPassword = password
//        if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
//            secret.text = text
//        }
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        print("Unlock global password: \(password)")
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
       
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        KeychainWrapper.standard.set(password, forKey: "Password")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
        print("Currently saved password: \(password)")
    }
    
}

