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

fileprivate var ChipItemKey: UInt8 = 0

@objc(ChipBarAlignment)
public enum ChipBarAlignment: Int {
  case top
  case bottom
  case hidden
}

extension UIViewController {
  /**
   A convenience property that provides access to the ChipBarController.
   This is the recommended method of accessing the ChipBarController
   through child UIViewControllers.
   */
  public var chipBarController: ChipBarController? {
    return traverseViewControllerHierarchyForClassType()
  }
}

open class ChipBarController: TransitionController {
  /**
   A Display value to indicate whether or not to
   display the rootViewController to the full view
   bounds, or up to the toolbar height.
   */
  open var displayStyle = DisplayStyle.partial {
    didSet {
      layoutSubviews()
    }
  }
  
  /// The ChipBar used to switch between view controllers.
  @IBInspectable
  public let chipBar = ChipBar()
  
  /// The chipBar alignment.
  open var chipBarAlignment = ChipBarAlignment.bottom {
    didSet {
      layoutSubviews()
    }
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    layoutChipBar()
    layoutContainer()
    layoutRootViewController()
  }
  
  open override func prepare() {
    super.prepare()
    prepareChipBar()
  }
}

fileprivate extension ChipBarController {
  /// Prepares the ChipBar.
  func prepareChipBar() {
    chipBar.depthPreset = .depth1
    view.addSubview(chipBar)
  }
}

fileprivate extension ChipBarController {
  /// Layout the container.
  func layoutContainer() {
    chipBar.frame.size.width = view.bounds.width
    
    switch displayStyle {
    case .partial:
      let p = chipBar.bounds.height
      let y = view.bounds.height - p
      
      switch chipBarAlignment {
      case .top:
        container.frame.origin.y = p
        container.frame.size.height = y
        
      case .bottom:
        container.frame.origin.y = 0
        container.frame.size.height = y
        
      case .hidden:
        container.frame.origin.y = 0
        container.frame.size.height = view.bounds.height
      }
      
      container.frame.size.width = view.bounds.width
      
    case .full:
      container.frame = view.bounds
    }
  }
  
  /// Layout the chipBar.
  func layoutChipBar() {
    chipBar.frame.size.width = view.bounds.width
    
    switch chipBarAlignment {
    case .top:
      chipBar.isHidden = false
      chipBar.frame.origin.y = 0
      
    case .bottom:
      chipBar.isHidden = false
      chipBar.frame.origin.y = view.bounds.height - chipBar.bounds.height
      
    case .hidden:
      chipBar.isHidden = true
    }
  }
  
  /// Layout the rootViewController.
  func layoutRootViewController() {
    rootViewController.view.frame = container.bounds
  }
}
