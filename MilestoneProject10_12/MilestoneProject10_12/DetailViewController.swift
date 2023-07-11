//
//  DetailViewController.swift
//  MilestoneProject10_12
//
//  Created by dnlab on 2023/06/30.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var selectedImageURL: URL?
    var selectedImageName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(contentsOfFile: selectedImageURL?.path ?? "")
        
    }
    
}
