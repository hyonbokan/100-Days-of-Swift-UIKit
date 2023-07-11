//
//  ViewController.swift
//  Project7
//
//  Created by dnlab on 2023/06/18.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var allPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCredit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPetition))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadList))
        
        title = "Petition List"
        
        // Do any additional setup after loading the view.
//       let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        let urlString: String
        
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
//            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            if let url = URL(string: urlString) {
                // try? data cause the app be blocked while it tries to fetch data
                if let data = try? Data(contentsOf: url) {
                    // we are OK to parse
                    self?.parse(json: data)
                    return
                }
            }
            
            self?.showError()
        }
    }
    
    
    @objc func reloadList() {
        let ac = UIAlertController(title: "Refresh", message: "The list has been refreshed", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
        petitions = allPetitions
        tableView.reloadData()
        
    }
    
    
    @objc func searchPetition() {
        let ac = UIAlertController(title: "Search Petition", message: "Input the title of the petition", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] _ in
            guard let search = ac?.textFields?[0].text else { return }
            print(search)
            self?.submit(search)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    func submit(_ answer: String) {
        let lowercaseAnswer = answer.lowercased()
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            for petition in (self?.petitions)! {
                if petition.title.lowercased().contains(lowercaseAnswer) {
                    self?.filteredPetitions.append(petition)
                }
            }
            self?.petitions = (self?.filteredPetitions)!
        }
        
        DispatchQueue.main.async {
            [weak self] in
            self?.tableView.reloadData()
        }
        
    }
    
    
    func showError() {
        DispatchQueue.main.async {
            [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            allPetitions = jsonPetitions.results
            
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        print(petitions)
        let petition = petitions[indexPath.row]
//        print(petition)
        // cellForRowAt looks like an iteration
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

