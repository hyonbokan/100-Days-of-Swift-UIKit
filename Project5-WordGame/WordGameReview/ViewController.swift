//
//  ViewController.swift
//  WordGameReview
//
//  Created by dnlab on 2023/06/17.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem =
        (UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer)))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWord = try? String(contentsOf: startWordURL) {
                allWords = startWord.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["canopy"]
        }
        startGame()
        
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Words", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter your word", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        // The part that is confusing
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            
            // need to add "submit" func/method
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    
    func submit(_ answer: String) {
        let lowerCasedAnswer = answer.lowercased()
//        let errorTitle: String
//        let errorMessage: String
        
        if isPossible(word: lowerCasedAnswer) {
            if isOriginal(word: lowerCasedAnswer) {
                if isReal(word: lowerCasedAnswer) {
                    // specify where to add new element in an array
                    usedWords.insert(answer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    // exist the method with "return" !!!!
                    return
                } else {
                    showErrorMessage(errorTitle: "The Word is not recognized.", errorMessage: "The word does not exist. Check the spelling and be sure that it is an actual English word AND the word count is ATLEAST 4 words.")
//                    errorTitle = "The Word is not recognized."
//                    errorMessage = "The word does not exist. Check the spelling and be sure that it is an actual English word AND the word count is ATLEAST 4 words."
                }
                
            } else {
//                errorTitle = "The Word is already used OR is a title"
//                errorMessage = "The \(answer) has already been used."
                showErrorMessage(errorTitle: "The Word is already used OR is a title", errorMessage: "The Word is already used OR is a title")
            }
        } else {
            guard let title = title else { return }
//
//            errorTitle = "The Word is not possible"
//            errorMessage = "You cannot spell that word from letter available from \(title.lowercased())."
            showErrorMessage(errorTitle: "The Word is not possible", errorMessage: "You cannot spell that word from letter available from \(title.lowercased()).")
            
        }

    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
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
        guard let title = title?.lowercased() else { return false }
        return !usedWords.contains(word) && word != title
    }
    
    func isReal(word: String) -> Bool {
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        if misspelledRange.location == NSNotFound && word.count > 3 {
            return true
        } else {
            return false
        }
    }
}


