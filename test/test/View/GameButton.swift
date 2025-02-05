//
//  GameButton.swift
//  test
//
//  Created by Michael Kan on 2/5/25.
//

import UIKit

final class GameButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
