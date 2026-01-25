//
//  URLFactory.swift
//  Pokedex
//
//  Created by Preston Hang on 1/19/26.
//

import Foundation

final class URLFactory {
    static func makePokemonURL(for pokemonName: String) -> URL? {
        guard let url = URL(string: API.baseURL + API.pokemon + "/" + pokemonName.lowercased()) else { return nil }
        return url
    }
    
    static func makeVersionURL() -> URL? {
        guard let url = URL(string: API.baseURL + API.version) else { return nil }
        return url
    }
}
