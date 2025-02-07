//
//  WordState.swift
//  WordScapeGameTest
//
//  Created by Michael Kan on 2/6/25.
//

import Foundation

/// The possible states for a moving word.
public enum WordState {
    case set      // Word is stacked on the left, not yet moving
    case moving   // Word is currently moving horizontally
    case finished // Word reached the right edge
    case captured // Word was tapped by the user
}
