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

public enum GridRow : Int {
	case Row1 = 1
	case Row2 = 2
	case Row3 = 3
	case Row4 = 4
	case Row5 = 5
	case Row6 = 6
	case Row7 = 7
	case Row8 = 8
	case Row9 = 9
	case Row10 = 10
	case Row11 = 11
	case Row12 = 12
}

public enum GridColumn : Int {
	case Column1 = 1
	case Column2 = 2
	case Column3 = 3
	case Column4 = 4
	case Column5 = 5
	case Column6 = 6
	case Column7 = 7
	case Column8 = 8
	case Column9 = 9
	case Column10 = 10
	case Column11 = 11
	case Column12 = 12
}

public enum GridLayout {
	case Horizontal
	case Vertical
}

public class Grid {
	/// The row size.
	public var row: GridRow {
		didSet {
			reloadLayout()
		}
	}
	
	/// The row size.
	public var rowOffset: GridRow? {
		didSet {
			reloadLayout()
		}
	}
	
	/// The column size.
	public var column: GridColumn {
		didSet {
			reloadLayout()
		}
	}
	
	/// The column size.
	public var columnOffset: GridColumn? {
		didSet {
			reloadLayout()
		}
	}
	
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
	
	/// The space between grid columns.
	public var spacing: CGFloat {
		didSet {
			reloadLayout()
		}
	}
	
	/// The direction in which the animation opens the menu.
	public var layout: GridLayout = .Horizontal {
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
	
	public init(row: GridRow = .Row12, column: GridColumn = .Column12, spacing: CGFloat = 0) {
		self.row = row
		self.column = column
		self.spacing = spacing
	}
	
	/// Reload the button layout.
	public func reloadLayout() {
		if let v: Array<UIView> = views {
			var n: Int = 0
			var m: Int = 0
			for var i: Int = 0, l: Int = v.count - 1; i <= l; ++i {
				let view: UIView = v[i]
				if let sv: UIView = view.superview {
					let w: CGFloat = (sv.bounds.width - contentInset.left - contentInset.right + spacing) / CGFloat(column.rawValue)
					let h: CGFloat = (sv.bounds.height - contentInset.top - contentInset.bottom + spacing) / CGFloat(row.rawValue)
					let c: Int = view.grid.column.rawValue
					let r: Int = view.grid.row.rawValue
					let co: Int = nil == view.grid.columnOffset ? 0 : view.grid.columnOffset!.rawValue
					let ro: Int = nil == view.grid.rowOffset ? 0 : view.grid.rowOffset!.rawValue
					if .Horizontal == layout {
						
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
					} else if .Vertical == layout {
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
					}
					n += c + co - 1
					m += r + ro - 1
				}
			}
		}
	}
}

private func associatedObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, initialiser: () -> ValueType) -> ValueType {
	if let associated = objc_getAssociatedObject(base, key) as? ValueType {
		return associated
	}
	
	let associated = initialiser()
	objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
	return associated
}

private func associateObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, value: ValueType) {
	objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}

private var gridKey: UInt8 = 0

public extension UIView {
	public var grid: Grid {
		get {
			return associatedObject(self, key: &gridKey) { return Grid() }
		}
		set(value) {
			associateObject(self, key: &gridKey, value: value)
		}
	}
}