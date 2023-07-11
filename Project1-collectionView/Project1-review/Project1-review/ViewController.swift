//
//  ViewController.swift
//  Project1-review
//
//  Created by dnlab on 2023/06/08.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()
//    var pictureName = ""
//    var pictureCount = 0
    var picturesDict = [String: Int]()
    let path = Bundle.main.resourcePath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm Viewer"
        
        let allItem = try! FileManager.default.contentsOfDirectory(atPath: path)
        
        for item in allItem {
            if item.hasPrefix("nss"){
                pictures.append(item)
                pictures.sort()
            }
        }
        
        let defaults = UserDefaults.standard

        if let savedImages = defaults.object(forKey: "picturesSelected") as? Data {
            if let decodedImages = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSDictionary.self, from: savedImages) as? [String: Int] {
                picturesDict = decodedImages
            }
        }
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let allImages = pictures[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image", for: indexPath) as? Image else {
            fatalError("Unable to dequeue Image")
        }
        
        cell.imageName.text = allImages
        cell.imageName.textColor = .white
        cell.imageView.image = UIImage(named: allImages)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageSelected = pictures[indexPath.item]
        if let imageVC = storyboard?.instantiateViewController(withIdentifier: "ImageView") as? ImageViewController {
            imageVC.selectedImage = imageSelected
//            pictureName = imageSelected
//            if picturesDict[pictureName] == nil {
//                pictureCount = 1
//                picturesDict[pictureName] = pictureCount
//            } else {
//                picturesDict[pictureName]! += 1
//            }
            // The solution to avoid force unwrapping is below. Close look to "if let count" part to create int var "count"
            if let count = picturesDict[imageSelected] {
                picturesDict[imageSelected] = count + 1
            } else {
                picturesDict[imageSelected] = 1
            }
            
            save()
            print(picturesDict)
            navigationController?.pushViewController(imageVC, animated: true)
        }
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: picturesDict, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "picturesSelected")
        }
    }
    
}
