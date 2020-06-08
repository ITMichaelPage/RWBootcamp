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
  @IBOutlet weak var hitMeButton: UIButton!
  
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
    hitMeButton.isEnabled = false
    currentValue = 0
  }
  
  @IBAction func startNewGame() {
    game.startNewGame()
    updateView()
  }
  
  @IBAction func tapped(sender: AnyObject) {
    view.endEditing(true)
  }
  
  @objc private func guessValueChanged() {
    guard let textValue = guessValueTextField.text, let numericValue = Int(textValue) else {
      hitMeButton.isEnabled = false
      return
    }
    currentValue = numericValue
    updateGuessValueTextColor()
    hitMeButton.isEnabled = true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let textFieldPriorValue = textField.text ?? ""
    let textFieldEnteredValue = string
    let textFieldValue = textFieldPriorValue + textFieldEnteredValue
    guard let numericValue = Int(textFieldValue) else {
      return false
    }
    let range = 1...100
    return range.contains(numericValue) ? true : false
  }
  
  // Update the guess value text color to indicate proximity to correct answer
  func updateGuessValueTextColor() {
    if let quickDiff = quickDiff {
      var textColor: UIColor
      switch quickDiff {
      case 0...5:
        textColor = .red
      case 6...50:
        textColor = .orange
      case 51...100:
        textColor = .blue
      default:
        textColor = .black
      }
      guessValueTextField.textColor = textColor
    }
  }
  
}

