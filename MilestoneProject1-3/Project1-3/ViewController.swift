//
//  ViewController.swift
//  Project1-3
//
//  Created by dnlab on 2023/06/13.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        title = "Countries of the World"
        
        
    }
    
    
    // Determine the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    // Determine the name of cells in each row - Table View Cell identifier = flags
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flags", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].uppercased()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set DetailedVC storyboardID - Detail
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailedViewController{
            vc.selectedFlag = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    


}

