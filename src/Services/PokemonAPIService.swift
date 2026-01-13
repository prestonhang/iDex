//
//  PokemonAPIService.swift
//  Pokedex
//
//  Created by Preston Hang on 1/11/26.
//

import Foundation

final class PokemonAPIService: APIService {
    func sendGETRequest(for pokemonName: String) async throws -> Pokemon {
        // Set up URL
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonName.lowercased())") else { throw URLError(.badURL)}
        
        // Send GET request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpURLResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200..<300).contains(httpURLResponse.statusCode) else {
            switch httpURLResponse.statusCode {
            case 300..<400:     throw APIError.redirection(httpURLResponse.statusCode)
            case 400..<500:     throw APIError.clientError(httpURLResponse.statusCode)
            case 500..<600:     throw APIError.serverError(httpURLResponse.statusCode)
            default:            throw APIError.generalError(httpURLResponse.statusCode)
            }
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedPokemon = try decoder.decode(Pokemon.self, from: data)
            return decodedPokemon
        } catch {
            print("Decoding failure. \(error)")
            throw APIError.decodingError
        }
    }
}
