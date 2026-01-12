//
//  PokemonSearcherViewModel.swift
//  iDex
//
//  Created by Preston Hang on 1/11/26.
//

import Foundation
import Combine
import SwiftUI

final class PokemonSearcherViewModel: ObservableObject {

    @Published var errorMessage: String? = nil
    @Published var last10PokemonSearched: [Pokemon] = []
    
    private let pokemonAPIService = PokemonAPIService()
    var lastSearchedPokemon: String {
        if !last10PokemonSearched.isEmpty {
            guard let pokemon = last10PokemonSearched.last else { return "" }
            return pokemon.name
        } else {
            return ""
        }
    }
        
    init() {
        
    }
    
    func getPokemon(for pokemonToGet: String) async {
        guard !pokemonToGet.isEmpty else {
            return
        }
        
        do {
            let retrievedPokemon = try await pokemonAPIService.sendGETRequest(for: pokemonToGet)
            
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
}
