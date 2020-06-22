//
//  CompatibilityScoreViewController.swift
//  CompatibilitySlider
//
//  Created by Michael Page on 21/6/20.
//  Copyright © 2020 Michael Page. All rights reserved.
//

import UIKit

class CompatibilityScoreViewController: UIViewController {

    var game = CompatibilitySliderGame()

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var relationshipAdvice: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scoreLabel.text = "\(Int(game.calculateCompatibilityScore()))%"
        relationshipAdvice.text = game.calculateRelationshipAdvice()
    }

    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }

}
