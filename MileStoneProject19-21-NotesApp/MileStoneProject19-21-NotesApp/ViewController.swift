//
//  ViewController.swift
//  MileStoneProject19-21-NotesApp
//
//  Created by dnlab on 2023/07/19.
//

import UIKit

class ViewController: UITableViewController {
    var allNotes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Your notes"
        //test
//        let testNote = Note(title: "Test", body: "Testing New Note")
//        allNotes.append(testNote)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNewNote))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(deleteNote))
        
        //load data
        let defaults = UserDefaults.standard
        
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                allNotes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("Failed to load data!")
            }
        }
        
    }
    
    @objc func addNewNote(){
        let ac = UIAlertController(title: "New Note", message: "Please give a title to your note", preferredStyle: .alert)
        ac.addTextField()
        let createNote = UIAlertAction(title: "Create", style: .default) {
            [weak self, weak ac] _ in
            guard let title = ac?.textFields?[0].text else { return }
            // create new instance of Note()
            let newNote = Note(title: title, body: "")
            self?.allNotes.append(newNote)
            self?.tableView.reloadData()
        }
        ac.addAction(createNote)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        save() 
    }
    
    @objc func deleteNote(){
        let ac = UIAlertController(title: "Delete Note", message: "Please input the note you want to delete(case sensitive)", preferredStyle: .alert)
        ac.addTextField()
        let deleteNote = UIAlertAction(title: "Delete", style: .default){
            [weak self, weak ac] _ in
            guard let inputTitle = ac?.textFields?[0].text else { return }
            //For-in loop requires '[Note]?' to conform to 'Sequence'; So, we need to safely unwrap it with optional binding
//            if let allNotes = self?.allNotes{
//                for note in allNotes{
//                    if note.title == inputTitle {
//                        print("Title: \(inputTitle) found!")
//
//                    } else {
//                        self?.error()
//                    }
//                }
//            }
            // (where: { $0.title == title }) is a closure used as an argument for the firstIndex() method. It's a concise way of expressing a condition that is used to find the index of an element in the array that satisfies the given condition. $0: refers to the current element in the array.
            if let index = self?.allNotes.firstIndex(where: {$0.title == inputTitle}) {
                self?.allNotes.remove(at: index)
                self?.tableView.reloadData()
                print("Note with title '\(inputTitle)' deleted!")
            } else {
                self?.error(errorMessage: "The note with a title \(inputTitle) not found")
            }
        }
        ac.addAction(deleteNote)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        save()
    }
    func error(errorMessage message: String){
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(errorAlert, animated: true)
    }
    
    // save data func
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(allNotes){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        } else {
            print("Failed to save data!")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let note = allNotes[indexPath.row]
        cell.textLabel?.text = note.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.detailNote = allNotes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

