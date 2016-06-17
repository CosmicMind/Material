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

@IBDesignable
public class MaterialLabel : UILabel {
	/**
	:name:	layerClass
	*/
	public override class func layerClass() -> AnyClass {
		return MaterialTextLayer.self
	}
	
	/**
	:name:	textLayer
	*/
	public var textLayer: MaterialTextLayer {
		return layer as! MaterialTextLayer
	}
	
	/**
	:name:	text
	*/
	@IBInspectable public override var text: String? {
		didSet {
			textLayer.text = text
		}
	}
	
	/**
	:name:	textColor
	*/
	@IBInspectable public override var textColor: UIColor? {
		didSet {
			textLayer.textColor = textColor
		}
	}
	
	/**
	:name:	font
	*/
	public override var font: UIFont! {
		didSet {
			textLayer.fontType = font
		}
	}
	
	/**
	:name:	textAlignment
	*/
	public override var textAlignment: NSTextAlignment {
		didSet {
			textLayer.textAlignment = textAlignment
		}
	}
	
	/**
	:name:	wrapped
	*/
	@IBInspectable public var wrapped: Bool {
		didSet {
			textLayer.wrapped = wrapped
		}
	}
	
	/**
	:name:	contentsScale
	*/
	@IBInspectable public var contentsScale: CGFloat {
		didSet {
			textLayer.contentsScale = contentsScale
		}
	}
	
	/**
	:name:	lineBreakMode
	*/
	public override var lineBreakMode: NSLineBreakMode {
		didSet {
			textLayer.lineBreakMode = lineBreakMode
		}
	}
	
	/**
	:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		wrapped = true
		contentsScale = MaterialDevice.scale
		super.init(coder: aDecoder)
		prepareView()
	}
	
	/**
	:name:	init
	*/
	public override init(frame: CGRect) {
		wrapped = true
		contentsScale = MaterialDevice.scale
		super.init(frame: frame)
		prepareView()
	}
	
	/**
	:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRect.zero)
	}
	
	/**
	:name:	stringSize
	*/
	public func stringSize(constrainedToWidth width: Double) -> CGSize {
		return textLayer.stringSize(constrainedToWidth: width)
	}
	
	/**
	:name:	prepareView
	*/
	public func prepareView() {
		contentScaleFactor = MaterialDevice.scale
		textAlignment = .Left
	}
}