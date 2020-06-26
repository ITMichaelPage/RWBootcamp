//
//  Date.swift
//  Birdie
//
//  Created by Michael Page on 25/6/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

extension Date {
    func asString(format: String = "dd-MM-yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
