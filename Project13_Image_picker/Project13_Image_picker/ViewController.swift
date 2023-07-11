//
//  ViewController.swift
//  Project13_Image_picker
//
//  Created by dnlab on 2023/07/02.
//
import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var radius: UISlider!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var imageView: UIImageView!
    var currentImage: UIImage!
    
    // 
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        // always ensure string does not contain typos
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        currentImage = image
        
        //By creating a CIImage object from the selected image, you can perform further image processing or apply Core Image filters to the image using the Core Image framework.
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        
        print("Finished Choosing filter")
        
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
            if let popoverController = ac.popoverPresentationController {
                
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        present(ac, animated: true)
        print("Change filter finished")
    }
    // The run-time error happens when changing the filter. Shows the list of filters, but once selected, it throws an error;
    // The error was in setValue; the line with setValue intensity was not removed.
    func setFilter(action: UIAlertAction){
        print("Set filter in process.........")
        guard currentImage != nil else { return
            noImageError()
        }
        print("Accessed to currentImage.........")
        guard let actionTitle = action.title else { return }
        title = actionTitle
        print("Accessed to action title:  \(actionTitle).........")
        currentFilter = CIFilter(name: actionTitle)
        // The initial setValue code was here.....
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
        print("Set filter finished")
    }
    func noImageError() {
        let ac = UIAlertController(title: "Error - No Image Found", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            print("no image")
            noImageError()
            return }
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }

    @IBAction func radiusChanged(_ sender: Any) {
        applyProcessing()
    }
    
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        print("Input keys: \(inputKeys)")
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        // since we added another slider, the setValue is modified as well
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey){
            currentFilter.setValue(radius.value * 10, forKey: kCIInputScaleKey)
        }

        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        print("Filter setValue set ## passed .......")
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            // Since imageView.image == nil is true, we can use this condition to check if there is any image currently present. If there is, apply fading effect.
            UIView.animate(withDuration: 1, delay: 0, animations: {
                if self.imageView.image != nil {
                    self.imageView.alpha = 0
                }
                // Finished must be used so the effect can actually be applied. Begin the animation with above condition. Once it's done do what's in the block below:
            }) { finished in
                self.imageView.alpha = 1
                self.imageView.image = processedImage
            }
            
//            imageView.image = processedImage
        }
        print("setFilter finished.......")
    }
    // previously error was due to the wrong contextInto. Make sure it is "UnsafeRawPointer" not just 'UnsafePointer'
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if let error = error {
            let ac = UIAlertController(title: "Save", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photo library", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        
    }
    
}

