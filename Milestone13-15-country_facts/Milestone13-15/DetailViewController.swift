//
//  DetailViewController.swift
//  Milestone13-15
//
//  Created by dnlab on 2023/07/06.
//

import UIKit

class DetailViewController: UITableViewController {
    var detailCountry: Country?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let detailCountry = detailCountry else { return }
        title = detailCountry.country
        print(detailCountry)
        // Register the cell class or nib with the table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "details")
    }
    
     
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath)
        //have the text fit the cell
        cell.textLabel?.numberOfLines = 0
        guard let detailCountry = detailCountry else { return cell}
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Country: \(detailCountry.country)"
        case 1:
            cell.textLabel?.text = "Capital: \(detailCountry.capital)"
        case 2:
            cell.textLabel?.text = "Size: \(detailCountry.size)"
        case 3:
            cell.textLabel?.text = "Population: \(detailCountry.population)"
        case 4:
            cell.textLabel?.text = "Official Language: \(detailCountry.officialLanguage)"
        case 5:
            cell.textLabel?.text = "Government: \(detailCountry.government)"
        default:
            cell.textLabel?.text = ""
        }
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
