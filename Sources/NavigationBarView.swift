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

public class NavigationBarView : MaterialView {
	/**
	:name:	statusBarStyle
	*/
	public var statusBarStyle: UIStatusBarStyle = UIApplication.sharedApplication().statusBarStyle {
		didSet {
			UIApplication.sharedApplication().statusBarStyle = statusBarStyle
		}
	}
	
	/**
	:name:	contentInsets
	*/
	public var contentInsets: MaterialEdgeInsets = .None {
		didSet {
			contentInsetsRef = MaterialEdgeInsetsToValue(contentInsets)
		}
	}
	
	/**
	:name:	contentInsetsRef
	*/
	public var contentInsetsRef: UIEdgeInsets = MaterialTheme.navigationBarView.contentInsetsRef {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	titleLabelInsets
	*/
	public var titleLabelInsets: MaterialEdgeInsets = .None {
		didSet {
			titleLabelInsetsRef = MaterialEdgeInsetsToValue(titleLabelInsets)
		}
	}
	
	/**
	:name:	titleLabelInsetsRef
	*/
	public var titleLabelInsetsRef: UIEdgeInsets = MaterialTheme.navigationBarView.titleLabelInsetsRef {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	titleLabel
	*/
	public var titleLabel: UILabel? {
		didSet {
			titleLabel?.translatesAutoresizingMaskIntoConstraints = false
			reloadView()
		}
	}
	
	/**
	:name:	detailLabelInsets
	*/
	public var detailLabelInsets: MaterialEdgeInsets = .None {
		didSet {
			detailLabelInsetsRef = MaterialEdgeInsetsToValue(detailLabelInsets)
		}
	}
	
	/**
	:name:	detailLabelInsetsRef
	*/
	public var detailLabelInsetsRef: UIEdgeInsets = MaterialTheme.navigationBarView.detailLabelInsetsRef {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	detailLabel
	*/
	public var detailLabel: UILabel? {
		didSet {
			detailLabel?.translatesAutoresizingMaskIntoConstraints = false
			reloadView()
		}
	}
	
	/**
	:name:	leftButtonsInsets
	*/
	public var leftButtonsInsets: MaterialEdgeInsets = .None {
		didSet {
			leftButtonsInsetsRef = MaterialEdgeInsetsToValue(leftButtonsInsets)
		}
	}
	
	/**
	:name:	leftButtonsInsetsRef
	*/
	public var leftButtonsInsetsRef: UIEdgeInsets = MaterialTheme.navigationBarView.leftButtonsInsetsRef {
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
	public var rightButtonsInsets: MaterialEdgeInsets = .None {
		didSet {
			rightButtonsInsetsRef = MaterialEdgeInsetsToValue(rightButtonsInsets)
		}
	}
	
	/**
	:name:	rightButtonsInsetsRef
	*/
	public var rightButtonsInsetsRef: UIEdgeInsets = MaterialTheme.navigationBarView.rightButtonsInsetsRef {
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
		self.init(frame: CGRectMake(MaterialTheme.navigationBarView.x, MaterialTheme.navigationBarView.y, MaterialTheme.navigationBarView.width, MaterialTheme.navigationBarView.height))
	}
	
	/**
	:name:	init
	*/
	public convenience init?(titleLabel: UILabel? = nil, detailLabel: UILabel? = nil, leftButtons: Array<UIButton>? = nil, rightButtons: Array<UIButton>? = nil) {
		self.init(frame: CGRectMake(MaterialTheme.navigationBarView.x, MaterialTheme.navigationBarView.y, MaterialTheme.navigationBarView.width, MaterialTheme.navigationBarView.height))
		prepareProperties(titleLabel, detailLabel: detailLabel, leftButtons: leftButtons, rightButtons: rightButtons)
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
		
		if nil != titleLabel {
			verticalFormat += "-(insetTop)"
			metrics["insetTop"] = contentInsetsRef.top + titleLabelInsetsRef.top
		} else if nil != detailLabel {
			verticalFormat += "-(insetTop)"
			metrics["insetTop"] = contentInsetsRef.top + detailLabelInsetsRef.top
		}
		
		// title
		if let v = titleLabel {
			verticalFormat += "-[titleLabel]"
			views["titleLabel"] = v
			
			addSubview(v)
			MaterialLayout.alignToParentHorizontally(self, child: v, left: contentInsetsRef.left + titleLabelInsetsRef.left, right: contentInsetsRef.right + titleLabelInsetsRef.right)
		}
		
		// detail
		if let v = detailLabel {
			if nil != titleLabel {
				verticalFormat += "-(insetB)"
				metrics["insetB"] = titleLabelInsetsRef.bottom + detailLabelInsetsRef.top
			}
			
			verticalFormat += "-[detailLabel]"
			views["detailLabel"] = v
			
			addSubview(v)
			MaterialLayout.alignToParentHorizontally(self, child: v, left: contentInsetsRef.left + detailLabelInsetsRef.left, right: contentInsetsRef.right + detailLabelInsetsRef.right)
		}
		
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
		
		if nil != detailLabel {
			if nil == metrics["insetC"] {
				metrics["insetBottom"] = contentInsetsRef.bottom + detailLabelInsetsRef.bottom
			} else {
				metrics["insetC"] = (metrics["insetC"] as! CGFloat) + detailLabelInsetsRef.bottom
			}
		} else if nil != titleLabel {
			if nil == metrics["insetC"] {
				metrics["insetBottom"] = contentInsetsRef.bottom + titleLabelInsetsRef.bottom
			} else {
				metrics["insetC"] = (metrics["insetC"] as! CGFloat) + titleLabelInsetsRef.bottom
			}
		}
		
		if 0 < views.count {
			verticalFormat += "-(insetBottom)-|"
			addConstraints(MaterialLayout.constraint(verticalFormat, options: [], metrics: metrics, views: views))
		}
	}
	
	/**
	:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		userInteractionEnabled = MaterialTheme.navigationBarView.userInteractionEnabled
		backgroundColor = MaterialTheme.navigationBarView.backgroundColor
		
		contentsRect = MaterialTheme.navigationBarView.contentsRect
		contentsCenter = MaterialTheme.navigationBarView.contentsCenter
		contentsScale = MaterialTheme.navigationBarView.contentsScale
		contentsGravity = MaterialTheme.navigationBarView.contentsGravity
		shadowDepth = MaterialTheme.navigationBarView.shadowDepth
		shadowColor = MaterialTheme.navigationBarView.shadowColor
		zPosition = MaterialTheme.navigationBarView.zPosition
		borderWidth = MaterialTheme.navigationBarView.borderWidth
		borderColor = MaterialTheme.navigationBarView.bordercolor
	}
	
	/**
	:name:	prepareProperties
	*/
	internal func prepareProperties(titleLabel: UILabel?, detailLabel: UILabel?, leftButtons: Array<UIButton>?, rightButtons: Array<UIButton>?) {
		self.titleLabel = titleLabel
		self.detailLabel = detailLabel
		self.leftButtons = leftButtons
		self.rightButtons = rightButtons
	}
}
