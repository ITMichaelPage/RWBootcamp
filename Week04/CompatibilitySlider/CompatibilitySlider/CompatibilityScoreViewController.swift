//
//  CompatibilityScoreViewController.swift
//  CompatibilitySlider
//
//  Created by Michael Page on 21/6/20.
//  Copyright © 2020 Michael Page. All rights reserved.
//

import UIKit
import Lottie

class CompatibilityScoreViewController: UIViewController {

    var game = CompatibilitySliderGame()

    @IBOutlet weak var foregroundAnimationView: AnimationView!
    @IBOutlet weak var backgroundAnimationView: AnimationView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var relationshipAdvice: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupBackgroundAnimation()
        setupForegroundAnimation()
        updateView()
    }

    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }

    func updateView() {
        scoreLabel.text = "\(Int(game.calculateCompatibilityScore()))%"
        relationshipAdvice.text = game.calculateRelationshipAdvice()
    }

    func setupBackgroundAnimation() {
        backgroundAnimationView.animation = Animation.named("FloatingHearts")
        backgroundAnimationView.contentMode = .scaleAspectFill
        backgroundAnimationView.loopMode = .loop
        backgroundAnimationView.play()
    }

    func setupForegroundAnimation() {
        var foregroundAnimationName = String()
        switch Int(game.calculateCompatibilityScore()) {
        case 0...20:
            foregroundAnimationName = "PunchingBears"
        case 21...40:
            foregroundAnimationName = "PokingBears"
        case 41...60:
            foregroundAnimationName = "FaceRubbingBears"
        case 61...70:
            foregroundAnimationName = "ToastingBears"
        case 71...80:
            foregroundAnimationName = "SnugglingBears"
        case 81...90:
            foregroundAnimationName = "KissingBears"
        case 91...100:
            foregroundAnimationName = "HyperKissingBears"
        default:
            print("Invalid compatibility score.")
        }

        foregroundAnimationView.animation = Animation.named(foregroundAnimationName)
        foregroundAnimationView.loopMode = .loop
        foregroundAnimationView.play()
    }

}
