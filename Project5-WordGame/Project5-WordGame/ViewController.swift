//
//  ViewController.swift
//  Project5-WordGame
//
//  Created by dnlab on 2023/06/14.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    var currentWord = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let savedCurrentWord = defaults.object(forKey: "currentWord") as? Data {
            if let decodedWord = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSString.self, from: savedCurrentWord) as String? {
                currentWord = decodedWord
            }
        }
        
        if let savedWordArr = defaults.object(forKey: "usedWords") as? Data {
            
            if let decodedArr = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSString.self], from: savedWordArr) as? [String] {
                usedWords = decodedArr
                print(usedWords)
            }
        }
        
        print("Unarchive Data: \n title: \(currentWord) \n usedWords: \(usedWords)")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    func startGame() {
        if currentWord == "" {
            currentWord = allWords.randomElement() ?? "None"
        }
        
        title = currentWord
        // remove comments to reload the data
//        usedWords.removeAll(keepingCapacity: true)
//        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    //Closures - chunks of code that can be treated like a variable – we can send the closure somewhere, where it gets stored away and executed later.
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        // This is the part I need to review
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String){
        let lowerCaseAnswer = answer.lowercased()
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerCaseAnswer) {
            if isOriginal(word: lowerCaseAnswer) {
                if isReal(word: lowerCaseAnswer) {
                    
                    usedWords.insert(answer, at: 0)
                    save()
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    errorTitle = "The Word is not recognized."
                    errorMessage = "The word does not exist. Check the spelling and be sure that it is an actual English word."
                }
            } else {
                errorTitle = "The Word is already used"
                errorMessage = "The \(answer) has already been used."
            }
        } else {
            // Good practice to avoid force unwrapping
            guard let title = title else { return }
            
            errorTitle = "The Word is not possible"
            errorMessage = "You cannot spell that word from letter available from \(title.lowercased())."
        }
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false}
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func save() {
        let defaults = UserDefaults.standard
        if let currentWord = try? NSKeyedArchiver.archivedData(withRootObject: currentWord, requiringSecureCoding: false) {
            defaults.set(currentWord, forKey: "currentWord")
        }
        if let words = try? NSKeyedArchiver.archivedData(withRootObject: usedWords, requiringSecureCoding: false) {
            defaults.set(words, forKey: "usedWords")
            print("saving usedWords \(usedWords)")
            
        }
        
    }
}

