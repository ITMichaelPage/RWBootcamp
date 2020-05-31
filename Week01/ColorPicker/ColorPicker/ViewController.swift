//
//  ViewController.swift
//  ColorPicker
//
//  Created by Michael Page on 31/5/20.
//  Copyright © 2020 Michael Page. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
    }

    @IBAction func setColor() {
        
    }

    @IBAction func resetValues() {
        
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        
    }

}

