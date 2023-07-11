//
//  ViewController.swift
//  MilestoneProject10_12
//
//  Created by dnlab on 2023/06/30.
// The biggest challenge was to show the selected image in the DetailViewController. The problem was resolved by adding URL to the Image class.

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var images = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        
        title = "Your favorite images"
//        let image = Image(name: "test image name", image: "test image file")
//        images.append(image)
        let defaults = UserDefaults.standard
        if let savedImages = defaults.object(forKey: "savedImages") as? Data{
            if let decodedImages = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [Image.self], from: savedImages) as? [Image] {
                images = decodedImages
            }
        }

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imagesRow = images[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageList", for: indexPath)
        cell.textLabel?.text = imagesRow.name
        
        return cell
    }
    
    @objc func addImage(){
        let picker = UIImagePickerController()
//        picker.allowsEditing = true
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                   if let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
//                       picker.mediaTypes = availableMediaTypes
//                       picker.sourceType = .camera
//                   }
//        } else {
//                   picker.sourceType = .photoLibrary
//               }
//
//               picker.delegate = self
//               present(picker, animated: true)
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDir().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let newImage = Image(name: "", url: imagePath)
        save()
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Name the image", message: "Please provide name for your image", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            newImage.name = newName
//            newImage.image = imageName
            self?.images.append(newImage)
            self?.save()
            self?.tableView.reloadData()
        })
        present(ac, animated: true)
        print("VC screen: \(newImage.name)")
        print("VC screen: \(newImage.url)")
        
    }
    
    func getDocumentsDir() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dvc = storyboard?.instantiateViewController(identifier: "ImageView") as? DetailViewController {
            dvc.selectedImageURL = images[indexPath.row].url
            dvc.selectedImageName = images[indexPath.row].name
            navigationController?.pushViewController(dvc, animated: true)
        }
    }
    
    func save(){
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: images, requiringSecureCoding: false){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "savedImages")
        }
    }
}

