//
//  PokemonSearcherView.swift

import SwiftUI

struct PokemonSearcherView: View {
    
    @State var searchText: String = ""
    @StateObject var viewModel: PokemonSearcherViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if let error = viewModel.errorMessage {
                    Text(error)
                        .padding()
                }
                
                if !viewModel.last10PokemonSearched.isEmpty {
                    List {
                        Section(header: Text("Recent Searches")) {
                            ForEach(viewModel.last10PokemonSearched.reversed()) { currentPokemon in
                                NavigationLink(value: currentPokemon) {
                                    Text(currentPokemon.name)
                                        .font(.headline)
                                    Text("ID: \(currentPokemon.id)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .onDelete(perform: viewModel.deletePokemon)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(.white)
                }
                else { Text("Welcome to the Pokédex!") }
            }
            .navigationTitle(Text("Search For Pokemon"))            .navigationDestination(for: Pokemon.self) { PokemonDetails(pokemon: $0) }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .task {
            if viewModel.last10PokemonSearched.isEmpty {
                print("Loading from UserDefaults...")
                await viewModel.loadAndFetchPokemonFromSearchHistory()
            }
        }
        .task(id: searchText) {
            await searchForPokemon()
        }
    }
    
    func searchForPokemon() async {
        do {
            try await Task.sleep(for: .milliseconds(1000))
            await viewModel.getPokemon(for: searchText)
        } catch {
            print(error.localizedDescription)
        }
    }
}


#Preview {
    PokemonSearcherView(viewModel: PokemonSearcherViewModel())
}
