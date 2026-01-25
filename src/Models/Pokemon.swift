//
//  Pokemon.swift
//  Pokedex
//
//  Created by Preston Hang on 1/7/26.
//

import SwiftUI

struct Pokemon: Codable, Hashable, Identifiable {
    let name: String
    let id: Int
    let types: [PokemonTypeEntry]
    let weight: Int
    let height: Int
    var heightInInches: Double {
        return (Double(height) * 0.1) * 39.3701
    }
    var weightInPounds: Double {
        return (Double(weight) * 0.1) * 2.20462
    }
    let sprites: PokemonSprits
    let stats: [PokemonStats]
}

struct PokemonTypeEntry: Codable, Hashable {
    let slot: Int
    let type: NamedAPIResource
}

struct PokemonSprits: Codable, Hashable {
    let frontDefault: String
}

struct PokemonStats: Codable, Hashable {
    let baseStat: Int
    let stat: NamedAPIResource
}

struct NamedAPIResource: Codable, Hashable {
    let name: String
    let url: String
}
