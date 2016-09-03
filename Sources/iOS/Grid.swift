/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
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

@objc(GridAxisDirection)
public enum GridAxisDirection: Int {
    case any
    case horizontal
    case vertical
}

public class GridAxis {
    /// Grid reference.
    unowned var grid: Grid
    
    /// The direction the grid lays its views out.
    open var direction: GridAxisDirection = .horizontal {
        didSet {
            grid.reload()
        }
    }
    
    /// The rows size.
    public var rows: Int {
        didSet {
            grid.reload()
        }
    }
    
    /// The columns size.
    public var columns: Int {
        didSet {
            grid.reload()
        }
    }
    
    /**
     Initializer.
     - Parameter grid: The Grid reference used for offset values.
     - Parameter rows: The number of rows, vertical axis the grid will use.
     - Parameter columns: The number of columns, horizontal axis the grid will use.
     */
    public init(grid: Grid, rows: Int = 12, columns: Int = 12) {
        self.grid = grid
        self.rows = rows
        self.columns = columns
    }
}

public class GridOffset {
    /// Grid reference.
    unowned var grid: Grid
    
    /// The rows size.
    public var rows: Int {
        didSet {
            grid.reload()
        }
    }
    
    /// The columns size.
    public var columns: Int {
        didSet {
            grid.reload()
        }
    }
    
    /**
     Initializer.
     - Parameter grid: The Grid reference used for offset values.
     - Parameter rows: The number of rows, vertical axis the grid will use.
     - Parameter columns: The number of columns, horizontal axis the grid will use.
     */
    public init(grid: Grid, rows: Int = 0, columns: Int = 0) {
        self.grid = grid
        self.rows = rows
        self.columns = columns
    }
}

public class Grid {
    /// Defer the calculation.
    public var deferred = false
    
    /// Context view.
    internal weak var context: UIView?
    
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
    public private(set) var offset: GridOffset!
    
    /// The axis in which the Grid is laying out its views.
    public private(set) var axis: GridAxis!
    
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
            reload()
        }
    }
    
    /**
     Initializer.
     - Parameter rows: The number of rows, vertical axis the grid will use.
     - Parameter columns: The number of columns, horizontal axis the grid will use.
     - Parameter interimSpace: The interim space between rows or columns.
     */
    public init(context: UIView?, rows: Int = 12, columns: Int = 12, interimSpace: InterimSpace = 0) {
        self.context = context
        self.rows = rows
        self.columns = columns
        self.interimSpace = interimSpace
        offset = GridOffset(grid: self)
        axis = GridAxis(grid: self)
    }
    
    /// Begins a deferred block.
    public func begin() {
        deferred = true
    }
    
    /// Completes a deferred block.
    public func commit() {
        deferred = false
        reload()
    }
    
    /// Reload the button layout.
    public func reload() {
        guard !deferred else {
            return
        }
        
        var n: Int = 0
        var i: Int = 0
        
        for child in views {
            guard let canvas = context else {
                return
            }
            
            if canvas != child.superview {
                child.removeFromSuperview()
                canvas.addSubview(child)
            }
            
            canvas.layoutIfNeeded()
            
            switch axis.direction {
            case .horizontal:
                let c = child.grid.columns
                let co = child.grid.offset.columns
                let w = (canvas.bounds.width - contentEdgeInsets.left - contentEdgeInsets.right - layoutEdgeInsets.left - layoutEdgeInsets.right + interimSpace) / CGFloat(axis.columns)
                
                child.x = CGFloat(i + n + co) * w + contentEdgeInsets.left + layoutEdgeInsets.left
                child.y = contentEdgeInsets.top + layoutEdgeInsets.top
                child.width = w * CGFloat(c) - interimSpace
                child.height = canvas.bounds.height - contentEdgeInsets.top - contentEdgeInsets.bottom - layoutEdgeInsets.top - layoutEdgeInsets.bottom
                
                n += c + co - 1
                
            case .vertical:
                let r = child.grid.rows
                let ro = child.grid.offset.rows
                let h = (canvas.bounds.height - contentEdgeInsets.top - contentEdgeInsets.bottom - layoutEdgeInsets.top - layoutEdgeInsets.bottom + interimSpace) / CGFloat(axis.rows)
                
                child.x = contentEdgeInsets.left + layoutEdgeInsets.left
                child.y = CGFloat(i + n + ro) * h + contentEdgeInsets.top + layoutEdgeInsets.top
                child.width = canvas.bounds.width - contentEdgeInsets.left - contentEdgeInsets.right - layoutEdgeInsets.left - layoutEdgeInsets.right
                child.height = h * CGFloat(r) - interimSpace
                
                n += r + ro - 1
                
            case .any:
                let r = child.grid.rows
                let ro = child.grid.offset.rows
                let c = child.grid.columns
                let co = child.grid.offset.columns
                let w = (canvas.bounds.width - contentEdgeInsets.left - contentEdgeInsets.right - layoutEdgeInsets.left - layoutEdgeInsets.right + interimSpace) / CGFloat(axis.columns)
                let h = (canvas.bounds.height - contentEdgeInsets.top - contentEdgeInsets.bottom - layoutEdgeInsets.top - layoutEdgeInsets.bottom + interimSpace) / CGFloat(axis.rows)
                
                child.x = CGFloat(co) * w + contentEdgeInsets.left + layoutEdgeInsets.left
                child.y = CGFloat(ro) * h + contentEdgeInsets.top + layoutEdgeInsets.top
                child.width = w * CGFloat(c) - interimSpace
                child.height = h * CGFloat(r) - interimSpace
            }
            
            i += 1
        }
    }
}

/// A memory reference to the Grid instance for UIView extensions.
private var GridKey: UInt8 = 0

/// Grid extension for UIView.
extension UIView {
    /// Grid reference.
    public private(set) var grid: Grid {
        get {
            return AssociatedObject(base: self, key: &GridKey) {
                return Grid(context: self)
            }
        }
        set(value) {
            AssociateObject(base: self, key: &GridKey, value: value)
        }
    }
}
