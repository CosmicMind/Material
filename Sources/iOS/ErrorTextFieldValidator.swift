//
//  ErrorTextFieldValidator.swift
//  Material
//
//  Created by Orkhan Alikhanov on 30/05/2018.
//  Copyright © 2018 CosmicMind, Inc. All rights reserved.
//

import UIKit
import Motion

open class ErrorTextFieldValidator: NSObject {
  public typealias ValidationClosure = (String) -> Bool
  open var closures: [(code: ValidationClosure, msg: String)] = []
  open weak var textField: ErrorTextField?
  
  open var autoValidationType: AutoValidationType = .default
  open var autoValidateOnlyIfErrorIsShownOnce = true
  open var isErrorShownOnce = false
  
  public init(textField: ErrorTextField) {
    self.textField = textField
    super.init()
    
    textField.addTarget(self, action: #selector(checkIfErrorHasGone), for: .editingChanged)
  }
  
  @objc
  private func checkIfErrorHasGone() {
    guard let textField = textField else { return }
    if autoValidateOnlyIfErrorIsShownOnce && !isErrorShownOnce { return }
    
    switch autoValidationType {
    case .none: break
    case .custom(let closure):
      closure(textField)
    case .default:
        _  = textField.isValid() // will hide if needed
    }
  }
  
  open func isValid(deferred: Bool) -> Bool {
    guard let textField = textField else { return false }
    if !deferred { textField.isErrorRevealed = false }
    for block in closures {
      if !block.code(textField.text ?? "") {
        if !deferred {
          textField.error = block.msg
          textField.isErrorRevealed = true
          isErrorShownOnce = true
        }
        return false
      }
    }
    return true
  }
  
  @discardableResult
  open func validate(msg: String, when code: @escaping ValidationClosure) -> Self {
    closures.append((code, msg))
    return self
  }
  
  public enum AutoValidationType {
    case none
    case `default`
    case custom((ErrorTextField) -> Void)
  }
}

private var AssociatedInstanceKey: UInt8 = 0
extension ErrorTextField {
  open var validator: ErrorTextFieldValidator {
    get {
      return AssociatedObject.get(base: self, key: &AssociatedInstanceKey) {
        return ErrorTextFieldValidator(textField: self)
      }
    }
    set(value) {
      AssociatedObject.set(base: self, key: &AssociatedInstanceKey, value: value)
    }
  }
  
  open func isValid(deferred: Bool = false) -> Bool {
    return validator.isValid(deferred: deferred)
  }
}

public extension ErrorTextFieldValidator {
  @discardableResult
  func email(msg: String) -> Self {
    return regex(msg: msg, pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
  }
  
  @discardableResult
  func username(msg: String) -> Self {
    return regex(msg: msg, pattern: "^[a-zA-Z0-9]+([_\\s\\-\\.\\']?[a-zA-Z0-9])*$")
  }
  
  @discardableResult
  func regex(msg: String, pattern: String) -> Self {
    return validate(msg: msg) {
      let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
      return pred.evaluate(with: $0)
    }
  }
  
  @discardableResult
  func min(length: Int, msg: String, trimmingSet: CharacterSet? = .whitespacesAndNewlines) -> Self {
    let trimmingSet = trimmingSet ?? .init()
    return validate(msg: msg) {
      $0.trimmingCharacters(in: trimmingSet).count >= length
    }
  }
  
  @discardableResult
  func notEmpty(msg: String, trimmingSet: CharacterSet? = .whitespacesAndNewlines) -> Self {
    let trimmingSet = trimmingSet ?? .init()
    return validate(msg: msg) {
      $0.trimmingCharacters(in: trimmingSet).isEmpty == false
    }
  }
  
  @discardableResult
  func noWhitespaces(msg: String) -> Self {
    return validate(msg: msg) {
      $0.rangeOfCharacter(from: .whitespaces) == nil
    }
  }
}

