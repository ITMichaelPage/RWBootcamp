//
//  ViewController.swift
//  CompatibilitySlider
//
//  Created by Jay Strawn on 6/16/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var compatibilityItemLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var questionLabel: UILabel!

    var compatibilityItems = ["Cats", "Dogs"] // Add more!
    var currentItemIndex = 0

    var person1 = Person(id: 1, items: [:])
    var person2 = Person(id: 2, items: [:])
    var currentPerson: Person?

    override func viewDidLoad() {
        super.viewDidLoad()
        currentPerson = person1
        updateQuestion()
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
    }

    @IBAction func didPressNextItemButton(_ sender: Any) {
        let currentItem = compatibilityItems[currentItemIndex]
        currentPerson?.items.updateValue(slider.value, forKey: currentItem)

        if currentPerson?.items.count ?? 0 < compatibilityItems.count {
            // Move on to next question
            currentItemIndex += 1
            updateQuestion()
        } else if currentPerson == person1 {
            // Time to switch to person2
            currentPerson = person2
            currentItemIndex = 0
            updateQuestion()
        } else {
            // No more questions
            let score = calculateCompatibility()
            showCompatibilityScoreAlert(score: score)
        }
    }

    func updateQuestion() {
        questionLabel.text = "User \(currentPerson!.id), what do you think about..."
        compatibilityItemLabel.text = compatibilityItems[currentItemIndex]
        slider.setValue(2.5, animated: true)
    }

    func calculateCompatibility() -> String {
        // If diff 0.0 is 100% and 5.0 is 0%, calculate match percentage
        var percentagesForAllItems: [Double] = []

        for (key, person1Rating) in person1.items {
            let person2Rating = person2.items[key] ?? 0
            let difference = abs(person1Rating - person2Rating)/5.0
            percentagesForAllItems.append(Double(difference))
        }

        let sumOfAllPercentages = percentagesForAllItems.reduce(0, +)
        let mismatchPercentage = sumOfAllPercentages / Double(compatibilityItems.count)
        let matchString = 100 - (mismatchPercentage * 100).rounded()
        return "\(matchString)%"
    }

    func showCompatibilityScoreAlert(score: String) {
        let title = "Results"
        let message = "You two are \(score) compatible"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.currentPerson = self.person1
            self.currentItemIndex = 0
            self.person1.items.removeAll()
            self.person2.items.removeAll()
            self.updateQuestion()
        })
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

}

