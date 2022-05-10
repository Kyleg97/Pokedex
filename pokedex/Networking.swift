//
//  Networking.swift
//  pokedex
//
//  Created by JPL-ST-SPRING2021 on 4/29/22.
//

import Foundation

struct Networking {
    let baseURL = "https://pokeapi.co/api/v2/pokemon"

    func fetchPokedex() async throws -> PokedexModel {
        let url = URL(string: "\(baseURL)?limit=151")!
        print("fetching pokedex..........")
        let (data,_) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(PokedexModel.self, from: data)
    }

    func fetchPokemon(name: String) async throws -> PokemonModel {
        let url = URL(string: "\(baseURL)/\(name)")!
        let (data,_) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(PokemonModel.self, from: data)
    }
    
    func fetchFlavor(number: Int) async throws -> FlavorModel {
        let url = URL(string: "\(baseURL)-species/\(number)")!
        let (data,_) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(FlavorModel.self, from: data)
    }
}
