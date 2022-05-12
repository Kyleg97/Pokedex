//
//  PokemonViewController.swift
//  pokedex
//
//  Created by Kyle Gilbert on 4/30/22.
//

import UIKit

class PokemonViewController: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var entryNumLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var flavorLabel: UILabel!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var specialAttackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var specialDefenseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var pokemonImage: UIImageView!
    
    @IBOutlet weak var compareButton: UIButton!
    
    let networking = Networking()
    
    var pokemonName: String?
    var pokemon: PokemonModel?
    var pokedexEntries: [Result] = []
    var image: UIImage?
    
    var flavorText: String?
    
    private func fetchImage() {
        let imageURL = URL(string: (pokemon?.sprites?.other?.officialArtwork?.frontDefault)!)
        var image: UIImage?
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = NSData(contentsOf: url)
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
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.tag = 100
        view.addSubview(blurEffectView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.color = UIColor.red
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        nameLabel.text = pokemonName?.firstCapitalized
        Task {
            do {
                activityIndicator.startAnimating()
                let pokemonResult = try await networking.fetchPokemon(name: pokemonName!)
                let flavorResult = try await networking.fetchFlavor(number: pokemonResult.id!)
                self.activityIndicator.stopAnimating()
                self.view.viewWithTag(100)?.removeFromSuperview()
                await MainActor.run {
                    pokemon = pokemonResult
                    fetchImage()
                    entryNumLabel.text = "#\(pokemon!.id!)"
                    
                    var flavorText = ""
                    for text in flavorResult.flavorTextEntries! {
                        if (text.language?.name == "en") {
                            flavorText = text.flavorText!
                            break
                        }
                    }
                    flavorLabel.text = "\(removeLineBreaks(str: flavorText))"
                    
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
                        if (i == 0 && types!.count > 1) {
                            typeString += " / "
                        }
                    }
                    typeLabel.text = typeString
                }
            }
        }
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        performSegue(withIdentifier: "ReturnPokedexSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pokedexViewController = segue.destination as? PokedexViewController else {
            return
        }
        pokedexViewController.pokemon1 = pokemon
        pokedexViewController.pokedexEntries = pokedexEntries
        pokedexViewController.image1 = image
        pokedexViewController.compare = true
    }
}
