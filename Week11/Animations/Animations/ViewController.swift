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
  @IBOutlet weak var notificationView: UIView!
  @IBOutlet weak var notificationViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var notificationStatusImageView: UIImageView!
  @IBOutlet weak var notificationStatusMessageLabel: UILabel!
  
  private var menuIsOpen = false
  private var queuedAnimations: [ObjectAnimation] = []
  private var queuedNotifications: [NotificationMessageStatus] = []
  private let animationNotificationsGroup = DispatchGroup()
  private var notificationIsVisible = false
  
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
    hideNotification()
    setAnimationObjectImage()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  func setAnimationObjectImage() {
    animationObject.layer.contents = #imageLiteral(resourceName: "PaperBoo").cgImage
  }
  
}

extension ViewController {
  
  @IBAction func centerButtonPressed() {
    disableButtons(for: 0.3)
    
    if menuIsOpen {
      applyObjectAnimations()
    }
    
    menuIsOpen.toggle()
    
    animateMenuState()
  }
  
  private func disableButtons(for duration: TimeInterval) {
    let buttons = [centerButton, colorButton, sizeButton, speedButton]
    
    buttons.forEach { (button) in
      // Disable button
      button?.isEnabled = false
      
      delay(seconds: duration) {
        // Re-enable the button
        button?.isEnabled = true
      }
    }
  }
  
  private func animateMenuState() {
    
    UIView.animate(withDuration: 0.3) {
      if self.menuIsOpen {
        // Move external buttons into the middle
        self.colorButton.center.x -= 100
        self.sizeButton.center.y -= 100
        self.speedButton.center.x += 100
      } else {
        // Move external buttons out from the middle
        self.colorButton.center.x += 100
        self.sizeButton.center.y += 100
        self.speedButton.center.x -= 100
      }
      self.view.layoutIfNeeded()
    }
  }
  
  @IBAction func addAnimationButtonPressed(_ sender: UIButton) {
    switch sender {
    case colorButton:
      queuedAnimations.append(.colorChange)
      queuedNotifications.append(.success)
    case sizeButton:
      queuedAnimations.append(.sizeChange)
      queuedNotifications.append(.success)
    case speedButton:
      queuedAnimations.append(.positionChange)
      queuedNotifications.append(.success)
    default:
      print("Error: Unknown button pressed!")
    }
    
    processNotificationsQueue()
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

extension ViewController {
  
  enum NotificationMessageStatus {
    case success, failure
  }
  
  func hideNotification() {
    notificationViewTopConstraint.constant -= 120
  }
  
  func configureNotification(for notificationMessageStatus: NotificationMessageStatus) {
    notificationView.layer.cornerRadius = 10
    
    switch notificationMessageStatus {
    case .success:
      notificationStatusImageView.image = UIImage(systemName: "checkmark.circle.fill")
      notificationStatusImageView.tintColor = .systemGreen
      notificationStatusMessageLabel.text = "Animation successfully added"
    case .failure:
      notificationStatusImageView.image = UIImage(systemName: "xmark.circle.fill")
      notificationStatusImageView.tintColor = .systemRed
      notificationStatusMessageLabel.text = "Failed to add animation"
    }
  }
  
  func displayNotification(notificationMessageStatus: NotificationMessageStatus) {
    self.configureNotification(for: notificationMessageStatus)
    self.notificationIsVisible = true
    
    UIView.animate(
      withDuration: 1.0,
      animations: {
        self.notificationView.center = CGPoint(x: 207, y: 74)
      },
      group: animationNotificationsGroup,
      completion: { _ in
        UIView.animate(
          withDuration: 1.3,
          animations: {
            self.notificationView.center = CGPoint(x: 207, y: -46)
          },
          group: self.animationNotificationsGroup,
          completion: { _ in
            self.notificationIsVisible = false
          }
        )
      }
    )
  }
  
  func processNotificationsQueue() {
    // Ensure a notification is not currently visible and a pending notification is present
    guard !notificationIsVisible, let nextNotification = queuedNotifications.first else {
      return
    }
    
    queuedNotifications.removeFirst()
    
    displayNotification(notificationMessageStatus: nextNotification)
    
    self.animationNotificationsGroup.notify(queue: DispatchQueue.main) {
      // Trigger processNotificationsQueue to display the next notification in the queue
      self.processNotificationsQueue()
    }
  }
  
}
