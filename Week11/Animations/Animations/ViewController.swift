//
//  ViewController.swift
//  Animations
//
//  Created by Michael Page on 7/8/20.
//  Copyright © 2020 Michael Page. All rights reserved.
//

import UIKit

enum ObjectAnimation {
  case opacityChange
  case sizeChange
  case positionChange
}

class ViewController: UIViewController {
  
  @IBOutlet var centerButton: UIButton!
  @IBOutlet var opacityButton: UIButton!
  @IBOutlet var sizeButton: UIButton!
  @IBOutlet var changePositionButton: UIButton!
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
  
  private var animationObjectIsTranslucent: Bool {
    animationObject.alpha < 1
  }
  private var animationObjectIsBig: Bool {
    animationObject.transform.scale > 1
  }
  private var animationObjectScaleMultiplier: CGFloat {
    self.animationObjectIsBig ? 2 : 1
  }
  private var animationObjectIsOnRightSideOfScreen: Bool {
    animationObject.center.x > UIScreen.main.bounds.width / 2
  }
  private var animationObjectIsFacingRightSideOfScreen = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    hideNotification()
    setAnimationObjectImage()
    animationObject.alpha = 0
    setButtonImages()
    NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    curlDownBooTransition(duration: 2)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  @objc private func applicationWillEnterForeground() {
    animateBooHover()
  }
  
  func setAnimationObjectImage() {
    animationObject.layer.contents = #imageLiteral(resourceName: "PaperBoo").cgImage
  }
  
  private func setButtonImages() {
    centerButton.setImage(UIImage(named: "PlayButton"), for: .normal)
    opacityButton.setImage(UIImage(named: "ChangeOpacityButton"), for: .normal)
    sizeButton.setImage(UIImage(named: "IncreaseSizeButton"), for: .normal)
    changePositionButton.setImage(UIImage(named: "ChangePositionButton"), for: .normal)
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
    let buttons = [centerButton, opacityButton, sizeButton, changePositionButton]
    
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
        self.opacityButton.center.x -= 100
        self.sizeButton.center.y -= 100
        self.changePositionButton.center.x += 100
      } else {
        // Move external buttons out from the middle
        self.opacityButton.center.x += 100
        self.sizeButton.center.y += 100
        self.changePositionButton.center.x -= 100
      }
      self.view.layoutIfNeeded()
    }
  }
  
  @IBAction func addAnimationButtonPressed(_ sender: UIButton) {
    switch sender {
    case opacityButton:
      queuedAnimations.append(.opacityChange)
      queuedNotifications.append(.success)
    case sizeButton:
      queuedAnimations.append(.sizeChange)
      queuedNotifications.append(.success)
    case changePositionButton:
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
            
      UIView.animate(
        withDuration: 1,
        animations: {
          switch objectAnimation {
          case .opacityChange:
            let newOpacity: CGFloat = self.animationObjectIsTranslucent ? 1 : 0.2
            self.animationObject.alpha = newOpacity
          case .sizeChange:
            let newScaleMultiplier: CGFloat = self.animationObjectScaleMultiplier == 1 ? 2 : 1
            // Increase the size of Boo without changing the facing direction
            let scaleX: CGFloat = (self.animationObjectIsFacingRightSideOfScreen ? 1 : -1) * newScaleMultiplier
            let y: CGFloat = 1 * newScaleMultiplier
            self.animationObject.transform = CGAffineTransform(scaleX: scaleX, y: y)
          case .positionChange:
            let newCenterPosition = self.animationObjectIsOnRightSideOfScreen ?  CGPoint(x: 90, y: 210) : CGPoint(x: 290, y: 410)
            self.animationObject.center = newCenterPosition
          }
        },
        completion: { _ in
          if objectAnimation == .positionChange {
            // Start hovering again
            self.animateBooHover()
            // Flip Boo to face the center
            self.horizontallyFlipBoo()
          }
        }
      )
      
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

extension ViewController {
  
  private func animateBooHover() {
    UIView.animate(
      withDuration: 1.5,
      delay: 0,
      options: [.repeat, .autoreverse],
      animations: {
        self.animationObject.center.y += 24
      },
      completion: nil
    )
  }
  
  private func horizontallyFlipBoo() {
    UIView.animate(
      withDuration: 0.7,
      animations: {
        let scaleX: CGFloat = (self.animationObjectIsFacingRightSideOfScreen ? -1 : 1) * self.animationObjectScaleMultiplier
        let y: CGFloat = 1 * self.animationObjectScaleMultiplier
        self.animationObject.transform = CGAffineTransform(scaleX: scaleX, y: y)
        self.animationObjectIsFacingRightSideOfScreen.toggle()
      },
      completion: nil
    )
  }
  
  private func curlDownBooTransition(duration: TimeInterval) {
    UIView.transition(
      with: animationObject,
      duration: duration,
      options: [.transitionCurlDown],
      animations: {
        self.animationObject.alpha = 1
      },
      completion: nil
    )
  }
  
}
