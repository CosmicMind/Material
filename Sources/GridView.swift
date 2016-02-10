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

public enum Grid : Int {
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

public protocol GridCell {
	/// Grid spacing.
	var grid: Grid { get set }
}

public class GridView : MaterialView {
	/// A single height for all views.
	public var unifiedHeight: CGFloat = 0 {
		didSet {
			reloadLayout()
		}
	}
	
	/// The grid size.
	public override var grid: Grid {
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
	public var views: Array<GridCell>? {
		didSet {
			reloadLayout()
		}
	}
	
	public convenience init() {
		self.init(frame: CGRectNull)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		spacing = 0
		super.init(coder: aDecoder)
		grid = .Grid12
	}

	public override init(frame: CGRect) {
		spacing = 0
		super.init(frame: frame)
		grid = .Grid12
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		reloadLayout()
	}
	
	/// Reload the button layout.
	public func reloadLayout() {
		for v in subviews {
			v.removeFromSuperview()
		}
		
		let g: Int = grid.rawValue
		let w: CGFloat = (width - spacing) / CGFloat(g)
		let h: CGFloat = (height - spacing) / CGFloat(g)
		if let v: Array<GridCell> = views {
			var n: Int = 0
			for var i: Int = 0, l: Int = v.count; i < l; ++i {
				let cell: GridCell = v[i]
				let view: UIView = cell as! UIView
				let m: Int = cell.grid.rawValue
				if .Horizontal == layout {
					view.frame = CGRectMake(CGFloat(i + n) * w + spacing, 0, (w * CGFloat(m)) - spacing, 0 < unifiedHeight ? unifiedHeight : view.intrinsicContentSize().height)
				} else {
					view.frame = CGRectMake(0, CGFloat(i + n) * h + spacing, view.intrinsicContentSize().width, (h * CGFloat(m)) - spacing)
				}
				view.removeFromSuperview()
				addSubview(view)
				n += m - 1
			}
		}
	}
}