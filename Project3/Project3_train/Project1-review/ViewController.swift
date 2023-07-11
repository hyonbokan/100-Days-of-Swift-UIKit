//
//  ViewController.swift
//  Project1-review
//
//  Created by dnlab on 2023/06/08.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
        
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = false
        // Do any additional setup after loading the view.
        let path = Bundle.main.resourcePath!
        let allItems = try! FileManager.default.contentsOfDirectory(atPath: path)

        
        for item in allItems{
            if item.hasPrefix("nss"){
                print(item)
                pictures.append(item)
                pictures.sort()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfPictures", for: indexPath)
        print("These are pictures[indexPath.row]: \(indexPath.row)" )
        cell.textLabel?.text = pictures[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let imageVC = storyboard?.instantiateViewController(withIdentifier: "ImageView") as? ImageViewController{
            imageVC.selectedImage = pictures[indexPath.row]
            imageVC.totalPictures = pictures.count
          //  imageVC.selectedPictureNum = pictures.firstIndex(of: imageVC.selectedImage!) ?? 0
            imageVC.selectedPictureNum = indexPath.row + 1
            navigationController?.pushViewController(imageVC, animated: true)
        }
    }
    
//    @objc func shareApp() {
//        guard
//    }
//
    
}
