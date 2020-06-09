//
//  UIColor.swift
//  BullsEye
//
//  Created by Michael Page on 9/6/20.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//
// Code based on Stack Overflow post: https://stackoverflow.com/a/35853850/4940066

import UIKit

struct ColorComponents {
    var red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat
}

extension UIColor {
  func getComponents() -> ColorComponents? {
    guard let components = self.cgColor.components else {
      return nil
    }
    
    if self.cgColor.numberOfComponents == 2 {
      // White only contains two components
      return ColorComponents(red: components[0], green: components[0], blue: components[0], alpha: components[1])
    } else {
      return ColorComponents(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
  }
  func interpolateColorTo(end: UIColor, fraction: CGFloat) -> UIColor? {
    let f = min(max(0, fraction), 1)
    
    guard let c1 = self.getComponents(), let c2 = end.getComponents() else {
      return nil
    }
    
    let red = c1.red + (c2.red - c1.red) * f
    let green = c1.green + (c2.green - c1.green) * f
    let blue = c1.blue + (c2.blue - c1.blue) * f
    let alpha = c1.alpha + (c2.alpha - c1.alpha) * f

    return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
