//
//  PokemonViewController.swift
//  pokedex
//
//  Created by JPL-ST-SPRING2021 on 4/30/22.
//

import UIKit

class PokemonViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var entryNumLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    
    let networking = Networking()
    
    var pokemonName: String?
    var pokemon: PokemonModel?
    // var image: String?
    
    private func fetchImage() {
        let imageURL = URL(string: (pokemon?.sprites?.other?.officialArtwork?.frontDefault)!)
        var image: UIImage?
        if let url = imageURL {
            //All network operations has to run on different thread(not on main thread).
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = NSData(contentsOf: url)
                //All UI operations has to run on main thread.
                DispatchQueue.main.async {
                    if imageData != nil {
                        image = UIImage(data: imageData as! Data)
                        self.pokemonImage.image = image
                        self.pokemonImage.sizeToFit()
                    } else {
                        image = nil
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        // yeet
        print("hey there, we're in the correct view controller!")
        print("pokemon name: \(pokemonName)")
        nameLabel.text = pokemonName?.firstCapitalized
        Task {
            do {
                let pokemonResult = try await networking.fetchPokemon(name: pokemonName!)
                // print(type(of: pokedexEntries.results))
                print("hi")
                await MainActor.run {
                    pokemon = pokemonResult
                    print("hello")
                    print(pokemon)
                    fetchImage()
                    entryNumLabel.text = "#\(pokemon!.order!)"
                }
                // now we need to map value of this ^ list into the table somehow, check muni app
            }
        }
    }
}
