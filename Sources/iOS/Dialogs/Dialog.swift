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

@objc
public protocol DialogDelegate {
  /**
   A delegation method that is executed when the Dialog is cancelled through tapping background.
   - Parameter _ dialog: A Dialog.
   */
  @objc
  optional func dialogDidCancel(_ dialog: Dialog)
  
  /**
   A delegation method that is executed when the Dialog will appear.
   - Parameter _ dialog: A Dialog.
   */
  @objc
  optional func dialogWillAppear(_ dialog: Dialog)
  
  /**
   A delegation method that is executed when the Dialog did disappear.
   - Parameter _ dialog: A Dialog.
   */
  @objc
  optional func dialogDidDisappear(_ dialog: Dialog)
  
  /**
   A delegation method that is executed to determine if the Dialog should be dismissed.
   - Parameter _ dialog: A Dialog.
   - Parameter shouldDismiss button: The tapped button. nil if dialog is being
   cancelled through tapping background.
   - Returns: A Boolean.
   */
  @objc
  optional func dialog(_ dialog: Dialog, shouldDismiss button: Button?) -> Bool
  
  /**
   A delegation method that is executed when the positive button of Dialog is tapped.
   - Parameter _ dialog: A Dialog.
   - Parameter didTapPositive button: A Button.
   */
  @objc
  optional func dialog(_ dialog: Dialog, didTapPositive button: Button)
  
  /**
   A delegation method that is executed when the negative button of Dialog is tapped.
   - Parameter _ dialog: A Dialog.
   - Parameter didTapNegative button: A Button.
   */
  @objc
  optional func dialog(_ dialog: Dialog, didTapNegative button: Button)
  
  /**
   A delegation method that is executed when the neutral button of Dialog is tapped.
   - Parameter _ dialog: A Dialog.
   - Parameter didTapNeutral button: A Button.
   */
  @objc
  optional func dialog(_ dialog: Dialog, didTapNeutral button: Button)
}

/// A builder for DialogController.
open class Dialog: NSObject {
  /// A reference to dialog controller.
  public let controller = DialogController<DialogView>()
  
  /// A weak reference to DialogDelegate.
  open weak var delegate: DialogDelegate?
  
  /// An empty initializer.
  public override init() {
    super.init()
    
    /// Set callbacks for delegate.
    shouldDismiss(handler: nil)
      .positive(nil, handler: nil)
      .negative(nil, handler: nil)
      .neutral(nil, handler: nil)
      .isCancelable(controller.isCancelable, handler: nil)
      .willAppear(handler: nil)
      .didDisappear(handler: nil)
  }
  
  /**
   Sets title of the dialog.
   - Parameter _ text: A string.
   - Returns: Dialog itself to allow chaining.
   */
  @discardableResult
  open func title(_ text: String?) -> Dialog {
    dialogView.titleLabel.text = text
    return self
  }
  
  /**
   Sets details of the dialog.
   - Parameter _ text: A string.
   - Returns: Dialog itself to allow chaining.
   */
  @discardableResult
  open func details(_ text: String?) -> Dialog {
    dialogView.detailsLabel.text = text
    return self
  }
  
  /**
   Sets title and handler for positive button of dialog.
   - Parameter _ title: A string.
   - Parameter handler: A closure handling tap.
   - Returns: Dialog itself to allow chaining.
   */
  @discardableResult
  open func positive(_ title: String?, handler: (() -> Void)?) -> Dialog {
    dialogView.positiveButton.title = title
    controller.didTapPositiveButtonHandler = { [unowned self] in
      self.delegate?.dialog?(self, didTapPositive: self.controller.dialogView.positiveButton)
      handler?()
    }
    return self
  }
  
  /**
   Sets title and handler for negative button of dialog.
   - Parameter _ title: A string.
   - Parameter handler: A closure handling tap.
   - Returns: Dialog itself to allow chaining.
   */
  @discardableResult
  open func negative(_ title: String?, handler: (() -> Void)?) -> Dialog {
    dialogView.negativeButton.title = title
    controller.didTapNegativeButtonHandler = { [unowned self] in
      self.delegate?.dialog?(self, didTapNegative: self.controller.dialogView.negativeButton)
      handler?()
    }
    return self
  }
  
  /**
   Sets title and handler for neutral button of dialog.
   - Parameter _ title: A string.
   - Parameter handler: A closure handling tap.
   - Returns: Dialog itself to allow chaining.
   */
  @discardableResult
  open func neutral(_ title: String?, handler: (() -> Void)?) -> Dialog {
    dialogView.neutralButton.title = title
    controller.didTapNeutralButtonHandler = { [unowned self] in
      self.delegate?.dialog?(self, didTapNeutral: self.controller.dialogView.neutralButton)
      handler?()
    }
    return self
  }
  
  /**
   Sets cancelability of dialog and handler for when it's cancelled.
   - Parameter _ value: A Bool.
   - Parameter handler: A closure handling cancellation.
   - Returns: Dialog itself to allow chaining.
   */
  @discardableResult
  open func isCancelable(_ value: Bool, handler: (() -> Void)? = nil) -> Dialog {
    controller.isCancelable = value
    controller.didCancelHandler = { [unowned self] in
      self.delegate?.dialogDidCancel?(self)
      handler?()
    }
    return self
  }
  
  /**
   Sets should-dismiss handler of dialog which takes dialogView and tapped
   button and returns a boolean indicating if dialog should be dismissed.
   - Parameter handler: A closure handling if dialog can be dismissed.
   - Returns: Dialog itself to allow chaining.
   */
  @discardableResult
  open func shouldDismiss(handler: ((DialogView, Button?) -> Bool)?) -> Dialog {
    controller.shouldDismissHandler = { [unowned self] dialogView, button in
      let d = self.delegate?.dialog?(self, shouldDismiss: button) ?? true
      let h = handler?(dialogView, button) ?? true
      return d && h
    }
    return self
  }
  
  /**
   Sets handler for when view controller will appear.
   - Parameter handler: A closure handling the event.
   - Returns: Dialog itself to allow chaining.
   */
  @discardableResult
  open func willAppear(handler: (() -> Void)?) -> Dialog {
    controller.willAppear = { [unowned self] in
      self.delegate?.dialogWillAppear?(self)
      handler?()
    }
    return self
  }
  
  /**
   Sets handler for when view controller did disappear.
   - Parameter handler: A closure handling the event.
   - Returns: Dialog itself to allow chaining.
   */
  @discardableResult
  open func didDisappear(handler: (() -> Void)?) -> Dialog {
    controller.didDisappear = { [unowned self] in
      self.delegate?.dialogDidDisappear?(self)
      handler?()
      self.controller.dialog = nil
    }
    return self
  }
  
  /**
   Sets dialog delegate.
   - Parameter delegate: A DialogDelegate.
   - Returns: Dialog itself to allow chaining.
   */
  @discardableResult
  open func delegate(_ delegate: DialogDelegate) -> Dialog {
    self.delegate = delegate
    return self
  }
  
  /**
   Presents dialog modally from given viewController.
   - Parameter _ viewController: A UIViewController.
   - Returns: Dialog itself to allow chaining.
   */
  @discardableResult
  open func show(_ viewController: UIViewController) -> Dialog {
    controller.dialog = self
    viewController.present(controller, animated: true, completion: nil)
    return self
  }
}

private extension Dialog {
  /// Returns dialogView of controller.
  var dialogView: DialogView {
    return controller.dialogView
  }
}

/// A memory reference to companion Dialog instance.
private var DialogKey: UInt8 = 0

private extension DialogController {
  /**
   A Dialog instance attached to the dialog controller.
   This is used to keep Dialog alive throughout the lifespan
   of the controller.
   */
  var dialog: Dialog? {
    get {
      return AssociatedObject.get(base: self, key: &DialogKey) {
        return nil
      }
    }
    set(value) {
      AssociatedObject.set(base: self, key: &DialogKey, value: value)
    }
  }
}
