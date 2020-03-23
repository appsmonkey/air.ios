//
//  BalloonMarker.swift
//  CityOSAir
//
//  Created by Andrej Saric on 19/12/2016.
//  Copyright © 2016 CityOS. All rights reserved.
//

import Foundation
import Charts

class BalloonMarker: MarkerImage {
  var color: UIColor?
  var arrowSize = CGSize(width: 15, height: 11)
  var font: UIFont?
  var textColor: UIColor?
  var insets = UIEdgeInsets()
  var minimumSize = CGSize()

  fileprivate var labelns: NSMutableAttributedString?
  fileprivate var _labelSize: CGSize = CGSize()
  fileprivate var _paragraphStyle: NSMutableParagraphStyle?

  init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets) {
    super.init()

    self.color = color
    self.font = font
    self.textColor = textColor
    self.insets = insets

    _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
    _paragraphStyle?.alignment = .center
  }

  override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
    let size = self.size
    var point = point
    point.x -= size.width / 2.0
    point.y -= size.height
    return super.offsetForDrawing(atPoint: point)
  }

  override func draw(context: CGContext, point: CGPoint) {
    if labelns == nil
      {
      return
    }

    let offset = self.offsetForDrawing(atPoint: point)
    let size = self.size

    var rect = CGRect(
      origin: CGPoint(
        x: point.x + offset.x,
        y: point.y + offset.y),
      size: size)
    rect.origin.x -= size.width / 2.0
    rect.origin.y -= size.height

    if let color = color
      {
      var myRect = rect
      myRect.size.height -= arrowSize.height
      let bezier = UIBezierPath(roundedRect: myRect, cornerRadius: 5)

      bezier.addLine(to: CGPoint(
        x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
        y: rect.origin.y + rect.size.height - arrowSize.height))

      bezier.addLine(to: CGPoint(
        x: rect.origin.x + rect.size.width / 2.0,
        y: rect.origin.y + rect.size.height))

      bezier.addLine(to: CGPoint(
        x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
        y: rect.origin.y + rect.size.height - arrowSize.height))

      color.setFill()
      UIColor.fromHex("e6e6e6").setStroke()
      bezier.stroke()
      bezier.fill()
    }

    rect.origin.y += self.insets.top
    rect.size.height -= self.insets.top + self.insets.bottom

    labelns?.draw(in: rect)
  }

  func setLabel(_ timestamp: String, value: String, notation: String) {

    let attributedTimestamp = NSMutableAttributedString(string: timestamp, attributes: [NSAttributedString.Key.font: UIFont.appRegularWithSize(6), NSAttributedString.Key.foregroundColor: UIColor.fromHex("b3b3b3")])

    let attributedValue = NSMutableAttributedString(string: value, attributes: [NSAttributedString.Key.font: UIFont.appMediumWithSize(7.5), NSAttributedString.Key.foregroundColor: UIColor.fromHex("000000")])

    let attributedNotation = NSMutableAttributedString(string: " \(notation)", attributes: [NSAttributedString.Key.font: UIFont.appRegularWithSize(5.5), NSAttributedString.Key.foregroundColor: UIColor.fromHex("b3b3b3")])

    attributedTimestamp.append(NSAttributedString(string: "\n"))
    attributedTimestamp.append(attributedValue)
    attributedTimestamp.append(attributedNotation)

    attributedTimestamp.addAttribute(NSAttributedString.Key.paragraphStyle, value: _paragraphStyle as Any, range: NSRange(location: 0, length: attributedTimestamp.length))

    labelns = attributedTimestamp

    _labelSize = labelns?.size() ?? CGSize.zero

    var size = CGSize()
    size.width = _labelSize.width + self.insets.left + self.insets.right
    size.height = _labelSize.height + self.insets.top + self.insets.bottom
    size.width = max(minimumSize.width, size.width)
    size.height = max(minimumSize.height, size.height)

    size.width += 10

    self.size = size
  }
}



