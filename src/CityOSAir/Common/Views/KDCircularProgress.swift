//
//  KDCircularProgress.swift
//  KDCircularProgress
//
//  Created by Kaan Dedeoglu on 1/14/15.
//  Copyright (c) 2015 Kaan Dedeoglu. All rights reserved.
//

import UIKit

public enum KDCircularProgressGlowMode {
  case forward, reverse, constant, noGlow
}

public class KDCircularProgress: UIView, CAAnimationDelegate {

  private enum Conversion {
    static func degreesToRadians (value: CGFloat) -> CGFloat {
      return value * CGFloat.pi / 180.0
    }
  }

  private enum Utility {
    static func clamp<T: Comparable>(value: T, minMax: (T, T)) -> T {
      let (min, max) = minMax
      if value < min {
        return min
      } else if value > max {
        return max
      } else {
        return value
      }
    }

    static func inverseLerp(value: CGFloat, minMax: (CGFloat, CGFloat)) -> CGFloat {
      return (value - minMax.0) / (minMax.1 - minMax.0)
    }

    static func lerp(value: CGFloat, minMax: (CGFloat, CGFloat)) -> CGFloat {
      return (minMax.1 - minMax.0) * value + minMax.0
    }

    static func colorLerp(value: CGFloat, minMax: (UIColor, UIColor)) -> UIColor {
      let clampedValue = clamp(value: value, minMax: (0, 1))

      let zero = CGFloat(0)

      var (r0, g0, b0, a0) = (zero, zero, zero, zero)
      minMax.0.getRed(&r0, green: &g0, blue: &b0, alpha: &a0)

      var (r1, g1, b1, a1) = (zero, zero, zero, zero)
      minMax.1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)

      return UIColor(red: lerp(value: clampedValue, minMax: (r0, r1)), green: lerp(value: clampedValue, minMax: (g0, g1)), blue: lerp(value: clampedValue, minMax: (b0, b1)), alpha: lerp(value: clampedValue, minMax: (a0, a1)))
    }

    static func mod(value: Double, range: Double, minMax: (Double, Double)) -> Double {
      let (min, max) = minMax
      assert(abs(range) <= abs(max - min), "range should be <= than the interval")
      if value >= min && value <= max {
        return value
      } else if value < min {
        return mod(value: value + range, range: range, minMax: minMax)
      } else {
        return mod(value: value - range, range: range, minMax: minMax)
      }
    }
  }

  private var progressLayer: KDCircularProgressViewLayer {
    get {
      return layer as! KDCircularProgressViewLayer
    }
  }

  private var radius: CGFloat = 0 {
    didSet {
      progressLayer.radius = radius
    }
  }

  public var progress: Double = 0 {
    didSet {
      let clampedProgress = Utility.clamp(value: progress, minMax: (0, 1))
      angle = 360 * clampedProgress
    }
  }

  public var angle: Double = 0 {
    didSet {
      if self.isAnimating() {
        self.pauseAnimation()
      }
      progressLayer.angle = angle
    }
  }

  public var startAngle: Double = 0 {
    didSet {
      startAngle = Utility.mod(value: startAngle, range: 360, minMax: (0, 360))
      progressLayer.startAngle = startAngle
      progressLayer.setNeedsDisplay()
    }
  }

  public var clockwise: Bool = true {
    didSet {
      progressLayer.clockwise = clockwise
      progressLayer.setNeedsDisplay()
    }
  }

  public var roundedCorners: Bool = true {
    didSet {
      progressLayer.roundedCorners = roundedCorners
    }
  }

  public var lerpColorMode: Bool = false {
    didSet {
      progressLayer.lerpColorMode = lerpColorMode
    }
  }

  public var gradientRotateSpeed: CGFloat = 0 {
    didSet {
      progressLayer.gradientRotateSpeed = gradientRotateSpeed
    }
  }

  public var glowAmount: CGFloat = 1.0 { //Between 0 and 1
    didSet {
      glowAmount = Utility.clamp(value: glowAmount, minMax: (0, 1))
      progressLayer.glowAmount = glowAmount
    }
  }

  public var glowMode: KDCircularProgressGlowMode = .forward {
    didSet {
      progressLayer.glowMode = glowMode
    }
  }

  public var progressThickness: CGFloat = 0.4 { //Between 0 and 1
    didSet {
      progressThickness = Utility.clamp(value: progressThickness, minMax: (0, 1))
      progressLayer.progressThickness = progressThickness / 2
    }
  }

  public var trackThickness: CGFloat = 0.5 { //Between 0 and 1
    didSet {
      trackThickness = Utility.clamp(value: trackThickness, minMax: (0, 1))
      progressLayer.trackThickness = trackThickness / 2
    }
  }

  public var trackColor: UIColor = .black {
    didSet {
      progressLayer.trackColor = trackColor
      progressLayer.setNeedsDisplay()
    }
  }

  public var progressInsideFillColor: UIColor? = nil {
    didSet {
      progressLayer.progressInsideFillColor = progressInsideFillColor ?? .clear
    }
  }

  public var progressColors: [UIColor] {
    get {
      return progressLayer.colorsArray
    }

    set {
      set(colors: newValue)
    }
  }

  private var animationCompletionBlock: ((Bool) -> Void)?

  override public init(frame: CGRect) {
    super.init(frame: frame)
    isUserInteractionEnabled = false
    setInitialValues()
    refreshValues()
  }

  convenience public init(frame: CGRect, colors: UIColor...) {
    self.init(frame: frame)
    set(colors: colors)
  }

  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    translatesAutoresizingMaskIntoConstraints = false
    isUserInteractionEnabled = false
    setInitialValues()
    refreshValues()
  }

  override public class var layerClass: AnyClass {
    return KDCircularProgressViewLayer.self
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    radius = (frame.size.width / 2.0) //* 0.8
  }

  private func setInitialValues() {
    radius = (frame.size.width / 2.0) //* 0.8 //We always apply a 20% padding, stopping glows from being clipped
    backgroundColor = .clear
    set(colors: .white, .cyan)
  }

  private func refreshValues() {
    progressLayer.angle = angle
    progressLayer.startAngle = startAngle
    progressLayer.clockwise = clockwise
    progressLayer.roundedCorners = roundedCorners
    progressLayer.lerpColorMode = lerpColorMode
    progressLayer.gradientRotateSpeed = gradientRotateSpeed
    progressLayer.glowAmount = glowAmount
    progressLayer.glowMode = glowMode
    progressLayer.progressThickness = progressThickness / 2
    progressLayer.trackColor = trackColor
    progressLayer.trackThickness = trackThickness / 2
  }


  public func set(colors: UIColor...) {
    set(colors: colors)
  }

  private func set(colors: [UIColor]) {
    progressLayer.colorsArray = colors
    progressLayer.setNeedsDisplay()
  }

  public func animate(fromAngle: Double, toAngle: Double, duration: TimeInterval, relativeDuration: Bool = true, completion: ((Bool) -> Void)?) {
    if isAnimating() {
      pauseAnimation()
    }

    let animationDuration: TimeInterval
    if relativeDuration {
      animationDuration = duration
    } else {
      let traveledAngle = Utility.mod(value: toAngle - fromAngle, range: 304, minMax: (0, 304))
      let scaledDuration = (TimeInterval(traveledAngle) * duration) / 304
      animationDuration = scaledDuration
    }

    let animation = CABasicAnimation(keyPath: "angle")
    animation.fromValue = fromAngle
    animation.toValue = toAngle
    animation.duration = animationDuration
    animation.delegate = self
    animation.isRemovedOnCompletion = false
    angle = toAngle
    animationCompletionBlock = completion

    progressLayer.add(animation, forKey: "angle")
  }

  public func animate(toAngle: Double, duration: TimeInterval, relativeDuration: Bool = true, completion: ((Bool) -> Void)?) {
    if isAnimating() {
      pauseAnimation()
    }
    animate(fromAngle: angle, toAngle: toAngle, duration: duration, relativeDuration: relativeDuration, completion: completion)
  }

  public func pauseAnimation() {
    guard let presentationLayer = progressLayer.presentation() else { return }

    let currentValue = presentationLayer.angle
    progressLayer.removeAllAnimations()
    angle = currentValue
  }

  public func stopAnimation() {
    progressLayer.removeAllAnimations()
    angle = 0
  }

  public func isAnimating() -> Bool {
    return progressLayer.animation(forKey: "angle") != nil
  }

  public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if let completionBlock = animationCompletionBlock {
      animationCompletionBlock = nil
      completionBlock(flag)
    }
  }

  public override func didMoveToWindow() {
    if let window = window {
      progressLayer.contentsScale = window.screen.scale
    }
  }

  public override func willMove(toSuperview newSuperview: UIView?) {
    if newSuperview == nil && isAnimating() {
      pauseAnimation()
    }
  }

  public override func prepareForInterfaceBuilder() {
    setInitialValues()
    refreshValues()
    progressLayer.setNeedsDisplay()
  }

  private class KDCircularProgressViewLayer: CALayer {
    @NSManaged var angle: Double
    var radius: CGFloat = 0 {
      didSet {
        invalidateGradientCache()
      }
    }
    var startAngle: Double = 0
    var clockwise: Bool = true {
      didSet {
        if clockwise != oldValue {
          invalidateGradientCache()
        }
      }
    }
    var roundedCorners: Bool = true
    var lerpColorMode: Bool = false
    var gradientRotateSpeed: CGFloat = 0 {
      didSet {
        invalidateGradientCache()
      }
    }
    var glowAmount: CGFloat = 0
    var glowMode: KDCircularProgressGlowMode = .forward
    var progressThickness: CGFloat = 0.5
    var trackThickness: CGFloat = 0.5
    var trackColor: UIColor = .black
    var progressInsideFillColor: UIColor = .clear
    var colorsArray: [UIColor] = [] {
      didSet {
        invalidateGradientCache()
      }
    }
    private var gradientCache: CGGradient?
    private var locationsCache: [CGFloat]?

    private enum GlowConstants {
      private static let sizeToGlowRatio: CGFloat = 0.00015
      static func glowAmount(forAngle angle: Double, glowAmount: CGFloat, glowMode: KDCircularProgressGlowMode, size: CGFloat) -> CGFloat {
        switch glowMode {
        case .forward:
          return CGFloat(angle) * size * sizeToGlowRatio * glowAmount
        case .reverse:
          return CGFloat(360 - angle) * size * sizeToGlowRatio * glowAmount
        case .constant:
          return 360 * size * sizeToGlowRatio * glowAmount
        default:
          return 0
        }
      }
    }

    override class func needsDisplay(forKey key: String) -> Bool {
      return key == "angle" ? true : super.needsDisplay(forKey: key)
    }

    override init(layer: Any) {
      super.init(layer: layer)
      let progressLayer = layer as! KDCircularProgressViewLayer
      radius = progressLayer.radius
      angle = progressLayer.angle
      startAngle = progressLayer.startAngle
      clockwise = progressLayer.clockwise
      roundedCorners = progressLayer.roundedCorners
      lerpColorMode = progressLayer.lerpColorMode
      gradientRotateSpeed = progressLayer.gradientRotateSpeed
      glowAmount = progressLayer.glowAmount
      glowMode = progressLayer.glowMode
      progressThickness = progressLayer.progressThickness
      trackThickness = progressLayer.trackThickness
      trackColor = progressLayer.trackColor
      colorsArray = progressLayer.colorsArray
      progressInsideFillColor = progressLayer.progressInsideFillColor
    }

    override init() {
      super.init()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }

    override func draw(in ctx: CGContext) {
      UIGraphicsPushContext(ctx)

      let size = bounds.size
      let width = size.width
      let height = size.height

      let trackLineWidth = radius * trackThickness
      let progressLineWidth = radius * progressThickness
      let arcRadius = max(radius - trackLineWidth / 2, radius - progressLineWidth / 2)

      let start = Conversion.degreesToRadians(value: 62)
      let end = Conversion.degreesToRadians(value: 118)

      ctx.addArc(center: CGPoint(x: width / 2.0, y: height / 2.0), radius: arcRadius, startAngle: start, endAngle: end, clockwise: true)


      trackColor.set()
      ctx.setStrokeColor(trackColor.cgColor)
      ctx.setFillColor(progressInsideFillColor.cgColor)
      ctx.setLineWidth(trackLineWidth)
      ctx.setLineCap(CGLineCap.round)
      ctx.drawPath(using: .fillStroke)


      UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

      startAngle = 118

      let imageCtx = UIGraphicsGetCurrentContext()
      let reducedAngle = Utility.mod(value: angle, range: 304, minMax: (0, 304))
      let fromAngle = Conversion.degreesToRadians(value: CGFloat(-startAngle))

      let toAngle = Conversion.degreesToRadians(value: CGFloat((clockwise == true ? -reducedAngle : reducedAngle) - startAngle))

      imageCtx?.addArc(center: CGPoint(x: width / 2.0, y: height / 2.0), radius: arcRadius, startAngle: fromAngle, endAngle: toAngle, clockwise: clockwise)

      let glowValue = GlowConstants.glowAmount(forAngle: reducedAngle, glowAmount: glowAmount, glowMode: glowMode, size: width)
      if glowValue > 0 {
        imageCtx?.setShadow(offset: CGSize.zero, blur: glowValue, color: UIColor.black.cgColor)
      }

      let linecap: CGLineCap = roundedCorners == true ? .round : .butt
      imageCtx?.setLineCap(linecap)
      imageCtx?.setLineWidth(progressLineWidth)
      imageCtx?.drawPath(using: .stroke)

      let drawMask: CGImage = UIGraphicsGetCurrentContext()!.makeImage()!
      UIGraphicsEndImageContext()

      ctx.saveGState()
      ctx.clip(to: bounds, mask: drawMask)

      if let color = colorsArray.first {
        fillRectWith(context: ctx, color: color)
      }

      ctx.restoreGState()
      UIGraphicsPopContext()
    }

    private func fillRectWith(context: CGContext!, color: UIColor) {
      context.setFillColor(color.cgColor)
      context.fill(bounds)
    }

    private func drawGradientWith(context: CGContext!, componentsArray: [CGFloat]) {
      let baseSpace = CGColorSpaceCreateDeviceRGB()
      let locations = locationsCache ?? gradientLocationsFor(colorCount: componentsArray.count / 4, gradientWidth: bounds.size.width)
      let gradient: CGGradient

      if let cachedGradient = gradientCache {
        gradient = cachedGradient
      } else {
        guard let cachedGradient = CGGradient(colorSpace: baseSpace, colorComponents: componentsArray, locations: locations, count: componentsArray.count / 4) else {
          return
        }

        gradientCache = cachedGradient
        gradient = cachedGradient
      }

      let halfX = bounds.size.width / 2.0
      //            let floatPi = CGFloat.pi
      let rotateSpeed = clockwise == true ? gradientRotateSpeed : gradientRotateSpeed * -1
      let angleInRadians = Conversion.degreesToRadians(value: rotateSpeed * CGFloat(angle) - 360)
      //            let oppositeAngle = angleInRadians > floatPi ? angleInRadians - floatPi : angleInRadians + floatPi

      //            let startPoint = CGPoint(x: (cos(angleInRadians) * halfX) + halfX, y: (sin(angleInRadians) * halfX) + halfX)
      //            let endPoint = CGPoint(x: (cos(oppositeAngle) * halfX) + halfX, y: (sin(oppositeAngle) * halfX) + halfX)

      let startInRadians = Conversion.degreesToRadians(value: rotateSpeed * CGFloat(118) - 360)
      let start = CGPoint(x: (cos(startInRadians) * halfX) + halfX, y: (sin(startInRadians) * halfX) + halfX)
      let end = CGPoint(x: (cos(angleInRadians) * halfX) + halfX, y: (sin(angleInRadians) * halfX) + halfX)


      context.drawLinearGradient(gradient, start: start, end: end, options: .drawsBeforeStartLocation)

    }

    private func gradientLocationsFor(colorCount: Int, gradientWidth: CGFloat) -> [CGFloat] {
      if colorCount == 0 || gradientWidth == 0 {
        return []
      } else {
        let progressLineWidth = radius * progressThickness
        let firstPoint = gradientWidth / 2 - (radius - progressLineWidth / 2)
        let increment = (gradientWidth - (2 * firstPoint)) / CGFloat(colorCount - 1)

        let locationsArray = (0..<colorCount).map { firstPoint + (CGFloat($0) * increment) }
        let result = locationsArray.map { $0 / gradientWidth }
        locationsCache = result
        return result
      }
    }

    private func invalidateGradientCache() {
      gradientCache = nil
      locationsCache = nil
    }
  }
}
