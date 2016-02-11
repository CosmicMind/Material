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
	public var contentInsetPreset: MaterialEdgeInsetPreset = .None {
		didSet {
			contentInset = MaterialEdgeInsetPresetToValue(contentInsetPreset)
		}
	}
	
	/// Insets value for grid.
	public var contentInset: UIEdgeInsets = MaterialEdgeInsetPresetToValue(.None) {
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
			var n: Int = 0
			var m: Int = 0
			for var i: Int = 0, l: Int = v.count - 1; i <= l; ++i {
				let view: UIView = v[i]
				if let sv: UIView = view.superview {
					let w: CGFloat = (sv.bounds.width - contentInset.left - contentInset.right + spacing) / CGFloat(axis.inherited ? columns : axis.columns)
					let h: CGFloat = (sv.bounds.height - contentInset.top - contentInset.bottom + spacing) / CGFloat(axis.inherited ? rows : axis.rows)
					let c: Int = view.grid.columns
					let r: Int = view.grid.rows
					let co: Int = view.grid.offset.columns
					let ro: Int = view.grid.offset.rows
					if .Horizontal == axis.direction {
						
						// View height.
						let vh: CGFloat = sv.bounds.height - contentInset.top - contentInset.bottom
						
						// View left.
						let vl: CGFloat = CGFloat(i + n + co) * w + contentInset.left
						
						// View width.
						let vw: CGFloat = (w * CGFloat(c)) - spacing
						
						if 0 == i {
							view.frame = CGRectMake(vl, contentInset.top, vw, vh)
						} else if l == i {
							view.frame = CGRectMake(vl, contentInset.top, vw, vh)
						} else {
							view.frame = CGRectMake(vl, contentInset.top, vw, vh)
						}
					
						n += c + co - 1
					} else if .Vertical == axis.direction {
						// View width.
						let vw: CGFloat = sv.bounds.width - contentInset.left - contentInset.right
						
						// View top.
						let vt: CGFloat = CGFloat(i + m + ro) * h + contentInset.top
						
						// View height.
						let vh: CGFloat = (h * CGFloat(r)) - spacing
						
						if 0 == i {
							view.frame = CGRectMake(contentInset.left, vt, vw, vh)
						} else if l == i {
							view.frame = CGRectMake(contentInset.left, vt, vw, vh)
						} else {
							view.frame = CGRectMake(contentInset.left, vt, vw, vh)
						}
					
						m += r + ro - 1
					}
				}
			}
		}
	}
}

private func associatedObject<T: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, initialiser: () -> T) -> T {
	if let associated: T = objc_getAssociatedObject(base, key) as? T {
		return associated
	}
	
	let associated = initialiser()
	objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
	return associated
}

private func associateObject<T: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, value: T) {
	objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}

private var gridKey: UInt8 = 0

public extension UIView {
	public var grid: Grid {
		get {
			return associatedObject(self, key: &gridKey) {
				return Grid()
			}
		}
		set(value) {
			associateObject(self, key: &gridKey, value: value)
		}
	}
}