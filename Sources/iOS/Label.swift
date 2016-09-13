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

open class Label: UILabel {
	/**
	:name:	layerClass
	*/
    open override class var layerClass: AnyClass {
		return MaterialTextLayer.self
	}
	
	/**
	:name:	textLayer
	*/
	open var textLayer: MaterialTextLayer {
		return layer as! MaterialTextLayer
	}
	
	/**
	:name:	text
	*/
	@IBInspectable
    open override var text: String? {
		didSet {
			textLayer.text = text
		}
	}
	
	/**
	:name:	textColor
	*/
	@IBInspectable
    open override var textColor: UIColor? {
		didSet {
			textLayer.textColor = textColor
		}
	}
	
	/**
	:name:	font
	*/
	open override var font: UIFont! {
		didSet {
			textLayer.fontType = font
		}
	}
	
	/**
	:name:	textAlignment
	*/
	open override var textAlignment: NSTextAlignment {
		didSet {
			textLayer.textAlignment = textAlignment
		}
	}
	
	/**
	:name:	wrapped
	*/
	@IBInspectable
    open var wrapped: Bool {
		didSet {
			textLayer.isWrapped = wrapped
		}
	}
	
	/**
	:name:	contentsScale
	*/
	@IBInspectable
    open var contentsScale: CGFloat {
		didSet {
			textLayer.contentsScale = contentsScale
		}
	}
	
	/**
	:name:	lineBreakMode
	*/
	open override var lineBreakMode: NSLineBreakMode {
		didSet {
			textLayer.lineBreakMode = lineBreakMode
		}
	}
	
	/**
	:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		wrapped = true
		contentsScale = Device.scale
		super.init(coder: aDecoder)
		prepare()
	}
	
	/**
	:name:	init
	*/
	public override init(frame: CGRect) {
		wrapped = true
		contentsScale = Device.scale
		super.init(frame: frame)
		prepare()
	}
	
	/**
	:name:	init
	*/
	public convenience init() {
		self.init(frame: .zero)
	}
	
	/**
	:name:	stringSize
	*/
	open func stringSize(constrainedToWidth width: Double) -> CGSize {
		return textLayer.stringSize(constrainedToWidth: width)
	}
	
	/**
	:name:	prepare
	*/
	open func prepare() {
		contentScaleFactor = Device.scale
		textAlignment = .left
	}
}
