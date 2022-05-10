//
//  Helpers.swift
//  pokedex
//
//  Created by JPL-ST-SPRING2021 on 4/30/22.
//

import Foundation
import UIKit

extension StringProtocol {
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}

func hectogramsToLbs(weight: Int) -> Int {
    return weight / Int(4.536)
}

func decimetersToInches(height: Int) -> Int {
    return height * Int(3.937)
}

func hasAdvantage(type1: [TypeElement], type2: [TypeElement]) -> Double {
    var multiplier = 1.0
    for i in 0...type1.count-1 {
        for j in 0...type2.count-1 {
            let t1 = type1[i].type!.name!
            let t2 = type2[j].type!.name!
            let mult = typeMatchups[t1]![t2]!
            // avoid 0 mult if pokemon has 2 types
            if (mult == 0 && type1.count == 2) {
                multiplier *= 1
            } else {
                multiplier *= mult
            }
        }
    }
    return multiplier
}
