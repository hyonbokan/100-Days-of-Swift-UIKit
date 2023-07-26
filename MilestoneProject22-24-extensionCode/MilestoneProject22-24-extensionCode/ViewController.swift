//
//  ViewController.swift
//  MilestoneProject22-24-extensionCode
//
//  Created by dnlab on 2023/07/26.
//

import UIKit

extension UIView {
    func bounceOut(duration: TimeInterval, scaleX: CGFloat, scaleY: CGFloat) -> Void {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        })
    }
}
// 5.times { print("Hello world!") }
extension Int {
    func times(_ closure: () -> Void) {
        //Make sure it is a positive int
        guard self > 0 else { return }
        for _ in 1...self {
            closure()
        }
    }
}

// Challenge 3
extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let index = firstIndex(of: item){
            remove(at: index)
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet var baseBall: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(scaleDown))
        
        3.times{ print("Hello!")}
        
        var numbers = [1, 2, 3, 3, 4, 5]
        numbers.remove(item: 3)
        print(numbers) // Expected Output: [1, 2, 4, 3, 5]

    }
    
    @objc func scaleDown() {
        baseBall.bounceOut(duration: 2, scaleX: 0.0001, scaleY: 0.0001)
    }

}
