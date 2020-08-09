//
//  UIView.swift
//  Animations
//
//  Created by Michael Page on 8/8/20.
//  Copyright © 2020 Michael Page. All rights reserved.
//

import UIKit

extension UIView {
  static func animate(withDuration duration: TimeInterval, animations: @escaping () -> Void, group: DispatchGroup, completion: ((Bool) -> Void)?) {
    group.enter()
    animate(withDuration: duration, animations: animations) { (animationCompleted) in
      defer {
        group.leave()
      }
      completion?(animationCompleted)
    }
  }
}
