//
//  CGAffineTransform.swift
//  Animations
//
//  Created by Vladimirs Matusevics on 30/9/19.
//  Source: https://stackoverflow.com/a/58174046/4940066
//

import UIKit

extension CGAffineTransform {
  var scale: Double {
    return sqrt(Double(a * a + c * c));
  }
}
