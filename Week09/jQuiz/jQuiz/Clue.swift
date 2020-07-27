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
    var points: Int
    let categoryID: Int
    let category: Category
    
    enum CodingKeys: String, CodingKey {
        case id, answer, question
        case points = "value"
        case categoryID = "category_id"
        case category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.answer = try container.decode(String.self, forKey: .answer).withoutHTMLTags()
        self.question = try container.decode(String.self, forKey: .question).withoutHTMLTags()
        self.points = try container.decode(Int?.self, forKey: .points) ?? 100
        self.categoryID = try container.decode(Int.self, forKey: .categoryID)
        self.category = try container.decode(Category.self, forKey: .category)
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
