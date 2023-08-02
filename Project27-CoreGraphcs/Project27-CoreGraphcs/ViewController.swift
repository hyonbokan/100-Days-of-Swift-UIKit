//
//  ViewController.swift
//  Project27-CoreGraphcs
//
//  Created by dnlab on 2023/07/31.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawEmoji()
//        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        print(currentDrawType)
        
        if currentDrawType > 6 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
            
        case 1:
            drawCircle()
            
        case 2:
            drawCheckerboard()
            
        case 3:
            drawRotatedSquares()
        
        case 4:
            drawLines()
        
        case 5:
            drawImagesAndText()
        
        case 6:
            drawEmoji()
            
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image {
            ctx in
            // drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10) //10 point border
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = image
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image {
            ctx in
            // drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5) //insetBy allows the circle to be round
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10) //10 point border
            
            // addEllipse - adds an elliptical (oval) path to the current graphics context.
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = image
    }
    
    func drawCheckerboard(){
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
            
            let image = renderer.image {
                ctx in
                ctx.cgContext.setFillColor(UIColor.black.cgColor)
                
                for row in 0..<8 {
                    for col in 0..<8 {
                        if (row + col) % 2 == 0 {
                            ctx.cgContext.fill(CGRect(x:col * 64, y: row * 64, width: 64, height: 64))
                        }
                    }
                }
            }
            
            imageView.image = image
        }
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image {
            ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
                
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image {
            ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
        }
        
        imageView.image = image
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image {
            ctx in
            let pargraphStyle = NSMutableParagraphStyle()
            pargraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: pargraphStyle
            ]
            
            let string = "The best-laid schemes o\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
            }
        imageView.image = image
        }
        
    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let emoji = renderer.image { ctx in
            // Draw the face
            let face = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(1)
            ctx.cgContext.addEllipse(in: face)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            
            let rightEye = CGRect(x: face.size.width - 150, y: face.size.height - 370, width: 25, height: 80)
            ctx.cgContext.setFillColor(UIColor.gray.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(1)
            ctx.cgContext.addEllipse(in: rightEye)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let leftEye = CGRect(x: face.size.width - 350, y: face.size.height - 370, width: 25, height: 80)
            ctx.cgContext.setFillColor(UIColor.gray.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(1)
            ctx.cgContext.addEllipse(in: leftEye)
            ctx.cgContext.drawPath(using: .fillStroke)
            // Instead of TWIN, I tried to draw lips
            let lipPath = UIBezierPath()
            //.move(to:) method is used to set the starting point of the path.
            lipPath.move(to: CGPoint(x: face.size.width - 250, y: face.size.height - 200))
            //.addCurve "to" parameter specifies the end point of the curve.
            lipPath.addCurve(to: CGPoint(x: face.size.width - 250, y: face.size.height - 150),
                             controlPoint1: CGPoint(x: face.size.width - 200, y: face.size.height - 170),
                             controlPoint2: CGPoint(x: face.size.width - 250, y: face.size.height - 150))
            lipPath.addCurve(to: CGPoint(x: face.size.width - 250, y: face.size.height - 100),
                             controlPoint1: CGPoint(x: face.size.width - 200, y: face.size.height - 120),
                             controlPoint2: CGPoint(x: face.size.width - 250, y: face.size.height - 100))
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            lipPath.fill()
        }
        
        imageView.image = emoji
    }
}

