/*
* Copyright (C) 2015 - 20spacing, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
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
*	*	Neither the name of Material nor the names of its
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
	case None
	case Horizontal
	case Vertical
}

public class GridAxis {
	/// Grid reference.
	unowned var grid: Grid
	
	/// Inherit grid rows and columns.
	public var inherited: Bool = true
	
	/// The direction the grid layouts its views out.
	public var direction: GridAxisDirection = .Horizontal
	
	/// The rows size.
	public var rows: Int {
		didSet {
			grid.reloadLayout()
		}
	}
	
	/// The columns size.
	public var columns: Int {
		didSet {
			grid.reloadLayout()
		}
	}
	
	/**
	Initializer.
	- Parameter grid: The Grid reference used for offset values.
	- Parameter rows: The number of rows, Vertical axis the grid will use.
	- Parameter columns: The number of columns, Horizontal axis the grid will use.
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
			grid.reloadLayout()
		}
	}
	
	/// The columns size.
	public var columns: Int {
		didSet {
			grid.reloadLayout()
		}
	}
	
	/**
	Initializer.
	- Parameter grid: The Grid reference used for offset values.
	- Parameter rows: The number of rows, Vertical axis the grid will use.
	- Parameter columns: The number of columns, Horizontal axis the grid will use.
	*/
	public init(grid: Grid, rows: Int = 0, columns: Int = 0) {
		self.grid = grid
		self.rows = rows
		self.columns = columns
	}
}

public class Grid {
	/// The rows size.
	public var rows: Int {
		didSet {
			reloadLayout()
		}
	}
	
	/// The columns size.
	public var columns: Int {
		didSet {
			reloadLayout()
		}
	}
	
	/// Offsets for rows and columns.
	public private(set) var offset: GridOffset!
	
	/// The axis in which the Grid is laying out its views.
	public private(set) var axis: GridAxis!
	
	/// Preset inset value for grid.
	public var contentInsetPreset: MaterialEdgeInset = .None {
		didSet {
			contentInset = MaterialEdgeInsetToValue(contentInsetPreset)
		}
	}
	
	/// Insets value for grid.
	public var contentInset: UIEdgeInsets = MaterialEdgeInsetToValue(.None) {
		didSet {
			reloadLayout()
		}
	}
	
	/// The space between grid columnss.
	public var spacing: CGFloat {
		didSet {
			reloadLayout()
		}
	}
	
	/// An Array of UIButtons.
	public var views: Array<UIView>? {
		didSet {
			reloadLayout()
		}
	}
	
	/**
	Initializer.
	- Parameter rows: The number of rows, Vertical axis the grid will use.
	- Parameter columns: The number of columns, Horizontal axis the grid will use.
	- Parameter spacing: The spacing between rows or columns.
	*/
	public init(rows: Int = 12, columns: Int = 12, spacing: CGFloat = 0) {
		self.rows = rows
		self.columns = columns
		self.spacing = spacing
		self.offset = GridOffset(grid: self)
		self.axis = GridAxis(grid: self)
	}
	
	/// Reload the button layout.
	public func reloadLayout() {
		if let v: Array<UIView> = views {
			let gc: Int = axis.inherited ? columns : axis.columns
			let gr: Int = axis.inherited ? rows : axis.rows
			var n: Int = 0
			for var i: Int = 0, l: Int = v.count - 1; i <= l; ++i {
				let view: UIView = v[i]
				if let sv: UIView = view.superview {
					sv.layoutIfNeeded()
					switch axis.direction {
					case .Horizontal:
						let w: CGFloat = (sv.bounds.width - contentInset.left - contentInset.right + spacing) / CGFloat(gc)
						let c: Int = view.grid.columns
						let co: Int = view.grid.offset.columns
						let vh: CGFloat = sv.bounds.height - contentInset.top - contentInset.bottom
						let vl: CGFloat = CGFloat(i + n + co) * w + contentInset.left
						let vw: CGFloat = w * CGFloat(c) - spacing
						view.frame = CGRectMake(vl, contentInset.top, vw, vh)
						n += c + co - 1
					case .Vertical:
						let h: CGFloat = (sv.bounds.height - contentInset.top - contentInset.bottom + spacing) / CGFloat(gr)
						let r: Int = view.grid.rows
						let ro: Int = view.grid.offset.rows
						let vw: CGFloat = sv.bounds.width - contentInset.left - contentInset.right
						let vt: CGFloat = CGFloat(i + n + ro) * h + contentInset.top
						let vh: CGFloat = h * CGFloat(r) - spacing
						view.frame = CGRectMake(contentInset.left, vt, vw, vh)
						n += r + ro - 1
					case .None:
						let w: CGFloat = (sv.bounds.width - contentInset.left - contentInset.right + spacing) / CGFloat(gc)
						let c: Int = view.grid.columns
						let co: Int = view.grid.offset.columns
						let h: CGFloat = (sv.bounds.height - contentInset.top - contentInset.bottom + spacing) / CGFloat(gr)
						let r: Int = view.grid.rows
						let ro: Int = view.grid.offset.rows
						let vt: CGFloat = CGFloat(ro) * h + contentInset.top
						let vl: CGFloat = CGFloat(co) * w + contentInset.left
						let vh: CGFloat = h * CGFloat(r) - spacing
						let vw: CGFloat = w * CGFloat(c) - spacing
						view.frame = CGRectMake(vl, vt, vw, vh)
					}
				}
			}
		}
	}
}

/**
Gets the Obj-C reference for the Grid object within the UIView extension.
- Parameter base: Base object.
- Parameter key: Memory key pointer.
- Parameter initializer: Object initializer.
- Returns: The associated reference for the initializer object.
*/
private func GridAssociatedObject<T: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, initializer: () -> T) -> T {
	if let v: T = objc_getAssociatedObject(base, key) as? T {
		return v
	}
	
	let v: T = initializer()
	objc_setAssociatedObject(base, key, v, .OBJC_ASSOCIATION_RETAIN)
	return v
}

/**
Sets the Obj-C reference for the Grid object within the UIView extension.
- Parameter base: Base object.
- Parameter key: Memory key pointer.
- Parameter value: The object instance to set for the associated object.
- Returns: The associated reference for the initializer object.
*/
private func GridAssociateObject<T: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, value: T) {
	objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}

/// A memory reference to the Grid instance for UIView extensions.
private var gridKey: UInt8 = 0

/// Grid extension for UIView.
public extension UIView {
	/// Grid reference.
	public var grid: Grid {
		get {
			return GridAssociatedObject(self, key: &gridKey) {
				return Grid()
			}
		}
		set(value) {
			GridAssociateObject(self, key: &gridKey, value: value)
		}
	}
}