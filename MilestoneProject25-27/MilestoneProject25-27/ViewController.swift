//
//  ViewController.swift
//  MilestoneProject25-27
//
//  Created by dnlab on 2023/08/02.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet var imageView: UIImageView!
    
    var currentImage: UIImage!
    var topText = ""
    var bottomText = ""
    
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImg))
    }
    
    @objc func shareImg(){
        guard let imageName = imageView.image else {
            print("No image name found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [imageName], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(vc, animated: true)
        
        
    }
    
    @objc func addImage(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        imageView.image = image
    }
    
    @IBAction func topTextTapped(_ sender: Any) {
        guard let image = imageView.image else { return }
        let acTop = UIAlertController(title: "Input for the top text", message: nil, preferredStyle: .alert)
        acTop.addTextField()
        let submitTop = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak acTop] _ in
            guard let text = acTop?.textFields?[0].text else { return }
            print("textField text is \(text)")
            self?.topText = text
            self?.drawText(loadedImage: image, topText: text, bottomText: self?.bottomText ?? "")
            self?.currentImage = image
        }
        acTop.addAction(submitTop)
        acTop.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(acTop, animated: true)

    }
    @IBAction func bottomTextTapped(_ sender: Any) {
        guard let image = currentImage else { return }
        // Overriding
        let acBottom = UIAlertController(title: "Input for the bottom text", message: nil, preferredStyle: .alert)
        acBottom.addTextField()
        let submitBottom = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak acBottom] _ in
            guard let text = acBottom?.textFields?[0].text else { return }
            self?.bottomText = text
            self?.drawText(loadedImage: image, topText: self?.topText ?? "", bottomText: text)
            self?.currentImage = image
        }
        acBottom.addAction(submitBottom)
        acBottom.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(acBottom, animated: true)
        
    }

    
    func drawText(loadedImage: UIImage, topText: String, bottomText: String) {
        
        let width = loadedImage.size.width
        let height = loadedImage.size.height
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let canvas = renderer.image {
            ctx in
            let newImage = loadedImage
            newImage.draw(at: CGPoint(x: 0, y: 0))
            
            let pargraphStyle = NSMutableParagraphStyle()
            pargraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 100),
                .paragraphStyle: pargraphStyle,
                .foregroundColor: UIColor.white
            ]
            let stringTop = topText
            let attributedString1 = NSAttributedString(string: stringTop, attributes: attrs)
            attributedString1.draw(with: CGRect(x: 0, y: 0, width: width, height: height), options: .usesLineFragmentOrigin, context: nil)
            
            let stringBottom = bottomText
            let attributedString2 = NSAttributedString(string: stringBottom, attributes: attrs)
            attributedString2.draw(with: CGRect(x: 0, y: 600, width: width, height: height), options: .usesLineFragmentOrigin, context: nil)
        }
        
        imageView.image = canvas
    }
    
}
