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

@objc(SearchBarViewDelegate)
public protocol SearchBarViewDelegate : MaterialDelegate {
	optional func materialSearchBarDidBeginEditing(searchBarView: SearchBarView)
	optional func materialSearchBarDidEndEditing(searchBarView: SearchBarView)
}

@objc(SearchBarView)
public class SearchBarView : MaterialView, UITextFieldDelegate {
	/**
		:name:	internalBackgroundColor
	*/
	internal var internalBackgroundColor: UIColor?
	
	/**
		:name:	editingBackgroundColor
	*/
	public var editingBackgroundColor: UIColor?
	
	/**
		:name:	statusBarStyle
	*/
	public var statusBarStyle: MaterialStatusBarStyle! {
		didSet {
			UIApplication.sharedApplication().setStatusBarStyle(.LightContent == statusBarStyle ? .LightContent : .Default, animated: true)
		}
	}
	
	/**
		:name:	textField
	*/
	public private(set) lazy var textField: UITextField = UITextField()
	
	/**
		:name:	contentInsets
	*/
	public var contentInsets: MaterialInsets = .None {
		didSet {
			contentInsetsRef = MaterialInsetsToValue(contentInsets)
		}
	}
	
	/**
		:name:	contentInsetsRef
	*/
	public var contentInsetsRef: MaterialInsetsType = MaterialTheme.searchBarView.contentInsetsRef {
		didSet {
			reloadView()
		}
	}
	
	/**
		:name:	textFieldInsets
	*/
	public var textFieldInsets: MaterialInsets = .None {
		didSet {
			textFieldInsetsRef = MaterialInsetsToValue(textFieldInsets)
		}
	}
	
	/**
		:name:	textFieldInsetsRef
	*/
	public var textFieldInsetsRef: MaterialInsetsType = MaterialTheme.searchBarView.textFieldInsetsRef {
		didSet {
			reloadView()
		}
	}
	
	/**
		:name:	leftButtonsInsets
	*/
	public var leftButtonsInsets: MaterialInsets = .None {
		didSet {
			leftButtonsInsetsRef = MaterialInsetsToValue(leftButtonsInsets)
		}
	}
	
	/**
		:name:	leftButtonsInsetsRef
	*/
	public var leftButtonsInsetsRef: MaterialInsetsType = MaterialTheme.searchBarView.leftButtonsInsetsRef {
		didSet {
			reloadView()
		}
	}
	
	/**
		:name:	leftButtons
	*/
	public var leftButtons: Array<UIButton>? {
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
	public var rightButtonsInsets: MaterialInsets = .None {
		didSet {
			rightButtonsInsetsRef = MaterialInsetsToValue(rightButtonsInsets)
		}
	}
	
	/**
		:name:	rightButtonsInsetsRef
	*/
	public var rightButtonsInsetsRef: MaterialInsetsType = MaterialTheme.searchBarView.rightButtonsInsetsRef {
		didSet {
			reloadView()
		}
	}
	
	/**
		:name:	rightButtons
	*/
	public var rightButtons: Array<UIButton>? {
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
		self.init(frame: CGRectMake(MaterialTheme.searchBarView.x, MaterialTheme.searchBarView.y, MaterialTheme.searchBarView.width, MaterialTheme.searchBarView.height))
	}
	
	/**
		:name:	init
	*/
	public convenience init?(leftButtons: Array<UIButton>? = nil, rightButtons: Array<UIButton>? = nil) {
		self.init(frame: CGRectMake(MaterialTheme.searchBarView.x, MaterialTheme.searchBarView.y, MaterialTheme.searchBarView.width, MaterialTheme.searchBarView.height))
		prepareProperties(leftButtons, rightButtons: rightButtons)
	}
	
	/**
		:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		userInteractionEnabled = MaterialTheme.searchBarView.userInteractionEnabled
		backgroundColor = MaterialTheme.searchBarView.backgroundColor
		
		contentsRect = MaterialTheme.searchBarView.contentsRect
		contentsCenter = MaterialTheme.searchBarView.contentsCenter
		contentsScale = MaterialTheme.searchBarView.contentsScale
		contentsGravity = MaterialTheme.searchBarView.contentsGravity
		shadowDepth = MaterialTheme.searchBarView.shadowDepth
		shadowColor = MaterialTheme.searchBarView.shadowColor
		zPosition = MaterialTheme.searchBarView.zPosition
		borderWidth = MaterialTheme.searchBarView.borderWidth
		borderColor = MaterialTheme.searchBarView.bordercolor
		
		prepareTextField()
		reloadView()
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
		
		verticalFormat += "-(insetTop)"
		metrics["insetTop"] = contentInsetsRef.top + textFieldInsetsRef.top
		
		// textField
		verticalFormat += "-[textField]"
		views["textField"] = textField
		
		addSubview(textField)
		
		MaterialLayout.alignToParentHorizontally(self, child: textField, left: contentInsetsRef.left + textFieldInsetsRef.left, right: contentInsetsRef.right + textFieldInsetsRef.right)
		
		// leftButtons
		if let v = leftButtons {
			if 0 < v.count {
				var h: String = "H:|"
				var d: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				var i: Int = 0
				for b in v {
					let k: String = "b\(i)"
					
					d[k] = b
					
					if 0 == i++ {
						h += "-(left)-"
					} else {
						h += "-(left_right)-"
					}
					
					h += "[\(k)]"
					
					addSubview(b)
					MaterialLayout.alignFromBottom(self, child: b, bottom: contentInsetsRef.bottom + leftButtonsInsetsRef.bottom)
				}
				
				addConstraints(MaterialLayout.constraint(h, options: [], metrics: ["left" : contentInsetsRef.left + leftButtonsInsetsRef.left, "left_right" : leftButtonsInsetsRef.left + leftButtonsInsetsRef.right], views: d))
			}
		}
		
		// rightButtons
		if let v = rightButtons {
			if 0 < v.count {
				var h: String = "H:"
				var d: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				var i: Int = v.count - 1
				
				for b in v {
					let k: String = "b\(i)"
					
					d[k] = b
					
					h += "[\(k)]"
					
					if 0 == i-- {
						h += "-(right)-"
					} else {
						h += "-(right_left)-"
					}
					
					addSubview(b)
					MaterialLayout.alignFromBottom(self, child: b, bottom: contentInsetsRef.bottom + rightButtonsInsetsRef.bottom)
				}
				
				addConstraints(MaterialLayout.constraint(h + "|", options: [], metrics: ["right" : contentInsetsRef.right + rightButtonsInsetsRef.right, "right_left" : rightButtonsInsetsRef.right + rightButtonsInsetsRef.left], views: d))
			}
		}
		
		if nil == metrics["insetC"] {
			metrics["insetBottom"] = contentInsetsRef.bottom + textFieldInsetsRef.bottom
		} else {
			metrics["insetC"] = (metrics["insetC"] as! CGFloat) + textFieldInsetsRef.bottom
		}
		
		if 0 < views.count {
			verticalFormat += "-(insetBottom)-|"
			addConstraints(MaterialLayout.constraint(verticalFormat, options: [], metrics: metrics, views: views))
		}
	}
	
	//
	//	:name:	prepareProperties
	//
	internal func prepareProperties(leftButtons: Array<UIButton>?, rightButtons: Array<UIButton>?) {
		self.leftButtons = leftButtons
		self.rightButtons = rightButtons
	}
	
	//
	//	:name:	prepareTextField
	//
	internal func prepareTextField() {
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.delegate = self
	}
	
	public func textFieldDidBeginEditing(textField: UITextField) {
		if let v: UIColor = editingBackgroundColor {
			internalBackgroundColor = backgroundColor
			backgroundColor = v
		}
		(delegate as? SearchBarViewDelegate)?.materialSearchBarDidBeginEditing?(self)
	}

	public func textFieldDidEndEditing(textField: UITextField) {
		backgroundColor = internalBackgroundColor
		internalBackgroundColor = nil
		(delegate as? SearchBarViewDelegate)?.materialSearchBarDidEndEditing?(self)
	}
}
