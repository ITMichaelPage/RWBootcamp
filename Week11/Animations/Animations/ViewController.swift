//
//  ViewController.swift
//  Animations
//
//  Created by Michael Page on 7/8/20.
//  Copyright © 2020 Michael Page. All rights reserved.
//

import UIKit

enum ObjectAnimation {
  case colorChange
  case sizeChange
  case positionChange
}

class ViewController: UIViewController {
  
  @IBOutlet var centerButton: UIButton!
  @IBOutlet var colorButton: UIButton!
  @IBOutlet var sizeButton: UIButton!
  @IBOutlet var speedButton: UIButton!
  @IBOutlet var animationObject: UIView!
  
  private var menuIsOpen = false
  private var queuedAnimations: [ObjectAnimation] = []
  
  private var animationObjectIsRed: Bool {
    animationObject.backgroundColor == UIColor.red
  }
  private var animationObjectIsBig: Bool {
    animationObject.transform.scale > 1
  }
  private var animationObjectIsOnRightSideOfScreen: Bool {
    animationObject.center.x > UIScreen.main.bounds.width / 2
  }
  
  
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
    
    if menuIsOpen {
      applyObjectAnimations()
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
  
  @IBAction func addAnimationButtonPressed(_ sender: UIButton) {
    switch sender {
    case colorButton:
      queuedAnimations.append(.colorChange)
    case sizeButton:
      queuedAnimations.append(.sizeChange)
    case speedButton:
      queuedAnimations.append(.positionChange)
    default:
      print("Error: Unknown button pressed!")
    }
  }
  
}

extension ViewController {
  
  func applyObjectAnimations() {
    queuedAnimations.forEach { (objectAnimation: ObjectAnimation) in
      
      UIView.animate(withDuration: 1) {
        switch objectAnimation {
        case .colorChange:
          let color = self.animationObjectIsRed ? UIColor.black : UIColor.red
          self.animationObject.backgroundColor = color
        case .sizeChange:
          let scale = self.animationObjectIsBig ? .identity : CGAffineTransform(scaleX: 2, y: 2)
          self.animationObject.transform = scale
        case .positionChange:
          let newCenterPosition = self.animationObjectIsOnRightSideOfScreen ?  CGPoint(x: 90, y: 410) : CGPoint(x: 290, y: 510)
          self.animationObject.center = newCenterPosition
        }
      }
      
    }
    
    queuedAnimations.removeAll()
  }
  
}
