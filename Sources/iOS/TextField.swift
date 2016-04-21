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
	/// A boolean that indicates if the titleLabel is animating.
	private var titleLabelAnimating: Bool = false
	
	/// A reference to the placeholder value.
	private var placeholderText: String?
	
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
	public private(set) lazy var lineLayer: CAShapeLayer = CAShapeLayer()
	
	/**
	A property that sets the distance between the textField and
	lineLayer.
	*/
	@IBInspectable public var lineLayerDistance: CGFloat = 4
	
	/// The height of the line when not active.
	@IBInspectable public var lineLayerThickness: CGFloat = 1
	
	/// The height of the line when active.
	@IBInspectable public var lineLayerActiveThickness: CGFloat = 2
	
	/// The lineLayer color when inactive.
	@IBInspectable public var lineLayerColor: UIColor? {
		didSet {
			lineLayer.backgroundColor = lineLayerColor?.CGColor
		}
	}
	
	/// The lineLayer active color.
	@IBInspectable public var lineLayerActiveColor: UIColor?
	
	/// The lineLayer detail color when inactive.
	@IBInspectable public var lineLayerDetailColor: UIColor?
	
	/// The lineLayer detail active color.
	@IBInspectable public var lineLayerDetailActiveColor: UIColor?
	
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
			if nil == lineLayerColor {
				lineLayerColor = titleLabelColor
			}
		}
	}
	
	/// The color of the titleLabel text when the textField is active.
	@IBInspectable public var titleLabelActiveColor: UIColor? {
		didSet {
			if nil == lineLayerActiveColor {
				lineLayerActiveColor = titleLabelActiveColor
			}
            tintColor = titleLabelActiveColor
		}
	}
	
	/**
	A property that sets the distance between the textField and
	titleLabel.
	*/
	@IBInspectable public var titleLabelAnimationDistance: CGFloat = 4
	
	/**
	The detail UILabel that is displayed when the detailLabelHidden property
	is set to false.
	*/
	@IBInspectable public private(set) var detailLabel: UILabel!
	
	/**
	The color of the detailLabel text when the detailLabelHidden property
	is set to false.
	*/
	@IBInspectable public var detailLabelActiveColor: UIColor? {
		didSet {
			if !detailLabelHidden {
				detailLabel.textColor = detailLabelActiveColor
				if nil == lineLayerDetailActiveColor {
					lineLayerDetailActiveColor = detailLabelActiveColor
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
	
	/// A boolean that indicates to hide or not hide the detailLabel.
	@IBInspectable public var detailLabelHidden: Bool = true {
		didSet {
			if detailLabelHidden {
				detailLabel.textColor = titleLabelColor
				lineLayer.backgroundColor = (editing ? lineLayerActiveColor : lineLayerColor)?.CGColor
				hideDetailLabel()
			} else {
				detailLabel.textColor = detailLabelActiveColor
				lineLayer.backgroundColor = (nil == lineLayerDetailActiveColor ? detailLabelActiveColor : lineLayerDetailActiveColor)?.CGColor
				showDetailLabel()
			}
		}
	}
	
	/// Sets the placeholder value.
	@IBInspectable public override var placeholder: String? {
		get {
			return editing ? nil : placeholderText
		}
		set(value) {
			if let v: String = value {
				placeholderText = v
				attributedPlaceholder = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderTextColor])
			} else {
				super.placeholder = nil
				if !editing {
					placeholderText = nil
				}
			}
			if false == text?.isEmpty {
				titleLabel.text = placeholderText
			}
		}
	}
	
	/// Placeholder textColor.
	@IBInspectable public var placeholderTextColor: UIColor = MaterialColor.darkText.others {
		didSet {
			if let v: String = placeholder {
				attributedPlaceholder = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderTextColor])
			}
		}
	}
	
	/// An override to the text property.
	@IBInspectable public override var text: String? {
		didSet {
			sendActionsForControlEvents(.ValueChanged)
			if nil != oldValue && true == text?.isEmpty && !editing {
				handleEditingDidEnd()
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
		self.init(frame: CGRectZero)
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		layoutClearButton()
	}
	
	public override func layoutSublayersOfLayer(layer: CALayer) {
		super.layoutSublayersOfLayer(layer)
		if self.layer == layer {
			layoutLineLayer()
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
		masksToBounds = false
		borderStyle = .None
		backgroundColor = MaterialColor.white
		textColor = MaterialColor.darkText.primary
		font = RobotoFont.regularWithSize(16)
		prepareClearButton()
		prepareTitleLabel()
		prepareLineLayer()
		prepareDetailLabel()
		addTarget(self, action: #selector(handleEditingDidBegin), forControlEvents: .EditingDidBegin)
		addTarget(self, action: #selector(handleEditingChanged), forControlEvents: .EditingChanged)
		addTarget(self, action: #selector(handleEditingDidEnd), forControlEvents: .EditingDidEnd)
		addTarget(self, action: #selector(handleValueChanged), forControlEvents: .ValueChanged)
	}
	
	/// Handler for editing changed.
	internal func handleEditingChanged() {
		sendActionsForControlEvents(.ValueChanged)
	}
	
	/// Clears the textField text.
	internal func handleClearButton() {
		if false == delegate?.textFieldShouldClear?(self) {
			return
		}
		text = nil
	}
	
	/// Ahdnler when text value changed.
	internal func handleValueChanged() {
		if detailLabelAutoHideEnabled && !detailLabelHidden {
			detailLabelHidden = true
			lineLayer.backgroundColor = (nil == lineLayerActiveColor ? titleLabelActiveColor : lineLayerActiveColor)?.CGColor
		}
	}
	
	/// Handler for text editing began.
	internal func handleEditingDidBegin() {
		showTitleLabel()
		placeholder = nil
		titleLabel.textColor = titleLabelActiveColor
		lineLayer.frame.size.height = lineLayerActiveThickness
		lineLayer.backgroundColor = (detailLabelHidden ? nil == lineLayerActiveColor ? titleLabelActiveColor : lineLayerActiveColor : nil == lineLayerDetailActiveColor ? detailLabelActiveColor : lineLayerDetailActiveColor)?.CGColor
	}
	
	/// Handler for text editing ended.
	internal func handleEditingDidEnd() {
		if true == text?.isEmpty && !titleLabelAnimating {
			hideTitleLabel()
		}
		titleLabel.textColor = titleLabelColor
		lineLayer.frame.size.height = lineLayerThickness
		lineLayer.backgroundColor = (detailLabelHidden ? nil == lineLayerColor ? titleLabelColor : lineLayerColor : nil == lineLayerDetailColor ? detailLabelActiveColor : lineLayerDetailColor)?.CGColor
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
	
	/// Prepares the titleLabel.
	private func prepareTitleLabel() {
		titleLabel = UILabel(frame: CGRectZero)
		titleLabel.hidden = true
		titleLabel.font = RobotoFont.mediumWithSize(12)
		addSubview(titleLabel)
		
		titleLabelColor = placeholderTextColor
		titleLabelActiveColor = MaterialColor.blue.accent3
		
		if false == text?.isEmpty {
			showTitleLabel()
		}
	}
	
	/// Prepares the detailLabel.
	private func prepareDetailLabel() {
		detailLabel = UILabel(frame: CGRectZero)
		detailLabel.hidden = true
		addSubview(detailLabel)
		if detailLabelHidden {
			detailLabel.alpha = 0
		} else {
			showDetailLabel()
		}
	}
	
	/// Prepares the lineLayer.
	private func prepareLineLayer() {
		layoutLineLayer()
		layer.addSublayer(lineLayer)
	}
	
	/// Layout the lineLayer.
	private func layoutLineLayer() {
		let h: CGFloat = lineLayerActiveThickness == lineLayer.frame.height ? lineLayerActiveThickness : lineLayerThickness
		lineLayer.frame = CGRectMake(0, bounds.height + lineLayerDistance, bounds.width, h)
	}
	
	/// Prepares the clearButton.
	private func prepareClearButton() {
		let image: UIImage? = MaterialIcon.cm.close
		clearButton = FlatButton()
		clearButton.contentEdgeInsets = UIEdgeInsetsZero
		clearButton.pulseColor = MaterialColor.black
        clearButton.pulseOpacity = 0.12
		clearButton.pulseScale = false
		clearButton.tintColor = placeholderTextColor
		clearButton.setImage(image, forState: .Normal)
		clearButton.setImage(image, forState: .Highlighted)
		clearButtonAutoHandleEnabled = true
		clearButtonMode = .Never
		rightViewMode = .WhileEditing
		rightView = clearButton
	}
	
	/// Layout the clearButton.
	private func layoutClearButton() {
		if 0 < width && 0 < height {
			clearButton.frame = CGRectMake(width - height, 0, height, height)
		}
	}
	
	/// Shows and animates the titleLabel property.
	private func showTitleLabel() {
		if titleLabel.hidden {
			let h: CGFloat = ceil(titleLabel.font.lineHeight)
			titleLabel.frame = bounds
			titleLabel.font = font
			titleLabel.text = placeholderText
			titleLabel.hidden = false
			UIView.animateWithDuration(0.15, animations: { [weak self] in
                if let s: TextField = self {
                    s.titleLabel.transform = CGAffineTransformScale(s.titleLabel.transform, 0.75, 0.75)
                    s.titleLabel.frame = CGRectMake(0, -(s.titleLabelAnimationDistance + h), s.bounds.width, h)
                }
			})
		}
	}
	
	/// Hides and animates the titleLabel property.
	private func hideTitleLabel() {
		titleLabelAnimating = true
		UIView.animateWithDuration(0.15, animations: { [weak self] in
			if let s: TextField = self {
                s.titleLabel.transform = CGAffineTransformIdentity
                s.titleLabel.frame = s.bounds
            }
		}) { [weak self] _ in
            if let s: TextField = self {
                s.titleLabel.hidden = true
				s.placeholder = s.placeholderText
				s.titleLabelAnimating = false
            }
		}
	}
	
	/// Shows and animates the detailLabel property.
	private func showDetailLabel() {
		if detailLabel.hidden {
			let h: CGFloat = ceil(detailLabel.font.lineHeight)
			detailLabel.frame = CGRectMake(0, bounds.height + lineLayerDistance, bounds.width, h)
			detailLabel.hidden = false
			UIView.animateWithDuration(0.15, animations: { [weak self] in
				if let s: TextField = self {
					s.detailLabel.frame.origin.y = s.frame.height + s.lineLayerDistance + s.detailLabelAnimationDistance
					s.detailLabel.alpha = 1
				}
			})
		}
	}
	
	/// Hides and animates the detailLabel property.
	private func hideDetailLabel() {
		UIView.animateWithDuration(0.15, animations: { [weak self] in
			if let s: TextField = self {
				s.detailLabel.alpha = 0
				s.detailLabel.frame.origin.y -= s.detailLabelAnimationDistance
			}
		}) { [weak self] _ in
			if let s: TextField = self {
				s.detailLabel.hidden = true
			}
		}
	}
}