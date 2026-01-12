//
//  APIError.swift
//  iDex
//
//  Created by Preston Hang on 1/11/26.
//

enum APIError: Error {
    case decodingError
    case redirection(_: Int)
    case clientError(_: Int)
    case serverError(_: Int)
    case generalError(_: Int)
}
