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

public class ImageCardView : MaterialPulseView {
	/**
	:name:	dividerLayer
	*/
	private var dividerLayer: CAShapeLayer?
	
	/**
	:name:	dividerColor
	*/
	@IBInspectable public var dividerColor: UIColor? {
		didSet {
			dividerLayer?.backgroundColor = dividerColor?.CGColor
		}
	}
	
	/**
	:name:	divider
	*/
	@IBInspectable public var divider: Bool = true {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	dividerInsets
	*/
	public var dividerInsetPreset: MaterialEdgeInset = .None {
		didSet {
			dividerInset = MaterialEdgeInsetToValue(dividerInsetPreset)
		}
	}
	
	/**
	:name:	dividerInset
	*/
	@IBInspectable public var dividerInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0) {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	imageLayer
	*/
	public private(set) var imageLayer: CAShapeLayer?
	
	/**
	:name:	image
	*/
	@IBInspectable public override var image: UIImage? {
		get {
			return nil == imageLayer?.contents ? nil : UIImage(CGImage: imageLayer?.contents as! CGImage)
		}
		set(value) {
			if let v = value {
				prepareImageLayer()
				imageLayer?.contents = v.CGImage
				if 0 == maxImageHeight {
					imageLayer?.frame.size.height = image!.size.height / contentsScale
				} else {
					let h: CGFloat = image!.size.height / contentsScale
					imageLayer?.frame.size.height = maxImageHeight < h ? maxImageHeight : h
				}
				imageLayer?.hidden = false
			} else {
				imageLayer?.contents = nil
				imageLayer?.frame = CGRectZero
				imageLayer?.hidden = true
				imageLayer?.removeFromSuperlayer()
			}
			reloadView()
		}
	}
	
	/**
	:name:	maxImageHeight
	*/
	@IBInspectable public var maxImageHeight: CGFloat = 0 {
		didSet {
			if let v: UIImage = image {
				if 0 < maxImageHeight {
					prepareImageLayer()
					let h: CGFloat = v.size.height / contentsScale
					imageLayer?.frame.size.height = maxImageHeight < h ? maxImageHeight : h
				} else {
					maxImageHeight = 0
					imageLayer?.frame.size.height = nil == image ? 0 : v.size.height / contentsScale
				}
				reloadView()
			}
		}
	}
	
	/**
	:name:	contentsRect
	*/
	@IBInspectable public override var contentsRect: CGRect {
		didSet {
			prepareImageLayer()
			imageLayer?.contentsRect = contentsRect
		}
	}
	
	/**
	:name:	contentsCenter
	*/
	@IBInspectable public override var contentsCenter: CGRect {
		didSet {
			prepareImageLayer()
			imageLayer?.contentsCenter = contentsCenter
		}
	}
	
	/**
	:name:	contentsScale
	*/
	@IBInspectable public override var contentsScale: CGFloat {
		didSet {
			prepareImageLayer()
			imageLayer?.contentsScale = contentsScale
		}
	}
	
	/// Determines how content should be aligned within the visualLayer's bounds.
	@IBInspectable public override var contentsGravity: String {
		get {
			return nil == imageLayer ? "" : imageLayer!.contentsGravity
		}
		set(value) {
			prepareImageLayer()
			imageLayer?.contentsGravity = value
		}
	}
	
	/**
	:name:	contentInsets
	*/
	public var contentInsetPreset: MaterialEdgeInset = .Square2 {
		didSet {
			contentInset = MaterialEdgeInsetToValue(contentInsetPreset)
		}
	}
	
	/**
	:name:	contentInset
	*/
	@IBInspectable public var contentInset: UIEdgeInsets = MaterialEdgeInsetToValue(.Square2) {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	titleLabelInsets
	*/
	public var titleLabelInsetPreset: MaterialEdgeInset = .Square2 {
		didSet {
			titleLabelInset = MaterialEdgeInsetToValue(titleLabelInsetPreset)
		}
	}
	
	/**
	:name:	titleLabelInset
	*/
	@IBInspectable public var titleLabelInset: UIEdgeInsets = MaterialEdgeInsetToValue(.Square2) {
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
	public var contentViewInsetPreset: MaterialEdgeInset = .Square2 {
		didSet {
			contentViewInset = MaterialEdgeInsetToValue(contentViewInsetPreset)
		}
	}
	
	/**
	:name:	contentViewInset
	*/
	@IBInspectable public var contentViewInset: UIEdgeInsets = MaterialEdgeInsetToValue(.Square2) {
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
	public var leftButtonsInsetPreset: MaterialEdgeInset = .None {
		didSet {
			leftButtonsInset = MaterialEdgeInsetToValue(leftButtonsInsetPreset)
		}
	}
	
	/**
	:name:	leftButtonsInset
	*/
	@IBInspectable public var leftButtonsInset: UIEdgeInsets = MaterialEdgeInsetToValue(.None) {
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
	public var rightButtonsInsetPreset: MaterialEdgeInset = .None {
		didSet {
			rightButtonsInset = MaterialEdgeInsetToValue(rightButtonsInsetPreset)
		}
	}
	
	/**
	:name:	rightButtonsInset
	*/
	@IBInspectable public var rightButtonsInset: UIEdgeInsets = MaterialEdgeInsetToValue(.None) {
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
		self.init(frame: CGRectZero)
	}
	
	/**
	:name:	init
	*/
	public convenience init?(image: UIImage? = nil, titleLabel: UILabel? = nil, contentView: UIView? = nil, leftButtons: Array<UIButton>? = nil, rightButtons: Array<UIButton>? = nil) {
		self.init(frame: CGRectZero)
		prepareProperties(image, titleLabel: titleLabel, contentView: contentView, leftButtons: leftButtons, rightButtons: rightButtons)
	}
	
	/**
	:name:	layoutSublayersOfLayer
	*/
	public override func layoutSublayersOfLayer(layer: CALayer) {
		super.layoutSublayersOfLayer(layer)
		if self.layer == layer {
			// image
			imageLayer?.frame.size.width = bounds.width
			
			// divider
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
		
		if nil != imageLayer?.contents {
			verticalFormat += "-(insetTop)"
			metrics["insetTop"] = imageLayer!.frame.height
		} else if nil != titleLabel {
			verticalFormat += "-(insetTop)"
			metrics["insetTop"] = contentInset.top + titleLabelInset.top
		} else if nil != contentView {
			verticalFormat += "-(insetTop)"
			metrics["insetTop"] = contentInset.top + contentViewInset.top
		}
		
		// title
		if let v: UILabel = titleLabel {
			addSubview(v)
			
			if nil == imageLayer?.contents {
				verticalFormat += "-[titleLabel]"
				views["titleLabel"] = v
			} else {
				MaterialLayout.alignFromTop(self, child: v, top: contentInset.top + titleLabelInset.top)
			}
			MaterialLayout.alignToParentHorizontally(self, child: v, left: contentInset.left + titleLabelInset.left, right: contentInset.right + titleLabelInset.right)
		}
		
		// detail
		if let v: UIView = contentView {
			addSubview(v)
			
			if nil == imageLayer?.contents && nil != titleLabel {
				verticalFormat += "-(insetB)"
				metrics["insetB"] = titleLabelInset.bottom + contentViewInset.top
			} else {
				metrics["insetTop"] = (metrics["insetTop"] as! CGFloat) + contentViewInset.top
			}
			
			verticalFormat += "-[contentView]"
			views["contentView"] = v
			
			MaterialLayout.alignToParentHorizontally(self, child: v, left: contentInset.left + contentViewInset.left, right: contentInset.right + contentViewInset.right)
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
					
					addSubview(b)
					MaterialLayout.alignFromBottom(self, child: b, bottom: contentInset.bottom + leftButtonsInset.bottom)
					
					i += 1
				}
				
				addConstraints(MaterialLayout.constraint(h, options: [], metrics: ["left" : contentInset.left + leftButtonsInset.left, "left_right" : leftButtonsInset.left + leftButtonsInset.right], views: d))
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
					
					addSubview(b)
					MaterialLayout.alignFromBottom(self, child: b, bottom: contentInset.bottom + rightButtonsInset.bottom)
					
					i -= 1
				}
				
				addConstraints(MaterialLayout.constraint(h + "|", options: [], metrics: ["right" : contentInset.right + rightButtonsInset.right, "right_left" : rightButtonsInset.right + rightButtonsInset.left], views: d))
			}
		}
		
		if nil == imageLayer?.contents {
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
					metrics["insetC"] = (metrics["insetC"] as! CGFloat) + titleLabelInset.bottom + (divider ? dividerInset.top + dividerInset.bottom : 0)
				}
			} else if nil != metrics["insetC"] {
				metrics["insetC"] = (metrics["insetC"] as! CGFloat) + contentInset.top + (divider ? dividerInset.top + dividerInset.bottom : 0)
			}
		} else if nil != contentView {
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
			
			if nil == metrics["insetC"] {
				metrics["insetBottom"] = contentInset.bottom + contentViewInset.bottom + (divider ? dividerInset.top + dividerInset.bottom : 0)
			} else {
				metrics["insetC"] = (metrics["insetC"] as! CGFloat) + contentViewInset.bottom + (divider ? dividerInset.top + dividerInset.bottom : 0)
			}
		} else {
			if 0 < leftButtons?.count {
				verticalFormat += "-[button]"
				views["button"] = leftButtons![0]
				metrics["insetTop"] = (metrics["insetTop"] as! CGFloat) + contentInset.top + leftButtonsInset.top + (divider ? dividerInset.top + dividerInset.bottom : 0)
				metrics["insetBottom"] = contentInset.bottom + leftButtonsInset.bottom
			} else if 0 < rightButtons?.count {
				verticalFormat += "-[button]"
				views["button"] = rightButtons![0]
				metrics["insetTop"] = (metrics["insetTop"] as! CGFloat) + contentInset.top + rightButtonsInset.top + (divider ? dividerInset.top + dividerInset.bottom : 0)
				metrics["insetBottom"] = contentInset.bottom + rightButtonsInset.bottom
			} else {
				if translatesAutoresizingMaskIntoConstraints {
					addConstraints(MaterialLayout.constraint("V:[view(height)]", options: [], metrics: ["height": imageLayer!.frame.height], views: ["view": self]))
				} else {
					height = imageLayer!.frame.height
				}
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
		depth = .Depth1
		dividerColor = MaterialColor.grey.lighten3
		cornerRadiusPreset = .Radius1
	}
	
	/**
	:name:	prepareImageLayer
	*/
	internal func prepareImageLayer() {
		if nil == imageLayer {
			imageLayer = CAShapeLayer()
			imageLayer!.masksToBounds = true
			imageLayer!.zPosition = 0
			visualLayer.addSublayer(imageLayer!)
		}
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
	internal func prepareProperties(image: UIImage?, titleLabel: UILabel?, contentView: UIView?, leftButtons: Array<UIButton>?, rightButtons: Array<UIButton>?) {
		self.image = image
		self.titleLabel = titleLabel
		self.contentView = contentView
		self.leftButtons = leftButtons
		self.rightButtons = rightButtons
	}
}