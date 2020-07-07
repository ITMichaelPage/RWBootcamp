/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

class PokemonGenerator {
  
  public static let shared = PokemonGenerator()
  
  private init () { }
  
  func generatePokemons() -> [Pokemon] {
    var pokemons: [Pokemon] = []
    let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
    do {
      let csv = try CSV(contentsOfURL: path ?? "")
      let rows = csv.rows
      for row in rows {
        let pokemonID = Int(row["id"] ?? "") ?? 0
        let name = row["identifier"] ?? ""
        let height = Int(row["height"] ?? "") ?? 0
        let weight = Int(row["weight"] ?? "") ?? 0
        let baseExperience = Int(row["base_experience"] ?? "") ?? 0
        let typeSlot1Identifier = TypeSlotIdentifier(rawValue: row["type_slot_1_identifier"] ?? "")
        let typeSlot2Identifier = TypeSlotIdentifier(rawValue: row["type_slot_2_identifier"] ?? "")
        let statsHP = Int(row["stats_hp"] ?? "") ?? 0
        let statsAttack = Int(row["stats_attack"] ?? "") ?? 0
        let statsDefense = Int(row["stats_defense"] ?? "") ?? 0
        let statsSpecialAttack = Int(row["stats_special-attack"] ?? "") ?? 0
        let statsSpecialDefense = Int(row["stats_special-defense"] ?? "") ?? 0
        let statsSpeed = Int(row["stats_speed"] ?? "") ?? 0
        let generation = Int(row["generation"] ?? "") ?? 0
        let evolvesFromPokemonID = Int(row["evolves_from_pokemon_id"] ?? "")
        let evolvesIntoPokemonIDsStrings = row["evolves_into_pokemon_ids"]?.split(separator: "/") ?? []
        let evolvesIntoPokemonIDs = evolvesIntoPokemonIDsStrings.map({Int($0)!})
        let pokemonDescriptionWithFakeCommas = row["description"] ?? ""
        let pokemonDescription = pokemonDescriptionWithFakeCommas.replacingOccurrences(of: "，", with: ",")
        let auraColor = AuraColor(rawValue: row["aura_color"] ?? "")
        
        let pokemon = Pokemon(id: pokemonID,
                              name: name.capitalized,
                              height: height,
                              weight: weight,
                              baseExperience: baseExperience,
                              typeSlot1Identifier: typeSlot1Identifier,
                              typeSlot2Identifier: typeSlot2Identifier,
                              statsHP: statsHP,
                              statsAttack: statsAttack,
                              statsDefense: statsDefense,
                              statsSpecialAttack: statsSpecialAttack,
                              statsSpecialDefense: statsSpecialDefense,
                              statsSpeed: statsSpeed,
                              generation: generation,
                              evolvesFromPokemonID: evolvesFromPokemonID,
                              evolvesIntoPokemonIDs: evolvesIntoPokemonIDs,
                              pokemonDescription: pokemonDescription,
                              auraColor: auraColor
        )
        
        pokemons.append(pokemon)
      }
      return pokemons
    } catch let error {
      print("\(error.localizedDescription)")
    }
    return pokemons
  }
  
}
