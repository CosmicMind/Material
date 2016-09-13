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

public protocol TextFieldDelegate: UITextFieldDelegate {}

open class TextField: UITextField {
    /// Default size when using AutoLayout.
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 32)
    }
    
    /// A Boolean that indicates if the TextField is in an animating state.
	open internal(set) var isAnimating = false
	
	/// A property that accesses the backing layer's backgroundColor.
	@IBInspectable
    open override var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.cgColor
		}
	}
	
    /// Reference to the divider.
	open private(set) var divider: CAShapeLayer!
	
	/// Divider height.
	@IBInspectable
    open var dividerHeight: CGFloat = 1
	
	/// Divider active state height.
	@IBInspectable
    open var dividerActiveHeight: CGFloat = 2
	
	/// Sets the divider.
	@IBInspectable
    open var dividerColor: UIColor = Color.darkText.dividers {
		didSet {
			if !isEditing {
				divider.backgroundColor = dividerColor.cgColor
			}
		}
	}
	
	/// Sets the divider.
	@IBInspectable
    open var dividerActiveColor: UIColor? {
		didSet {
			if let v: UIColor = dividerActiveColor {
				if isEditing {
					divider.backgroundColor = v.cgColor
				}
			}
		}
	}
	
	/// The placeholderLabel font value.
	@IBInspectable
    open override var font: UIFont? {
		didSet {
			placeholderLabel.font = font
		}
	}
 
	/// TextField's text property observer.
	@IBInspectable
    open override var text: String? {
		didSet {
			if true == text?.isEmpty && !isFirstResponder {
				placeholderEditingDidEndAnimation()
			}
		}
	}
	
	/// The placeholderLabel text value.
	@IBInspectable
    open override var placeholder: String? {
		get {
			return placeholderLabel.text
		}
		set(value) {
			placeholderLabel.text = value
			if let v: String = value {
				placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderColor])
			}
		}
	}
	
	/// The placeholder UILabel.
	@IBInspectable
    open private(set) var placeholderLabel: UILabel!
	
	/// Placeholder textColor.
	@IBInspectable
    open var placeholderColor = Color.darkText.others {
		didSet {
			if !isEditing {
				if let v: String = placeholder {
					placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderColor])
				}
			}
		}
	}
	
	/// Placeholder active textColor.
	@IBInspectable
    open var placeholderActiveColor = Color.blue.base {
		didSet {
			if isEditing {
				if let v: String = placeholder {
					placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderActiveColor])
				}
			}
			tintColor = placeholderActiveColor
		}
	}
	
	/// This property adds a padding to placeholder y position animation
	open var placeholderVerticalOffset: CGFloat = 0
	
	/// The detailLabel UILabel that is displayed.
	@IBInspectable
    open private(set) lazy var detailLabel = UILabel(frame: .zero)
	
	
	/// The detailLabel text value.
	@IBInspectable
    open var detail: String? {
		get {
			return detailLabel.text
		}
		set(value) {
			detailLabel.text = value
			if let v: String = value {
				detailLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: detailColor])
			}
			layoutDetailLabel()
		}
	}
	
	/// Detail textColor.
	@IBInspectable
    open var detailColor = Color.darkText.others {
		didSet {
			if let v: String = detailLabel.text {
				detailLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: detailColor])
			}
		}
	}
    
	/// Vertical distance for the detailLabel from the divider.
	@IBInspectable
    open var detailVerticalOffset: CGFloat = 8 {
		didSet {
			layoutDetailLabel()
		}
	}
	
	/// Handles the textAlignment of the placeholderLabel.
	open override var textAlignment: NSTextAlignment {
		get {
			return super.textAlignment
		}
		set(value) {
			super.textAlignment = value
			placeholderLabel.textAlignment = value
			detailLabel.textAlignment = value
		}
	}
	
	/// Enables the clearIconButton.
	@IBInspectable
    open var isClearIconButtonEnable: Bool {
		get {
			return nil != clearIconButton
		}
		set(value) {
			if value {
				if nil == clearIconButton {
                    clearIconButton = IconButton(image: Icon.cm.clear, tintColor: placeholderColor)
					clearIconButton!.contentEdgeInsets = .zero
					clearIconButton!.pulseAnimation = .center
                    clearButtonMode = .never
					rightViewMode = .whileEditing
					rightView = clearIconButton
					clearIconButtonAutoHandle = clearIconButtonAutoHandle ? true : false
				}
			} else {
				clearIconButton?.removeTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
				clearIconButton = nil
			}
		}
	}
	
	/// Enables the automatic handling of the clearIconButton.
	@IBInspectable
    open var clearIconButtonAutoHandle = true {
		didSet {
			clearIconButton?.removeTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
			if clearIconButtonAutoHandle {
				clearIconButton?.addTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
			}
		}
	}
	
	/// Enables the visibilityIconButton.
	@IBInspectable
    open var isVisibilityIconButtonEnable: Bool {
		get {
			return nil != visibilityIconButton
		}
		set(value) {
			if value {
				if nil == visibilityIconButton {
                    visibilityIconButton = IconButton(image: Icon.visibility, tintColor: placeholderColor.withAlphaComponent(isSecureTextEntry ? 0.38 : 0.54))
					visibilityIconButton!.contentEdgeInsets = .zero
					visibilityIconButton!.pulseAnimation = .center
					isSecureTextEntry = true
					clearButtonMode = .never
					rightViewMode = .whileEditing
					rightView = visibilityIconButton
					visibilityIconButtonAutoHandle = visibilityIconButtonAutoHandle ? true : false
				}
			} else {
				visibilityIconButton?.removeTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
				visibilityIconButton = nil
			}
		}
	}
	
	/// Enables the automatic handling of the visibilityIconButton.
	@IBInspectable
    open var visibilityIconButtonAutoHandle: Bool = true {
		didSet {
			visibilityIconButton?.removeTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
			if visibilityIconButtonAutoHandle {
				visibilityIconButton?.addTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
			}
		}
	}
	
	/// A reference to the clearIconButton.
	open private(set) var clearIconButton: IconButton?
	
	/// A reference to the visibilityIconButton.
	open private(set) var visibilityIconButton: IconButton?
	
    /**
     `layoutIfNeeded` is called within `becomeFirstResponder` to
     fix an issue that when the TextField calls `becomeFirstResponder`
     immediately when launching an instance, the TextField is not
     calculated correctly.
     */
    open override func becomeFirstResponder() -> Bool {
        layoutIfNeeded()
        return super.becomeFirstResponder()
    }
    
	/**
     An initializer that initializes the object with a NSCoder object.
     - Parameter aDecoder: A NSCoder instance.
     */
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepare()
	}
	
	/**
     An initializer that initializes the object with a CGRect object.
     If AutoLayout is used, it is better to initilize the instance
     using the init() initializer.
     - Parameter frame: A CGRect instance.
     */
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepare()
	}
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: .zero)
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
        layoutToSize()
	}
	
	open override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		if self.layer == layer {
            layoutShape()
			layoutDivider()
		}
	}
	
	/// Handles the text editing did begin state.
    @objc
	open func handleEditingDidBegin() {
        dividerEditingDidBeginAnimation()
		placeholderEditingDidBeginAnimation()
	}
	
	/// Handles the text editing did end state.
	@objc
    open func handleEditingDidEnd() {
		dividerEditingDidEndAnimation()
		placeholderEditingDidEndAnimation()
	}
	
	/// Handles the clearIconButton TouchUpInside event.
	@objc
    open func handleClearIconButton() {
		if false == delegate?.textFieldShouldClear?(self) {
			return
		}
		text = nil
	}
	
	/// Handles the visibilityIconButton TouchUpInside event.
    @objc
	open func handleVisibilityIconButton() {
		isSecureTextEntry = !isSecureTextEntry
		if !isSecureTextEntry {
			super.font = nil
			font = placeholderLabel.font
		}
		visibilityIconButton?.tintColor = visibilityIconButton?.tintColor.withAlphaComponent(isSecureTextEntry ? 0.38 : 0.54)
	}
	
	/**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
	open func prepare() {
		super.placeholder = nil
        clipsToBounds = false
		borderStyle = .none
		backgroundColor = nil
		contentScaleFactor = Device.scale
		prepareDivider()
		preparePlaceholderLabel()
		prepareDetailLabel()
		prepareTargetHandlers()
        prepareTextAlignment()
	}
    
	/// Ensures that the components are sized correctly.
	open func layoutToSize() {
		if !isAnimating {
            layoutPlaceholderLabel()
			layoutDetailLabel()
			layoutClearIconButton()
			layoutVisibilityIconButton()
		}
	}
	
	/// Layout the divider.
	open func layoutDivider() {
        divider.frame = CGRect(x: 0, y: height, width: width, height: isEditing ? dividerActiveHeight : dividerHeight)
	}
	
	/// Layout the placeholderLabel.
	open func layoutPlaceholderLabel() {
		if !isEditing && true == text?.isEmpty {
			placeholderLabel.frame = bounds
		} else if placeholderLabel.transform.isIdentity {
			placeholderLabel.frame = bounds
			placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
			switch textAlignment {
			case .left, .natural:
				placeholderLabel.x = 0
			case .right:
				placeholderLabel.x = width - placeholderLabel.width
			default:break
			}
			placeholderLabel.y = -placeholderLabel.height + placeholderVerticalOffset
			placeholderLabel.textColor = placeholderColor
		} else {
			switch textAlignment {
			case .left, .natural:
				placeholderLabel.x = 0
			case .right:
				placeholderLabel.x = width - placeholderLabel.width
			case .center:
				placeholderLabel.center.x = width / 2
			default:break
			}
			placeholderLabel.width = width * 0.75
		}
	}
	
	/// Layout the detailLabel.
	open func layoutDetailLabel() {
		let h: CGFloat = nil == detail ? 12 : detailLabel.font.stringSize(string: detail!, constrainedToWidth: Double(width)).height
        detailLabel.frame = CGRect(x: 0, y: divider.y + detailVerticalOffset, width: width, height: h)
	}
	
	/// Layout the clearIconButton.
	open func layoutClearIconButton() {
		if let v = clearIconButton {
			if 0 < width && 0 < height {
                v.frame = CGRect(x: width - height, y: 0, width: height, height: height)
			}
		}
	}
	
	/// Layout the visibilityIconButton.
	open func layoutVisibilityIconButton() {
		if let v = visibilityIconButton {
			if 0 < width && 0 < height {
                v.frame = CGRect(x: width - height, y: 0, width: height, height: height)
			}
		}
	}
	
	/// The animation for the divider when editing begins.
	open func dividerEditingDidBeginAnimation() {
		divider.height = dividerActiveHeight
		divider.backgroundColor = nil == dividerActiveColor ? placeholderActiveColor.cgColor : dividerActiveColor!.cgColor
	}
	
	/// The animation for the divider when editing ends.
	open func dividerEditingDidEndAnimation() {
		divider.frame.size.height = dividerHeight
		divider.backgroundColor = dividerColor.cgColor
	}
	
	/// The animation for the placeholder when editing begins.
	open func placeholderEditingDidBeginAnimation() {
		if placeholderLabel.transform.isIdentity {
			isAnimating = true
			UIView.animate(withDuration: 0.15, animations: { [weak self] in
				if let s = self {
					s.placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
					switch s.textAlignment {
					case .left, .natural:
						s.placeholderLabel.x = 0
					case .right:
						s.placeholderLabel.x = s.width - s.placeholderLabel.width
					default:break
					}
					s.placeholderLabel.y = -s.placeholderLabel.height + s.placeholderVerticalOffset
					s.placeholderLabel.textColor = s.placeholderActiveColor
				}
			}) { [weak self] _ in
				self?.isAnimating = false
			}
		} else if isEditing {
			placeholderLabel.textColor = placeholderActiveColor
		}
	}
	
	/// The animation for the placeholder when editing ends.
	open func placeholderEditingDidEndAnimation() {
		if !placeholderLabel.transform.isIdentity && true == text?.isEmpty {
			isAnimating = true
			UIView.animate(withDuration: 0.15, animations: { [weak self] in
				if let s = self {
					s.placeholderLabel.transform = CGAffineTransform.identity
					s.placeholderLabel.x = 0
					s.placeholderLabel.y = 0
					s.placeholderLabel.textColor = s.placeholderColor
				}
			}) { [weak self] _ in
				self?.isAnimating = false
			}
		} else if !isEditing {
			placeholderLabel.textColor = placeholderColor
		}
	}
	
	/// Prepares the divider.
	private func prepareDivider() {
        divider = CAShapeLayer()
		dividerColor = Color.darkText.dividers
		layer.addSublayer(divider)
	}
	
	/// Prepares the placeholderLabel.
	private func preparePlaceholderLabel() {
        placeholderLabel = UILabel(frame: .zero)
		placeholderColor = Color.darkText.others
        font = RobotoFont.regular(with: 16)
        addSubview(placeholderLabel)
	}
	
	/// Prepares the detailLabel.
	private func prepareDetailLabel() {
        detailLabel.font = RobotoFont.regular(with: 12)
        detailLabel.numberOfLines = 0
		detailColor = Color.darkText.others
		addSubview(detailLabel)
	}
	
	/// Prepares the target handlers.
	private func prepareTargetHandlers() {
		addTarget(self, action: #selector(handleEditingDidBegin), for: .editingDidBegin)
		addTarget(self, action: #selector(handleEditingDidEnd), for: .editingDidEnd)
	}
    
    /// Prepares the textAlignment.
    private func prepareTextAlignment() {
        textAlignment = .rightToLeft == UIApplication.shared.userInterfaceLayoutDirection ? .right : .left
    }
}
