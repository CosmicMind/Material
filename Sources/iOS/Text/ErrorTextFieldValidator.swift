/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Motion

/**
 Validator plugin for ErrorTextField and subclasses.
 Can be accessed via `textField.validator`
 ### Example
 ```swift
 field.validator
 .notEmpty(message: "Choose username")
 .min(length: 3, message: "Minimum 3 characters")
 .noWhitespaces(message: "Username cannot contain spaces")
 .username(message: "Unallowed characters in username")
 }
 ```
 */
open class ErrorTextFieldValidator {
  /// A typealias for validation closure.
  public typealias ValidationClosure = (_ text: String) -> Bool
  
  /// Validation closures and their error messages.
  open var closures: [(code: ValidationClosure, message: String)] = []
  
  /// A reference to the textField.
  open weak var textField: ErrorTextField?
  
  /// Behavior for auto-validation.
  open var autoValidationType: AutoValidationType = .default
  
  /**
   A flag indicating if error message is shown at least once.
   Used for `AutoValidationType.default`.
   */
  open var isErrorShownOnce = false
  
  /**
   Initializes validator.
   - Parameter textField: An ErrorTextField to validate.
   */
  public init(textField: ErrorTextField) {
    self.textField = textField
    prepare()
  }
  
  /**
   Prepares the validator instance when intialized. When subclassing,
   it is recommended to override the prepare method
   to initialize property values and other setup operations.
   The super.prepare method should always be called immediately
   when subclassing.
   */
  open func prepare() {
    textField?.addTarget(self, action: #selector(autoValidate), for: .editingChanged)
  }
  
  /**
   Validates textField based on `autoValidationType`.
   This method is called when textField.text changes.
   */
  @objc
  private func autoValidate() {
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
  
  /**
   Validates textField.text against criteria defined in `closures`
   and shows relevant error message on failure.
   - Parameter isDeferred: Defer showing error message.
   - Returns: Boolean indicating if validation passed.
   */
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
  
  
  /** Adds provided closure and its error message to the validation chain.
   - Parameter message: A message to be shown when validation fails.
   - Parameter code: Closure to run for validation.
   - Returns: Validator itself to allow chaining.
   */
  @discardableResult
  open func validate(message: String, when code: @escaping ValidationClosure) -> Self {
    closures.append((code, message))
    return self
  }
  
  
  /**
   Types for determining behaviour of auto-validation
   which is run when textField.text changes.
   */
  public enum AutoValidationType {
    /// Turn off.
    case none
    
    /// Run validation only if error is shown once.
    case `default`
    
    /// Always run validation.
    case always
    
    /**
     Custom auto-validation logic passed as closure
     which accepts ErrorTextField. Closure is called
     when `textField.text` changes.
     */
    case custom((ErrorTextField) -> Void)
  }
}

/// Memory key pointer for `validator`.
private var AssociatedInstanceKey: UInt8 = 0
extension ErrorTextField {
  /// A reference to validator.
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
  
  /**
   Validates textField.text against criteria defined in `closures`
   and shows relevant error message on failure.
   - Parameter isDeferred: Defer showing error message. Default is false.
   - Returns: Boolean indicating if validation passed.
   */
  @discardableResult
  open func isValid(isDeferred: Bool = false) -> Bool {
    return validator.isValid(isDeferred: isDeferred)
  }
}

public extension ErrorTextFieldValidator {
  /**
   Validate that field contains correct email address.
   - Parameter message: A message to show for incorrect emails.
   - Returns: Validator itself to allow chaining.
   */
  @discardableResult
  func email(message: String) -> Self {
    return regex(message: message, pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
  }
  
  /**
   Validate that field contains allowed usernames characters.
   - Parameter message: A message to show for disallowed usernames.
   - Returns: Validator itself to allow chaining.
   */
  @discardableResult
  func username(message: String) -> Self {
    return regex(message: message, pattern: "^[a-zA-Z0-9]+([_\\s\\-\\.\\']?[a-zA-Z0-9])*$")
  }
  
  /**
   Validate that field text matches provided regex pattern.
   - Parameter message: A message to show for unmatched texts.
   - Parameter pattern: A regex pattern to match.
   - Returns: Validator itself to allow chaining.
   */
  @discardableResult
  func regex(message: String, pattern: String) -> Self {
    return validate(message: message) {
      let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
      return pred.evaluate(with: $0)
    }
  }
  
  /**
   Validate that field text has minimum `length`.
   - Parameter length: Minimum allowed text length.
   - Parameter message: A message to show when requirement is not met.
   - Parameter trimmingSet: A trimming CharacterSet for trimming text before validation.
   - Returns: Validator itself to allow chaining.
   */
  @discardableResult
  func min(length: Int, message: String, trimmingSet: CharacterSet? = .whitespacesAndNewlines) -> Self {
    let trimmingSet = trimmingSet ?? .init()
    return validate(message: message) {
      $0.trimmingCharacters(in: trimmingSet).count >= length
    }
  }
  
  /**
   Validate that field text has maximum `length`.
   - Parameter length: Minimum allowed text length.
   - Parameter message: A message to show when requirement is not met.
   - Parameter trimmingSet: A trimming CharacterSet for trimming text before validation.
   - Returns: Validator itself to allow chaining.
   */
  @discardableResult
  func max(length: Int, message: String, trimmingSet: CharacterSet? = .whitespacesAndNewlines) -> Self {
    let trimmingSet = trimmingSet ?? .init()
    return validate(message: message) {
      $0.trimmingCharacters(in: trimmingSet).count <= length
    }
  }
  
  /**
   Validate that field text is not empty.
   - Parameter message: A message to show when requirement is not met.
   - Parameter trimmingSet: A trimming CharacterSet for trimming text before validation.
   - Returns: Validator itself to allow chaining.
   */
  @discardableResult
  func notEmpty(message: String, trimmingSet: CharacterSet? = .whitespacesAndNewlines) -> Self {
    let trimmingSet = trimmingSet ?? .init()
    return validate(message: message) {
      $0.trimmingCharacters(in: trimmingSet).isEmpty == false
    }
  }
  
  
  /**
   Validate that field text contains no whitespaces.
   - Parameter message: A message to show when requirement is not met.
   - Parameter trimmingSet: A trimming CharacterSet for trimming text before validation.
   - Returns: Validator itself to allow chaining.
   */
  @discardableResult
  func noWhitespaces(message: String) -> Self {
    return validate(message: message) {
      $0.rangeOfCharacter(from: .whitespaces) == nil
    }
  }
}
