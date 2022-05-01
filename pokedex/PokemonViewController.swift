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
    @IBOutlet weak var typeLabel: UILabel!
    
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var specialAttackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var specialDefenseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
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
                print("calling pokemonResult...")
                let pokemonResult = try await networking.fetchPokemon(name: pokemonName!)
                // print(type(of: pokedexEntries.results))
                print("printing the result after fetch...")
                print(pokemonResult)
                print("hi")
                await MainActor.run {
                    pokemon = pokemonResult
                    print("hello")
                    print(pokemon)
                    fetchImage()
                    entryNumLabel.text = "#\(pokemon!.order!)"
                    
                    heightLabel.text = "Height: \(decimetersToInches(height: pokemon!.height!)) inches"
                    weightLabel.text = "Weight: \(hectogramsToLbs(weight: pokemon!.weight!)) lbs"
                    
                    hpLabel.text = "HP: \(pokemon!.stats![0].baseStat!)"
                    attackLabel.text = "ATK: \(pokemon!.stats![1].baseStat!)"
                    defenseLabel.text = "DEF: \(pokemon!.stats![2].baseStat!)"
                    specialAttackLabel.text = "S.ATK: \(pokemon!.stats![3].baseStat!)"
                    specialDefenseLabel.text = "S.DEF: \(pokemon!.stats![4].baseStat!)"
                    speedLabel.text = "SPD: \(pokemon!.stats![5].baseStat!)"
                    var typeString = ""
                    let types = pokemon?.types!
                    for i in 0...types!.count-1 {
                        typeString += (types![i].type?.name?.firstCapitalized)!
                        if (i == 0) {
                            typeString += " / "
                        }
                    }
                    typeLabel.text = typeString
                }
                // now we need to map value of this ^ list into the table somehow, check muni app
            }
        }
    }
}
