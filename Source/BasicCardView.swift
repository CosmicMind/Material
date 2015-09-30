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

public class BasicCardView: MaterialPulseView {
	/**
		:name:	titleInsets
	*/
	public var titleInsets: MaterialInsets? {
		didSet {
			titleInsetsRef = nil == titleInsets ? nil : MaterialInsetsToValue(titleInsets!)
		}
	}
	
	/**
		:name:	titleInsetsRef
	*/
	public var titleInsetsRef: MaterialInsetsType! {
		didSet {
			titleInsetsRef = nil == titleInsetsRef ? (top: 0, left: 0, bottom: 0, right: 0) : titleInsetsRef!
			reloadView()
		}
	}
	
	/**
		:name:	titleLabel
	*/
	public var titleLabel: UILabel? {
		didSet {
			if let v = titleLabel {
				v.translatesAutoresizingMaskIntoConstraints = false
			}
			reloadView()
		}
	}
	
	/**
		:name:	leftButtonsInsets
	*/
	public var leftButtonsInsets: MaterialInsets? {
		didSet {
			leftButtonsInsetsRef = nil == leftButtonsInsets ? nil : MaterialInsetsToValue(leftButtonsInsets!)
		}
	}
	
	/**
		:name:	leftButtonsInsetsRef
	*/
	public var leftButtonsInsetsRef: MaterialInsetsType! {
		didSet {
			leftButtonsInsetsRef = nil == leftButtonsInsetsRef ? (top: 0, left: 0, bottom: 0, right: 0) : leftButtonsInsetsRef!
			reloadView()
		}
	}
	
	/**
		:name:	leftButtons
	*/
	public var leftButtons: Array<MaterialButton>? {
		didSet {
			if let v = leftButtons {
				for b in v {
					b.translatesAutoresizingMaskIntoConstraints = false
				}
			}
			reloadView()
		}
	}
	
	/**
		:name:	rightButtonsInsets
	*/
	public var rightButtonsInsets: MaterialInsets? {
		didSet {
			rightButtonsInsetsRef = nil == rightButtonsInsets ? nil : MaterialInsetsToValue(rightButtonsInsets!)
		}
	}
	
	/**
		:name:	rightButtonsInsetsRef
	*/
	public var rightButtonsInsetsRef: MaterialInsetsType! {
		didSet {
			rightButtonsInsetsRef = nil == rightButtonsInsetsRef ? (top: 0, left: 0, bottom: 0, right: 0) : rightButtonsInsetsRef!
			reloadView()
		}
	}
	
	/**
		:name:	rightButtons
	*/
	public var rightButtons: Array<MaterialButton>? {
		didSet {
			if let v = rightButtons {
				for b in v {
					b.translatesAutoresizingMaskIntoConstraints = false
				}
			}
			reloadView()
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
	}
	
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectZero)
	}
	
	/**
		:name:	init
	*/
	public convenience init?(titleLabel: UILabel? = nil, leftButtons: Array<MaterialButton>? = nil, rightButtons: Array<MaterialButton>? = nil) {
		self.init(frame: CGRectZero)
		self.prepareProperties(titleLabel, leftButtons: leftButtons, rightButtons: rightButtons)
	}
	
	/**
		:name:	reloadView
	*/
	public func reloadView() {
		// clear constraints so new ones do not conflict
		removeConstraints(constraints)
		for v in subviews {
			v.removeFromSuperview()
		}
		
		var verticalFormat: String = "V:|"
		var views: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
		var metrics: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
		
		// title
		if let v = titleLabel {
			verticalFormat += "-(titleLabelTopInset)-[titleLabel]-(titleLabelBottomInset)-"
			views["titleLabel"] = titleLabel
			metrics["titleLabelTopInset"] = titleInsetsRef!.top
			metrics["titleLabelBottomInset"] = titleInsetsRef!.bottom
			
			addSubview(v)
			v.layer.zPosition = 2000
			MaterialLayout.alignToParentHorizontallyWithInsets(self, child: v, left: titleInsetsRef!.left, right: titleInsetsRef!.right)
		}
		
		// leftButtons
		if let v = leftButtons {
			var h: String = "H:|"
			var d: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
			var i: Int = 0
			
			for b in v {
				let k: String = "b\(i++)"
				d[k] = b
				h += "-(left)-[\(k)]"
				
				insertSubview(b, atIndex: 1)
				MaterialLayout.alignFromBottom(self, child: b, bottom: leftButtonsInsetsRef!.bottom)
			}
			
			addConstraints(MaterialLayout.constraint(h, options: [], metrics: ["left" : leftButtonsInsetsRef!.left], views: d))
		}
		
		// rightButtons
		if let v = rightButtons {
			var h: String = "H:"
			var d: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
			var i: Int = 0
			
			for b in v {
				let k: String = "b\(i++)"
				d[k] = b
				h += "[\(k)]-(right)-"
				
				insertSubview(b, atIndex: 1)
				MaterialLayout.alignFromBottom(self, child: b, bottom: rightButtonsInsetsRef!.bottom)
			}
			
			addConstraints(MaterialLayout.constraint(h + "|", options: [], metrics: ["right" : rightButtonsInsetsRef!.right], views: d))
		}
		
		if 0 < views.count {
			verticalFormat += "|"
			
			addConstraints(MaterialLayout.constraint(verticalFormat, options: [], metrics: metrics, views: views))
		}
	}
	
	//
	//	:name:	prepareProperties
	//
	internal func prepareProperties(titleLabel: UILabel?, leftButtons: Array<MaterialButton>?, rightButtons: Array<MaterialButton>?) {
		self.titleLabel = titleLabel
		self.leftButtons = leftButtons
		self.rightButtons = rightButtons
	}
	
	//
	//	:name:	prepareView
	//
	internal override func prepareView() {
		super.prepareView()
		userInteractionEnabled = MaterialTheme.basicCardView.userInteractionEnabled
		backgroundColor = MaterialTheme.basicCardView.backgroudColor
		titleInsetsRef = MaterialTheme.basicCardView.titleInsetsRef
		leftButtonsInsetsRef = MaterialTheme.basicCardView.leftButtonsInsetsRef
		rightButtonsInsetsRef = MaterialTheme.basicCardView.rightButtonsInsetsRef
		
		contentsRect = MaterialTheme.basicCardView.contentsRect
		contentsCenter = MaterialTheme.basicCardView.contentsCenter
		contentsScale = MaterialTheme.basicCardView.contentsScale
		contentsGravity = MaterialTheme.basicCardView.contentsGravity
		shadowDepth = MaterialTheme.basicCardView.shadowDepth
		shadowColor = MaterialTheme.basicCardView.shadowColor
		zPosition = MaterialTheme.basicCardView.zPosition
		masksToBounds = MaterialTheme.basicCardView.masksToBounds
		cornerRadius = MaterialTheme.basicCardView.cornerRadius
		borderWidth = MaterialTheme.basicCardView.borderWidth
		borderColor = MaterialTheme.basicCardView.bordercolor
	}
}
