//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

public class MaterialLabel : UILabel {
	/**
		:name:	layerClass
	*/
	public override class func layerClass() -> AnyClass {
		return CATextLayer.self
	}
	
	/**
		:name:	textLayer
	*/
	public var textLayer: CATextLayer {
		return layer as! CATextLayer
	}
	
	/**
		:name:	text
	*/
	public override var text: String? {
		didSet {
			textLayer.string = text
		}
	}
	
	/**
		:name:	textColor
	*/
	public override var textColor: UIColor? {
		didSet {
			textLayer.foregroundColor = textColor?.CGColor
		}
	}
	
	/**
		:name:	font
	*/
	public override var font: UIFont? {
		didSet {
			if let v = font {
				textLayer.font = CGFontCreateWithFontName(v.fontName as CFStringRef)!
				textLayer.fontSize = v.pointSize
			}
		}
	}
	
	/**
		:name:	textAlignment
	*/
	public override var textAlignment: NSTextAlignment {
		didSet {
			switch textAlignment {
			case .Left:
				textLayer.alignmentMode = kCAAlignmentLeft
			case .Center:
				textLayer.alignmentMode = kCAAlignmentCenter
			case .Right:
				textLayer.alignmentMode = kCAAlignmentRight
			case .Justified:
				textLayer.alignmentMode = kCAAlignmentJustified
			case .Natural:
				textLayer.alignmentMode = kCAAlignmentNatural
			}
		}
	}
	
	/**
		:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
		:name:	init
	*/
	public override init(frame: CGRect) {
		super.init(frame: frame)
		textLayer.wrapped = true
		textLayer.contentsScale = UIScreen.mainScreen().scale
	}
}