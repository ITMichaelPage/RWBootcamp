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

import UIKit

struct Pokemon {
  let id: Int
  let name: String
  let height, weight, baseExperience: Int
  let typeSlot1Identifier, typeSlot2Identifier: TypeSlotIdentifier?
  let statsHP, statsAttack, statsDefense, statsSpecialAttack: Int
  let statsSpecialDefense, statsSpeed, generation: Int
  let evolvesFromPokemonID: Int?
  let evolvesToPokemonIDs: [Int]?
  let pokemonDescription: String
  let auraColor: AuraColor?
  var typeSlot1IdentifierColor: UIColor? {
    guard let typeSlot1Identifier = typeSlot1Identifier,
      let color = UIColor(named: "type-\(typeSlot1Identifier)") else {
      return nil
    }
    return color
  }
  var typeSlot2IdentifierColor: UIColor? {
    guard let typeSlot2Identifier = typeSlot2Identifier,
      let color = UIColor(named: "type-\(typeSlot2Identifier)") else {
      return nil
    }
    return color
  }
}

enum AuraColor: String, Codable {
  case black = "black"
  case blue = "blue"
  case brown = "brown"
  case gray = "gray"
  case green = "green"
  case pink = "pink"
  case purple = "purple"
  case red = "red"
  case white = "white"
  case yellow = "yellow"
}

enum TypeSlotIdentifier: String, Codable {
  case bug = "bug"
  case dark = "dark"
  case dragon = "dragon"
  case electric = "electric"
  case fairy = "fairy"
  case fighting = "fighting"
  case fire = "fire"
  case flying = "flying"
  case ghost = "ghost"
  case grass = "grass"
  case ground = "ground"
  case ice = "ice"
  case normal = "normal"
  case poison = "poison"
  case psychic = "psychic"
  case rock = "rock"
  case steel = "steel"
  case water = "water"
}
