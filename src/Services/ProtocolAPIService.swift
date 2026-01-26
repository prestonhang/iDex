//
//  APIServiceProtocol.swift
//  Pokedex
//
//  Created by Preston Hang on 1/11/26.
//

import Foundation

protocol APIService {
    func sendGETRequestForPokeAPI(for url: URL?) async throws -> Pokemon
    func sendGETRequestForCardAPI(for url: URL?) async throws -> Card
    
    
}
