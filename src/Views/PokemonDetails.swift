//
//  SelectedPokemonView.swift
//  Pokedex
//
//  Created by Preston Hang on 1/7/26.
//

import SwiftUI

struct PokemonDetails: View {
    
    var pokemon: Pokemon
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("No. \(pokemon.id)")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Color.secondary)
            HStack {
                ForEach(pokemon.types, id: \.slot) { type in
                    Text(type.type.name.capitalized)
                        .padding(10)
                        .foregroundColor(Color.white)
                        .bold(true)
                        .background(getColor(for: type.type.name))
                        .cornerRadius(10)
                }
                // Push Types to the left
                Spacer()
            }
            VStack(alignment: .leading) {
                Text("\(Int(pokemon.heightInInches) / 12)'\(pokemon.heightInInches.truncatingRemainder(dividingBy: 12), specifier: "%.1f")\"")
                    .foregroundColor(Color.secondary)
                Text("\(pokemon.weightInPounds, specifier: "%.2f") lbs")
                    .foregroundColor(Color.secondary)
            }
            getSprite()
            
            getStats()
            
            // Push All Content to the top
            Spacer()
        }
        .navigationTitle(pokemon.name.capitalized)
        .padding()
    }
    
    @ViewBuilder
    func getSprite() -> some View {
        if let url = URL(string: pokemon.sprites.frontDefault) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image(systemName: "questionmark.circle")
                @unknown default:
                    Text("Unknown Issue in Image Loading")
                }
            }
        }
    }
    
    @ViewBuilder
    func getStats() -> some View {
        ForEach(pokemon.stats, id: \.stat.name){ stat in
            Text(stat.stat.name.capitalized + ": \(stat.baseStat)")
        }
    }
    
    func getColor(for type: String) -> Color {
        switch type.lowercased() {
        case "fire": return .orange
        case "water": return .blue
        case "grass": return .green
        case "electric": return .yellow
        case "ice": return Color(red: 0.6, green: 0.8, blue: 1.0) // Light Blue
        case "fighting": return .brown
        case "poison": return .purple
        case "ground": return .orange.opacity(0.8)
        case "flying": return .indigo
        case "psychic": return .pink
        case "bug": return Color(red: 0.6, green: 0.7, blue: 0.1) // Olive/Lime
        case "rock": return Color(red: 0.7, green: 0.6, blue: 0.4) // Tan/Stone
        case "ghost": return Color(red: 0.4, green: 0.3, blue: 0.6) // Deep Purple
        case "dragon": return Color(red: 0.4, green: 0.2, blue: 0.9) // Royal Blue/Purple
        case "steel": return Color(red: 0.7, green: 0.7, blue: 0.8) // Metallic Silver
        case "fairy": return .pink.opacity(0.6)
        case "dark": return Color(red: 0.2, green: 0.2, blue: 0.2) // Almost Black
        case "normal": return .gray
        default: return .gray // For "Unknown" or "Shadow" types
        }
    }
}

#Preview {

}
