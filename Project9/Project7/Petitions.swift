//
//  Petitions.swift
//  Project7
//
//  Created by dnlab on 2023/06/19.
//

import Foundation

// Since we need the data inside the results, create "results" var that contains array of the values we need.

struct Petitions: Codable {
    var results: [Petition]
}
