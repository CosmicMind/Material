/*
 * Copyright (C) 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Original Inspiration & Author
 * Copyright (C) 2018 Orkhan Alikhanov <orkhan.alikhanov@gmail.com>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  * Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 *  * Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 *  * Neither the name of CosmicMind nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
