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

@objc(GridAxisDirection)
public enum GridAxisDirection: Int {
  case any
  case horizontal
  case vertical
}

public struct GridAxis {
  /// The direction the grid lays its views out.
  public var direction = GridAxisDirection.horizontal
  
  /// The rows size.
  public var rows: Int
  
  /// The columns size.
  public var columns: Int
  
  /**
   Initializer.
   - Parameter rows: The number of rows, vertical axis the grid will use.
   - Parameter columns: The number of columns, horizontal axis the grid will use.
   */
  internal init(rows: Int = 12, columns: Int = 12) {
    self.rows = rows
    self.columns = columns
  }
}

public struct GridOffset {
  /// The rows size.
  public var rows: Int
  
  /// The columns size.
  public var columns: Int
  
  /**
   Initializer.
   - Parameter rows: The number of rows, vertical axis the grid will use.
   - Parameter columns: The number of columns, horizontal axis the grid will use.
   */
  internal init(rows: Int = 0, columns: Int = 0) {
    self.rows = rows
    self.columns = columns
  }
}

public struct Grid {
  /// Context view.
  internal weak var context: UIView?
  
  /// Defer the calculation.
  public var isDeferred = false
  
  /// Number of rows.
  public var rows: Int {
    didSet {
      reload()
    }
  }
  
  /// Number of columns.
  public var columns: Int {
    didSet {
      reload()
    }
  }
  
  /// Offsets for rows and columns.
  public var offset = GridOffset() {
    didSet {
      reload()
    }
  }
  
  /// The axis in which the Grid is laying out its views.
  public var axis = GridAxis() {
    didSet {
      reload()
    }
  }
  
  /// Preset inset value for grid.
  public var layoutEdgeInsetsPreset = EdgeInsetsPreset.none {
    didSet {
      layoutEdgeInsets = EdgeInsetsPresetToValue(preset: contentEdgeInsetsPreset)
    }
  }
  
  /// Insets value for grid.
  public var layoutEdgeInsets = EdgeInsets.zero {
    didSet {
      reload()
    }
  }
  
  /// Preset inset value for grid.
  public var contentEdgeInsetsPreset = EdgeInsetsPreset.none {
    didSet {
      contentEdgeInsets = EdgeInsetsPresetToValue(preset: contentEdgeInsetsPreset)
    }
  }
  
  /// Insets value for grid.
  public var contentEdgeInsets = EdgeInsets.zero {
    didSet {
      reload()
    }
  }
  
  /// A preset wrapper for interim space.
  public var interimSpacePreset = InterimSpacePreset.none {
    didSet {
      interimSpace = InterimSpacePresetToValue(preset: interimSpacePreset)
    }
  }
  
  /// The space between grid rows and columnss.
  public var interimSpace: InterimSpace {
    didSet {
      reload()
    }
  }
  
  /// An Array of UIButtons.
  public var views = [UIView]() {
    didSet {
      oldValue.forEach {
        $0.removeFromSuperview()
      }
      
      reload()
    }
  }
  
  /**
   Initializer.
   - Parameter rows: The number of rows, vertical axis the grid will use.
   - Parameter columns: The number of columns, horizontal axis the grid will use.
   - Parameter interimSpace: The interim space between rows or columns.
   */
  internal init(context: UIView?, rows: Int = 0, columns: Int = 0, interimSpace: InterimSpace = 0) {
    self.context = context
    self.rows = rows
    self.columns = columns
    self.interimSpace = interimSpace
  }
  
  /// Begins a deferred block.
  public mutating func begin() {
    isDeferred = true
  }
  
  /// Completes a deferred block.
  public mutating func commit() {
    isDeferred = false
    reload()
  }
  
  /**
   Update grid in a deferred block.
   - Parameter _ block: An update code block.
   */
  public mutating func update(_ block: (Grid) -> Void) {
    begin()
    block(self)
    commit()
  }
  
  /// Reload the button layout.
  public func reload() {
    guard !isDeferred else {
      return
    }
    
    guard let canvas = context else {
      return
    }
    
    for v in views {
      if canvas != v.superview {
        canvas.addSubview(v)
      }
    }
    
    let count = views.count
    
    guard 0 < count else {
      return
    }
    
    /// It is important to call `setNeedsLayout` and `layoutIfNeeded`
    /// in order to have the parent view's `frame` calculation be set
    /// for `Grid` to be able to then calculate the correct dimenions
    /// of its `child` views.
    canvas.setNeedsLayout()
    canvas.layoutIfNeeded()
    
    guard 0 < canvas.bounds.width && 0 < canvas.bounds.height else {
      return
    }
    
    var n = 0
    var i = 0
    
    for v in views {
      // Forces the view to adjust accordingly to size changes, ie: UILabel.
      (v as? UILabel)?.sizeToFit()
      
      switch axis.direction {
      case .horizontal:
        let c = 0 == v.grid.columns ? axis.columns / count : v.grid.columns
        let co = v.grid.offset.columns
        let w = (canvas.bounds.width - contentEdgeInsets.left - contentEdgeInsets.right - layoutEdgeInsets.left - layoutEdgeInsets.right + interimSpace) / CGFloat(axis.columns)
        
        v.frame.origin.x = CGFloat(i + n + co) * w + contentEdgeInsets.left + layoutEdgeInsets.left
        v.frame.origin.y = contentEdgeInsets.top + layoutEdgeInsets.top
        v.frame.size.width = w * CGFloat(c) - interimSpace
        v.frame.size.height = canvas.bounds.height - contentEdgeInsets.top - contentEdgeInsets.bottom - layoutEdgeInsets.top - layoutEdgeInsets.bottom
        
        n += c + co - 1
        
      case .vertical:
        let r = 0 == v.grid.rows ? axis.rows / count : v.grid.rows
        let ro = v.grid.offset.rows
        let h = (canvas.bounds.height - contentEdgeInsets.top - contentEdgeInsets.bottom - layoutEdgeInsets.top - layoutEdgeInsets.bottom + interimSpace) / CGFloat(axis.rows)
        
        v.frame.origin.x = contentEdgeInsets.left + layoutEdgeInsets.left
        v.frame.origin.y = CGFloat(i + n + ro) * h + contentEdgeInsets.top + layoutEdgeInsets.top
        v.frame.size.width = canvas.bounds.width - contentEdgeInsets.left - contentEdgeInsets.right - layoutEdgeInsets.left - layoutEdgeInsets.right
        v.frame.size.height = h * CGFloat(r) - interimSpace
        
        n += r + ro - 1
        
      case .any:
        let r = 0 == v.grid.rows ? axis.rows / count : v.grid.rows
        let ro = v.grid.offset.rows
        let c = 0 == v.grid.columns ? axis.columns / count : v.grid.columns
        let co = v.grid.offset.columns
        let w = (canvas.bounds.width - contentEdgeInsets.left - contentEdgeInsets.right - layoutEdgeInsets.left - layoutEdgeInsets.right + interimSpace) / CGFloat(axis.columns)
        let h = (canvas.bounds.height - contentEdgeInsets.top - contentEdgeInsets.bottom - layoutEdgeInsets.top - layoutEdgeInsets.bottom + interimSpace) / CGFloat(axis.rows)
        
        v.frame.origin.x = CGFloat(co) * w + contentEdgeInsets.left + layoutEdgeInsets.left
        v.frame.origin.y = CGFloat(ro) * h + contentEdgeInsets.top + layoutEdgeInsets.top
        v.frame.size.width = w * CGFloat(c) - interimSpace
        v.frame.size.height = h * CGFloat(r) - interimSpace
      }
      
      i += 1
      
      /// reload the grid layout for each view on
      /// each iteration, in order to ensure that
      /// subviews are recalculated correctly.
      if (isDeferred) { continue }
      v.grid.reload()
    }
  }
}

fileprivate var AssociatedInstanceKey: UInt8 = 0

extension UIView {
  /// Grid reference.
  public var grid: Grid {
    get {
      return AssociatedObject.get(base: self, key: &AssociatedInstanceKey) {
        return Grid(context: self)
      }
    }
    set(value) {
      AssociatedObject.set(base: self, key: &AssociatedInstanceKey, value: value)
    }
  }
  
  /// A reference to grid's layoutEdgeInsetsPreset.
  open var layoutEdgeInsetsPreset: EdgeInsetsPreset {
    get {
      return grid.layoutEdgeInsetsPreset
    }
    set(value) {
      grid.layoutEdgeInsetsPreset = value
    }
  }
  
  /// A reference to grid's layoutEdgeInsets.
  @IBInspectable
  open var layoutEdgeInsets: EdgeInsets {
    get {
      return grid.layoutEdgeInsets
    }
    set(value) {
      grid.layoutEdgeInsets = value
    }
  }
}
