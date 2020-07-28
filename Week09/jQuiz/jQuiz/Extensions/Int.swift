//
//  Int.swift
//  jQuiz
//
//  Created by Michael Page on 27/7/20.
//  Source: https://stackoverflow.com/a/44458986/4940066
//

import Foundation

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
