//
//  CompatibilitySliderGame.swift
//  CompatibilitySlider
//
//  Created by Michael Page on 21/6/20.
//  Copyright © 2020 Michael Page. All rights reserved.
//

import Foundation

class CompatibilitySliderGame {

    var compatibilityItems = ["Cats", "Dogs"] // Add more!
    var currentItemIndex = 0

    var person1 = Person(id: 1, items: [:])
    var person2 = Person(id: 2, items: [:])
    var currentPerson: Person?

    func startNewGame() {
        currentItemIndex = -1
        currentPerson = person1
        person1.items.removeAll()
        person2.items.removeAll()
        let _ = updateQuestion()
    }

    func updateQuestion() -> Bool {
        if currentPerson?.items.count ?? 0 < compatibilityItems.count {
            // Move on to next question
            currentItemIndex += 1
            return true
        } else if currentPerson == person1 {
            // Time to switch to person2
            currentPerson = person2
            currentItemIndex = 0
            return true
        } else {
            // No more questions
            return false
        }
    }

    func calculateCompatibilityScore() -> Double {
        // If diff 0.0 is 100% and 5.0 is 0%, calculate match percentage
        var percentagesForAllItems: [Double] = []

        for (key, person1Rating) in person1.items {
            let person2Rating = person2.items[key] ?? 0
            let difference = abs(person1Rating - person2Rating)/5.0
            percentagesForAllItems.append(Double(difference))
        }

        let sumOfAllPercentages = percentagesForAllItems.reduce(0, +)
        let mismatchPercentage = sumOfAllPercentages / Double(compatibilityItems.count)
        let matchPercentage = 100 - (mismatchPercentage * 100).rounded()
        return matchPercentage
    }

    func calculateRelationshipAdvice() -> String {
        switch Int(calculateCompatibilityScore()) {
        case 0...20:
            return "You don't see eye to eye, on many things."
        case 21...30:
            return "Discuss why your views are so different."
        case 31...40:
            return "Your differing views may complement each other."
        case 41...50:
            return "Your relationship could go either way."
        case 51...60:
            return "Grab brunch together, there's potential."
        case 61...70:
            return "You share many of the same views, a good start."
        case 71...80:
            return "You have a good foundation, build upon it!"
        case 81...90:
            return "Love is on the cards for these two!"
        case 91...100:
            return "Skip dating and get married!"
        default:
            return "Invalid compatibility score."
        }
    }

}
