//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io> and other CosmicMind contributors
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

public class MaterialTextLayer : CATextLayer {
	/**
	:name:	internalFont
	*/
	private var internalFont: UIFont?
	
	/**
	:name:	font
	*/
	public override var font: AnyObject? {
		get {
			return internalFont
		}
		set(value) {
			internalFont = value as? UIFont
			if let v: UIFont = internalFont {
				super.font = CGFontCreateWithFontName(v.fontName as CFStringRef)!
				pointSize = v.pointSize
			}
		}
	}
	
	/**
	:name:	text
	*/
	public var text: String? {
		didSet {
			string = text as? AnyObject
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
				truncationMode = kCATruncationNone
			case .ByCharWrapping: // Wrap at character boundaries
				truncationMode = kCATruncationNone
			case .ByClipping: // Simply clip
				truncationMode = kCATruncationNone
			case .ByTruncatingHead: // Truncate at head of line: "...wxyz"
				truncationMode = kCATruncationStart
			case .ByTruncatingTail: // Truncate at tail of line: "abcd..."
				truncationMode = kCATruncationEnd
			case .ByTruncatingMiddle: // Truncate middle of line:  "ab...yz"
				truncationMode = kCATruncationMiddle
			}
		}
	}
	
	/**
	:name:	x
	*/
	public var x: CGFloat {
		get {
			return frame.origin.x
		}
		set(value) {
			frame.origin.x = value
		}
	}
	
	/**
	:name:	y
	*/
	public var y: CGFloat {
		get {
			return frame.origin.y
		}
		set(value) {
			frame.origin.y = value
		}
	}
	
	/**
	:name:	width
	*/
	public var width: CGFloat {
		get {
			return frame.size.width
		}
		set(value) {
			frame.size.width = value
		}
	}
	
	/**
	:name:	height
	*/
	public var height: CGFloat {
		get {
			return frame.size.height
		}
		set(value) {
			frame.size.height = value
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
		if let v: UIFont = internalFont {
			if 0 < text?.utf16.count {
				return v.stringSize(text!, constrainedToWidth: width)
			}
		}
		return CGSizeZero
	}
	
	/**
	:name:	prepareLayer
	*/
	internal func prepareLayer() {
		textColor = MaterialTheme.textLayer.textColor
		textAlignment = MaterialTheme.textLayer.textAlignment
		wrapped = MaterialTheme.textLayer.wrapped
		contentsScale = MaterialTheme.textLayer.contentsScale
		font = MaterialTheme.textLayer.font
		lineBreakMode = MaterialTheme.textLayer.lineBreakMode
	}
}
