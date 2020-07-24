//
//  QuestionCodable.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

struct Clue: Codable, Equatable, Hashable {
    let id: Int
    let answer, question: String
    let points: Int? = 100
    let categoryID: Int
    let category: Category
    
    enum CodingKeys: String, CodingKey {
        case id, answer, question
        case points = "value"
        case categoryID = "category_id"
        case category
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(answer)
    }
    
    static func == (lhs: Clue, rhs: Clue) -> Bool {
        return lhs.answer == rhs.answer
    }
}

struct Category: Codable {
    let id: Int
    let title: String
    let cluesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case cluesCount = "clues_count"
    }
}
