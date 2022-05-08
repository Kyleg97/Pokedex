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
    
    @IBOutlet weak var type1: UILabel!
    @IBOutlet weak var type2: UILabel!
    
    @IBOutlet weak var hpLabel1: UILabel!
    @IBOutlet weak var atkLabel1: UILabel!
    @IBOutlet weak var sAtkLabel1: UILabel!
    @IBOutlet weak var defLabel1: UILabel!
    @IBOutlet weak var sDefLabel1: UILabel!
    @IBOutlet weak var speedLabel1: UILabel!
    
    @IBOutlet weak var hpLabel2: UILabel!
    @IBOutlet weak var atkLabel2: UILabel!
    @IBOutlet weak var sAtkLabel2: UILabel!
    @IBOutlet weak var defLabel2: UILabel!
    @IBOutlet weak var sDefLabel2: UILabel!
    @IBOutlet weak var speedLabel2: UILabel!
    
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
                        // self.pokemonImage1.sizeToFit()
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
                       // self.pokemonImage2.sizeToFit()
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
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
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
                    
                    let mon1 = PokemonStats(
                        hp: pokemon1!.stats![0].baseStat!,
                        atk: pokemon1!.stats![1].baseStat!,
                        sAtk: pokemon1!.stats![3].baseStat!,
                        def: pokemon1!.stats![2].baseStat!,
                        sDef: pokemon1!.stats![4].baseStat!,
                        spd: pokemon1!.stats![5].baseStat!,
                        type1: pokemon1!.types![0].type!.name!.firstCapitalized,
                        type2: (pokemon1!.types!.count > 1) ? pokemon1!.types![1].type!.name?.firstCapitalized : nil
                    )
                    
                    let mon2 = PokemonStats(
                        hp: pokemon2!.stats![0].baseStat!,
                        atk: pokemon2!.stats![1].baseStat!,
                        sAtk: pokemon2!.stats![3].baseStat!,
                        def: pokemon2!.stats![2].baseStat!,
                        sDef: pokemon2!.stats![4].baseStat!,
                        spd: pokemon2!.stats![5].baseStat!,
                        type1: pokemon2!.types![0].type!.name!.firstCapitalized,
                        type2: (pokemon2!.types!.count > 1) ? pokemon2!.types![1].type!.name?.firstCapitalized : nil
                    )
                    
                    if (mon1.type2 != nil) {
                        type1.text = "\(mon1.type1) / \n\(mon1.type2 ?? "")"
                    } else {
                        type1.text = "\(mon1.type1)"
                    }
                    
                    if (mon2.type2 != nil) {
                        type2.text = "\(mon2.type1) / \n\(mon2.type2 ?? "")"
                    } else {
                        type2.text = "\(mon2.type1)"
                    }
                    
                    hpLabel1.text = "\(mon1.hp)"
                    atkLabel1.text = "\(mon1.atk)"
                    sAtkLabel1.text = "\(mon1.sAtk)"
                    defLabel1.text = "\(mon1.def)"
                    sDefLabel1.text = "\(mon1.sDef)"
                    speedLabel1.text = "\(mon1.spd)"
                    
                    hpLabel1.textColor = (mon1.hp < mon2.hp) ? UIColor.red : UIColor.green
                    atkLabel1.textColor = (mon1.atk < mon2.atk) ? UIColor.red : UIColor.green
                    sAtkLabel1.textColor = (mon1.sAtk < mon2.sAtk) ? UIColor.red : UIColor.green
                    defLabel1.textColor = (mon1.def < mon2.def) ? UIColor.red : UIColor.green
                    sDefLabel1.textColor = (mon1.sDef < mon2.sDef) ? UIColor.red : UIColor.green
                    speedLabel1.textColor = (mon1.spd < mon2.spd) ? UIColor.red : UIColor.green
                    
                    hpLabel2.text = "\(mon2.hp)"
                    atkLabel2.text = "\(mon2.atk)"
                    sAtkLabel2.text = "\(mon2.sAtk)"
                    defLabel2.text = "\(mon2.def)"
                    sDefLabel2.text = "\(mon2.sDef)"
                    speedLabel2.text = "\(mon2.spd)"
                    
                    hpLabel2.textColor = (mon1.hp > mon2.hp) ? UIColor.red : UIColor.green
                    atkLabel2.textColor = (mon1.atk > mon2.atk) ? UIColor.red : UIColor.green
                    sAtkLabel2.textColor = (mon1.sAtk > mon2.sAtk) ? UIColor.red : UIColor.green
                    defLabel2.textColor = (mon1.def > mon2.def) ? UIColor.red : UIColor.green
                    sDefLabel2.textColor = (mon1.sDef > mon2.sDef) ? UIColor.red : UIColor.green
                    speedLabel2.textColor = (mon1.spd > mon2.spd) ? UIColor.red : UIColor.green
                }
            }
        }
    }
}

struct PokemonStats {
    let hp, atk, sAtk, def, sDef, spd: Int
    let type1: String
    let type2: String?
    
    init(hp: Int, atk: Int, sAtk: Int, def: Int, sDef: Int, spd: Int, type1: String, type2: String?) {
        self.hp = hp
        self.atk = atk
        self.sAtk = sAtk
        self.def = def
        self.sDef = sDef
        self.spd = spd
        self.type1 = type1
        self.type2 = type2
    }
    
}
