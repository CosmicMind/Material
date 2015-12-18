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
	public override var text: String? {
		didSet {
			textLayer.text = text
		}
	}
	
	/**
	:name:	textColor
	*/
	public override var textColor: UIColor? {
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
	public var wrapped: Bool! {
		didSet {
			textLayer.wrapped = nil == wrapped ? MaterialTheme.label.wrapped : wrapped!
		}
	}
	
	/**
	:name:	contentsScale
	*/
	public var contentsScale: CGFloat! {
		didSet {
			textLayer.contentsScale = nil == contentsScale ? MaterialTheme.label.contentsScale : contentsScale!
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
		super.init(coder: aDecoder)
	}
	
	/**
	:name:	init
	*/
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
	}
	
	/**
	:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectNull)
		prepareView()
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
		textAlignment = MaterialTheme.label.textAlignment
		wrapped = MaterialTheme.label.wrapped
		contentsScale = MaterialTheme.label.contentsScale
		font = MaterialTheme.label.font
	}
}