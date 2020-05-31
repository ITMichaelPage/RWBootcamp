//
//  UIColor.swift
//  ColorPicker
//
//  Created by Michael Page on 31/5/20.
//  Copyright © 2020 Michael Page. All rights reserved.
//

import UIKit

extension UIColor {
convenience init(red: Int, green: Int, blue: Int) {
    self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1.0)
    }
}
