//
//  PokemonSearcherViewModel.swift
//  Pokedex
//
//  Created by Preston Hang on 1/11/26.
//

import Foundation
import Combine
import SwiftUI

final class PokemonSearcherViewModel: ObservableObject {

    @Published var errorMessage: String? = nil
    @Published var last10PokemonSearched: [Pokemon] = []
    private let searchHistoryKey: String = "last10PokemonSearched"
    private let pokemonAPIService = PokemonAPIService()
        
    init() {
        
    }
    
    func getPokemon(for pokemonToGet: String) async {
        guard !pokemonToGet.isEmpty else {
            return
        }
        
        do {
            let pokemonUrl = URLFactory.makePokemonURL(for: pokemonToGet)
            let retrievedPokemon = try await pokemonAPIService.sendGETRequestForPokeAPI(for: pokemonUrl)
            
            if last10PokemonSearched.count >= 10 {
                last10PokemonSearched.removeFirst()
            }
            last10PokemonSearched.append(retrievedPokemon)
            errorMessage = nil
        } catch {
            errorMessage = "Failed to fetch data for \(pokemonToGet). \(error.localizedDescription)"
        }
    }
    
    func deletePokemon(at offsets: IndexSet) {
        last10PokemonSearched.remove(atOffsets: offsets)
    }

    func saveSearchHistory() {
        let pokemonNames = last10PokemonSearched.map(\.name)
        UserDefaults.standard.set(pokemonNames, forKey: searchHistoryKey)
    }
    
//    func loadAndFetchPokemonFromSearchHistory() async {
//        guard let savedNames = UserDefaults.standard.stringArray(forKey: searchHistoryKey) else { return }
//        
//        await withTaskGroup(of: Pokemon?.self) { group in
//            for name in savedNames {
//                group.addTask {
//                    return try? await getPokemon(for: name)
//                }
//            }
//            
//            for await pokemon in group {
//                if let pokemon = pokemon {
//                    DispatchQueue.main.async {
//                        last10PokemonSearched.append(pokemon)
//                    }
//                }
//            }
//        }
//    }
}
