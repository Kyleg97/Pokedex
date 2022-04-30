//
//  ViewController.swift
//  pokedex
//
//  Created by JPL-ST-SPRING2021 on 4/29/22.
//

import UIKit

class ViewController: UIViewController {
    
    let networking = Networking()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("hi")
        Task {
            do {
                let pokedexEntries = try await networking.fetchPokedex()
                print(pokedexEntries)
            }
        }
        // Do any additional setup after loading the view.
    }


}

