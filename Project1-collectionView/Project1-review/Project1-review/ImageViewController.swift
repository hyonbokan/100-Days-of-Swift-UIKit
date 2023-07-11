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
        title = "Picture \(selectedImage ?? "you have selected")"
        navigationController?.navigationItem.largeTitleDisplayMode = .never
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
