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
 *	*	Neither the name of CosmicMind nor the names of its
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

public class MaterialTextLayer: CATextLayer {
	/**
	:name:	fontType
	*/
	public var fontType: UIFont? {
		didSet {
			if let v: UIFont = fontType {
				super.font = CGFont(v.fontName as CFString)!
				pointSize = v.pointSize
			}
		}
	}
	
	/**
	:name:	text
	*/
	@IBInspectable public var text: String? {
		didSet {
			string = text as Any
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
			foregroundColor = textColor?.cgColor
		}
	}
	
	/**
	:name:	textAlignment
	*/
	public var textAlignment: NSTextAlignment = .left {
		didSet {
			switch textAlignment {
			case .left:
				alignmentMode = kCAAlignmentLeft
			case .center:
				alignmentMode = kCAAlignmentCenter
			case .right:
				alignmentMode = kCAAlignmentRight
			case .justified:
				alignmentMode = kCAAlignmentJustified
			case .natural:
				alignmentMode = kCAAlignmentNatural
			}
		}
	}
	
	/**
	:name:	lineBreakMode
	*/
	public var lineBreakMode: NSLineBreakMode = .byWordWrapping {
		didSet {
			switch lineBreakMode {
			case .byWordWrapping: // Wrap at word boundaries, default
				truncationMode = kCATruncationNone
			case .byCharWrapping: // Wrap at character boundaries
				truncationMode = kCATruncationNone
			case .byClipping: // Simply clip
				truncationMode = kCATruncationNone
			case .byTruncatingHead: // Truncate at head of line: "...wxyz"
				truncationMode = kCATruncationStart
			case .byTruncatingTail: // Truncate at tail of line: "abcd..."
				truncationMode = kCATruncationEnd
			case .byTruncatingMiddle: // Truncate middle of line:  "ab...yz"
				truncationMode = kCATruncationMiddle
			}
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
	public override init(layer: Any) {
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
        guard let v = fontType, let t = text, 0 < t.utf16.count else {
            return .zero
        }
        return v.stringSize(string: text!, constrainedToWidth: width)
	}
	
	/**
	:name:	prepareLayer
	*/
	internal func prepareLayer() {
		textColor = Color.black
		textAlignment = .left
		isWrapped = true
		contentsScale = Device.scale
		lineBreakMode = .byWordWrapping
	}
}
