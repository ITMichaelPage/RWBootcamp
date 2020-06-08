/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

enum SelectedSliderTag: Int {
    case Red
    case Green
    case Blue
}

class ViewController: UIViewController {
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var targetTextLabel: UILabel!
  @IBOutlet weak var guessLabel: UILabel!
  
  @IBOutlet weak var redLabel: UILabel!
  @IBOutlet weak var greenLabel: UILabel!
  @IBOutlet weak var blueLabel: UILabel!
  
  @IBOutlet weak var redSlider: UISlider!
  @IBOutlet weak var greenSlider: UISlider!
  @IBOutlet weak var blueSlider: UISlider!
  
  @IBOutlet weak var roundLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  
  var game = BullsEyeGame()
  var rgb = RGB()
  
  @IBAction func aSliderMoved(sender: UISlider) {
    let roundedValue = Int(sender.value.rounded())
    
    switch sender.tag {
    case SelectedSliderTag.Red.rawValue:
      redLabel.text = String("R \(roundedValue)")
      rgb.r = roundedValue
    case SelectedSliderTag.Green.rawValue:
      greenLabel.text = String("G \(roundedValue)")
      rgb.g = roundedValue
    case SelectedSliderTag.Blue.rawValue:
      blueLabel.text = String("B \(roundedValue)")
      rgb.b = roundedValue
    default:
      return
    }
    guessLabel.backgroundColor = UIColor.init(rgbStruct: rgb)
  }
  
  @IBAction func showAlert(sender: AnyObject) {
    guard let (title, message) = game.evaluatePlayerSelection(rgb) else {
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
  
  @IBAction func startOver(sender: AnyObject) {
    game.startNewGame()
    updateView()
  }
  
  func updateView() {
    guard let targetValue = game.currentRound?.targetValue else {
      return
    }
    
    targetLabel.backgroundColor = UIColor.init(rgbStruct: targetValue)
    redLabel.text = String("R \(Int(redSlider.value))")
    greenLabel.text = String("G \(Int(greenSlider.value))")
    blueLabel.text = String("B \(Int(blueSlider.value))")
    roundLabel.text = String("Round: \(game.roundNumber)")
    scoreLabel.text = String("Score: \(game.score)")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    game.startNewGame()
    updateView()
  }
}

