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

public extension UIFont {
	func sizeOfString(string: String, constrainedToWidth width: Double) -> CGSize {
		return string.boundingRectWithSize(CGSize(width: width, height: DBL_MAX),
			options: NSStringDrawingOptions.UsesLineFragmentOrigin,
			attributes: [NSFontAttributeName: self],
			context: nil).size
	}
}

public class MaterialTextLayer : CATextLayer {
	/**
		:name:	pointSize
	*/
	public var text: String? {
		didSet {
			string = text
		}
	}
	
	/**
		:name:	pointSize
	*/
	public var pointSize: CGFloat = 10 {
		didSet {
			fontSize = pointSize
		}
	}
	
	/**
		:name:	font
	*/
	public override var font: AnyObject? {
		get {
			return super.font
		}
		set(value) {
			if let v = value as? UIFont {
				super.font = CGFontCreateWithFontName(v.fontName as CFStringRef)!
				pointSize = v.pointSize
			}
		}
	}
	
	/**
		:name:	textColor
	*/
	public var textColor: UIColor? {
		didSet {
			foregroundColor = textColor?.CGColor
		}
	}
	
	/**
		:name:	textAlignment
	*/
	public var textAlignment: NSTextAlignment = .Left {
		didSet {
			switch textAlignment {
			case .Left:
				alignmentMode = kCAAlignmentLeft
			case .Center:
				alignmentMode = kCAAlignmentCenter
			case .Right:
				alignmentMode = kCAAlignmentRight
			case .Justified:
				alignmentMode = kCAAlignmentJustified
			case .Natural:
				alignmentMode = kCAAlignmentNatural
			}
		}
	}
	
	/**
		:name:	lineBreakMode
	*/
	public var lineBreakMode: NSLineBreakMode = .ByWordWrapping {
		didSet {
			switch lineBreakMode {
			case .ByWordWrapping: // Wrap at word boundaries, default
				wrapped = true
				truncationMode = kCATruncationNone
			case .ByCharWrapping: // Wrap at character boundaries
				wrapped = true
				truncationMode = kCATruncationNone
			case .ByClipping: // Simply clip
				wrapped = false
				truncationMode = kCATruncationNone
			case .ByTruncatingHead: // Truncate at head of line: "...wxyz"
				wrapped = false
				truncationMode = kCATruncationStart
			case .ByTruncatingTail: // Truncate at tail of line: "abcd..."
				wrapped = false
				truncationMode = kCATruncationEnd
			case .ByTruncatingMiddle: // Truncate middle of line:  "ab...yz"
				wrapped = false
				truncationMode = kCATruncationMiddle
			}
		}
	}
	
	/**
		:name: init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
		:name: init
	*/
	public override init(layer: AnyObject) {
		super.init(layer: layer)
		prepareLayer()
	}
	
	/**
		:name: init
	*/
	public override init() {
		super.init()
		prepareLayer()
	}
	
	/**
		:name:	stringSize
	*/
	public func stringSize(constrainedToWidth width: Double) -> CGSize {
		if let v: UIFont = font as? UIFont {
			if let s: String = string as? String {
				return v.sizeOfString(s, constrainedToWidth: width)
			}
		}
		return CGSizeZero
	}
	
	//
	//	:name:	prepareLayer
	//
	internal func prepareLayer() {
		textColor = MaterialColor.black
	}
}

