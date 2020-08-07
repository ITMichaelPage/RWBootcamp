//
//  ViewController.swift
//  Animations
//
//  Created by Michael Page on 7/8/20.
//  Copyright © 2020 Michael Page. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet var centerButton: UIButton!
  @IBOutlet var colorButton: UIButton!
  @IBOutlet var sizeButton: UIButton!
  @IBOutlet var speedButton: UIButton!
  
  private var menuIsOpen = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
}

extension ViewController {
  
  @IBAction func centerButtonPressed() {
    // Disable the center button
    centerButton.isEnabled = false
    delay(seconds: 0.5) {
      // Renable the center button
      self.centerButton.isEnabled = true
    }
    
    menuIsOpen.toggle()

    UIView.animateKeyframes(
      withDuration: 0.6,
      delay: 0,
      animations: { [colorButton = self.colorButton!, sizeButton = self.sizeButton!, speedButton = self.speedButton!] in
        
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
          if self.menuIsOpen {
            // Move external buttons into the middle
            colorButton.center.x -= 100
            sizeButton.center.y -= 100
            speedButton.center.x += 100
          } else {
            // Move external buttons out from the middle
            colorButton.center.x += 100
            sizeButton.center.y += 100
            speedButton.center.x -= 100
          }
        }
      }
    )
  }
  
}
