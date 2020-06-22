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

    let game = CompatibilitySliderGame()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        game.startNewGame()
        updateView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCompatibilityScore" {
            let compatibilityScoreViewController = segue.destination as! CompatibilityScoreViewController
            compatibilityScoreViewController.game = game
        }
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
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

}

