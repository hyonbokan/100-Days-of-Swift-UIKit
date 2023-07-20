// The biggest challenge was creating json file and parsing it. The format of the file must be the same os in Country stuct. If the data is nested, separate files with class should be added.


import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Country Facts"
        if let jsonUrl = Bundle.main.url(forResource: "CountriesInfo", withExtension: "json") {
            if let allData = try? Data(contentsOf: jsonUrl) {
                print("Reading the url....")
                parse(json: allData)
            }
        }
        
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        print("Parsing JSON....")
        // To successfully parse the data it should be [Country].self
        if let jsonCountries = try? decoder.decode([Country].self, from: json){
            countries = jsonCountries
            print(countries)
            tableView.reloadData()
            print("Parsing finished....")
        }
    }
    
    // Make sure it is tableView - numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.country
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = DetailViewController()
//        vc.detailCountry = countries[indexPath.row]
//        navigationController?.pushViewController(vc, animated: true)
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "CountryDetail") as? DetailViewController else {
                return
            }
            detailVC.detailCountry = countries[indexPath.row]
            navigationController?.pushViewController(detailVC, animated: true)
        }

}

