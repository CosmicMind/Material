//
//  ErrorTextFieldValidator.swift
//  Material
//
//  Created by Orkhan Alikhanov on 30/05/2018.
//  Copyright © 2018 CosmicMind, Inc. All rights reserved.
//

import UIKit
import Motion

open class ErrorTextFieldValidator {
  public typealias ValidationClosure = (_ text: String) -> Bool
  open var closures: [(code: ValidationClosure, message: String)] = []
  open weak var textField: ErrorTextField?
  
  open var autoValidationType: AutoValidationType = .default
  open var isErrorShownOnce = false
  
  public init(textField: ErrorTextField) {
    self.textField = textField
    prepare()
  }
  
  open func prepare() {
    textField?.addTarget(self, action: #selector(checkIfErrorHasGone), for: .editingChanged)
  }
  
  @objc
  private func checkIfErrorHasGone() {
    guard let textField = textField else { return }
    
    switch autoValidationType {
    case .none: break
    case .custom(let closure):
      closure(textField)
    case .default:
      guard isErrorShownOnce else { return }
      textField.isValid()
    case .always:
      textField.isValid()
    }
  }
  
  @discardableResult
  open func isValid(isDeferred: Bool) -> Bool {
    guard let textField = textField else { return false }
    for block in closures {
      if !block.code(textField.text ?? "") {
        if !isDeferred {
          textField.error = block.message
          textField.isErrorRevealed = true
          isErrorShownOnce = true
        }
        return false
      }
    }
    if !isDeferred { textField.isErrorRevealed = false }
    return true
  }
  
  @discardableResult
  open func validate(message: String, when code: @escaping ValidationClosure) -> Self {
    closures.append((code, message))
    return self
  }
  
  public enum AutoValidationType {
    case none
    case `default`
    case always
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
  
  @discardableResult
  open func isValid(isDeferred: Bool = false) -> Bool {
    return validator.isValid(isDeferred: isDeferred)
  }
}

public extension ErrorTextFieldValidator {
  @discardableResult
  func email(message: String) -> Self {
    return regex(message: message, pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
  }
  
  @discardableResult
  func username(message: String) -> Self {
    return regex(message: message, pattern: "^[a-zA-Z0-9]+([_\\s\\-\\.\\']?[a-zA-Z0-9])*$")
  }
  
  @discardableResult
  func regex(message: String, pattern: String) -> Self {
    return validate(message: message) {
      let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
      return pred.evaluate(with: $0)
    }
  }
  
  @discardableResult
  func min(length: Int, message: String, trimmingSet: CharacterSet? = .whitespacesAndNewlines) -> Self {
    let trimmingSet = trimmingSet ?? .init()
    return validate(message: message) {
      $0.trimmingCharacters(in: trimmingSet).count >= length
    }
  }
  
  @discardableResult
  func notEmpty(message: String, trimmingSet: CharacterSet? = .whitespacesAndNewlines) -> Self {
    let trimmingSet = trimmingSet ?? .init()
    return validate(message: message) {
      $0.trimmingCharacters(in: trimmingSet).isEmpty == false
    }
  }
  
  @discardableResult
  func noWhitespaces(message: String) -> Self {
    return validate(message: message) {
      $0.rangeOfCharacter(from: .whitespaces) == nil
    }
  }
}

