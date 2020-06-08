//
//  Round.swift
//  RevBullsEye
//
//  Created by Michael Page on 5/6/20.
//  Copyright © 2020 Michael Page. All rights reserved.
//

import Foundation

struct Round {
  
  let targetValue = Int.random(in: 1...100)
  
  func pointsTitleAndMessage(selectedValue: Int) -> (roundPoints: Int, title: String, message: String) {
    let distanceFromTargetValue = abs(targetValue - selectedValue)
    var points = 100 - distanceFromTargetValue
    
    let title: String
    if distanceFromTargetValue == 0 {
      title = "Perfect!"
      points += 100
    } else if distanceFromTargetValue < 5 {
      title = "You almost had it!"
      if distanceFromTargetValue == 1 {
        points += 50
      }
    } else if distanceFromTargetValue < 10 {
      title = "Pretty good!"
    } else {
      title = "Not even close..."
    }
    
    let message = "You scored \(points) points"
    
    return (points, title, message)
  }
  
}
