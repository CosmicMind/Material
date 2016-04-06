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

public protocol TextFieldDelegate : UITextFieldDelegate {}

@IBDesignable
public class TextField : UITextField {
	/**
	This property is the same as clipsToBounds. It crops any of the view's
	contents from bleeding past the view's frame.
	*/
	@IBInspectable public var masksToBounds: Bool {
		get {
			return layer.masksToBounds
		}
		set(value) {
			layer.masksToBounds = value
		}
	}
	
	/// A property that accesses the backing layer's backgroundColor.
	@IBInspectable public override var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.CGColor
		}
	}
	
	/// A property that accesses the layer.frame.origin.x property.
	@IBInspectable public var x: CGFloat {
		get {
			return layer.frame.origin.x
		}
		set(value) {
			layer.frame.origin.x = value
		}
	}
	
	/// A property that accesses the layer.frame.origin.y property.
	@IBInspectable public var y: CGFloat {
		get {
			return layer.frame.origin.y
		}
		set(value) {
			layer.frame.origin.y = value
		}
	}
	
	/// A property that accesses the layer.frame.size.width property.
	@IBInspectable public var width: CGFloat {
		get {
			return layer.frame.size.width
		}
		set(value) {
			layer.frame.size.width = value
		}
	}
	
	/// A property that accesses the layer.frame.size.height property.
	@IBInspectable public var height: CGFloat {
		get {
			return layer.frame.size.height
		}
		set(value) {
			layer.frame.size.height = value
		}
	}
	
	/// A property that accesses the backing layer's shadowColor.
	@IBInspectable public var shadowColor: UIColor? {
		didSet {
			layer.shadowColor = shadowColor?.CGColor
		}
	}
	
	/// A property that accesses the backing layer's shadowOffset.
	@IBInspectable public var shadowOffset: CGSize {
		get {
			return layer.shadowOffset
		}
		set(value) {
			layer.shadowOffset = value
		}
	}
	
	/// A property that accesses the backing layer's shadowOpacity.
	@IBInspectable public var shadowOpacity: Float {
		get {
			return layer.shadowOpacity
		}
		set(value) {
			layer.shadowOpacity = value
		}
	}
	
	/// A property that accesses the backing layer's shadowRadius.
	@IBInspectable public var shadowRadius: CGFloat {
		get {
			return layer.shadowRadius
		}
		set(value) {
			layer.shadowRadius = value
		}
	}
	
	/// A property that accesses the backing layer's shadowPath.
	@IBInspectable public var shadowPath: CGPath? {
		get {
			return layer.shadowPath
		}
		set(value) {
			layer.shadowPath = value
		}
	}
	
	/// Enables automatic shadowPath sizing.
	@IBInspectable public var shadowPathAutoSizeEnabled: Bool = true {
		didSet {
			if shadowPathAutoSizeEnabled {
				layoutShadowPath()
			} else {
				shadowPath = nil
			}
		}
	}
	
	/**
	A property that sets the shadowOffset, shadowOpacity, and shadowRadius
	for the backing layer. This is the preferred method of setting depth
	in order to maintain consitency across UI objects.
	*/
	public var depth: MaterialDepth = .None {
		didSet {
			let value: MaterialDepthType = MaterialDepthToValue(depth)
			shadowOffset = value.offset
			shadowOpacity = value.opacity
			shadowRadius = value.radius
			layoutShadowPath()
		}
	}
	
	/// A property that sets the cornerRadius of the backing layer.
	public var cornerRadiusPreset: MaterialRadius = .None {
		didSet {
			if let v: MaterialRadius = cornerRadiusPreset {
				cornerRadius = MaterialRadiusToValue(v)
			}
		}
	}
	
	/// A property that accesses the layer.cornerRadius.
	@IBInspectable public var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set(value) {
			layer.cornerRadius = value
			layoutShadowPath()
		}
	}
	
	/// A preset property to set the borderWidth.
	public var borderWidthPreset: MaterialBorder = .None {
		didSet {
			borderWidth = MaterialBorderToValue(borderWidthPreset)
		}
	}
	
	/// A property that accesses the layer.borderWith.
	@IBInspectable public var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set(value) {
			layer.borderWidth = value
		}
	}
	
	/// A property that accesses the layer.borderColor property.
	@IBInspectable public var borderColor: UIColor? {
		get {
			return nil == layer.borderColor ? nil : UIColor(CGColor: layer.borderColor!)
		}
		set(value) {
			layer.borderColor = value?.CGColor
		}
	}
	
	/// A property that accesses the layer.position property.
	@IBInspectable public var position: CGPoint {
		get {
			return layer.position
		}
		set(value) {
			layer.position = value
		}
	}
	
	/// A property that accesses the layer.zPosition property.
	@IBInspectable public var zPosition: CGFloat {
		get {
			return layer.zPosition
		}
		set(value) {
			layer.zPosition = value
		}
	}
	
	/// Handle the clearButton manually.
	@IBInspectable public var clearButtonAutoHandleEnabled: Bool = true {
		didSet {
			clearButton.removeTarget(self, action: #selector(handleClearButton), forControlEvents: .TouchUpInside)
			if clearButtonAutoHandleEnabled {
				clearButton.addTarget(self, action: #selector(handleClearButton), forControlEvents: .TouchUpInside)
			}
		}
	}
	
	/// Reference to the clearButton.
	public private(set) var clearButton: FlatButton!
	
	/// The bottom border layer.
	public private(set) lazy var bottomBorderLayer: CAShapeLayer = CAShapeLayer()
	
	/**
	A property that sets the distance between the textField and
	bottomBorderLayer.
	*/
	@IBInspectable public var bottomBorderLayerDistance: CGFloat = 4
	
	/**
	The title UILabel that is displayed when there is text. The
	titleLabel text value is updated with the placeholder text
	value before being displayed.
	*/
	@IBInspectable public private(set) var titleLabel: UILabel!
	
	/// The color of the titleLabel text when the textField is not active.
	@IBInspectable public var titleLabelColor: UIColor? {
		didSet {
			titleLabel.textColor = titleLabelColor
			MaterialAnimation.animationDisabled { [unowned self] in
				self.bottomBorderLayer.backgroundColor = self.titleLabelColor?.CGColor
			}
		}
	}
	
	/// The color of the titleLabel text when the textField is active.
	@IBInspectable public var titleLabelActiveColor: UIColor?
	
	/**
	A property that sets the distance between the textField and
	titleLabel.
	*/
	@IBInspectable public var titleLabelAnimationDistance: CGFloat = 8
	
	/// An override to the text property.
	@IBInspectable public override var text: String? {
		didSet {
			textFieldDidChange()
		}
	}
	
	/**
	The detail UILabel that is displayed when the detailLabelHidden property
	is set to false.
	*/
	public var detailLabel: UILabel? {
		didSet {
			prepareDetailLabel()
		}
	}
	
	/**
	The color of the detailLabel text when the detailLabelHidden property
	is set to false.
	*/
	@IBInspectable public var detailLabelActiveColor: UIColor? {
		didSet {
			if !detailLabelHidden {
				detailLabel?.textColor = detailLabelActiveColor
				MaterialAnimation.animationDisabled { [unowned self] in
					self.bottomBorderLayer.backgroundColor = self.detailLabelActiveColor?.CGColor
				}
			}
		}
	}
	
	/**
	A property that sets the distance between the textField and
	detailLabel.
	*/
	@IBInspectable public var detailLabelAnimationDistance: CGFloat = 8
	
	/**
	A Boolean that indicates the detailLabel should hide
	automatically when text changes.
	*/
	@IBInspectable public var detailLabelAutoHideEnabled: Bool = true
	
	/**
	:name:	detailLabelHidden
	*/
	@IBInspectable public var detailLabelHidden: Bool = true {
		didSet {
			if detailLabelHidden {
				detailLabel?.textColor = titleLabelColor
				MaterialAnimation.animationDisabled { [unowned self] in
					self.bottomBorderLayer.backgroundColor = self.editing ? self.titleLabelActiveColor?.CGColor : self.titleLabelColor?.CGColor
				}
				hideDetailLabel()
			} else {
				detailLabel?.textColor = detailLabelActiveColor
				MaterialAnimation.animationDisabled { [unowned self] in
					self.bottomBorderLayer.backgroundColor = self.detailLabelActiveColor?.CGColor
				}
				showDetailLabel()
			}
		}
	}
	
	/// A wrapper for searchBar.placeholder.
	@IBInspectable public override var placeholder: String? {
		didSet {
			if let v: String = placeholder {
				attributedPlaceholder = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderTextColor])
			}
		}
	}
	
	/// Placeholder textColor.
	@IBInspectable public var placeholderTextColor: UIColor = MaterialColor.black {
		didSet {
			if let v: String = placeholder {
				attributedPlaceholder = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderTextColor])
			}
		}
	}
	
	/**
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepareView()
	}
	
	/**
	An initializer that initializes the object with a CGRect object.
	If AutoLayout is used, it is better to initilize the instance
	using the init() initializer.
	- Parameter frame: A CGRect instance.
	*/
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
	}
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: CGRectNull)
	}
	
	/// Overriding the layout callback for sublayers.
	public override func layoutSublayersOfLayer(layer: CALayer) {
		super.layoutSublayersOfLayer(layer)
		if self.layer == layer {
			bottomBorderLayer.frame = CGRectMake(0, bounds.height + bottomBorderLayerDistance, bounds.width, 1)
			layoutShadowPath()
		}
	}
	
	/**
	A method that accepts CAAnimation objects and executes them on the
	view's backing layer.
	- Parameter animation: A CAAnimation instance.
	*/
	public func animate(animation: CAAnimation) {
		animation.delegate = self
		if let a: CABasicAnimation = animation as? CABasicAnimation {
			a.fromValue = (nil == layer.presentationLayer() ? layer : layer.presentationLayer() as! CALayer).valueForKeyPath(a.keyPath!)
		}
		if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
			layer.addAnimation(a, forKey: a.keyPath!)
		} else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
			layer.addAnimation(a, forKey: nil)
		} else if let a: CATransition = animation as? CATransition {
			layer.addAnimation(a, forKey: kCATransition)
		}
	}
	
	/**
	A delegation method that is executed when the backing layer starts
	running an animation.
	- Parameter anim: The currently running CAAnimation instance.
	*/
	public override func animationDidStart(anim: CAAnimation) {
		(delegate as? MaterialAnimationDelegate)?.materialAnimationDidStart?(anim)
	}
	
	/**
	A delegation method that is executed when the backing layer stops
	running an animation.
	- Parameter anim: The CAAnimation instance that stopped running.
	- Parameter flag: A boolean that indicates if the animation stopped
	because it was completed or interrupted. True if completed, false
	if interrupted.
	*/
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		if let a: CAPropertyAnimation = anim as? CAPropertyAnimation {
			if let b: CABasicAnimation = a as? CABasicAnimation {
				if let v: AnyObject = b.toValue {
					if let k: String = b.keyPath {
						layer.setValue(v, forKeyPath: k)
						layer.removeAnimationForKey(k)
					}
				}
			}
			(delegate as? MaterialAnimationDelegate)?.materialAnimationDidStop?(anim, finished: flag)
		} else if let a: CAAnimationGroup = anim as? CAAnimationGroup {
			for x in a.animations! {
				animationDidStop(x, finished: true)
			}
		}
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public func prepareView() {
		backgroundColor = MaterialColor.white
		masksToBounds = false
		prepareBottomBorderLayer()
		prepareClearButton()
		prepareTitleLabel()
		reloadView()
	}
	
	/// Reloads the view.
	public func reloadView() {
		/// Align the clearButton.
		clearButton.frame = CGRectMake(width - height, 0, height, height)
	}
	
	
	/// Clears the textField text.
	internal func handleClearButton() {
		text = ""
	}
	
	/// Ahdnler when text value changed.
	internal func textFieldValueChanged() {
		if detailLabelAutoHideEnabled && !detailLabelHidden {
			detailLabelHidden = true
			MaterialAnimation.animationDisabled { [unowned self] in
				self.bottomBorderLayer.backgroundColor = self.titleLabelActiveColor?.CGColor
			}
		}
	}
	
	/// Handler for text editing began.
	internal func textFieldDidBegin() {
		titleLabel.textColor = titleLabelActiveColor
		MaterialAnimation.animationDisabled { [unowned self] in
			self.bottomBorderLayer.backgroundColor = self.detailLabelHidden ? self.titleLabelActiveColor?.CGColor : self.detailLabelActiveColor?.CGColor
		}
	}
	
	/// Handler for text changed.
	internal func textFieldDidChange() {
		if 0 < text?.utf16.count {
			showTitleLabel()
		} else if 0 == text?.utf16.count {
			hideTitleLabel()
		}
		sendActionsForControlEvents(.ValueChanged)
	}
	
	/// Handler for text editing ended.
	internal func textFieldDidEnd() {
		if 0 < text?.utf16.count {
			showTitleLabel()
		} else if 0 == text?.utf16.count {
			hideTitleLabel()
		}
		titleLabel.textColor = titleLabelColor
		MaterialAnimation.animationDisabled { [unowned self] in
			self.bottomBorderLayer.backgroundColor = self.detailLabelHidden ? self.titleLabelColor?.CGColor : self.detailLabelActiveColor?.CGColor
		}
	}
	
	/// Sets the shadow path.
	internal func layoutShadowPath() {
		if shadowPathAutoSizeEnabled {
			if .None == depth {
				shadowPath = nil
			} else if nil == shadowPath {
				shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).CGPath
			} else {
				animate(MaterialAnimation.shadowPath(UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).CGPath, duration: 0))
			}
		}
	}
	
	/// Prepares the titleLabel property.
	private func prepareTitleLabel() {
		titleLabel = UILabel()
		titleLabel.hidden = true
		titleLabel.font = RobotoFont.mediumWithSize(12)
		titleLabelColor = MaterialColor.grey.base
		titleLabelActiveColor = MaterialColor.blue.accent3
		
		addSubview(titleLabel)
		if 0 < text?.utf16.count {
			showTitleLabel()
		} else {
			titleLabel.alpha = 0
		}
		addTarget(self, action: #selector(textFieldDidBegin), forControlEvents: .EditingDidBegin)
		addTarget(self, action: #selector(textFieldDidChange), forControlEvents: .EditingChanged)
		addTarget(self, action: #selector(textFieldDidEnd), forControlEvents: .EditingDidEnd)
	}
	
	/// Prepares the detailLabel property.
	private func prepareDetailLabel() {
		if let v: UILabel = detailLabel {
			v.hidden = true
			addSubview(v)
			if detailLabelHidden {
				v.alpha = 0
			} else {
				showDetailLabel()
			}
			if nil == titleLabel {
				addTarget(self, action: #selector(textFieldDidBegin), forControlEvents: .EditingDidBegin)
				addTarget(self, action: #selector(textFieldDidChange), forControlEvents: .EditingChanged)
				addTarget(self, action: #selector(textFieldDidEnd), forControlEvents: .EditingDidEnd)
			}
			addTarget(self, action: #selector(textFieldValueChanged), forControlEvents: .ValueChanged)
		}
	}
	
	/// Prepares the bottomBorderLayer property.
	private func prepareBottomBorderLayer() {
		layer.addSublayer(bottomBorderLayer)
	}
	
	/// Prepares the clearButton.
	private func prepareClearButton() {
		let image: UIImage? = MaterialIcon.cm.close
		clearButton = FlatButton()
		clearButton.contentEdgeInsets = UIEdgeInsetsZero
		clearButton.pulseColor = MaterialColor.grey.base
		clearButton.pulseScale = false
		clearButton.tintColor = MaterialColor.grey.base
		clearButton.setImage(image, forState: .Normal)
		clearButton.setImage(image, forState: .Highlighted)
		clearButtonAutoHandleEnabled = true
		clearButtonMode = .Never
		rightViewMode = .WhileEditing
		rightView = clearButton
	}
	
	/// Shows and animates the titleLabel property.
	private func showTitleLabel() {
		if titleLabel.hidden {
			if let s: String = placeholder {
				if 0 == titleLabel.text?.utf16.count || nil == titleLabel.text {
					titleLabel.text = s
				}
			}
			let h: CGFloat = ceil(titleLabel.font.lineHeight)
			titleLabel.frame = CGRectMake(0, -h, bounds.width, h)
			titleLabel.hidden = false
			UIView.animateWithDuration(0.25, animations: { [unowned self] in
				self.titleLabel.alpha = 1
				self.titleLabel.frame.origin.y -= self.titleLabelAnimationDistance
			})
		}
	}
	
	/// Hides and animates the titleLabel property.
	private func hideTitleLabel() {
		UIView.animateWithDuration(0.25, animations: { [unowned self] in
			self.titleLabel.alpha = 0
			self.titleLabel.frame.origin.y += self.titleLabelAnimationDistance
		}) { _ in
			self.titleLabel.hidden = true
		}
	}
	
	/// Shows and animates the detailLabel property.
	private func showDetailLabel() {
		if let v: UILabel = detailLabel {
			if v.hidden {
				let h: CGFloat = ceil(v.font.lineHeight)
				v.frame = CGRectMake(0, bounds.height + bottomBorderLayerDistance, bounds.width, h)
				v.hidden = false
				UIView.animateWithDuration(0.25, animations: { [unowned self] in
					v.frame.origin.y = self.frame.height + self.bottomBorderLayerDistance + self.detailLabelAnimationDistance
					v.alpha = 1
				})
			}
		}
	}
	
	/// Hides and animates the detailLabel property.
	private func hideDetailLabel() {
		if let v: UILabel = detailLabel {
			UIView.animateWithDuration(0.25, animations: { [unowned self] in
				v.alpha = 0
				v.frame.origin.y -= self.detailLabelAnimationDistance
			}) { _ in
				v.hidden = true
			}
		}
	}
}