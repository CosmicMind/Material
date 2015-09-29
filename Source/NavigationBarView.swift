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

public class NavigationBarView: MaterialView {
	//
	//	:name:	isLoading
	//
	internal lazy var isLoading: Bool = false
	
	/**
		:name:	statusBarStyle
	*/
	public var statusBarStyle: MaterialStatusBarStyle! {
		didSet {
			UIApplication.sharedApplication().setStatusBarStyle(.LightContent == statusBarStyle ? .LightContent : .Default, animated: true)
		}
	}
	
	/**
		:name:	titleInsets
	*/
	public var titleInsets: MaterialInsets? {
		didSet {
			titleInsetsRef = MaterialInsetsToValue(nil == titleInsets ? .Inset0 : titleInsets!)
		}
	}
	
	/**
		:name:	titleInsetsRef
	*/
	public var titleInsetsRef: MaterialInsetsType! {
		didSet {
			titleInsetsRef = nil == titleInsetsRef ? MaterialTheme.navigation.titleInsetsRef : titleInsetsRef!
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
			leftButtonsInsetsRef = MaterialInsetsToValue(nil == leftButtonsInsets ? .Inset0 : leftButtonsInsets!)
		}
	}
	
	/**
		:name:	leftButtonsInsetsRef
	*/
	public var leftButtonsInsetsRef: MaterialInsetsType! {
		didSet {
			leftButtonsInsetsRef = nil == leftButtonsInsetsRef ? MaterialTheme.navigation.leftButtonsInsetsRef : leftButtonsInsetsRef!
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
			rightButtonsInsetsRef = MaterialInsetsToValue(nil == rightButtonsInsets ? .Inset0 : rightButtonsInsets!)
		}
	}
	
	/**
		:name:	rightButtonsInsetsRef
	*/
	public var rightButtonsInsetsRef: MaterialInsetsType! {
		didSet {
			rightButtonsInsetsRef = nil == rightButtonsInsetsRef ? MaterialTheme.navigation.rightButtonsInsetsRef : rightButtonsInsetsRef!
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
		self.init(frame: CGRectMake(MaterialTheme.navigation.x, MaterialTheme.navigation.y, MaterialTheme.navigation.width, MaterialTheme.navigation.height))
	}
	
	/**
		:name:	init
	*/
	public convenience init?(titleLabel: UILabel? = nil, leftButtons: Array<MaterialButton>? = nil, rightButtons: Array<MaterialButton>? = nil) {
		self.init(frame: CGRectMake(MaterialTheme.navigation.x, MaterialTheme.navigation.y, MaterialTheme.navigation.width, MaterialTheme.navigation.height))
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
		
		// title
		if let v = titleLabel {
			insertSubview(v, atIndex: 0)
			MaterialLayout.alignToParentHorizontallyWithInsets(self, child: v, left: titleInsetsRef!.left, right: titleInsetsRef!.right)
			MaterialLayout.alignFromBottom(self, child: v, bottom: titleInsetsRef!.bottom)
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
		userInteractionEnabled = MaterialTheme.navigation.userInteractionEnabled
		backgroundColor = MaterialTheme.navigation.backgroudColor
		statusBarStyle = MaterialTheme.navigation.statusBarStyle
		titleInsetsRef = MaterialTheme.navigation.titleInsetsRef
		leftButtonsInsetsRef = MaterialTheme.navigation.leftButtonsInsetsRef
		rightButtonsInsetsRef = MaterialTheme.navigation.rightButtonsInsetsRef
		
		contentsRect = MaterialTheme.navigation.contentsRect
		contentsCenter = MaterialTheme.navigation.contentsCenter
		contentsScale = MaterialTheme.navigation.contentsScale
		contentsGravity = MaterialTheme.navigation.contentsGravity
		shadowDepth = MaterialTheme.navigation.shadowDepth
		shadowColor = MaterialTheme.navigation.shadowColor
		zPosition = MaterialTheme.navigation.zPosition
		masksToBounds = MaterialTheme.navigation.masksToBounds
		cornerRadius = MaterialTheme.navigation.cornerRadius
		borderWidth = MaterialTheme.navigation.borderWidth
		borderColor = MaterialTheme.navigation.bordercolor
	}
}
