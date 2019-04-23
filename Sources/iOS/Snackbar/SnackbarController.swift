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

@objc(SnackbarControllerDelegate)
public protocol SnackbarControllerDelegate {
  /**
   A delegation method that is executed when a Snackbar will show.
   - Parameter snackbarController: A SnackbarController.
   - Parameter snackbar: A Snackbar.
   */
  @objc
  optional func snackbarController(snackbarController: SnackbarController, willShow snackbar: Snackbar)
  
  /**
   A delegation method that is executed when a Snackbar did show.
   - Parameter snackbarController: A SnackbarController.
   - Parameter snackbar: A Snackbar.
   */
  @objc
  optional func snackbarController(snackbarController: SnackbarController, didShow snackbar: Snackbar)
  
  /**
   A delegation method that is executed when a Snackbar will hide.
   - Parameter snackbarController: A SnackbarController.
   - Parameter snackbar: A Snackbar.
   */
  @objc
  optional func snackbarController(snackbarController: SnackbarController, willHide snackbar: Snackbar)
  
  /**
   A delegation method that is executed when a Snackbar did hide.
   - Parameter snackbarController: A SnackbarController.
   - Parameter snackbar: A Snackbar.
   */
  @objc
  optional func snackbarController(snackbarController: SnackbarController, didHide snackbar: Snackbar)
}

@objc(SnackbarAlignment)
public enum SnackbarAlignment: Int {
  case top
  case bottom
}

extension UIViewController {
  /**
   A convenience property that provides access to the SnackbarController.
   This is the recommended method of accessing the SnackbarController
   through child UIViewControllers.
   */
  public var snackbarController: SnackbarController? {
    return traverseViewControllerHierarchyForClassType()
  }
}

open class SnackbarController: TransitionController {
  /// Reference to the Snackbar.
  public let snackbar = Snackbar()
  
  /// A boolean indicating if the Snacbar is animating.
  open internal(set) var isAnimating = false
  
  /// Delegation handler.
  open weak var delegate: SnackbarControllerDelegate?
  
  /// Snackbar alignment setting.
  open var snackbarAlignment = SnackbarAlignment.bottom
  
  /// A preset wrapper around snackbarEdgeInsets.
  open var snackbarEdgeInsetsPreset = EdgeInsetsPreset.none {
    didSet {
      snackbarEdgeInsets = EdgeInsetsPresetToValue(preset: snackbarEdgeInsetsPreset)
    }
  }
  
  /// A reference to snackbarEdgeInsets.
  @IBInspectable
  open var snackbarEdgeInsets = EdgeInsets.zero {
    didSet {
      layoutSubviews()
    }
  }
  
  /**
   A boolean that controls if layoutEdgeInsets of snackbar is adjusted
   automatically.
   */
  @IBInspectable
  open var automaticallyAdjustSnackbarLayoutEdgeInsets = true
  
  /**
   Animates to a SnackbarStatus.
   - Parameter status: A SnackbarStatus enum value.
   */
  @discardableResult
  open func animate(snackbar status: SnackbarStatus, delay: TimeInterval = 0, animations: ((Snackbar) -> Void)? = nil, completion: ((Snackbar) -> Void)? = nil) -> MotionCancelBlock? {
    return Motion.delay(delay) { [weak self, status = status, animations = animations, completion = completion] in
      guard let s = self else {
        return
      }
      
      if .visible == status {
        s.delegate?.snackbarController?(snackbarController: s, willShow: s.snackbar)
      } else {
        s.delegate?.snackbarController?(snackbarController: s, willHide: s.snackbar)
      }
      
      s.isAnimating = true
      s.isUserInteractionEnabled = false
      
      UIView.animate(withDuration: 0.25, animations: { [weak self, status = status, animations = animations] in
        guard let s = self else {
          return
        }
        
        s.layoutSnackbar(status: status)
        
        animations?(s.snackbar)
      }) { [weak self, status = status, completion = completion] _ in
        guard let s = self else {
          return
        }
        
        s.isAnimating = false
        s.isUserInteractionEnabled = true
        s.snackbar.status = status
        s.layoutSubviews()
        
        if .visible == status {
          s.delegate?.snackbarController?(snackbarController: s, didShow: s.snackbar)
        } else {
          s.delegate?.snackbarController?(snackbarController: s, didHide: s.snackbar)
        }
        
        completion?(s.snackbar)
      }
    }
  }
  
  open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    reload()
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    guard !isAnimating else {
      return
    }
    
    reload()
  }
  
  /// Reloads the view.
  open func reload() {
    snackbar.frame.origin.x = snackbarEdgeInsets.left
    snackbar.frame.size.width = view.bounds.width - snackbarEdgeInsets.left - snackbarEdgeInsets.right
    snackbar.frame.size.height = snackbar.heightPreset.rawValue
    
    if automaticallyAdjustSnackbarLayoutEdgeInsets {
      snackbar.layoutEdgeInsets = .zero
      if .bottom == snackbarAlignment {
        snackbar.frame.size.height += bottomLayoutGuide.length
        snackbar.layoutEdgeInsets.bottom += bottomLayoutGuide.length
      } else {
        snackbar.frame.size.height += topLayoutGuide.length
        snackbar.layoutEdgeInsets.top += topLayoutGuide.length
      }
      
      rootViewController.view.frame = view.bounds
      layoutSnackbar(status: snackbar.status)
    }
  }
  
  open override func prepare() {
    super.prepare()
    prepareSnackbar()
  }
  
  /// Prepares the snackbar.
  private func prepareSnackbar() {
    snackbar.layer.zPosition = 10000
    view.addSubview(snackbar)
  }
  
  /**
   Lays out the Snackbar.
   - Parameter status: A SnackbarStatus enum value.
   */
  private func layoutSnackbar(status: SnackbarStatus) {
    if .bottom == snackbarAlignment {
      snackbar.frame.origin.y = .visible == status ? view.bounds.height - snackbar.bounds.height - snackbarEdgeInsets.bottom : view.bounds.height
    } else {
      snackbar.frame.origin.y = .visible == status ? snackbarEdgeInsets.top : -snackbar.bounds.height
    }
  }
}
