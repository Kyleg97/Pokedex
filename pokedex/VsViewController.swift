//
//  VsViewController.swift
//  pokedex
//
//  Created by JPL-ST-SPRING2021 on 5/5/22.
//

import UIKit

class VsViewController: UIViewController {
    
    let networking = Networking()
    
    var pokemon1: PokemonModel?
    var pokemon2name: String?
    var pokemon2: PokemonModel?
    var image1: UIImage?
    var image2: UIImage?
    
    
    @IBOutlet weak var pokemonImage1: UIImageView!
    
    @IBOutlet weak var pokemonImage2: UIImageView!
    
   private func fetchImage() {
        let imageURL = URL(string: (pokemon1?.sprites?.other?.officialArtwork?.frontDefault)!)
        var image: UIImage?
        if let url = imageURL {
            //All network operations has to run on different thread(not on main thread).
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = NSData(contentsOf: url)
                //All UI operations has to run on main thread.
                DispatchQueue.main.async {
                    if imageData != nil {
                        image = UIImage(data: imageData! as Data)
                        self.pokemonImage1.image = image
                        self.pokemonImage1.sizeToFit()
                        //self.pokemonImage1.image = self.image1
                        //self.pokemonImage1.sizeToFit()
                    } else {
                        image = nil
                    }
                }
            }
        }
       let imageURL2 = URL(string: (pokemon2?.sprites?.other?.officialArtwork?.frontDefault)!)
       var image2: UIImage?
       if let url = imageURL2 {
           //All network operations has to run on different thread(not on main thread).
           DispatchQueue.global(qos: .userInitiated).async {
               let imageData = NSData(contentsOf: url)
               //All UI operations has to run on main thread.
               DispatchQueue.main.async {
                   if imageData != nil {
                       image2 = UIImage(data: imageData! as Data)
                       self.pokemonImage2.image = image2
                       self.pokemonImage2.sizeToFit()
                       //self.pokemonImage1.image = self.image1
                       //self.pokemonImage1.sizeToFit()
                   } else {
                       image2 = nil
                   }
               }
           }
       }
    }
    
    override func viewDidLoad() {
        self.title = "\(pokemon1!.name!.firstCapitalized) vs \(pokemon2name!.firstCapitalized)"
        self.pokemonImage1.image = image1
        super.viewDidLoad()
        // print(image1)
        Task {
            do {
                let pokemonResult = try await networking.fetchPokemon(name: pokemon2name!)
                await MainActor.run {
                    pokemon2 = pokemonResult
                    fetchImage()
                }
            }
        }
    }
}
