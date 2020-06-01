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

enum ColorModel {
    case RGB
    case HSB
}

class ViewController: UIViewController {

    var firstSliderValue = 0
    var secondSliderValue = 0
    var thirdSliderValue = 0
    
    var colorName = ""
    var colorModel: ColorModel = .RGB
    var calculatedColor: UIColor {
        get {
            switch colorModel {
            case .RGB:
                return UIColor.init(red: firstSliderValue, green: secondSliderValue, blue: thirdSliderValue)
            case .HSB:
                return UIColor.init(hue: firstSliderValue, saturation: secondSliderValue, brightness: thirdSliderValue)
            }
        }
    }
    var labelsColor: UIColor {
        get {
            return (calculatedColor.isDark ?? true) ? UIColor.white : UIColor.black
        }
    }

    @IBOutlet weak var colorNameLabel: UILabel!
    @IBOutlet weak var liveColorPreviewView: UIView!

    @IBOutlet weak var firstSliderTitleLabel: UILabel!
    @IBOutlet weak var firstSlider: UISlider!
    @IBOutlet weak var firstSliderValueLabel: UILabel!
    @IBOutlet weak var firstSliderBackgroundView: UIView!

    @IBOutlet weak var secondSliderTitleLabel: UILabel!
    @IBOutlet weak var secondSlider: UISlider!
    @IBOutlet weak var secondSliderValueLabel: UILabel!

    @IBOutlet weak var thirdSliderTitleLabel: UILabel!
    @IBOutlet weak var thirdSlider: UISlider!
    @IBOutlet weak var thirdSliderValueLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        liveColorPreviewView.layer.cornerRadius = 6
        updateColorNameLabel()
        updateSliderValueLabels()
    }

    @IBAction func setColor() {
        showColorNameAlert()
    }

    @IBAction func resetValues() {
        firstSliderValue = 0
        secondSliderValue = 0
        thirdSliderValue = 0
        
        updateColorNameLabel(reset: true)
        updateSliderValues()
        updateSliderValueLabels()
        updateLivePreviewColor()
        updateBackgroundColor()
        updateLabelsColor()
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        let roundedValue = Int(slider.value.rounded())

        switch slider.tag {
        case SelectedSliderTag.First.rawValue:
            switch colorModel {
            case .RGB:
                // Red slider
                slider.minimumTrackTintColor = UIColor(red: Int(slider.value), green: 0, blue: 0)
            case .HSB:
                // Hue slider, no tint required as hue slider track will be visible
                break
            }
            firstSliderValue = roundedValue
        case SelectedSliderTag.Second.rawValue:
            switch colorModel {
            case .RGB:
                // Green slider
                slider.minimumTrackTintColor = UIColor(red: 0, green: Int(slider.value), blue: 0)
            case .HSB:
                // Saturation slider
                slider.minimumTrackTintColor = UIColor(hue: 0, saturation: Int(slider.value), brightness: 100)
            }
            secondSliderValue = roundedValue
        case SelectedSliderTag.Third.rawValue:
            switch colorModel {
            case .RGB:
                // Blue slider
                slider.minimumTrackTintColor = UIColor(red: 0, green: 0, blue: Int(slider.value))
            case .HSB:
                // Brightness slider
                slider.minimumTrackTintColor = UIColor(hue: 0, saturation: 0, brightness: Int(slider.value))
            }
            thirdSliderValue = roundedValue
        default:
            return
        }
        
        updateColorNameLabel(reset: true)
        updateSliderValueLabels()
        updateLivePreviewColor()
    }

    @IBAction func colorModelChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            colorModel = .RGB
        case 1:
            colorModel = .HSB
        default:
            return
        }
        
        switch colorModel {
        case .RGB:
            firstSliderTitleLabel.text = "Red"
            firstSlider.maximumValue = 255
            secondSliderTitleLabel.text = "Green"
            secondSlider.maximumValue = 255
            thirdSliderTitleLabel.text = "Blue"
            thirdSlider.maximumValue = 255
        case .HSB:
            firstSliderTitleLabel.text = "Hue"
            firstSlider.maximumValue = 360
            secondSliderTitleLabel.text = "Saturation"
            secondSlider.maximumValue = 100
            thirdSliderTitleLabel.text = "Brightness"
            thirdSlider.maximumValue = 100
        }
        
        updateHueSliderTrackVisibility()
        resetValues()
    }

    func updateColorNameLabel(reset: Bool = false) {
        if reset {
            colorName = ""
        }
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

    func updateLivePreviewColor() {
        liveColorPreviewView.backgroundColor = calculatedColor
    }

    func updateBackgroundColor() {
        self.view.backgroundColor = calculatedColor
    }

    func updateLabelsColor() {
        let labels = [
            colorNameLabel,
            firstSliderTitleLabel,
            firstSliderValueLabel,
            secondSliderTitleLabel,
            secondSliderValueLabel,
            thirdSliderTitleLabel,
            thirdSliderValueLabel
        ]
        
        for label in labels {
            label?.textColor = labelsColor
        }
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
            self.updateLabelsColor()
        })
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

    func updateHueSliderTrackVisibility() {
        switch colorModel {
        case .RGB:
            // Remove hue slider track
            if let hueSliderBackgroundImageView = firstSliderBackgroundView.viewWithTag(100) {
                hueSliderBackgroundImageView.removeFromSuperview()
            }
            
            // Restore maximum slider track
            firstSlider.maximumTrackTintColor = nil
        case .HSB:
            // Create hue slider track
            let hueSliderBackgroundImageView = UIImageView(image: #imageLiteral(resourceName: "SliderHueTrack"))
            // Place image where slider track would normally appear
            hueSliderBackgroundImageView.frame = CGRect(x: 0, y: firstSlider.frame.height / 2.2,
                                                        width: firstSlider.frame.width - 4,
                                                        height: 3)
            // Resize on device orientation change
            hueSliderBackgroundImageView.autoresizingMask = .flexibleWidth
            hueSliderBackgroundImageView.tag = 100
            firstSliderBackgroundView.addSubview(hueSliderBackgroundImageView)
            firstSliderBackgroundView.sendSubviewToBack(hueSliderBackgroundImageView)
            
            // Hide regular slider tracks
            firstSlider.minimumTrackTintColor = UIColor.clear
            firstSlider.maximumTrackTintColor = UIColor.clear
        }

    }

}

