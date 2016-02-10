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

import Foundation
func associatedObject<ValueType: AnyObject>(
	base: AnyObject,
	key: UnsafePointer<UInt8>,
	initialiser: () -> ValueType)
	-> ValueType {
		if let associated = objc_getAssociatedObject(base, key)
			as? ValueType { return associated }
		let associated = initialiser()
		objc_setAssociatedObject(base, key, associated,
			.OBJC_ASSOCIATION_RETAIN)
		return associated
}
func associateObject<ValueType: AnyObject>(
	base: AnyObject,
	key: UnsafePointer<UInt8>,
	value: ValueType) {
		objc_setAssociatedObject(base, key, value,
			.OBJC_ASSOCIATION_RETAIN)
}

public enum GridSize : Int {
	case Grid1 = 1
	case Grid2 = 2
	case Grid3 = 3
	case Grid4 = 4
	case Grid5 = 5
	case Grid6 = 6
	case Grid7 = 7
	case Grid8 = 8
	case Grid9 = 9
	case Grid10 = 10
	case Grid11 = 11
	case Grid12 = 12
}

public enum GridLayout {
	case Horizontal
	case Vertical
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
	
	public var column: GridSize {
		get {
			return grid.column
		}
		set(value) {
			grid.column = value
		}
	}
	
	public var row: GridSize {
		get {
			return grid.row
		}
		set(value) {
			grid.row = value
		}
	}
	
	public var size: CGSize {
		get {
			return grid.size
		}
		set(value) {
			grid.size = value
		}
	}
	
	public var spacing: CGFloat {
		get {
			return grid.spacing
		}
		set(value) {
			grid.spacing = value
		}
	}
	
	public var views: Array<UIView>? {
		get {
			return grid.views
		}
		set(value) {
			grid.views = value
		}
	}
}

public protocol GridCell {
	/// Grid column size.
	var column: GridSize { get set }
	
	/// Grid row size.
	var row: GridSize { get set }
}

public class Grid {
	/// The size of the grid.
	public var size: CGSize = CGSizeZero {
		didSet {
			reloadLayout()
		}
	}
	
	/// The column size.
	public var column: GridSize {
		didSet {
			reloadLayout()
		}
	}
	
	/// The row size.
	public var row: GridSize {
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
	
	public init(row: GridSize = .Grid12, column: GridSize = .Grid12, spacing: CGFloat = 0) {
		self.row = row
		self.column = column
		self.spacing = spacing
	}
	
	/// Reload the button layout.
	public func reloadLayout() {
		let gc: Int = column.rawValue
		let gr: Int = row.rawValue
		let w: CGFloat = (size.width - contentInset.left - contentInset.right) / CGFloat(gc)
		let h: CGFloat = (size.height - contentInset.top - contentInset.bottom - spacing) / CGFloat(gr)
		if let v: Array<UIView> = views {
			var n: Int = 0
			var m: Int = 0
			for var i: Int = 0, l: Int = v.count - 1; i <= l; ++i {
				let view: UIView = v[i]
				let c: Int = view.column.rawValue
				let r: Int = view.row.rawValue
				if .Horizontal == layout {
					if 0 == i {
						view.frame = CGRectMake(CGFloat(i + n) * w + contentInset.left, contentInset.top, (w * CGFloat(c)) - spacing, (0 < size.height ? size.height : view.intrinsicContentSize().height) - contentInset.top - contentInset.bottom)
					} else if l == i {
						view.frame = CGRectMake(CGFloat(i + n) * w + contentInset.left + spacing, contentInset.top, (w * CGFloat(c)) - spacing, (0 < size.height ? size.height : view.intrinsicContentSize().height) - contentInset.top - contentInset.bottom)
					} else {
						view.frame = CGRectMake(CGFloat(i + n) * w + contentInset.right, contentInset.top, (w * CGFloat(c)) - spacing, (0 < size.height ? size.height : view.intrinsicContentSize().height) - contentInset.top - contentInset.bottom)
					}
				} else {
					if 0 == i {
						view.frame = CGRectMake(contentInset.left, CGFloat(i + m) * h + contentInset.top + spacing, (0 < size.width ? size.width : view.intrinsicContentSize().width) - contentInset.left - contentInset.right, (h * CGFloat(r)) - spacing)
					} else if l == i {
						view.frame = CGRectMake(contentInset.left, CGFloat(i + m) * h + contentInset.top + spacing, (0 < size.width ? size.width : view.intrinsicContentSize().width) - contentInset.left - contentInset.right, (h * CGFloat(r)) - spacing)
					} else {
						view.frame = CGRectMake(contentInset.left, CGFloat(i + m) * h + contentInset.top + spacing, (0 < size.width ? size.width : view.intrinsicContentSize().width) - contentInset.left - contentInset.right, (h * CGFloat(r)) - spacing)
					}
				}
				n += c - 1
				m += r - 1
			}
		}
	}
}