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

public enum FABMenuBacking {
  case none
  case fade
  case blur
}

extension UIViewController {
  /**
   A convenience property that provides access to the FABMenuController.
   This is the recommended method of accessing the FABMenuController
   through child UIViewControllers.
   */
  public var fabMenuController: FABMenuController? {
    return traverseViewControllerHierarchyForClassType()
  }
}

open class FABMenuController: TransitionController {
  /// Reference to the MenuView.
  @IBInspectable
  open var fabMenu = FABMenu()
  
  /// A FABMenuBacking value type.
  open var fabMenuBacking = FABMenuBacking.blur
  
  /// The fabMenuBacking UIBlurEffectStyle.
  open var fabMenuBackingBlurEffectStyle = UIBlurEffect.Style.light
  
  /// A reference to the blurView.
  open fileprivate(set) var blurView: UIView?
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    rootViewController.view.frame = view.bounds
  }
  
  open override func prepare() {
    super.prepare()
    prepareFABMenu()
  }
}

extension FABMenuController: FABMenuDelegate {}

fileprivate extension FABMenuController {
  /// Prepares the fabMenu.
  func prepareFABMenu() {
    fabMenu.delegate = self
    fabMenu.layer.zPosition = 1000
    
    fabMenu.handleFABButtonCallback = { [weak self] in
      self?.handleFABButtonCallback(button: $0)
    }
    
    fabMenu.handleOpenCallback = { [weak self] in
      self?.handleOpenCallback()
    }
    
    fabMenu.handleCloseCallback = { [weak self] in
      self?.handleCloseCallback()
    }
    
    fabMenu.handleCompletionCallback = { [weak self] in
      self?.handleCompletionCallback(view: $0)
    }
    
    view.addSubview(fabMenu)
  }
}

fileprivate extension FABMenuController {
  /// Shows the fabMenuBacking.
  func showFabMenuBacking() {
    showFade()
    showBlurView()
  }
  
  /// Hides the fabMenuBacking.
  func hideFabMenuBacking() {
    hideFade()
    hideBlurView()
  }
  
  /// Shows the blurView.
  func showBlurView() {
    guard .blur == fabMenuBacking else {
      return
    }
    
    guard !fabMenu.isOpened, fabMenu.isEnabled else {
      return
    }
    
    guard nil == blurView else {
      return
    }
    
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: fabMenuBackingBlurEffectStyle))
    blurView = UIView()
    blurView?.layout(blur).edges()
    view.layout(blurView!).edges()
    view.bringSubviewToFront(fabMenu)
  }
  
  /// Hides the blurView.
  func hideBlurView() {
    guard .blur == fabMenuBacking else {
      return
    }
    
    guard fabMenu.isOpened, fabMenu.isEnabled else {
      return
    }
    
    blurView?.removeFromSuperview()
    blurView = nil
  }
  
  /// Shows the fade.
  func showFade() {
    guard .fade == fabMenuBacking else {
      return
    }
    
    guard !fabMenu.isOpened, fabMenu.isEnabled else {
      return
    }
    
    UIView.animate(withDuration: 0.15, animations: { [weak self] in
      self?.rootViewController.view.alpha = 0.15
    })
  }
  
  /// Hides the fade.
  func hideFade() {
    guard .fade == fabMenuBacking else {
      return
    }
    
    guard fabMenu.isOpened, fabMenu.isEnabled else {
      return
    }
    
    UIView.animate(withDuration: 0.15, animations: { [weak self] in
      self?.rootViewController.view.alpha = 1
    })
  }
}

fileprivate extension FABMenuController {
  /**
   Handler to toggle the FABMenu opened or closed.
   - Parameter button: A UIButton.
   */
  func handleFABButtonCallback(button: UIButton) {
    guard fabMenu.isOpened else {
      fabMenu.open(isTriggeredByUserInteraction: true)
      return
    }
    
    fabMenu.close(isTriggeredByUserInteraction: true)
  }
  
  /// Handler for when the FABMenu.open function is called.
  func handleOpenCallback() {
    isUserInteractionEnabled = false
    showFabMenuBacking()
  }
  
  /// Handler for when the FABMenu.close function is called.
  func handleCloseCallback() {
    isUserInteractionEnabled = false
    hideFabMenuBacking()
  }
  
  /**
   Completion handler for FABMenu open and close calls.
   - Parameter view: A UIView.
   */
  func handleCompletionCallback(view: UIView) {
    if view == fabMenu.fabMenuItems.last {
      isUserInteractionEnabled = true
    }
  }
}
