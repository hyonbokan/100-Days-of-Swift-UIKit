//
//  ViewController.swift
//  MilestoneProject25-27
//
//  Created by dnlab on 2023/08/02.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var imageView: UIImageView!
    
    var memes = [Meme]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        
    }
    
 
    
    @objc func addImage(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction func topTextTapped(_ sender: Any) {
        
    }
    @IBAction func bottomTextTapped(_ sender: Any) {
        
    }
    
}

