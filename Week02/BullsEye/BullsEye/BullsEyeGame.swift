//
//  BullsEyeGame.swift
//  BullsEye
//
//  Created by Michael Page on 5/6/20.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation

struct BullsEyeGame {
  
  var score = Int()
  private var rounds = [Round]()
  var currentRound: Round? {
    return rounds.last
  }
  var roundNumber: Int {
    return rounds.count
  }
  
  mutating func startNewRound() {
    rounds.append(Round())
  }
  
  mutating func startNewGame() {
    score = 0
    rounds.removeAll()
    startNewRound()
  }

  mutating func evaluatePlayerSelection(_ selectedValue: Int) -> (title: String, message: String)? {
    if let currentRound = currentRound {
      let (points, title, message) = currentRound.pointsTitleAndMessage(selectedValue: selectedValue)
      score += points
      
      return (title, message)
    }
    return nil
  }
  
}
