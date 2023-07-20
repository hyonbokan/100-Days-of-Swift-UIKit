//
//  DetailedViewController.swift
//  Project1-3
//
//  Created by dnlab on 2023/06/13.
//

import UIKit

class DetailedViewController: UIViewController {
    var selectedFlag: String?
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var imageLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedFlag?.uppercased()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        
        // Adding button:
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
        
        

        
        
        if let imageToLoad = selectedFlag {
            imageView.image = UIImage(named: imageToLoad)
            // The text is not shown
            imageLabel.text = imageToLoad.uppercased()
            imageLabel.font.withSize(20)
            imageLabel.textColor = .darkText
        }
        
    }
    
    @objc func shareImage() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No img found")
            return
        }
        guard let imageText = imageLabel.text else {
            print("No text found")
            return
        }
        
        let avc = UIActivityViewController(activityItems: [image, imageText], applicationActivities: [])
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(avc, animated: true)
        
        // Add Privacy Info - Privacy - Photo Library
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
