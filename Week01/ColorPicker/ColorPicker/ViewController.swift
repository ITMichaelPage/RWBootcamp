//
//  ViewController.swift
//  ColorPicker
//
//  Created by Michael Page on 31/5/20.
//  Copyright © 2020 Michael Page. All rights reserved.
//

import UIKit

enum SelectedSliderTag: Int {
    case First
    case Second
    case Third
}

class ViewController: UIViewController {

    var firstSliderValue = 0
    var secondSliderValue = 0
    var thirdSliderValue = 0
    
    var colorName = ""
    var backgroundColor: UIColor {
        get {
            return UIColor.init(red: firstSliderValue, green: secondSliderValue, blue: thirdSliderValue)
        }
    }

    @IBOutlet weak var colorNameLabel: UILabel!

    @IBOutlet weak var firstSliderTitleLabel: UILabel!
    @IBOutlet weak var firstSlider: UISlider!
    @IBOutlet weak var firstSliderValueLabel: UILabel!

    @IBOutlet weak var secondSliderTitleLabel: UILabel!
    @IBOutlet weak var secondSlider: UISlider!
    @IBOutlet weak var secondSliderValueLabel: UILabel!

    @IBOutlet weak var thirdSliderTitleLabel: UILabel!
    @IBOutlet weak var thirdSlider: UISlider!
    @IBOutlet weak var thirdSliderValueLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateColorNameLabel()
        updateSliderValueLabels()
    }

    @IBAction func setColor() {
        showColorNameAlert()
    }

    @IBAction func resetValues() {
        colorName = ""
        firstSliderValue = 0
        secondSliderValue = 0
        thirdSliderValue = 0
        
        updateColorNameLabel()
        updateSliderValues()
        updateSliderValueLabels()
        updateBackgroundColor()
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        let roundedValue = Int(slider.value.rounded())

        switch slider.tag {
        case SelectedSliderTag.First.rawValue:
            firstSliderValue = roundedValue
        case SelectedSliderTag.Second.rawValue:
            secondSliderValue = roundedValue
        case SelectedSliderTag.Third.rawValue:
            thirdSliderValue = roundedValue
        default:
            return
        }
        
        updateSliderValueLabels()
    }

    func updateColorNameLabel() {
        colorNameLabel.text = colorName
    }

    func updateSliderValues() {
        firstSlider.setValue(Float(firstSliderValue), animated: true)
        secondSlider.setValue(Float(secondSliderValue), animated: true)
        thirdSlider.setValue(Float(thirdSliderValue), animated: true)
    }

    func updateSliderValueLabels() {
        firstSliderValueLabel.text = String(firstSliderValue)
        secondSliderValueLabel.text = String(secondSliderValue)
        thirdSliderValueLabel.text = String(thirdSliderValue)
    }

    func updateBackgroundColor() {
        self.view.backgroundColor = backgroundColor
    }

    func showColorNameAlert() {
        let title = "Fabulous!"
        let message = "Please enter the name of this color"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Color Name"
            textField.autocapitalizationType = .words;
        })
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { action in
            if let enteredColorName = alert.textFields?.first?.text {
                self.colorName = enteredColorName
                self.updateColorNameLabel()
            }
            self.updateBackgroundColor()
        })
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

}

