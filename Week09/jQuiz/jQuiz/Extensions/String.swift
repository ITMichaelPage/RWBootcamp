//
//  String.swift
//  jQuiz
//
//  Created by Michael Page on 27/7/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

extension String {
    func withoutHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
