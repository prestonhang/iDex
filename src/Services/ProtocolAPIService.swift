//
//  APIServiceProtocol.swift
//  Pokedex
//
//  Created by Preston Hang on 1/11/26.
//

protocol APIService {
    func sendGETRequest(for pokemonName: String) async throws -> Pokemon
}
