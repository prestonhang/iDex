//
//  PokemonSearcherView.swift

import SwiftUI

struct PokemonSearcherView: View {
    
    @State var searchText: String = ""
    @StateObject var viewModel: PokemonSearcherViewModel
    
    var body: some View {
        NavigationStack {
            VStack{
                if let pokemon = viewModel.pokemon {
                    // Wrap result in NavigationLink
                    NavigationLink(value: pokemon) {
                        Text(pokemon.name)
                            .font(.headline)
                        Text("ID: \(pokemon.id)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                else if let error = viewModel.errorMessage { Text(error) }
                else { Text("Search for a Pokemon by name!") }
                Spacer()
            }
            .navigationTitle(Text("Search For Pokemon"))
            .navigationDestination(for: Pokemon.self) { PokemonDetails(pokemon: $0) }
            .padding()
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .task(id: searchText) {
            
            do {
                try await Task.sleep(for: .milliseconds(1000))
                
                await viewModel.getPokemon(for: searchText)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


#Preview {
    PokemonSearcherView(viewModel: PokemonSearcherViewModel())
}
