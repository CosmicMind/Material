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

public protocol TextFieldDelegate : UITextFieldDelegate {}

public class TextField : UITextField {
	/**
	:name:	bottomBorderLayer
	*/
	public private(set) lazy var bottomBorderLayer: CAShapeLayer = CAShapeLayer()
	
	/**
	:name:	backgroundColor
	*/
	public override var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.CGColor
		}
	}
	
	/**
	:name:	x
	*/
	public var x: CGFloat {
		get {
			return layer.frame.origin.x
		}
		set(value) {
			layer.frame.origin.x = value
		}
	}
	
	/**
	:name:	y
	*/
	public var y: CGFloat {
		get {
			return layer.frame.origin.y
		}
		set(value) {
			layer.frame.origin.y = value
		}
	}
	
	/**
	:name:	width
	*/
	public var width: CGFloat {
		get {
			return layer.frame.size.width
		}
		set(value) {
			layer.frame.size.width = value
		}
	}
	
	/**
	:name:	height
	*/
	public var height: CGFloat {
		get {
			return layer.frame.size.height
		}
		set(value) {
			layer.frame.size.height = value
		}
	}
	
	/**
	:name:	borderWidth
	*/
	public var borderWidth: MaterialBorder {
		didSet {
			layer.borderWidth = MaterialBorderToValue(borderWidth)
		}
	}
	
	/**
	:name:	borderColor
	*/
	public var borderColor: UIColor? {
		didSet {
			layer.borderColor = borderColor?.CGColor
		}
	}
	
	/**
	:name:	position
	*/
	public var position: CGPoint {
		get {
			return layer.position
		}
		set(value) {
			layer.position = value
		}
	}
	
	/**
	:name:	zPosition
	*/
	public var zPosition: CGFloat {
		get {
			return layer.zPosition
		}
		set(value) {
			layer.zPosition = value
		}
	}
	
	/**
	:name:	titleLabelNormalColor
	*/
	public var titleLabelNormalColor: UIColor? {
		didSet {
			titleLabel?.textColor = titleLabelNormalColor
			bottomBorderLayer.backgroundColor = titleLabelNormalColor?.CGColor
		}
	}
	
	/**
	:name:	titleLabelHighlightedColor
	*/
	public var titleLabelHighlightedColor: UIColor?
	
	/**
	:name:	detailLabelHighlightedColor
	*/
	public var detailLabelHighlightedColor: UIColor?
	
	/**
	:name:	titleLabel
	*/
	public var titleLabel: UILabel? {
		didSet {
			prepareTitleLabel()
		}
	}
	
	/**
	:name:	detailLabel
	*/
	public var detailLabel: UILabel? {
		didSet {
			prepareDetailLabel()
		}
	}
	
	/**
	:name:	detailLabelHidden
	*/
	public var detailLabelHidden: Bool = false {
		didSet {
			if detailLabelHidden {
				bottomBorderLayer.backgroundColor = editing ? titleLabelHighlightedColor?.CGColor : titleLabelNormalColor?.CGColor
				hideDetailLabel()
			} else {
				detailLabel?.textColor = detailLabelHighlightedColor
				bottomBorderLayer.backgroundColor = detailLabelHighlightedColor?.CGColor
				showDetailLabel()
			}
		}
	}
	
	/**
	:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		borderWidth = .None
		super.init(coder: aDecoder)
		prepareView()
	}
	
	/**
	:name:	init
	*/
	public override init(frame: CGRect) {
		borderWidth = .None
		super.init(frame: frame)
		prepareView()
	}
	
	/**
	:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectNull)
	}
	
	/**
	:name:	layoutSublayersOfLayer
	*/
	public override func layoutSublayersOfLayer(layer: CALayer) {
		super.layoutSublayersOfLayer(layer)
		if self.layer == layer {
			bottomBorderLayer.frame = CGRectMake(0, bounds.height + 8, bounds.width, 1)
		}
	}
	
	/**
	:name:	prepareView
	*/
	public func prepareView() {
		clipsToBounds = false
		prepareBottomBorderLayer()
	}
	
	/**
	:name:	textFieldDidBegin
	*/
	internal func textFieldDidBegin(textField: TextField) {
		titleLabel?.text = placeholder
		if 0 == text?.utf16.count {
			titleLabel?.textColor = titleLabelNormalColor
			bottomBorderLayer.backgroundColor = titleLabelNormalColor?.CGColor
			detailLabelHidden = true
		} else {
			titleLabel?.textColor = titleLabelHighlightedColor
			bottomBorderLayer.backgroundColor = detailLabelHidden ? titleLabelHighlightedColor?.CGColor : detailLabelHighlightedColor?.CGColor
		}
	}
	
	/**
	:name:	textFieldDidChange
	*/
	internal func textFieldDidChange(textField: TextField) {
		if 0 < text?.utf16.count {
			showTitleLabel()
			titleLabel?.textColor = titleLabelHighlightedColor
			bottomBorderLayer.backgroundColor = detailLabelHidden ? titleLabelHighlightedColor?.CGColor : detailLabelHighlightedColor?.CGColor
		} else if 0 == text?.utf16.count {
			hideTitleLabel()
			detailLabelHidden = true
		}
	}
	
	/**
	:name:	textFieldDidEnd
	*/
	internal func textFieldDidEnd(textField: TextField) {
		if 0 < text?.utf16.count {
			showTitleLabel()
		} else if 0 == text?.utf16.count {
			hideTitleLabel()
		}
		titleLabel?.textColor = titleLabelNormalColor
		bottomBorderLayer.backgroundColor = detailLabelHidden ? titleLabelNormalColor?.CGColor : detailLabelHighlightedColor?.CGColor
	}
	
	/**
	:name:	prepareTitleLabel
	*/
	private func prepareTitleLabel() {
		if let v: UILabel = titleLabel {
			MaterialAnimation.animationDisabled {
				v.hidden = true
				v.alpha = 0
			}
			titleLabel?.text = placeholder
			let h: CGFloat = v.font.pointSize
			v.frame = CGRectMake(0, -h, bounds.width, h)
			addSubview(v)
			addTarget(self, action: "textFieldDidBegin:", forControlEvents: .EditingDidBegin)
			addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
			addTarget(self, action: "textFieldDidEnd:", forControlEvents: .EditingDidEnd)
		}
	}
	
	/**
	:name:	prepareDetailLabel
	*/
	private func prepareDetailLabel() {
		if let v: UILabel = detailLabel {
			MaterialAnimation.animationDisabled {
				v.hidden = true
				v.alpha = 0
			}
			let h: CGFloat = v.font.pointSize
			v.frame = CGRectMake(0, h + 12, bounds.width, h)
			addSubview(v)
			addTarget(self, action: "textFieldDidBegin:", forControlEvents: .EditingDidBegin)
			addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
			addTarget(self, action: "textFieldDidEnd:", forControlEvents: .EditingDidEnd)
		}
	}
	
	/**
	:name:	prepareBottomBorderLayer
	*/
	private func prepareBottomBorderLayer() {
		layer.addSublayer(bottomBorderLayer)
	}
	
	/**
	:name:	showTitleLabel
	*/
	private func showTitleLabel() {
		if let v: UILabel = titleLabel {
			v.frame.size.height = v.font.pointSize
			v.hidden = false
			UIView.animateWithDuration(0.25, animations: {
				v.alpha = 1
				v.frame.origin.y = -v.frame.height - 4
			})
		}
	}
	
	/**
	:name:	hideTitleLabel
	*/
	private func hideTitleLabel() {
		if let v: UILabel = titleLabel {
			UIView.animateWithDuration(0.25, animations: {
				v.alpha = 0
				v.frame.origin.y = -v.frame.height
			}) { _ in
				v.hidden = true
			}
		}
	}
	
	/**
	:name:	showDetailLabel
	*/
	private func showDetailLabel() {
		if let v: UILabel = detailLabel {
			v.frame.size.height = v.font.pointSize
			v.hidden = false
			UIView.animateWithDuration(0.25, animations: {
				v.alpha = 1
				v.frame.origin.y = v.frame.height + 28
			})
		}
	}
	
	/**
	:name:	hideDetailLabel
	*/
	private func hideDetailLabel() {
		if let v: UILabel = detailLabel {
			UIView.animateWithDuration(0.25, animations: {
				v.alpha = 0
				v.frame.origin.y = v.frame.height + 20
			}) { _ in
				v.hidden = true
			}
		}
	}
}