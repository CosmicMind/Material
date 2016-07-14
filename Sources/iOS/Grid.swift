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

public enum GridAxisDirection {
    case none
    case horizontal
    case vertical
}

public class GridAxis {
    /// Grid reference.
    unowned var grid: Grid
    
    /// Inherit grid rows and columns.
    public var inherited: Bool = false
    
    /// The direction the grid lays its views out.
    public var direction: GridAxisDirection = .horizontal
    
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
    public var layoutInsetsPreset: InsetsPreset = .none {
        didSet {
            layoutInsets = InsetsPresetToValue(preset: contentInsetsPreset)
        }
    }
    
    /// Insets value for grid.
    public var layoutInsets: Insets = InsetsPresetToValue(preset: .none) {
        didSet {
            reload()
        }
    }
    
    /// Preset inset value for grid.
    public var contentInsetsPreset: InsetsPreset = .none {
        didSet {
            contentInsets = InsetsPresetToValue(preset: contentInsetsPreset)
        }
    }
    
    /// Insets value for grid.
    public var contentInsets: Insets = InsetsPresetToValue(preset: .none) {
        didSet {
            reload()
        }
    }
    
    /// A preset wrapper for interim space.
    public var interimSpacePreset: InterimSpacePreset = .none {
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
    public var views: Array<UIView>? {
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
    
    /// Reload the button layout.
    public func reload() {
        if let v: Array<UIView> = views {
            let gc: Int = axis.inherited ? columns : axis.columns
            let gr: Int = axis.inherited ? rows : axis.rows
            var n: Int = 0
            for i in 0..<v.count {
                let child: UIView = v[i]
                if let parent: UIView = context {
                    if parent != child.superview {
                        child.removeFromSuperview()
                        parent.addSubview(child)
                    }
                    parent.layoutIfNeeded()
                    switch axis.direction {
                    case .horizontal:
                        let w: CGFloat = (parent.bounds.width - contentInsets.left - contentInsets.right - layoutInsets.left - layoutInsets.right + interimSpace) / CGFloat(gc)
                        let c: Int = child.grid.columns
                        let co: Int = child.grid.offset.columns
                        let vh: CGFloat = parent.bounds.height - contentInsets.top - contentInsets.bottom - layoutInsets.top - layoutInsets.bottom
                        let vl: CGFloat = CGFloat(i + n + co) * w + contentInsets.left + layoutInsets.left
                        let vw: CGFloat = w * CGFloat(c) - interimSpace
                        child.frame = CGRect(x: vl, y: contentInsets.top + layoutInsets.top, width: vw, height: vh)
                        n += c + co - 1
                    case .vertical:
                        let h: CGFloat = (parent.bounds.height - contentInsets.top - contentInsets.bottom - layoutInsets.top - layoutInsets.bottom + interimSpace) / CGFloat(gr)
                        let r: Int = child.grid.rows
                        let ro: Int = child.grid.offset.rows
                        let vw: CGFloat = parent.bounds.width - contentInsets.left - contentInsets.right - layoutInsets.left - layoutInsets.right
                        let vt: CGFloat = CGFloat(i + n + ro) * h + contentInsets.top + layoutInsets.top
                        let vh: CGFloat = h * CGFloat(r) - interimSpace
                        child.frame = CGRect(x: contentInsets.left + layoutInsets.left, y: vt, width: vw, height: vh)
                        n += r + ro - 1
                    case .none:
                        let w: CGFloat = (parent.bounds.width - contentInsets.left - contentInsets.right - layoutInsets.left - layoutInsets.right + interimSpace) / CGFloat(gc)
                        let c: Int = child.grid.columns
                        let co: Int = child.grid.offset.columns
                        let h: CGFloat = (parent.bounds.height - contentInsets.top - contentInsets.bottom - layoutInsets.top - layoutInsets.bottom + interimSpace) / CGFloat(gr)
                        let r: Int = child.grid.rows
                        let ro: Int = child.grid.offset.rows
                        let vt: CGFloat = CGFloat(ro) * h + contentInsets.top + layoutInsets.top
                        let vl: CGFloat = CGFloat(co) * w + contentInsets.left + layoutInsets.left
                        let vh: CGFloat = h * CGFloat(r) - interimSpace
                        let vw: CGFloat = w * CGFloat(c) - interimSpace
                        child.frame = CGRect(x: vl, y: vt, width: vw, height: vh)
                    }
                }
            }
        }
    }
}

/// A memory reference to the Grid instance for UIView extensions.
private var GridKey: UInt8 = 0

/// Grid extension for UIView.
public extension UIView {
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
