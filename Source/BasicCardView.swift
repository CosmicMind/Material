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
	//
	//	:name:	dividerLayer
	//
	internal var dividerLayer: CAShapeLayer?
	
	//
	//	:name:	dividerColor
	//
	public var dividerColor: UIColor? {
		didSet {
			dividerLayer?.backgroundColor = dividerColor?.CGColor
			reloadView()
		}
	}
	
	/**
		:name:	divider
	*/
	public var divider: Bool = MaterialTheme.basicCardView.divider {
		didSet {
			reloadView()
		}
	}
	
	/**
		:name:	contentInsets
	*/
	public var contentInsets: MaterialInsets? {
		didSet {
			contentInsetsRef = nil == contentInsets ? nil : MaterialInsetsToValue(contentInsets!)
		}
	}
	
	/**
		:name:	contentInsetsRef
	*/
	public var contentInsetsRef: MaterialInsetsType! {
		didSet {
			contentInsetsRef = nil == contentInsetsRef ? (top: 0, left: 0, bottom: 0, right: 0) : contentInsetsRef!
			reloadView()
		}
	}
	
	/**
		:name:	titleLabelInsets
	*/
	public var titleLabelInsets: MaterialInsets? {
		didSet {
			titleLabelInsetsRef = nil == titleLabelInsets ? nil : MaterialInsetsToValue(titleLabelInsets!)
		}
	}
	
	/**
		:name:	titleLabelInsetsRef
	*/
	public var titleLabelInsetsRef: MaterialInsetsType! {
		didSet {
			titleLabelInsetsRef = nil == titleLabelInsetsRef ? (top: 0, left: 0, bottom: 0, right: 0) : titleLabelInsetsRef!
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
				v.lineBreakMode = .ByWordWrapping
				v.numberOfLines = 0
				v.textColor = MaterialColor.white
				v.font = RobotoFont.regularWithSize(18)
			}
			reloadView()
		}
	}
	
	/**
		:name:	detailLabelInsets
	*/
	public var detailLabelInsets: MaterialInsets? {
		didSet {
			detailLabelInsetsRef = nil == detailLabelInsets ? nil : MaterialInsetsToValue(detailLabelInsets!)
		}
	}
	
	/**
		:name:	detailLabelInsetsRef
	*/
	public var detailLabelInsetsRef: MaterialInsetsType! {
		didSet {
			detailLabelInsetsRef = nil == detailLabelInsetsRef ? (top: 0, left: 0, bottom: 0, right: 0) : detailLabelInsetsRef!
			reloadView()
		}
	}
	
	/**
		:name:	detailLabel
	*/
	public var detailLabel: UILabel? {
		didSet {
			if let v = detailLabel {
				v.translatesAutoresizingMaskIntoConstraints = false
				v.lineBreakMode = .ByWordWrapping
				v.numberOfLines = 0
				v.textColor = MaterialColor.white
				v.font = RobotoFont.regularWithSize(14)
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
					b.setTitleColor(MaterialColor.amber.darken1, forState: .Normal)
					b.setTitleColor(MaterialColor.amber.lighten1, forState: .Highlighted)
					b.pulseColor = nil
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
					b.setTitleColor(MaterialColor.amber.darken1, forState: .Normal)
					b.setTitleColor(MaterialColor.amber.lighten1, forState: .Highlighted)
					b.pulseColor = nil
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
	public convenience init?(titleLabel: UILabel? = nil, detailLabel: UILabel? = nil, leftButtons: Array<MaterialButton>? = nil, rightButtons: Array<MaterialButton>? = nil) {
		self.init(frame: CGRectZero)
		self.prepareProperties(titleLabel, detailLabel: detailLabel, leftButtons: leftButtons, rightButtons: rightButtons)
	}
	
	/**
		:name:	layoutSubviews
	*/
	public override func layoutSubviews() {
		super.layoutSubviews()
		// divider
		if true == divider {
			var y: CGFloat = 0
			if 0 < leftButtons?.count {
				y += contentInsetsRef!.bottom + leftButtonsInsetsRef!.top + leftButtonsInsetsRef!.bottom + leftButtons![0].height
			} else if 0 < rightButtons?.count {
				y += contentInsetsRef!.bottom + rightButtonsInsetsRef!.top + rightButtonsInsetsRef!.bottom + rightButtons![0].height
			}
			if 0 < y {
				prepareDivider(bounds.size.height - y - 0.5, width: bounds.size.width)
			}
		} else {
			dividerLayer?.removeFromSuperlayer()
			dividerLayer = nil
		}
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
			metrics["insetTop"] = contentInsetsRef!.top + titleLabelInsetsRef!.top
		} else if nil != detailLabel {
			verticalFormat += "-(insetTop)"
			metrics["insetTop"] = contentInsetsRef!.top + detailLabelInsetsRef!.top
		}
		
		// title
		if let v = titleLabel {
			verticalFormat += "-[titleLabel]"
			views["titleLabel"] = v
			
			addSubview(v)
			v.layer.zPosition = 2000
			MaterialLayout.alignToParentHorizontallyWithInsets(self, child: v, left: contentInsetsRef!.left + titleLabelInsetsRef!.left, right: contentInsetsRef!.right + titleLabelInsetsRef!.right)
		}
		
		// detail
		if let v = detailLabel {
			if nil != titleLabel {
				verticalFormat += "-(insetB)"
				metrics["insetB"] = titleLabelInsetsRef!.bottom + detailLabelInsetsRef!.top
			}
			
			verticalFormat += "-[detailLabel]"
			views["detailLabel"] = v
			
			addSubview(v)
			v.layer.zPosition = 2000
			MaterialLayout.alignToParentHorizontallyWithInsets(self, child: v, left: contentInsetsRef!.left + detailLabelInsetsRef!.left, right: contentInsetsRef!.right + detailLabelInsetsRef!.right)
		}
		
		// leftButtons
		if let v = leftButtons {
			if 0 < v.count {
				var h: String = "H:|"
				var d: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				var i: Int = 0
				
				for b in v {
					let k: String = "b\(i++)"
					d[k] = b
					h += "-(left)-[\(k)]"
					
					addSubview(b)
					b.layer.zPosition = 2000
					MaterialLayout.alignFromBottom(self, child: b, bottom: contentInsetsRef!.bottom + leftButtonsInsetsRef!.bottom)
				}
				
				addConstraints(MaterialLayout.constraint(h, options: [], metrics: ["left" : leftButtonsInsetsRef!.left], views: d))
			}
		}
		
		// rightButtons
		if let v = rightButtons {
			if 0 < v.count {
				var h: String = "H:"
				var d: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				var i: Int = 0
				
				for b in v {
					let k: String = "b\(i++)"
					d[k] = b
					h += "[\(k)]-(right)-"
					
					addSubview(b)
					b.layer.zPosition = 2000
					MaterialLayout.alignFromBottom(self, child: b, bottom: contentInsetsRef!.bottom + rightButtonsInsetsRef!.bottom)
				}
				
				addConstraints(MaterialLayout.constraint(h + "|", options: [], metrics: ["right" : rightButtonsInsetsRef!.right], views: d))
			}
		}
		
		if 0 < leftButtons?.count {
			verticalFormat += "-(insetC)-[button]"
			views["button"] = leftButtons![0]
			metrics["insetC"] = leftButtonsInsetsRef!.top
			metrics["insetBottom"] = contentInsetsRef!.bottom + leftButtonsInsetsRef!.bottom
		} else if 0 < rightButtons?.count {
			verticalFormat += "-(insetC)-[button]"
			views["button"] = rightButtons![0]
			metrics["insetC"] = rightButtonsInsetsRef!.top
			metrics["insetBottom"] = contentInsetsRef!.bottom + rightButtonsInsetsRef!.bottom
		}
		
		if nil != detailLabel {
			if nil == metrics["insetC"] {
				metrics["insetBottom"] = contentInsetsRef!.bottom + detailLabelInsetsRef!.bottom
			} else {
				metrics["insetC"] = (metrics["insetC"] as! CGFloat) + detailLabelInsetsRef!.bottom
			}
		} else if nil != titleLabel {
			if nil == metrics["insetC"] {
				metrics["insetBottom"] = contentInsetsRef!.bottom + titleLabelInsetsRef!.bottom
			} else {
				metrics["insetC"] = (metrics["insetC"] as! CGFloat) + titleLabelInsetsRef!.bottom
			}
		}
		
		if 0 < views.count {
			verticalFormat += "-(insetBottom)-|"
			addConstraints(MaterialLayout.constraint(verticalFormat, options: [], metrics: metrics, views: views))
		}
	}
	
	//
	//	:name:	prepareDivider
	//
	internal func prepareDivider(y: CGFloat, width: CGFloat) {
		if nil == dividerLayer {
			dividerLayer = CAShapeLayer()
			dividerLayer!.backgroundColor = dividerColor?.CGColor
			dividerLayer!.frame = CGRectMake(0, y, width, 1)
			dividerLayer!.zPosition = 900
			visualLayer.addSublayer(dividerLayer!)
		}
	}
	
	//
	//	:name:	prepareProperties
	//
	internal func prepareProperties(titleLabel: UILabel?, detailLabel: UILabel?, leftButtons: Array<MaterialButton>?, rightButtons: Array<MaterialButton>?) {
		self.titleLabel = titleLabel
		self.detailLabel = detailLabel
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
		contentInsetsRef = MaterialTheme.basicCardView.contentInsetsRef
		titleLabelInsetsRef = MaterialTheme.basicCardView.titleLabelInsetsRef
		detailLabelInsetsRef = MaterialTheme.basicCardView.detailLabelInsetsRef
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
		dividerColor = MaterialTheme.basicCardView.dividerColor
	}
}
