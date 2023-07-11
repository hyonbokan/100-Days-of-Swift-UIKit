//
//  Image.swift
//  MilestoneProject10_12
//
//  Created by dnlab on 2023/06/30.
//

import UIKit

class Image: NSObject, NSCoding {
    var name: String
    var url: URL
    
    init(name: String, url: URL){
        self.name = name
        self.url = url
    }
    
    required init?(coder decoder: NSCoder){
        name = decoder.decodeObject(forKey: "name") as? String ?? ""
        url = decoder.decodeObject(forKey: "image") as? URL ?? URL(fileReferenceLiteralResourceName: "")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(url, forKey: "url")
    }
}
