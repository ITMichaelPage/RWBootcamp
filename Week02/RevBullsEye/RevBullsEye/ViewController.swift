//
//  ViewController.swift
//  RevBullsEye
//
//  Created by Michael Page on 7/6/20.
//  Copyright © 2020 Michael Page. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  
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
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!
  @IBOutlet weak var guessValueTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    game.startNewGame()
    updateView()
    
    guessValueTextField.delegate = self
    guessValueTextField.addTarget(self, action: #selector(guessValueChanged), for: .editingChanged)
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
  
  func updateView() {
    guard let targetValue = targetValue else {
      return
    }
    slider.setValue(Float(targetValue) / 100, animated: true)
    scoreLabel.text = String("Score: \(score)")
    roundLabel.text = String("Round: \(round)")
    guessValueTextField.text = ""
    currentValue = 0
  }
  
  @IBAction func startNewGame() {
    game.startNewGame()
    updateView()
  }
  
  @objc private func guessValueChanged() {
    guard let textValue = guessValueTextField.text, let numericValue = Int(textValue) else {
      return
    }
    currentValue = numericValue
  }
  
}

