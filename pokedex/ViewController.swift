//
//  ViewController.swift
//  pokedex
//
//  Created by JPL-ST-SPRING2021 on 4/29/22.
//

import UIKit

class PokemonCell: UITableViewCell {
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let networking = Networking()
    
    var pokedexEntries: [Result] = []
    
    @IBOutlet weak var pokedexTable: UITableView!
    
    override func viewDidLoad() {
        pokedexTable.delegate = self
        pokedexTable.dataSource = self
        pokedexTable.register(PokemonCell.self, forCellReuseIdentifier: "PokemonCell")
        super.viewDidLoad()
        Task {
            do {
                let pokedexEntriesResult = try await networking.fetchPokedex()
                // print(type(of: pokedexEntries.results))
                await MainActor.run {
                    pokedexEntries = pokedexEntriesResult.results ?? []
                    pokedexTable.reloadData()
                    if (pokedexEntries.count == 0) {
                        navigationItem.title = "Network error"
                    }
                }
                // now we need to map value of this ^ list into the table somehow, check muni app
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokedexEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell") as? PokemonCell else {
            return UITableViewCell()
        }
        let name = pokedexEntries[indexPath.row].name
        cell.textLabel?.text = name
        return cell

    }


}

