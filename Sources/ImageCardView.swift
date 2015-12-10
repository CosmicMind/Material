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

public class ImageCardView : MaterialPulseView {
	/**
	:name:	dividerLayer
	*/
	private var dividerLayer: CAShapeLayer?
	
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
	public var divider: Bool = MaterialTheme.imageCardView.divider {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	dividerInsets
	*/
	public var dividerInsets: MaterialEdgeInsets = .None {
		didSet {
			dividerInsetsRef = MaterialEdgeInsetsToValue(dividerInsets)
		}
	}
	
	/**
	:name:	dividerInsetsRef
	*/
	public var dividerInsetsRef: UIEdgeInsets = MaterialTheme.imageCardView.dividerInsetsRef {
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
	public override var image: UIImage? {
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
	public var maxImageHeight: CGFloat = 0 {
		didSet {
			if 0 < maxImageHeight {
				prepareImageLayer()
				let h: CGFloat = image!.size.height / contentsScale
				imageLayer?.frame.size.height = maxImageHeight < h ? maxImageHeight : h
			} else {
				maxImageHeight = 0
				imageLayer?.frame.size.height = nil == image ? 0 : image!.size.height / contentsScale
			}
			reloadView()
		}
	}
	
	/**
	:name:	contentsRect
	*/
	public override var contentsRect: CGRect {
		didSet {
			prepareImageLayer()
			imageLayer?.contentsRect = contentsRect
		}
	}
	
	/**
	:name:	contentsCenter
	*/
	public override var contentsCenter: CGRect {
		didSet {
			prepareImageLayer()
			imageLayer?.contentsCenter = contentsCenter
		}
	}
	
	/**
	:name:	contentsScale
	*/
	public override var contentsScale: CGFloat {
		didSet {
			prepareImageLayer()
			imageLayer?.contentsScale = contentsScale
		}
	}
	
	/**
	:name:	contentsGravity
	*/
	public override var contentsGravity: MaterialGravity {
		didSet {
			prepareImageLayer()
			imageLayer?.contentsGravity = MaterialGravityToString(contentsGravity)
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
	public var contentInsetsRef: UIEdgeInsets = MaterialTheme.imageCardView.contentInsetsRef {
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
	public var titleLabelInsetsRef: UIEdgeInsets = MaterialTheme.imageCardView.titleLabelInsetsRef {
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
	public var detailLabelInsetsRef: UIEdgeInsets = MaterialTheme.imageCardView.detailLabelInsetsRef {
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
	public var leftButtonsInsetsRef: UIEdgeInsets = MaterialTheme.imageCardView.leftButtonsInsetsRef {
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
	public var rightButtonsInsetsRef: UIEdgeInsets = MaterialTheme.imageCardView.rightButtonsInsetsRef {
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
			// image
			imageLayer?.frame.size.width = bounds.width
			
			// divider
			if divider {
				var y: CGFloat = contentInsetsRef.bottom + dividerInsetsRef.bottom
				if 0 < leftButtons?.count {
					y += leftButtonsInsetsRef.top + leftButtonsInsetsRef.bottom + leftButtons![0].frame.height
				} else if 0 < rightButtons?.count {
					y += rightButtonsInsetsRef.top + rightButtonsInsetsRef.bottom + rightButtons![0].frame.height
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
			metrics["insetTop"] = contentInsetsRef.top + titleLabelInsetsRef.top
		} else if nil != detailLabel {
			verticalFormat += "-(insetTop)"
			metrics["insetTop"] = contentInsetsRef.top + detailLabelInsetsRef.top
		}
		
		// title
		if let v = titleLabel {
			addSubview(v)
			
			if nil == imageLayer?.contents {
				verticalFormat += "-[titleLabel]"
				views["titleLabel"] = v
			} else {
				MaterialLayout.alignFromTop(self, child: v, top: contentInsetsRef.top + titleLabelInsetsRef.top)
			}
			MaterialLayout.alignToParentHorizontally(self, child: v, left: contentInsetsRef.left + titleLabelInsetsRef.left, right: contentInsetsRef.right + titleLabelInsetsRef.right)
		}
		
		// detail
		if let v = detailLabel {
			addSubview(v)
			
			if nil == imageLayer?.contents && nil != titleLabel {
				verticalFormat += "-(insetB)"
				metrics["insetB"] = titleLabelInsetsRef.bottom + detailLabelInsetsRef.top
			} else {
				metrics["insetTop"] = (metrics["insetTop"] as! CGFloat) + detailLabelInsetsRef.top
			}
			
			verticalFormat += "-[detailLabel]"
			views["detailLabel"] = v
			
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
		
		if nil == imageLayer?.contents {
			if 0 < leftButtons?.count {
				verticalFormat += "-(insetC)-[button]"
				views["button"] = leftButtons![0]
				metrics["insetC"] = leftButtonsInsetsRef.top
				metrics["insetBottom"] = contentInsetsRef.bottom + leftButtonsInsetsRef.bottom
			} else if 0 < rightButtons?.count {
				verticalFormat += "-(insetC)-[button]"
				views["button"] = rightButtons![0]
				metrics["insetC"] = rightButtonsInsetsRef.top
				metrics["insetBottom"] = contentInsetsRef.bottom + rightButtonsInsetsRef.bottom
			}
			
			if nil != detailLabel {
				if nil == metrics["insetC"] {
					metrics["insetBottom"] = contentInsetsRef.bottom + detailLabelInsetsRef.bottom + (divider ? dividerInsetsRef.top + dividerInsetsRef.bottom : 0)
				} else {
					metrics["insetC"] = (metrics["insetC"] as! CGFloat) + detailLabelInsetsRef.bottom + (divider ? dividerInsetsRef.top + dividerInsetsRef.bottom : 0)
				}
			} else if nil != titleLabel {
				if nil == metrics["insetC"] {
					metrics["insetBottom"] = contentInsetsRef.bottom + titleLabelInsetsRef.bottom + (divider ? dividerInsetsRef.top + dividerInsetsRef.bottom : 0)
				} else {
					metrics["insetC"] = (metrics["insetC"] as! CGFloat) + titleLabelInsetsRef.bottom + (divider ? dividerInsetsRef.top + dividerInsetsRef.bottom : 0)
				}
			} else if nil != metrics["insetC"] {
				metrics["insetC"] = (metrics["insetC"] as! CGFloat) + contentInsetsRef.top + (divider ? dividerInsetsRef.top + dividerInsetsRef.bottom : 0)
			}
		} else if nil != detailLabel {
			if 0 < leftButtons?.count {
				verticalFormat += "-(insetC)-[button]"
				views["button"] = leftButtons![0]
				metrics["insetC"] = leftButtonsInsetsRef.top
				metrics["insetBottom"] = contentInsetsRef.bottom + leftButtonsInsetsRef.bottom
			} else if 0 < rightButtons?.count {
				verticalFormat += "-(insetC)-[button]"
				views["button"] = rightButtons![0]
				metrics["insetC"] = rightButtonsInsetsRef.top
				metrics["insetBottom"] = contentInsetsRef.bottom + rightButtonsInsetsRef.bottom
			}
			
			if nil == metrics["insetC"] {
				metrics["insetBottom"] = contentInsetsRef.bottom + detailLabelInsetsRef.bottom + (divider ? dividerInsetsRef.top + dividerInsetsRef.bottom : 0)
			} else {
				metrics["insetC"] = (metrics["insetC"] as! CGFloat) + detailLabelInsetsRef.bottom + (divider ? dividerInsetsRef.top + dividerInsetsRef.bottom : 0)
			}
		} else {
			if 0 < leftButtons?.count {
				verticalFormat += "-[button]"
				views["button"] = leftButtons![0]
				metrics["insetTop"] = (metrics["insetTop"] as! CGFloat) + contentInsetsRef.top + leftButtonsInsetsRef.top + (divider ? dividerInsetsRef.top + dividerInsetsRef.bottom : 0)
				metrics["insetBottom"] = contentInsetsRef.bottom + leftButtonsInsetsRef.bottom
			} else if 0 < rightButtons?.count {
				verticalFormat += "-[button]"
				views["button"] = rightButtons![0]
				metrics["insetTop"] = (metrics["insetTop"] as! CGFloat) + contentInsetsRef.top + rightButtonsInsetsRef.top + (divider ? dividerInsetsRef.top + dividerInsetsRef.bottom : 0)
				metrics["insetBottom"] = contentInsetsRef.bottom + rightButtonsInsetsRef.bottom
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
		userInteractionEnabled = MaterialTheme.imageCardView.userInteractionEnabled
		backgroundColor = MaterialTheme.imageCardView.backgroundColor
		pulseColor = MaterialTheme.imageCardView.pulseColor
		
		contentsRect = MaterialTheme.imageCardView.contentsRect
		contentsCenter = MaterialTheme.imageCardView.contentsCenter
		contentsScale = MaterialTheme.imageCardView.contentsScale
		contentsGravity = MaterialTheme.imageCardView.contentsGravity
		shadowDepth = MaterialTheme.imageCardView.shadowDepth
		shadowColor = MaterialTheme.imageCardView.shadowColor
		zPosition = MaterialTheme.imageCardView.zPosition
		borderWidth = MaterialTheme.imageCardView.borderWidth
		borderColor = MaterialTheme.imageCardView.bordercolor
		dividerColor = MaterialTheme.imageCardView.dividerColor
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
		dividerLayer?.frame = CGRectMake(dividerInsetsRef.left, y, width - dividerInsetsRef.left - dividerInsetsRef.right, 1)
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