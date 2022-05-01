//
//  Helpers.swift
//  pokedex
//
//  Created by JPL-ST-SPRING2021 on 4/30/22.
//

import Foundation

extension StringProtocol {
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
