//
//  ViewController.swift
//  pokedex
//
//  Created by JPL-ST-SPRING2021 on 4/29/22.
//

import UIKit

class PokemonCell: UITableViewCell {
    
}

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    let networking = Networking()
    
    var pokedexEntries: [Result] = []
    var filteredEntries: [Result] = []

    var searching = false
    var searchController : UISearchController!
    
    @IBOutlet weak var pokedexTable: UITableView!
    
    override func viewDidLoad() {
        pokedexTable.delegate = self
        pokedexTable.dataSource = self
        pokedexTable.register(PokemonCell.self, forCellReuseIdentifier: "PokemonCell")
        super.viewDidLoad()
        
        self.searchController = UISearchController(searchResultsController:  nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
        
        Task {
            do {
                let pokedexEntriesResult = try await networking.fetchPokedex()
                await MainActor.run {
                    pokedexEntries = pokedexEntriesResult.results ?? []
                    // print(pokedexEntriesResult)
                    pokedexTable.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching) {
            return filteredEntries.count
        } else {
            return pokedexEntries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell") as? PokemonCell else {
            return UITableViewCell()
        }
        if (searching) {
            let name = filteredEntries[indexPath.row].name?.firstCapitalized
            cell.textLabel?.text = name
        } else {
            let name = pokedexEntries[indexPath.row].name?.firstCapitalized
            cell.textLabel?.text = name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToPokemonSegue", sender: indexPath)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredEntries = pokedexEntries.filter { $0.name!.lowercased().prefix(searchText.count) == searchText.lowercased() }
        searching = true
        pokedexTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        pokedexTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pokemonViewController = segue.destination as? PokemonViewController else {
            return
        }
        guard let indexPath = sender as? IndexPath else {
            return
        }
        if (searching) {
            pokemonViewController.pokemonName = filteredEntries[indexPath.row].name!
            pokemonViewController.pokedexEntries = pokedexEntries
        } else {
            pokemonViewController.pokemonName = pokedexEntries[indexPath.row].name!
            pokemonViewController.pokedexEntries = pokedexEntries
        }
    }
}
