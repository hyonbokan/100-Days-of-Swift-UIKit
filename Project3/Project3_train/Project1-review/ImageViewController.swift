//
//  ImageViewController.swift
//  Project1-review
//
//  Created by dnlab on 2023/06/08.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var selectedPictureNum = 0
    var totalPictures = 0
    var selectedImage: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Picture \(selectedPictureNum + 1) of \(totalPictures)"
//        title = selectedImage
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        // challenge share the name of the image
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImgName))
        
        
//        if let imageToLoad = selectedImage { ... }:
//
//        This line checks if the selectedImage variable has a non-nil value using optional binding (if let statement).
//        If selectedImage is not nil, the code inside the block is executed.
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        guard let imageName = selectedImage else {
            print("No image name found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
//    @objc func shareImgName() {
//        guard let imageName = selectedImage else {
//            print("No image name found")
//            return
//        }
//        let img = UIActivityViewController(activityItems: [imageName], applicationActivities: [])
//        img.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
//        present(img, animated: true)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
