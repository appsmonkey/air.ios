//
//  TextExtensions.swift
//  CityOSAir
//
//  Created by Haris Kovacevic on 05/06/2019.
//  Copyright © 2019 CityOS. All rights reserved.
//

import Foundation
import UIKit

extension String {

  func attributedString(attributes: [NSAttributedString.Key: Any]? = nil) -> NSMutableAttributedString {
    return NSMutableAttributedString(string: self, attributes: attributes)
  }

  func isValidPassword() -> Bool {
    let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[ !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~])[A-Za-z\\d !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~]{8,}"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
  }

  /// Returns localized string for the current locale. If the key doesn't exist, `self` is returned.
  func localized(_ args: CVarArg...) -> String {
    guard !isEmpty else { return self }
    let localizedString = NSLocalizedString(self, comment: "")
    return withVaList(args) { NSString(format: localizedString, locale: Locale.current, arguments: $0) as String }
  }

  /// Email validation
  var isEmail: Bool {
    let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    //let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: self)
  }

  func dateFromString() -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss"//"yyy-MM-dd'T'HH:mm:ss.SSSZ"

    if let date = formatter.date(from: self) {
      return date.toLocalTime()
    }

    return nil
  }

  func chartPointDateFromStringForTimeframe(timeframe: Timeframe) -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = timeframe == .week ? "yyy-MM-dd" : "yyy-MM-dd'T'HH:mm:ss"//"yyy-MM-dd'T'HH:mm:ss"

    if let date = formatter.date(from: self) {
      return date.toLocalTime()
    }

    return nil
  }

  func truncate(length: Int, trailing: String = "…") -> String {
    if self.count > length {
      return String(self.prefix(length)) + trailing
    } else {
      return self
    }
  }
}

extension NSMutableAttributedString {
  func makeBold(string: String, fontSize: Double = 12.0) -> NSMutableAttributedString {
    let range = (self.string as NSString).range(of: string)
    self.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: CGFloat(fontSize)), range: range)
    return self
  }

  func makeLink(string: String, link: String) -> NSMutableAttributedString {
    let range = (self.string as NSString).range(of: string)
    self.addAttribute(.link, value: link, range: range)
    return self
  }
}

extension Optional where Wrapped: Collection {
  var isNilOrEmpty: Bool {
    return self?.isEmpty ?? true
  }
}
