import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let networking = Networking()
    var pokemon1: PokemonModel?
    var image1: UIImage?
    //var pokemon2: PokemonModel?
    //var image2: UIImage?
    var pokedexEntries: [Result]?
    
    @IBOutlet weak var pokedexTable: UITableView!
    
    override func viewDidLoad() {
        pokedexTable.delegate = self
        pokedexTable.dataSource = self
        pokedexTable.register(PokemonCell.self, forCellReuseIdentifier: "PokemonCell")
        /*print("pokemon")
        print(pokemon1)
        print("pokedex entries...")
        print(pokedexEntries)*/
        var pokemonName = "\(pokemon1!.name ?? "MissingNo.")"
        self.title = "\(pokemonName.firstCapitalized) vs ..."
        super.viewDidLoad()
        // print(image1)
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
        // print("section: \(indexPath.section)")
        // print("row: \(indexPath.row)")
        performSegue(withIdentifier: "ToVsSegue", sender: indexPath)
        /*Task {
            do {
                // activityIndicator.startAnimating()
                print("calling pokemonResult...")
                let pokemonResult = try await networking.fetchPokemon(name: pokemon2Name!)
                // self.activityIndicator.stopAnimating()
                await MainActor.run {
                    pokemon2 = pokemonResult
                    performSegue(withIdentifier: "ToVsSegue", sender: indexPath)
                    // image2 = fetchImage(pokemon: pokemon2)
                }
                // now we need to map value of this ^ list into the table somehow, check muni app
            }
        }*/
        // performSegue(withIdentifier: "ToPokemonSegue", sender: indexPath)
        // need to perform segue to whatever screen we come up with
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vsViewController = segue.destination as? VsViewController else {
            return
        }
        guard let indexPath = sender as? IndexPath else {
            return
        }
        // var image2 = fetchImage(pokemon: pokemon2)
        // pokemonViewController.pokemonName = pokedexEntries[indexPath.row].name!
        vsViewController.pokemon1 = pokemon1
        vsViewController.image1 = image1
        // print(pokemon1)
        // print(image1)
        // let pokemon2Name = pokedexEntries![indexPath.row].name
        vsViewController.pokemon2name = pokedexEntries![indexPath.row].name
    }
    
    /*private func fetchImage(pokemon: PokemonModel?) -> UIImage {
        let imageURL = URL(string: (pokemon?.sprites?.other?.officialArtwork?.frontDefault)!)
        var image: UIImage?
        if let url = imageURL {
            //All network operations has to run on different thread(not on main thread).
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = NSData(contentsOf: url)
                //All UI operations has to run on main thread.
                DispatchQueue.main.async {
                    if imageData != nil {
                        image = UIImage(data: imageData! as Data)
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


}
