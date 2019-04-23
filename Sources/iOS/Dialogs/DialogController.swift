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

/// A UIViewController managing DialogView.
open class DialogController<T: DialogView>: UIViewController {
  /// A reference to dialogView.
  public let dialogView = T()
  
  /// A boolean indicating cancelability of dialog when user taps on background.
  open var isCancelable = false
  
  /// A reference to did-cancel handler.
  open var didCancelHandler: (() -> Void)?
  
  /**
   A reference to should-dismiss handler which takes dialogView
   and tapped button and returns Boolean indicating if dialog should be dismissed.
   */
  open var shouldDismissHandler: ((T, Button?) -> Bool)?
  
  /// A reference to handler for when positiveButton is tapped.
  open var didTapPositiveButtonHandler: (() -> Void)?
  
  /// A reference to handler for when negativeButton is tapped.
  open var didTapNegativeButtonHandler: (() -> Void)?
  
  /// A reference to handler for when neutralButton is tapped.
  open var didTapNeutralButtonHandler: (() -> Void)?
  
  /// A reference to handler for when controller will appear.
  open var willAppear: (() -> Void)?
  
  /// A reference to handler for when controller did disappear.
  open var didDisappear: (() -> Void)?
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    prepare()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepare()
  }
  
  /// Prepares controller for presentation.
  open func prepare() {
    isMotionEnabled = true
    motionTransitionType = .fade
    modalPresentationStyle = .overFullScreen
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    prepareView()
    prepareDialogView()
  }
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    willAppear?()
  }
  
  open override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    didDisappear?()
  }
  
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    dialogView.maxSize = CGSize(width: Screen.width * 0.8, height: Screen.height * 0.9)
  }
  
  /**
   Dismisses dialog.
   - Parameter isAnimated: A boolean.
   */
  open func dismiss(isAnimated: Bool = true) {
    dismiss(isTriggeredByUserInteraction: false, isAnimated: isAnimated)
  }
  
  /// Handler for when background scrim is tapped.
  @objc
  private func didTapBackgroundView() {
    guard isCancelable else {
      return
    }
    
    dismiss(isTriggeredByUserInteraction: true, isAnimated: true)
  }
  
  /// Handler for when one of 3 dialog buttons is tapped.
  @objc
  private func didTapButton(_ sender: Button) {
    switch sender {
    case dialogView.positiveButton:
      didTapPositiveButtonHandler?()
      
    case dialogView.negativeButton:
      didTapNegativeButtonHandler?()
      
    case dialogView.neutralButton:
      didTapNeutralButtonHandler?()
      
    default:
      break
    }
    
    dismiss(isTriggeredByUserInteraction: true, isAnimated: true, using: sender)
  }
}

private extension DialogController {
  /// Prepares view.
  func prepareView() {
    let v = UIControl()
    v.backgroundColor = Color.black.withAlphaComponent(0.33)
    v.addTarget(self, action: #selector(didTapBackgroundView), for: .touchUpInside)
    view = v
  }
  
  /// Prepares dialogView.
  func prepareDialogView() {
    view.layout(dialogView).center()
    dialogView.buttonArea.subviews.forEach {
      ($0 as? Button)?.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
  }
}

private extension DialogController {
  /**
   Dismisses dialog.
   - Parameter isTriggeredByUserInteraction: A boolean indicating whether the action is
   triggered by a user interaction
   - Parameter isAnimated: A boolean indicating if the dismissal should be animated.
   - Parameter using button: A button triggering the dismissal.
   */
  func dismiss(isTriggeredByUserInteraction: Bool, isAnimated: Bool, using button: Button? = nil) {
    if isTriggeredByUserInteraction {
      guard shouldDismissHandler?(dialogView, button) ?? true else {
        return
      }
    }
    
    presentingViewController?.dismiss(animated: isAnimated, completion: nil)
    
    guard isTriggeredByUserInteraction, nil == button else {
      return
    }
    
    didCancelHandler?()
  }
}
