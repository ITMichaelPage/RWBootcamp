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
    themeSlider()
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
    slider.setValue(Float(currentValue), animated: true)
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
      var primaryColor: UIColor
      var secondaryColor: UIColor
      var fraction: CGFloat
      
      switch quickDiff {
      case 0...5:
        primaryColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        secondaryColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        fraction = (CGFloat(quickDiff) / 100.0) * 4
      case 6...30:
        primaryColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        secondaryColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        fraction = (CGFloat(quickDiff) / 100.0) * 1.5
      case 31...100:
        primaryColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
        secondaryColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        fraction = (CGFloat(quickDiff) / 100.0)
      default:
        return
      }
      slider.minimumTrackTintColor = primaryColor.interpolateColorTo(end: secondaryColor, fraction: fraction)
    }
  }
  
  func themeSlider() {
    let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-Normal")
    slider.setThumbImage(thumbImageNormal, for: .normal)
    
    let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    
    let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
    let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
    slider.setMaximumTrackImage(trackRightResizable, for: .normal)
  }
  
}



