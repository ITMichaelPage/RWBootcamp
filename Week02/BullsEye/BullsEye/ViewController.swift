//
//  ViewController.swift
//  BullsEye
//
//  Created by Ray Wenderlich on 6/13/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var game = BullsEyeGame()
  var currentValue = 0
  var targetValue: Int? {
    return game.currentRound?.targetValue
  }
  var score: Int {
    return game.score
  }
  var round: Int {
    return game.roundNumber
  }
  var quickDiff: Int? {
    guard let targetValue = game.currentRound?.targetValue else {
      return nil
    }
    return abs(targetValue - currentValue)
  }
  
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let roundedValue = slider.value.rounded()
    currentValue = Int(roundedValue)
    game.startNewGame()
    updateView()
    updateSliderTrackTintColorHint()
  }

  @IBAction func showAlert() {
    guard let (title, message) = game.evaluatePlayerSelection(currentValue) else {
      return
    }
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: {
      action in
      self.game.startNewRound()
      self.updateView()
    })
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func sliderMoved(_ slider: UISlider) {
    let roundedValue = slider.value.rounded()
    currentValue = Int(roundedValue)
    updateSliderTrackTintColorHint()
  }
  
  func updateView() {
    currentValue = 50
    slider.value = Float(currentValue)
    targetLabel.text = targetValue != nil ? String(targetValue!) : "???"
    scoreLabel.text = String(score)
    roundLabel.text = String(round)
    updateSliderTrackTintColorHint()
  }
  
  @IBAction func startNewGame() {
    game.startNewGame()
    updateView()
  }
  
  private func updateSliderTrackTintColorHint() {
    if let quickDiff = quickDiff {
      slider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(CGFloat(quickDiff) / 100.0)
    }
  }
  
}



