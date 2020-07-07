//
//  UIColor.swift
//  ColorPicker
//
//  Modified by Michael Page on 6/6/20.
//  Sourced from Stack Overflow post: https://stackoverflow.com/a/49894741/4940066
//

import UIKit

extension UIView {
  func startRotating(duration: TimeInterval, repeatCount: Float = Float.infinity, clockwise: Bool = true) {
    
    guard self.layer.animation(forKey: "transform.rotation.z") == nil else {
      return
    }
    
    let animation = CABasicAnimation(keyPath: "transform.rotation.z")
    let direction = clockwise ? 1.0 : -1.0
    animation.toValue = NSNumber(value: .pi * 2 * direction)
    animation.duration = duration
    animation.isCumulative = true
    animation.repeatCount = repeatCount
    animation.isRemovedOnCompletion = false
    self.layer.add(animation, forKey: "transform.rotation.z")
  }
  
  func stopRotating() {
    self.layer.removeAnimation(forKey: "transform.rotation.z")
  }
}
