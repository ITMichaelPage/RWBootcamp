//
//  CustomSwitch.swift
//  Cryptly
//
//  Modified by Michael Page on 15/6/20.
//  Code heavily based on Nathan Tannar's Re-Engineering UISwitch blog post: https://blog.prototypr.io/re-engineering-uiswitch-9a82f270edfd
//

import UIKit

class CustomSwitch: UIControl {
  
  var isOn: Bool = false {
    didSet {
      stateDidChange()
    }
  }
  
  var borderWidth: CGFloat = 2 {
    didSet {
      trackLayer.borderWidth = borderWidth
      layoutSublayers(of: layer)
    }
  }
  
  var trackTopBottomPadding: CGFloat = 0 {
    didSet {
      layoutSublayers(of: layer)
    }
  }
  
  var contentLeadingTrailingPadding: CGFloat = 0 {
    didSet {
      layoutSublayers(of: layer)
    }
  }
  
  var thumbRadiusPadding: CGFloat = 0 {
    didSet {
      layoutThumbLayer(for: layer.bounds)
    }
  }
  
  var onTintColor: UIColor = #colorLiteral(red: 0.2078431373, green: 0.7764705882, blue: 0.3490196078, alpha: 1) {
    didSet {
      trackLayer.backgroundColor = getBackgroundColor()
    }
  }
  
  var offBorderTintColor: UIColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9019607843, alpha: 1) {
    didSet {
      trackLayer.backgroundColor = getBackgroundColor()
      (offContentLayer as? CATextLayer)?.foregroundColor = offBorderTintColor.cgColor
    }
  }
  
  var thumbTintColor: UIColor = .white {
    didSet {
      thumbLayer.backgroundColor = thumbTintColor.cgColor
      (onContentLayer as? CATextLayer)?.foregroundColor = thumbTintColor.cgColor
    }
  }
  
  var thumbImage: CGImage? {
    didSet {
      thumbLayer.contents = thumbImage
    }
  }
  
  var onImage: CGImage? {
    didSet {
      addOnImageLayerIfNeeded()
      onContentLayer?.contents = onImage
    }
  }
  
  var offImage: CGImage? {
    didSet {
      addOffImageLayerIfNeeded()
      offContentLayer?.contents = offImage
    }
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: 52, height: 31)
  }
  
  let trackLayer = CALayer()
  let innerLayer = CALayer()
  let thumbLayer = CALayer()
  private let contentsLayer = CALayer()
  
  var onContentLayer: CALayer? {
    willSet {
      onContentLayer?.removeFromSuperlayer()
    }
    didSet {
      layoutOnContentLayer(for: layer.bounds)
    }
  }
  
  var offContentLayer: CALayer? {
    willSet {
      offContentLayer?.removeFromSuperlayer()
    }
    didSet {
      layoutOffContentLayer(for: layer.bounds)
    }
  }
  
  private var isTouchDown: Bool = false
  
  convenience init() {
    self.init(frame: .zero)
    frame.size = intrinsicContentSize
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    controlDidLoad()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    controlDidLoad()
  }
  
  func controlDidLoad() {
    layer.addSublayer(trackLayer)
    layer.addSublayer(innerLayer)
    layer.addSublayer(contentsLayer)
    layer.addSublayer(thumbLayer)
    
    trackLayer.backgroundColor = getBackgroundColor()
    trackLayer.borderColor = getBackgroundColor()
    trackLayer.borderWidth = borderWidth
    
    innerLayer.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9019607843, alpha: 1)
    
    contentsLayer.masksToBounds = true
    
    thumbLayer.backgroundColor = thumbTintColor.cgColor
    thumbLayer.shadowColor = UIColor.gray.cgColor
    thumbLayer.shadowRadius = 2
    thumbLayer.shadowOpacity = 0.4
    thumbLayer.shadowOffset = CGSize(width: 0.75, height: 2)
    thumbLayer.contentsGravity = .resizeAspect
    
    addTouchHandlers()
    
    layoutSublayers(of: layer)
  }
  
  override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)
    layoutTrackLayer(for: layer.bounds)
    layoutInnerLayer(for: layer.bounds)
    layoutThumbLayer(for: layer.bounds)
    layoutContentsLayer(for: layer.bounds)
    layoutOffContentLayer(for: layer.bounds)
    layoutOnContentLayer(for: layer.bounds)
  }
  
  func layoutTrackLayer(for bounds: CGRect) {
    trackLayer.frame = bounds.insetBy(dx: trackTopBottomPadding, dy: trackTopBottomPadding)
    trackLayer.cornerRadius = trackLayer.bounds.height / 2
  }
  
  func layoutInnerLayer(for bounds: CGRect) {
    let inset = borderWidth + trackTopBottomPadding
    let isInnerHidden = isOn || isTouchDown
    innerLayer.frame = isInnerHidden
      ? CGRect(origin: trackLayer.position, size: .zero)
      : bounds.insetBy(dx: inset, dy: inset)
    innerLayer.cornerRadius = isInnerHidden
      ? 0
      : bounds.height / 2 - inset
  }
  
  func layoutThumbLayer(for bounds: CGRect) {
    let size = getThumbSize()
    let origin = getThumbOrigin(for: size.width)
    thumbLayer.frame = CGRect(origin: origin, size: size)
    thumbLayer.cornerRadius = size.height / 2
  }
  
  func layoutContentsLayer(for bounds: CGRect) {
    contentsLayer.frame = bounds
    contentsLayer.cornerRadius = contentsLayer.bounds.height / 2
  }
  
  func layoutOffContentLayer(for bounds: CGRect) {
    let isTextLayer = offContentLayer is CATextLayer
    let size = getContentLayerSize(for: offContentLayer)
    let y = isTextLayer
      ? bounds.midY - size.height / 2
      : borderWidth
    let leading = contentLeadingTrailingPadding + borderWidth
    let x = !isOn ? bounds.width - size.width - leading : bounds.width
    let origin = CGPoint(x: x, y: y)
    offContentLayer?.frame = CGRect(origin: origin, size: size)
  }
  
  func layoutOnContentLayer(for bounds: CGRect) {
    let isTextLayer = onContentLayer is CATextLayer
    let size = getContentLayerSize(for: onContentLayer)
    let y = isTextLayer
      ? bounds.midY - size.height / 2
      : borderWidth
    let leading = contentLeadingTrailingPadding + borderWidth
    let x = isOn ? leading : -bounds.width / 2
    let origin = CGPoint(x: x, y: y)
    onContentLayer?.frame = CGRect(origin: origin, size: size)
  }
  
  func stateDidChange() {
    sendActions(for: .valueChanged)
    trackLayer.backgroundColor = getBackgroundColor()
    trackLayer.borderWidth = isOn ? 0 : borderWidth
  }
  
  func setOn(_ on: Bool, animated: Bool) {
    CATransaction.begin()
    CATransaction.setDisableActions(!animated)
    isOn = on
    layoutSublayers(of: layer)
    sendActions(for: .valueChanged)
    CATransaction.commit()
  }
  
  // MARK: - Touches
  private func addTouchHandlers() {
    addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
    addTarget(self, action: #selector(touchUp), for: [.touchUpInside])
    addTarget(self, action: #selector(touchEnded), for: [.touchDragExit, .touchCancel])
    
    let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftRight(_:)))
    leftSwipeGesture.direction = [.left]
    addGestureRecognizer(leftSwipeGesture)
    
    let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftRight(_:)))
    rightSwipeGesture.direction = [.right]
    addGestureRecognizer(rightSwipeGesture)
  }
  
  @objc private func swipeLeftRight(_ gesture: UISwipeGestureRecognizer) {
    let canLeftSwipe = isOn && gesture.direction == .left
    let canRightSwipe = !isOn && gesture.direction == .right
    guard canLeftSwipe || canRightSwipe else { return }
    touchUp()
  }
  
  @objc private func touchDown() {
    isTouchDown = true
    layoutSublayers(of: layer)
  }
  
  @objc private func touchUp() {
    isOn.toggle()
    touchEnded()
  }
  
  @objc private func touchEnded() {
    isTouchDown = false
    layoutSublayers(of: layer)
  }
  
  // MARK: - Layout Helper
  final func getBackgroundColor() -> CGColor {
    return (isOn ? onTintColor : offBorderTintColor).cgColor
  }
  
  final func getThumbSize() -> CGSize {
    let height = bounds.height - 2 * (borderWidth + thumbRadiusPadding)
    let width = isTouchDown ? height * 1.2 : height
    return CGSize(width: width, height: height)
  }
  
  final func getThumbOrigin(for width: CGFloat) -> CGPoint {
    let inset = borderWidth + thumbRadiusPadding
    let x = isOn ? bounds.width - width - inset : inset
    return CGPoint(x: x, y: inset)
  }
  
  final func getContentLayerSize(for layer: CALayer?) -> CGSize {
    let inset = 2 * (borderWidth + trackTopBottomPadding)
    let diameter = bounds.height - inset
    if let textLayer = layer as? CATextLayer {
      return textLayer.preferredFrameSize()
    }
    return CGSize(width: diameter, height: diameter)
  }
  
  // MARK: - Content Layers
  private func addOnImageLayerIfNeeded() {
    guard onImage != nil else {
      onContentLayer = nil
      return
    }
    let imageLayer = CALayer()
    imageLayer.contentsGravity = .resizeAspectFill
    imageLayer.contentsScale = UIScreen.main.scale
    contentsLayer.addSublayer(imageLayer)
    onContentLayer = imageLayer
  }
  
  private func addOffImageLayerIfNeeded() {
    guard offImage != nil else {
      offContentLayer = nil
      return
    }
    let imageLayer = CALayer()
    imageLayer.contentsGravity = .resizeAspectFill
    imageLayer.contentsScale = UIScreen.main.scale
    contentsLayer.addSublayer(imageLayer)
    offContentLayer = imageLayer
  }
  
}
