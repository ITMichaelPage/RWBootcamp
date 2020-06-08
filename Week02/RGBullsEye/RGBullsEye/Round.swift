//
//  Round.swift
//  RGBullsEye
//
//  Created by Michael Page on 6/6/20.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation

struct Round {
  
  let targetValue = RGB.random()

  func pointsTitleAndMessage(selectedValue: RGB) -> (roundPoints: Int, title: String, message: String) {
    let distanceFromTargetValue = selectedValue.difference(target: targetValue) * 100
    var points = Int(100 - distanceFromTargetValue)
    
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
