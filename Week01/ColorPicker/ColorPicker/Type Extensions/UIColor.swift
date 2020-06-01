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
    convenience init(hue: Int, saturation: Int, brightness: Int) {
        self.init(hue: CGFloat(hue)/360, saturation: CGFloat(saturation)/100, brightness: CGFloat(brightness)/100, alpha: 1.0)
    }
    var isDark: Bool? {
        guard let components = self.cgColor.components else {
            return nil
        }

        // Color brightness formula from http://www.w3.org/WAI/ER/WD-AERT/#color-contrast
        let red = components[0] * 299
        let green = components[1] * 587
        let blue = components[2] * 114
        
        let brightness = (red + green + blue) / 1000
        
        return brightness < 0.5 ? true : false
    }
}
