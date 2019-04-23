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

@objc(SearchBarAlignment)
public enum SearchBarAlignment: Int {
  case top
  case bottom
}

extension UIViewController {
  /**
   A convenience property that provides access to the SearchBarController.
   This is the recommended method of accessing the SearchBarController
   through child UIViewControllers.
   */
  public var searchBarController: SearchBarController? {
    return traverseViewControllerHierarchyForClassType()
  }
}

open class SearchBarController: StatusBarController {
  /// Reference to the SearchBar.
  @IBInspectable
  public let searchBar = SearchBar()
  
  /// The searchBar alignment.
  open var searchBarAlignment = SearchBarAlignment.top {
    didSet {
      layoutSubviews()
    }
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    layoutSearchBar()
    layoutContainer()
    layoutRootViewController()
  }
  
  open override func prepare() {
    super.prepare()
    displayStyle = .partial
    
    prepareSearchBar()
  }
}

fileprivate extension SearchBarController {
  /// Prepares the searchBar.
  func prepareSearchBar() {
    searchBar.layer.zPosition = 1000
    searchBar.depthPreset = .depth1
    view.addSubview(searchBar)
  }
}

fileprivate extension SearchBarController {
  /// Layout the container.
  func layoutContainer() {
    switch displayStyle {
    case .partial:
      let p = searchBar.bounds.height
      let q = statusBarOffsetAdjustment
      let h = view.bounds.height - p - q
      
      switch searchBarAlignment {
      case .top:
        container.frame.origin.y = q + p
        container.frame.size.height = h
        
      case .bottom:
        container.frame.origin.y = q
        container.frame.size.height = h
      }
      
      container.frame.size.width = view.bounds.width
      
    case .full:
      container.frame = view.bounds
    }
  }
  
  /// Layout the searchBar.
  func layoutSearchBar() {
    searchBar.frame.origin.x = 0
    searchBar.frame.origin.y = .top == searchBarAlignment ? statusBarOffsetAdjustment : view.bounds.height - searchBar.bounds.height
    searchBar.frame.size.width = view.bounds.width
  }
  
  /// Layout the rootViewController.
  func layoutRootViewController() {
    rootViewController.view.frame = container.bounds
  }
}
