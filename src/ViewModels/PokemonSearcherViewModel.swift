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
    
    func returnPokemon(for pokemonToGet: String) async -> Pokemon? {
        guard !pokemonToGet.isEmpty else {
            return nil
        }
        
        do {
            let pokemonUrl = URLFactory.makePokemonURL(for: pokemonToGet)
            let retrievedPokemon = try await pokemonAPIService.sendGETRequestForPokeAPI(for: pokemonUrl)
            errorMessage = nil
            return retrievedPokemon
        } catch {
            errorMessage = "Failed to fetch data for \(pokemonToGet). \(error.localizedDescription)"
            return nil
        }
    }
    
    func getPokemon(for pokemonToGet: String) async {
        guard !pokemonToGet.isEmpty else {
            return
        }
        
        if alreadySearched(pokemonToGet) {
            return
        }
        
        do {
            let pokemonUrl = URLFactory.makePokemonURL(for: pokemonToGet)
            let retrievedPokemon = try await pokemonAPIService.sendGETRequestForPokeAPI(for: pokemonUrl)
            
            if last10PokemonSearched.count >= 10 {
                last10PokemonSearched.removeFirst()
            }
            last10PokemonSearched.append(retrievedPokemon)
            saveSearchHistory()
            errorMessage = nil
        } catch {
            errorMessage = "Failed to fetch data for \(pokemonToGet). \(error.localizedDescription)"
        }
    }
    
    func deletePokemon(at offsets: IndexSet) {
        last10PokemonSearched.remove(atOffsets: offsets)
    }
    
    @MainActor
    func saveSearchHistory() {
        let pokemonNames = last10PokemonSearched.map(\.name)
        UserDefaults.standard.set(pokemonNames, forKey: searchHistoryKey)
    }
    
    func loadAndFetchPokemonFromSearchHistory() async {
        guard let savedNames = UserDefaults.standard.stringArray(forKey: searchHistoryKey) else { return }
        
        await withTaskGroup(of: Pokemon?.self) { group in
            for name in savedNames {
                group.addTask {
                    return await self.returnPokemon(for: name)
                }
            }
            
            for await pokemon in group {
                if let pokemon = pokemon {
                    last10PokemonSearched.append(pokemon)
                }
            }
        }
    }
    
    func alreadySearched(_ pokemonToGet: String) -> Bool {
        let searchedContainingSameName = last10PokemonSearched.firstIndex{ $0.name.caseInsensitiveCompare(pokemonToGet) == .orderedSame}
        guard searchedContainingSameName == nil else {
            guard let index = searchedContainingSameName else { return true }
            let justSearchedPokemon = last10PokemonSearched.remove(at: index)
            last10PokemonSearched.append(justSearchedPokemon)
            return true
        }
        return false
    }
}
