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
    
    @Published var pokemon: Pokemon?
    @Published var errorMessage: String? = nil
    private let pokemonAPIService = PokemonAPIService()
    var lastSearchedPokemon: String {
        if let pokemon {
            return pokemon.name
        } else {
            return ""
        }
    }
        
    init() {
        
    }
    
    func getPokemon(for pokemonToGet: String) async {
        guard !pokemonToGet.isEmpty else {
            errorMessage = "Search for a Pokemon by name!"
            return
        }
        
        do {
            pokemon = try await pokemonAPIService.sendGETRequest(for: pokemonToGet)
            errorMessage = nil
        } catch {
            errorMessage = "Failed to fetch data for \(pokemonToGet). \(error.localizedDescription)"
        }
    }
}
