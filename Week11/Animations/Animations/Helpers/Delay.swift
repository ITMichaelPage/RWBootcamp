//
//  Delay.swift
//  Animations
//
//  Created by Michael Page on 7/8/20.
//  Copyright © 2020 Michael Page. All rights reserved.
//

import Foundation

func delay(seconds: TimeInterval, execute: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: execute)
}
