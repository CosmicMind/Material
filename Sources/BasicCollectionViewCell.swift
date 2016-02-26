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

public enum BasicCollectionViewCellSize {
	case Small
	case Default
	case Large
}

public class BasicCollectionViewCell : MaterialCollectionViewCell {
	/// An Optional title UILabel.
	public var titleLabel: UILabel? {
		didSet {
			reloadView()
		}
	}
	
	/// An Optional detail UILabel.
	public var detailLabel: UILabel? {
		didSet {
			reloadView()
		}
	}
	
	/// An Optional ControlView.
	public var controlView: ControlView? {
		didSet {
			reloadView()
		}
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public override func prepareView() {
		super.prepareView()
		contentInsetPreset = .Square3
		backgroundColor = MaterialColor.white
	}
	
	/// Reloads the view.
	public func reloadView() {
		contentView.grid.views = []
		switch height {
		case 192:
			let rows: Int = Int(height / 48)
			
			contentView.grid.axis.direction = .Vertical
			contentView.grid.axis.rows = rows
			
			for v in contentView.subviews {
				v.removeFromSuperview()
			}
			
			var a: Int = 0
			var b: Int = 0
			var c: Int = 0
			
			if nil != titleLabel && nil == detailLabel && nil == controlView {
				a = rows
			} else if nil == titleLabel && nil != detailLabel && nil == controlView {
				b = rows
			} else if nil == titleLabel && nil == detailLabel && nil != controlView {
				c = rows
			} else if nil != titleLabel && nil != detailLabel && nil == controlView {
				a = 1
				b = rows - 1
			} else if nil != titleLabel && nil == detailLabel && nil != controlView {
				a = rows - 1
				c = 1
			} else if nil == titleLabel && nil != detailLabel && nil != controlView {
				b = rows - 1
				c = 1
			} else if nil != titleLabel && nil != detailLabel && nil != controlView {
				a = 1
				b = rows - 6
				c = 1
			}
			
			if let v: UILabel = titleLabel {
				v.grid.rows = a
				contentView.addSubview(v)
				contentView.grid.views?.append(v)
			}
			
			if let v: UILabel = detailLabel {
				v.grid.rows = b
				contentView.addSubview(v)
				contentView.grid.views?.append(v)
			}
			
			if let v: ControlView = controlView {
				v.grid.rows = c
				contentView.addSubview(v)
				contentView.grid.views?.append(v)
			}
			
			grid.views = [
				contentView
			]
			contentView.grid.reloadLayout()
		case 144:
			let rows: Int = Int(height / 48)
			
			contentView.grid.axis.direction = .Vertical
			contentView.grid.axis.rows = rows
			
			for v in contentView.subviews {
				v.removeFromSuperview()
			}
			
			var a: Int = 0
			var b: Int = 0
			var c: Int = 0
			
			if nil != titleLabel && nil == detailLabel && nil == controlView {
				a = rows
			} else if nil == titleLabel && nil != detailLabel && nil == controlView {
				b = rows
			} else if nil == titleLabel && nil == detailLabel && nil != controlView {
				c = rows
			} else if nil != titleLabel && nil != detailLabel && nil == controlView {
				a = 1
				b = rows - 1
			} else if nil != titleLabel && nil == detailLabel && nil != controlView {
				a = rows - 1
				c = 1
			} else if nil == titleLabel && nil != detailLabel && nil != controlView {
				b = rows - 1
				c = 1
			} else if nil != titleLabel && nil != detailLabel && nil != controlView {
				a = 1
				b = rows - 6
				c = 1
			}
			
			if let v: UILabel = titleLabel {
				v.grid.rows = a
				contentView.addSubview(v)
				contentView.grid.views?.append(v)
			}
			
			if let v: UILabel = detailLabel {
				v.grid.rows = b
				contentView.addSubview(v)
				contentView.grid.views?.append(v)
			}
			
			if let v: ControlView = controlView {
				v.grid.rows = c
				contentView.addSubview(v)
				contentView.grid.views?.append(v)
			}
			
			grid.views = [
				contentView
			]
			contentView.grid.reloadLayout()
		case 192:
			let rows: Int = Int(height / 48)
			
			contentView.grid.axis.direction = .Vertical
			contentView.grid.axis.rows = rows
			
			for v in contentView.subviews {
				v.removeFromSuperview()
			}
			
			var a: Int = 0
			var b: Int = 0
			var c: Int = 0
			
			if nil != titleLabel && nil == detailLabel && nil == controlView {
				a = rows
			} else if nil == titleLabel && nil != detailLabel && nil == controlView {
				b = rows
			} else if nil == titleLabel && nil == detailLabel && nil != controlView {
				c = rows
			} else if nil != titleLabel && nil != detailLabel && nil == controlView {
				a = 1
				b = rows - 1
			} else if nil != titleLabel && nil == detailLabel && nil != controlView {
				a = rows - 1
				c = 1
			} else if nil == titleLabel && nil != detailLabel && nil != controlView {
				b = rows - 1
				c = 1
			} else if nil != titleLabel && nil != detailLabel && nil != controlView {
				a = 1
				b = rows - 6
				c = 1
			}
			
			if let v: UILabel = titleLabel {
				v.grid.rows = a
				contentView.addSubview(v)
				contentView.grid.views?.append(v)
			}
			
			if let v: UILabel = detailLabel {
				v.grid.rows = b
				contentView.addSubview(v)
				contentView.grid.views?.append(v)
			}
			
			if let v: ControlView = controlView {
				v.grid.rows = c
				contentView.addSubview(v)
				contentView.grid.views?.append(v)
			}
			
			grid.views = [
				contentView
			]
			contentView.grid.reloadLayout()
		default:
			grid.views = []
			contentView.grid.views = []
		}
	}
}
