//
//  Note.swift
//  MileStoneProject19-21-NotesApp
//
//  Created by dnlab on 2023/07/19.
//

import UIKit
// Note NSObject is done applying second method of decoding.
// The first method requires to use NSCoder
class Note: NSObject, Codable {
    var title: String
    var body: String
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}
