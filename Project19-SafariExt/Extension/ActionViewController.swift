//
//  ActionViewController.swift
//  Extension
//
//  Created by dnlab on 2023/07/14.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showExamples))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
//        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
//            if let itemProvider = inputItem.attachments?.first {
//                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
//                    // code
//                    guard let itemDictionary = dict as? NSDictionary else { return }
//                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
//                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
//                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
//
//                    //closure inside other closure
//                    DispatchQueue.main.async {
//                        self?.title = self?.pageTitle
//                    }
//                }
//            }
//        }
        //The inputItem represents the input data received by the extension. In this case, it refers to the first item in the inputItems array of the extension context.
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            //The itemProvider is used to access the attachments associated with the input item. Here, we retrieve the first attachment.
            //load the item's content for identifier - property list type
                if let itemProvider = inputItem.attachments?.first {
                    itemProvider.loadItem(forTypeIdentifier: UTType.propertyList.identifier) { [weak self] (dict, error) in
                        // the loaded item is cast to an NSDictionary. This is done to access the JavaScript-related values stored in the item's dictionary.
                        guard let itemDictionary = dict as? NSDictionary else { return }
                        //The javaScriptValues dictionary is extracted from the item dictionary using the NSExtensionJavaScriptPreprocessingResultsKey key. It contains information such as the title and URL of the web page.
                        guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                
                        self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                        self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                        //can't retrieve title and url
                        print(javaScriptValues["title"])
                        print(javaScriptValues["URL"])
                        //closure inside other closure
                        //ensure UI updates are performed on the main thread
                        DispatchQueue.main.async {
                            self?.title = self?.pageTitle
                        }
                    }
                }
            }
    }

    @IBAction func done() {
        guard let userInput = script.text else { return }
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": userInput]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
//        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: UTType.propertyList.identifier)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
        UserDefaults.standard.set(userInput, forKey: pageURL)
    }
    
    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0,
                                               left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
                                               right: 0)
            script.scrollIndicatorInsets = script.contentInset
            
            let selectedRange = script.selectedRange
            script.scrollRangeToVisible(selectedRange)
        }
    }
    
    @objc func showExamples() {
        let ac = UIAlertController(title: "Examples of JS commands", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "alert(document.title);", style: .default))
        present(ac, animated: true)
    }
    
    
}
