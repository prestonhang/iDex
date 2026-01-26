//
//  AppCoordinator.swift
//  Pokedex
//
//  Created by Preston Hang on 1/19/26.
//

import UIKit
import SwiftUI


enum ViewRoute {
    case regionBrowser
    case gameBrowser
    case pokemonSearch
    case settings
}

final class ViewCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigate(to: .pokemonSearch)
    }
    
    func navigate(to route: ViewRoute) {
        switch route {
        case .pokemonSearch:
            // Create View
            let viewModel = PokemonSearcherViewModel()
            let swiftUIPokemonSearchView = PokemonSearcherView(viewModel: viewModel)
            
            // Wrap in UIHostingController
            let hostedViewController = UIHostingController(rootView: swiftUIPokemonSearchView)
            navigationController?.pushViewController(hostedViewController, animated: true)
        default:
            return
        }
    }
    
    
}
