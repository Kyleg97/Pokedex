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

/*func fetchImage(pokemon: PokemonModel?) -> UIImage {
    let imageURL = URL(string: (pokemon?.sprites?.other?.officialArtwork?.frontDefault)!)
    print("IMAGE URL")
    print(imageURL)
    var image: UIImage?
    if let url = imageURL {
        //All network operations has to run on different thread(not on main thread).
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData = NSData(contentsOf: url)
            //All UI operations has to run on main thread.
            DispatchQueue.main.async {
                if imageData != nil {
                    image = UIImage(data: imageData! as Data)
                    // image.sizeToFit()
                    // self.pokemonImage.image = image
                    // self.pokemonImage.sizeToFit()
                } else {
                    image = nil
                }
            }
        }
    }
    return image!
}*/
