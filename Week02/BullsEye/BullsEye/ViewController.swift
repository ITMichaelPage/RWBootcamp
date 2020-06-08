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
  }
  
  func updateView() {
    currentValue = 50
    slider.value = Float(currentValue)
    targetLabel.text = targetValue != nil ? String(targetValue!) : "???"
    scoreLabel.text = String(score)
    roundLabel.text = String(round)
  }
  
  @IBAction func startNewGame() {
    game.startNewGame()
    updateView()
  }
  
}



