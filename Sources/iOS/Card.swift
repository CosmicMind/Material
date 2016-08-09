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

public class Card: PulseView {
	/**
	:name:	dividerLayer
	*/
	internal var dividerLayer: CAShapeLayer?
	
	/**
	:name:	dividerColor
	*/
	@IBInspectable public var dividerColor: UIColor? {
		didSet {
			dividerLayer?.backgroundColor = dividerColor?.cgColor
		}
	}
	
	/**
	:name:	divider
	*/
	@IBInspectable public var divider = true {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	dividerInsets
	*/
	public var dividerEdgeInsetsPreset: EdgeInsetsPreset = .none {
		didSet {
			dividerInset = EdgeInsetsPresetToValue(preset: dividerEdgeInsetsPreset)
		}
	}
	
	/**
	:name:	dividerInset
	*/
	@IBInspectable public var dividerInset = EdgeInsets(top: 8, left: 0, bottom: 8, right: 0) {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	contentInsets
	*/
	public var contentEdgeInsetsPreset: EdgeInsetsPreset = .square2 {
		didSet {
			contentInset = EdgeInsetsPresetToValue(preset: contentEdgeInsetsPreset)
		}
	}
	
	/**
	:name:	contentInset
	*/
	@IBInspectable public var contentInset = EdgeInsetsPresetToValue(preset: .square2) {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	titleLabelInsets
	*/
	public var titleLabelEdgeInsetsPreset: EdgeInsetsPreset = .square2 {
		didSet {
			titleLabelInset = EdgeInsetsPresetToValue(preset: titleLabelEdgeInsetsPreset)
		}
	}
	
	/**
	:name:	titleLabelInset
	*/
	@IBInspectable public var titleLabelInset = EdgeInsetsPresetToValue(preset: .square2) {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	titleLabel
	*/
	@IBInspectable public var titleLabel: UILabel? {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	contentViewInsets
	*/
	public var contentViewEdgeInsetsPreset: EdgeInsetsPreset = .square2 {
		didSet {
			contentViewInset = EdgeInsetsPresetToValue(preset: contentViewEdgeInsetsPreset)
		}
	}
	
	/**
	:name:	contentViewInset
	*/
	@IBInspectable public var contentViewInset = EdgeInsetsPresetToValue(preset: .square2) {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	contentView
	*/
	@IBInspectable public var contentView: UIView? {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	leftButtonsInsets
	*/
	public var leftButtonsEdgeInsetsPreset: EdgeInsetsPreset = .none {
		didSet {
			leftButtonsInset = EdgeInsetsPresetToValue(preset: leftButtonsEdgeInsetsPreset)
		}
	}
	
	/**
	:name:	leftButtonsInset
	*/
	@IBInspectable public var leftButtonsInset = EdgeInsets.zero {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	leftButtons
	*/
	public var leftButtons: Array<UIButton>? {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	rightButtonsInsets
	*/
	public var rightButtonsEdgeInsetsPreset: EdgeInsetsPreset = .none {
		didSet {
            rightButtonsInset = EdgeInsetsPresetToValue(preset: rightButtonsEdgeInsetsPreset)
		}
	}
	
	/**
	:name:	rightButtonsInset
	*/
	@IBInspectable public var rightButtonsInset = EdgeInsets.zero {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	rightButtons
	*/
	public var rightButtons: Array<UIButton>? {
		didSet {
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
		self.init(frame: CGRect.zero)
	}
	
	/**
	:name:	init
	*/
	public convenience init?(image: UIImage? = nil, titleLabel: UILabel? = nil, contentView: UIView? = nil, leftButtons: Array<UIButton>? = nil, rightButtons: Array<UIButton>? = nil) {
		self.init(frame: CGRect.zero)
		prepareProperties(image: image, titleLabel: titleLabel, contentView: contentView, leftButtons: leftButtons, rightButtons: rightButtons)
	}
	
	/**
	:name:	layoutSublayersOfLayer
	*/
	public override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		if self.layer == layer {
			if divider {
				var y: CGFloat = contentInset.bottom + dividerInset.bottom
				if 0 < leftButtons?.count {
					y += leftButtonsInset.top + leftButtonsInset.bottom + leftButtons![0].frame.height
				} else if 0 < rightButtons?.count {
					y += rightButtonsInset.top + rightButtonsInset.bottom + rightButtons![0].frame.height
				}
				if 0 < y {
					prepareDivider(y: bounds.height - y - 0.5, width: bounds.width)
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
		} else if nil != contentView {
			verticalFormat += "-(insetTop)"
			metrics["insetTop"] = contentInset.top + contentViewInset.top
		}
		
		// title
		if let v: UILabel = titleLabel {
			verticalFormat += "-[titleLabel]"
			views["titleLabel"] = v
			
			_ = layout(v).horizontally(left: contentInset.left + titleLabelInset.left, right: contentInset.right + titleLabelInset.right)
		}
		
		// detail
		if let v: UIView = contentView {
			if nil == titleLabel {
				metrics["insetTop"] = (metrics["insetTop"] as! CGFloat) + contentViewInset.top
			} else {
				verticalFormat += "-(insetB)"
				metrics["insetB"] = titleLabelInset.bottom + contentViewInset.top
			}
			
			verticalFormat += "-[contentView]"
			views["contentView"] = v
			
			_ = layout(v).horizontally(left: contentInset.left + contentViewInset.left, right: contentInset.right + contentViewInset.right)
		}
		
		// leftButtons
		if let v: Array<UIButton> = leftButtons {
			if 0 < v.count {
				var h: String = "H:|"
				var d: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				var i: Int = 0
				for b in v {
					let k: String = "b\(i)"
					
					d[k] = b
					
					if 0 == i {
						h += "-(left)-"
					} else {
						h += "-(left_right)-"
					}
					
					h += "[\(k)]"
					
					_ = layout(b).bottom(contentInset.bottom + leftButtonsInset.bottom)
					
					i += 1
				}
				
				addConstraints(Layout.constraint(format: h, options: [], metrics: ["left" : contentInset.left + leftButtonsInset.left, "left_right" : leftButtonsInset.left + leftButtonsInset.right], views: d))
			}
		}
		
		// rightButtons
		if let v: Array<UIButton> = rightButtons {
			if 0 < v.count {
				var h: String = "H:"
				var d: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				var i: Int = v.count - 1
				
				for b in v {
					let k: String = "b\(i)"
					
					d[k] = b
					
					h += "[\(k)]"
					
					if 0 == i {
						h += "-(right)-"
					} else {
						h += "-(right_left)-"
					}
					
					_ = layout(b).bottom(contentInset.bottom + rightButtonsInset.bottom)
					
					i -= 1
				}
				
				addConstraints(Layout.constraint(format: h + "|", options: [], metrics: ["right" : contentInset.right + rightButtonsInset.right, "right_left" : rightButtonsInset.right + rightButtonsInset.left], views: d))
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
		
		if nil != contentView {
			if nil == metrics["insetC"] {
				metrics["insetBottom"] = contentInset.bottom + contentViewInset.bottom + (divider ? dividerInset.top + dividerInset.bottom : 0)
			} else {
				metrics["insetC"] = (metrics["insetC"] as! CGFloat) + contentViewInset.bottom + (divider ? dividerInset.top + dividerInset.bottom : 0)
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
			addConstraints(Layout.constraint(format: verticalFormat, options: [], metrics: metrics, views: views))
		}
	}
	
	/**
	:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		depthPreset = .depth1
		dividerColor = Color.grey.lighten3
		cornerRadiusPreset = .cornerRadius1
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
		dividerLayer?.backgroundColor = dividerColor?.cgColor
        dividerLayer?.frame = CGRect(x: dividerInset.left, y: y, width: width - dividerInset.left - dividerInset.right, height: 1)
	}
	
	/**
	:name:	prepareProperties
	*/
	internal func prepareProperties(image: UIImage?, titleLabel: UILabel?, contentView: UIView?, leftButtons: Array<UIButton>?, rightButtons: Array<UIButton>?) {
		self.image = image
		self.titleLabel = titleLabel
		self.contentView = contentView
		self.leftButtons = leftButtons
		self.rightButtons = rightButtons
	}
}
