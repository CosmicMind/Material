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

public class MaterialTextLayer : CATextLayer {
	/**
	:name:	fontType
	*/
	public var fontType: UIFont? {
		didSet {
			if let v: UIFont = fontType {
				super.font = CGFontCreateWithFontName(v.fontName as CFStringRef)!
				pointSize = v.pointSize
			}
		}
	}
	
	/**
	:name:	text
	*/
	@IBInspectable public var text: String? {
		didSet {
			string = text as? AnyObject
		}
	}
	
	/**
	:name:	pointSize
	*/
	@IBInspectable public var pointSize: CGFloat = 10 {
		didSet {
			fontSize = pointSize
		}
	}
	
	/**
	:name:	textColor
	*/
	@IBInspectable public var textColor: UIColor? {
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
	@IBInspectable public var x: CGFloat {
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
	@IBInspectable public var y: CGFloat {
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
	@IBInspectable public var width: CGFloat {
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
	@IBInspectable public var height: CGFloat {
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
		prepareLayer()
	}
	
	/**
	:name: init
	*/
	public override init(layer: AnyObject) {
		super.init()
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
	:name: init
	*/
	public convenience init(frame: CGRect) {
		self.init()
		self.frame = frame
	}
	
	/**
	:name:	stringSize
	*/
	public func stringSize(constrainedToWidth width: Double) -> CGSize {
		if let v: UIFont = fontType {
			if 0 < text?.utf16.count {
				return v.stringSize(text!, constrainedToWidth: width)
			}
		}
		return CGSize.zero
	}
	
	/**
	:name:	prepareLayer
	*/
	internal func prepareLayer() {
		textColor = MaterialColor.black
		textAlignment = .Left
		wrapped = true
		contentsScale = MaterialDevice.scale
		lineBreakMode = .ByWordWrapping
	}
}
