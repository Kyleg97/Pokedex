import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let networking = Networking()
    var pokemon1: PokemonModel?
    var pokedexEntries: [Result]?
    
    @IBOutlet weak var pokedexTable: UITableView!
    
    override func viewDidLoad() {
        pokedexTable.delegate = self
        pokedexTable.dataSource = self
        pokedexTable.register(PokemonCell.self, forCellReuseIdentifier: "PokemonCell")
        print("pokemon")
        print(pokemon1)
        print("pokedex entries...")
        print(pokedexEntries)
        var pokemonName = "\(pokemon1!.name ?? "MissingNo.")"
        self.title = "\(pokemonName.firstCapitalized) vs ..."
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokedexEntries!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell") as? PokemonCell else {
            return UITableViewCell()
        }
        let name = pokedexEntries![indexPath.row].name?.firstCapitalized
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        // performSegue(withIdentifier: "ToPokemonSegue", sender: indexPath)
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pokemonViewController = segue.destination as? PokemonViewController else {
            return
        }
        guard let indexPath = sender as? IndexPath else {
            return
        }
        pokemonViewController.pokemonName = pokedexEntries[indexPath.row].name!
    }*/


}
