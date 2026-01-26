//
//  PokemonAPIService.swift
//  Pokedex
//
//  Created by Preston Hang on 1/11/26.
//

import Foundation

final class PokemonAPIService: APIService {
    #warning("TODO - Implement CardAPI")
    func sendGETRequestForCardAPI(for url: URL?) async throws -> Card {
        return Card(name: "")
    }
    
    func sendGETRequestForPokeAPI(for url: URL?) async throws -> Pokemon {
        let data = try await sendGETRequest(for: url)
        
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
    
    private func sendGETRequest(for url: URL?) async throws -> Data {
        guard let validURL = url else { throw URLError(.badURL)}
        let (data, response) = try await URLSession.shared.data(from: validURL)
        try validateHTTPResponse(response: response)
        
        return data
    }
    
    private func validateHTTPResponse(response: URLResponse?) throws {
        guard let validResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch validResponse.statusCode {
        case 200..<300:     return
        case 300..<400:     throw APIError.redirection(validResponse.statusCode)
        case 400..<500:     throw APIError.clientError(validResponse.statusCode)
        case 500..<600:     throw APIError.serverError(validResponse.statusCode)
        default:            throw APIError.generalError(validResponse.statusCode)
        }
    }
}
