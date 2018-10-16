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

/// A builder for DialogController.
open class Dialog {
  /// A reference to dialog controller.
  public let controller = DialogController<DialogView>()
  
  /// An empty initializer.
  public init() { }
  
  /**
   Sets title of the dialog.
   - Parameter _ text: A string.
   - Returns: DialogBuilder itself to allow chaining.
   */
  open func title(_ text: String?) -> Dialog {
    dialogView.titleLabel.text = text
    return self
  }
  
  /**
   Sets details of the dialog.
   - Parameter _ text: A string.
   - Returns: DialogBuilder itself to allow chaining.
   */
  open func details(_ text: String?) -> Dialog {
    dialogView.detailsLabel.text = text
    return self
  }
  
  /**
   Sets title and handler for positive button of dialog.
   - Parameter _ title: A string.
   - Parameter handler: A closure handling tap.
   - Returns: DialogBuilder itself to allow chaining.
   */
  open func positive(_ title: String?, handler: (() -> Void)?) -> Dialog {
    dialogView.positiveButton.title = title
    controller.didTapPositiveButtonHandler = handler
    return self
  }
  
  /**
   Sets title and handler for negative button of dialog.
   - Parameter _ title: A string.
   - Parameter handler: A closure handling tap.
   - Returns: DialogBuilder itself to allow chaining.
   */
  open func negative(_ title: String?, handler: (() -> Void)?) -> Dialog {
    dialogView.negativeButton.title = title
    controller.didTapNegativeButtonHandler = handler
    return self
  }
  
  /**
   Sets title and handler for neutral button of dialog.
   - Parameter _ title: A string.
   - Parameter handler: A closure handling tap.
   - Returns: DialogBuilder itself to allow chaining.
   */
  open func neutral(_ title: String?, handler: (() -> Void)?) -> Dialog {
    dialogView.neutralButton.title = title
    controller.didTapNeutralButtonHandler = handler
    return self
  }
  
  /**
   Sets cancelability of dialog and handler for when it's cancelled.
   - Parameter _ value: A Bool.
   - Parameter handler: A closure handling cancellation.
   - Returns: DialogBuilder itself to allow chaining.
   */
  open func isCancelable(_ value: Bool, handler: (() -> Void)? = nil) -> Dialog {
    controller.isCancelable = value
    controller.didCancelHandler = handler
    return self
  }
  
  /**
   Sets should-dismiss handler of dialog which takes dialogView and tapped
   button and returns a boolean indicating if dialog should be dismissed.
   - Parameter handler: A closure handling if dialog can be dismissed.
   - Returns: DialogBuilder itself to allow chaining.
   */
  open func shouldDismiss(handler: ((DialogView, Button?) -> Bool)?) -> Dialog {
    controller.shouldDismissHandler = handler
    return self
  }
  
  /**
   Presents dialog modally from given viewController.
   - Parameter _ viewController: A UIViewController.
   - Returns: DialogBuilder itself to allow chaining.
   */
  @discardableResult
  open func show(_ viewController: UIViewController) -> Dialog {
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
