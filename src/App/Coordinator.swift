//
//  Coordinator.swift
//  Pokedex
//
//  Created by Preston Hang on 1/19/26.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    func start()
}
