//
// Copyright (C) 2015 - 2016 CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved. 
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

public class CardView : MaterialPulseView {
	/**
	:name:	dividerLayer
	*/
	internal var dividerLayer: CAShapeLayer?
	
	/**
	:name:	dividerColor
	*/
	public var dividerColor: UIColor? {
		didSet {
			dividerLayer?.backgroundColor = dividerColor?.CGColor
		}
	}
	
	/**
	:name:	divider
	*/
	public var divider: Bool = true {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	dividerInsets
	*/
	public var dividerInsetPreset: MaterialEdgeInsets = .None {
		didSet {
			dividerInset = MaterialEdgeInsetsToValue(dividerInsetPreset)
		}
	}
	
	/**
	:name:	dividerInset
	*/
	public var dividerInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0) {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	contentInsets
	*/
	public var contentInsetPreset: MaterialEdgeInsets = .None {
		didSet {
			contentInset = MaterialEdgeInsetsToValue(contentInsetPreset)
		}
	}
	
	/**
	:name:	contentInset
	*/
	public var contentInset: UIEdgeInsets = MaterialEdgeInsetsToValue(.Square2) {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	titleLabelInsets
	*/
	public var titleLabelInsetPreset: MaterialEdgeInsets = .None {
		didSet {
			titleLabelInset = MaterialEdgeInsetsToValue(titleLabelInsetPreset)
		}
	}
	
	/**
	:name:	titleLabelInset
	*/
	public var titleLabelInset: UIEdgeInsets = MaterialEdgeInsetsToValue(.Square2) {
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
	public var detailLabelInsetPreset: MaterialEdgeInsets = .None {
		didSet {
			detailLabelInset = MaterialEdgeInsetsToValue(detailLabelInsetPreset)
		}
	}
	
	/**
	:name:	detailLabelInset
	*/
	public var detailLabelInset: UIEdgeInsets = MaterialEdgeInsetsToValue(.Square2) {
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
	public var leftButtonsInsetPreset: MaterialEdgeInsets = .None {
		didSet {
			leftButtonsInset = MaterialEdgeInsetsToValue(leftButtonsInsetPreset)
		}
	}
	
	/**
	:name:	leftButtonsInset
	*/
	public var leftButtonsInset: UIEdgeInsets = MaterialEdgeInsetsToValue(.None) {
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
	public var rightButtonsInsetPreset: MaterialEdgeInsets = .None {
		didSet {
			rightButtonsInset = MaterialEdgeInsetsToValue(rightButtonsInsetPreset)
		}
	}
	
	/**
	:name:	rightButtonsInset
	*/
	public var rightButtonsInset: UIEdgeInsets = MaterialEdgeInsetsToValue(.None) {
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
		self.init(frame: CGRectNull)
	}
	
	/**
	:name:	init
	*/
	public convenience init?(image: UIImage? = nil, titleLabel: UILabel? = nil, detailLabel: UILabel? = nil, leftButtons: Array<UIButton>? = nil, rightButtons: Array<UIButton>? = nil) {
		self.init(frame: CGRectNull)
		prepareProperties(image, titleLabel: titleLabel, detailLabel: detailLabel, leftButtons: leftButtons, rightButtons: rightButtons)
	}
	
	/**
	:name:	layoutSublayersOfLayer
	*/
	public override func layoutSublayersOfLayer(layer: CALayer) {
		super.layoutSublayersOfLayer(layer)
		if self.layer == layer {
			if divider {
				var y: CGFloat = contentInset.bottom + dividerInset.bottom
				if 0 < leftButtons?.count {
					y += leftButtonsInset.top + leftButtonsInset.bottom + leftButtons![0].frame.height
				} else if 0 < rightButtons?.count {
					y += rightButtonsInset.top + rightButtonsInset.bottom + rightButtons![0].frame.height
				}
				if 0 < y {
					prepareDivider(bounds.height - y - 0.5, width: bounds.width)
				}
			} else {
				dividerLayer?.removeFromSuperlayer()
				dividerLayer = nil
			}
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
			metrics["insetTop"] = contentInset.top + titleLabelInset.top
		} else if nil != detailLabel {
			verticalFormat += "-(insetTop)"
			metrics["insetTop"] = contentInset.top + detailLabelInset.top
		}
		
		// title
		if let v = titleLabel {
			addSubview(v)
			
			verticalFormat += "-[titleLabel]"
			views["titleLabel"] = v
			
			MaterialLayout.alignToParentHorizontally(self, child: v, left: contentInset.left + titleLabelInset.left, right: contentInset.right + titleLabelInset.right)
		}
		
		// detail
		if let v = detailLabel {
			addSubview(v)
			
			if nil == titleLabel {
				metrics["insetTop"] = (metrics["insetTop"] as! CGFloat) + detailLabelInset.top
			} else {
				verticalFormat += "-(insetB)"
				metrics["insetB"] = titleLabelInset.bottom + detailLabelInset.top
			}
			
			verticalFormat += "-[detailLabel]"
			views["detailLabel"] = v
			
			MaterialLayout.alignToParentHorizontally(self, child: v, left: contentInset.left + detailLabelInset.left, right: contentInset.right + detailLabelInset.right)
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
					MaterialLayout.alignFromBottom(self, child: b, bottom: contentInset.bottom + leftButtonsInset.bottom)
				}
				
				addConstraints(MaterialLayout.constraint(h, options: [], metrics: ["left" : contentInset.left + leftButtonsInset.left, "left_right" : leftButtonsInset.left + leftButtonsInset.right], views: d))
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
					MaterialLayout.alignFromBottom(self, child: b, bottom: contentInset.bottom + rightButtonsInset.bottom)
				}
				
				addConstraints(MaterialLayout.constraint(h + "|", options: [], metrics: ["right" : contentInset.right + rightButtonsInset.right, "right_left" : rightButtonsInset.right + rightButtonsInset.left], views: d))
			}
		}
		
		if 0 < leftButtons?.count {
			verticalFormat += "-(insetC)-[button]"
			views["button"] = leftButtons![0]
			metrics["insetC"] = leftButtonsInset.top
			metrics["insetBottom"] = contentInset.bottom + leftButtonsInset.bottom
		} else if 0 < rightButtons?.count {
			verticalFormat += "-(insetC)-[button]"
			views["button"] = rightButtons![0]
			metrics["insetC"] = rightButtonsInset.top
			metrics["insetBottom"] = contentInset.bottom + rightButtonsInset.bottom
		}
		
		if nil != detailLabel {
			if nil == metrics["insetC"] {
				metrics["insetBottom"] = contentInset.bottom + detailLabelInset.bottom + (divider ? dividerInset.top + dividerInset.bottom : 0)
			} else {
				metrics["insetC"] = (metrics["insetC"] as! CGFloat) + detailLabelInset.bottom + (divider ? dividerInset.top + dividerInset.bottom : 0)
			}
		} else if nil != titleLabel {
			if nil == metrics["insetC"] {
				metrics["insetBottom"] = contentInset.bottom + titleLabelInset.bottom + (divider ? dividerInset.top + dividerInset.bottom : 0)
			} else {
				metrics["insetC"] = (metrics["insetTop"] as! CGFloat) + titleLabelInset.bottom + (divider ? dividerInset.top + dividerInset.bottom : 0)
			}
		} else if nil != metrics["insetC"] {
			metrics["insetC"] = (metrics["insetC"] as! CGFloat) + contentInset.top + (divider ? dividerInset.top + dividerInset.bottom : 0)
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
		pulseColor = MaterialColor.blueGrey.lighten4
		depth = .Depth2
		dividerColor = MaterialColor.blueGrey.lighten5
	}
	
	/**
	:name:	prepareDivider
	*/
	internal func prepareDivider(y: CGFloat, width: CGFloat) {
		if nil == dividerLayer {
			dividerLayer = CAShapeLayer()
			dividerLayer!.zPosition = 0
			layer.addSublayer(dividerLayer!)
		}
		dividerLayer?.backgroundColor = dividerColor?.CGColor
		dividerLayer?.frame = CGRectMake(dividerInset.left, y, width - dividerInset.left - dividerInset.right, 1)
	}
	
	/**
	:name:	prepareProperties
	*/
	internal func prepareProperties(image: UIImage?, titleLabel: UILabel?, detailLabel: UILabel?, leftButtons: Array<UIButton>?, rightButtons: Array<UIButton>?) {
		self.image = image
		self.titleLabel = titleLabel
		self.detailLabel = detailLabel
		self.leftButtons = leftButtons
		self.rightButtons = rightButtons
	}
}