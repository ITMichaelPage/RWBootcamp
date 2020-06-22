//
//  ViewController.swift
//  CompatibilitySlider
//
//  Created by Jay Strawn on 6/16/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    @IBOutlet weak var compatibilityItemLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var backgroundAnimationView: AnimationView!
    @IBOutlet weak var emojiCryingAnimationView: AnimationView!
    @IBOutlet weak var emojiSadAnimationView: AnimationView!
    @IBOutlet weak var emojiConfusedAnimationView: AnimationView!
    @IBOutlet weak var emojiHappyAnimationView: AnimationView!
    @IBOutlet weak var emojiAwesomeAnimationView: AnimationView!

    let game = CompatibilitySliderGame()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        game.startNewGame()
        setupBackgroundAnimation()
        setupEmojiAnimations()
        updateView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCompatibilityScore" {
            let compatibilityScoreViewController = segue.destination as! CompatibilityScoreViewController
            compatibilityScoreViewController.game = game
        }
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let emojiAnimationViews: [AnimationView] = [emojiCryingAnimationView,
                                   emojiSadAnimationView,
                                   emojiConfusedAnimationView,
                                   emojiHappyAnimationView,
                                   emojiAwesomeAnimationView]
        
        emojiAnimationViews.forEach { (emojiAnimationView) in
            emojiAnimationView.pause()
        }

        switch Int(sender.value.rounded()) {
        case 0:
            emojiCryingAnimationView.play()
        case 1:
            emojiSadAnimationView.play()
        case 2...3:
            emojiConfusedAnimationView.play()
        case 4:
            emojiHappyAnimationView.play()
        case 5:
            emojiAwesomeAnimationView.play()
        default:
            print("Invalid compatibility score.")
        }
    }

    @IBAction func didPressNextItemButton(_ sender: Any) {
        let currentItem = game.compatibilityItems[game.currentItemIndex]
        game.currentPerson?.items.updateValue(slider.value, forKey: currentItem)
        
        if game.updateQuestion() {
            updateView()
        } else {
            performSegue(withIdentifier: "ShowCompatibilityScore", sender: self)
        }
    }

    func updateView() {
        questionLabel.text = "User \(game.currentPerson!.id), what do you think about..."
        compatibilityItemLabel.text = game.compatibilityItems[game.currentItemIndex]
        slider.setValue(2.5, animated: true)
    }

    func setupBackgroundAnimation() {
        backgroundAnimationView.animation = Animation.named("BackgroundRotatingGradientPink")
        backgroundAnimationView.animationSpeed = 0.1
        backgroundAnimationView.contentMode = .scaleAspectFill
        backgroundAnimationView.loopMode = .loop
        backgroundAnimationView.play()
    }

    func setupEmojiAnimations() {
        emojiCryingAnimationView.animation = Animation.named("EmojiCrying")
        emojiSadAnimationView.animation = Animation.named("EmojiSad")
        emojiConfusedAnimationView.animation = Animation.named("EmojiConfused")
        emojiHappyAnimationView.animation = Animation.named("EmojiHappy")
        emojiAwesomeAnimationView.animation = Animation.named("EmojiAwesome")
    }

}

