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

@IBDesignable
public class TextField: UITextField {
    /// Default size when using AutoLayout.
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 32)
    }
    
    /// A Boolean that indicates if the TextField is in an animating state.
	public private(set) var animating: Bool = false
	
	/// A property that accesses the backing layer's backgroundColor.
	@IBInspectable public override var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.cgColor
		}
	}
	
    /// Reference to the divider.
	public private(set) lazy var divider: CAShapeLayer = CAShapeLayer()
	
	/// Divider height.
	@IBInspectable public var dividerHeight: CGFloat = 1
	
	/// Divider active state height.
	@IBInspectable public var dividerActiveHeight: CGFloat = 2
	
	/// Sets the divider.
	@IBInspectable public var dividerColor: UIColor = Color.darkText.dividers {
		didSet {
			if !isEditing {
				divider.backgroundColor = dividerColor.cgColor
			}
		}
	}
	
	/// Sets the divider.
	@IBInspectable public var dividerActiveColor: UIColor? {
		didSet {
			if let v: UIColor = dividerActiveColor {
				if isEditing {
					divider.backgroundColor = v.cgColor
				}
			}
		}
	}
	
	/// The placeholderLabel font value.
	@IBInspectable public override var font: UIFont? {
		didSet {
			placeholderLabel.font = font
		}
	}
 
	/// TextField's text property observer.
	@IBInspectable public override var text: String? {
		didSet {
			if true == text?.isEmpty && !isFirstResponder {
				placeholderEditingDidEndAnimation()
			}
		}
	}
	
	/// The placeholderLabel text value.
	@IBInspectable public override var placeholder: String? {
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
	@IBInspectable public private(set) lazy var placeholderLabel: UILabel = UILabel(frame: CGRect.zero)
	
	/// Placeholder textColor.
	@IBInspectable public var placeholderColor: UIColor = Color.darkText.others {
		didSet {
			if !isEditing {
				if let v: String = placeholder {
					placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderColor])
				}
			}
		}
	}
	
	/// Placeholder active textColor.
	@IBInspectable public var placeholderActiveColor: UIColor = Color.blue.base {
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
	public var placeholderVerticalOffset: CGFloat = 0
	
	/// The detailLabel UILabel that is displayed.
	@IBInspectable public private(set) lazy var detailLabel: UILabel = UILabel(frame: CGRect.zero)
	
	
	/// The detailLabel text value.
	@IBInspectable public var detail: String? {
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
	@IBInspectable public var detailColor: UIColor = Color.darkText.others {
		didSet {
			if let v: String = detailLabel.text {
				detailLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: detailColor])
			}
		}
	}
    
	/// Vertical distance for the detailLabel from the divider.
	@IBInspectable public var detailVerticalOffset: CGFloat = 8 {
		didSet {
			layoutDetailLabel()
		}
	}
	
	/// Handles the textAlignment of the placeholderLabel.
	public override var textAlignment: NSTextAlignment {
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
	@IBInspectable public var enableClearIconButton: Bool {
		get {
			return nil != clearIconButton
		}
		set(value) {
			if value {
				if nil == clearIconButton {
					let image: UIImage? = Icon.cm.clear
					clearIconButton = IconButton(frame: CGRect.zero)
					clearIconButton!.contentEdgeInsets = UIEdgeInsets.zero
					clearIconButton!.pulseAnimation = .center
					clearIconButton!.tintColor = placeholderColor
					clearIconButton!.setImage(image, for: .normal)
                    clearIconButton!.setImage(image, for: .highlighted)
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
	@IBInspectable public var clearIconButtonAutoHandle: Bool = true {
		didSet {
			clearIconButton?.removeTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
			if clearIconButtonAutoHandle {
				clearIconButton?.addTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
			}
		}
	}
	
	/// Enables the visibilityIconButton.
	@IBInspectable public var enableVisibilityIconButton: Bool {
		get {
			return nil != visibilityIconButton
		}
		set(value) {
			if value {
				if nil == visibilityIconButton {
					let image: UIImage? = Icon.visibility
					visibilityIconButton = IconButton(frame: CGRect.zero)
					visibilityIconButton!.contentEdgeInsets = UIEdgeInsets.zero
					visibilityIconButton!.pulseAnimation = .center
					visibilityIconButton!.tintColor = placeholderColor
                    visibilityIconButton!.setImage(image, for: .normal)
                    visibilityIconButton!.setImage(image, for: .highlighted)
					visibilityIconButton!.tintColor = placeholderColor.withAlphaComponent(isSecureTextEntry ? 0.38 : 0.54)
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
	@IBInspectable public var visibilityIconButtonAutoHandle: Bool = true {
		didSet {
			visibilityIconButton?.removeTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
			if visibilityIconButtonAutoHandle {
				visibilityIconButton?.addTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
			}
		}
	}
	
	/// A reference to the clearIconButton.
	public private(set) var clearIconButton: IconButton?
	
	/// A reference to the visibilityIconButton.
	public private(set) var visibilityIconButton: IconButton?
	
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
		self.init(frame: CGRect.zero)
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
        layoutToSize()
	}
	
	public override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		if self.layer == layer {
            layoutShape()
			layoutDivider()
		}
	}
	
	/// Handles the text editing did begin state.
	public func handleEditingDidBegin() {
		dividerEditingDidBeginAnimation()
		placeholderEditingDidBeginAnimation()
	}
	
	/// Handles the text editing did end state.
	public func handleEditingDidEnd() {
		dividerEditingDidEndAnimation()
		placeholderEditingDidEndAnimation()
	}
	
	/// Handles the clearIconButton TouchUpInside event.
	public func handleClearIconButton() {
		if false == delegate?.textFieldShouldClear?(self) {
			return
		}
		text = nil
	}
	
	/// Handles the visibilityIconButton TouchUpInside event.
	public func handleVisibilityIconButton() {
		isSecureTextEntry = !isSecureTextEntry
		if !isSecureTextEntry {
			super.font = nil
			font = placeholderLabel.font
		}
		visibilityIconButton?.tintColor = visibilityIconButton?.tintColor.withAlphaComponent(isSecureTextEntry ? 0.38 : 0.54)
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public func prepareView() {
		super.placeholder = nil
		clipsToBounds = false
		borderStyle = .none
		backgroundColor = nil
		textColor = Color.darkText.primary
		font = RobotoFont.regularWithSize(size: 16)
		contentScaleFactor = Device.scale
		prepareDivider()
		preparePlaceholderLabel()
		prepareDetailLabel()
		prepareTargetHandlers()
        prepareTextAlignment()
	}
	
	/// Ensures that the components are sized correctly.
	public func layoutToSize() {
		if !animating {
			layoutPlaceholderLabel()
			layoutDetailLabel()
			layoutClearIconButton()
			layoutVisibilityIconButton()
		}
	}
	
	/// Layout the divider.
	public func layoutDivider() {
        divider.frame = CGRect(x: 0, y: height, width: width, height: isEditing ? dividerActiveHeight : dividerHeight)
	}
	
	/// Layout the placeholderLabel.
	public func layoutPlaceholderLabel() {
		if !isEditing && true == text?.isEmpty {
			placeholderLabel.frame = bounds
		} else if placeholderLabel.transform.isIdentity {
			placeholderLabel.frame = bounds
			placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
			switch textAlignment {
			case .left, .natural:
				placeholderLabel.frame.origin.x = 0
			case .right:
				placeholderLabel.frame.origin.x = width - placeholderLabel.frame.width
			default:break
			}
			placeholderLabel.frame.origin.y = -placeholderLabel.frame.size.height + placeholderVerticalOffset
			placeholderLabel.textColor = placeholderColor
		} else {
			switch textAlignment {
			case .left, .natural:
				placeholderLabel.frame.origin.x = 0
			case .right:
				placeholderLabel.frame.origin.x = width - placeholderLabel.frame.width
			case .center:
				placeholderLabel.center.x = width / 2
			default:break
			}
			placeholderLabel.frame.size.width = width * 0.75
		}
	}
	
	/// Layout the detailLabel.
	public func layoutDetailLabel() {
		let h: CGFloat = nil == detail ? 12 : detailLabel.font.stringSize(string: detail!, constrainedToWidth: Double(width)).height
        detailLabel.frame = CGRect(x: 0, y: divider.frame.origin.y + detailVerticalOffset, width: width, height: h)
	}
	
	/// Layout the clearIconButton.
	public func layoutClearIconButton() {
		if let v = clearIconButton {
			if 0 < width && 0 < height {
                v.frame = CGRect(x: width - height, y: 0, width: height, height: height)
			}
		}
	}
	
	/// Layout the visibilityIconButton.
	public func layoutVisibilityIconButton() {
		if let v = visibilityIconButton {
			if 0 < width && 0 < height {
                v.frame = CGRect(x: width - height, y: 0, width: height, height: height)
			}
		}
	}
	
	/// The animation for the divider when editing begins.
	public func dividerEditingDidBeginAnimation() {
		divider.frame.size.height = dividerActiveHeight
		divider.backgroundColor = nil == dividerActiveColor ? placeholderActiveColor.cgColor : dividerActiveColor!.cgColor
	}
	
	/// The animation for the divider when editing ends.
	public func dividerEditingDidEndAnimation() {
		divider.frame.size.height = dividerHeight
		divider.backgroundColor = dividerColor.cgColor
	}
	
	/// The animation for the placeholder when editing begins.
	public func placeholderEditingDidBeginAnimation() {
		if placeholderLabel.transform.isIdentity {
			animating = true
			UIView.animate(withDuration: 0.15, animations: { [weak self] in
				if let s = self {
					s.placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
					switch s.textAlignment {
					case .left, .natural:
						s.placeholderLabel.frame.origin.x = 0
					case .right:
						s.placeholderLabel.frame.origin.x = s.width - s.placeholderLabel.frame.width
					default:break
					}
					s.placeholderLabel.frame.origin.y = -s.placeholderLabel.frame.size.height + s.placeholderVerticalOffset
					s.placeholderLabel.textColor = s.placeholderActiveColor
				}
			}) { [weak self] _ in
				self?.animating = false
			}
		} else if isEditing {
			placeholderLabel.textColor = placeholderActiveColor
		}
	}
	
	/// The animation for the placeholder when editing ends.
	public func placeholderEditingDidEndAnimation() {
		if !placeholderLabel.transform.isIdentity && true == text?.isEmpty {
			animating = true
			UIView.animate(withDuration: 0.15, animations: { [weak self] in
				if let s = self {
					s.placeholderLabel.transform = CGAffineTransform.identity
					s.placeholderLabel.frame.origin.x = 0
					s.placeholderLabel.frame.origin.y = 0
					s.placeholderLabel.textColor = s.placeholderColor
				}
			}) { [weak self] _ in
				self?.animating = false
			}
		} else if !isEditing {
			placeholderLabel.textColor = placeholderColor
		}
	}
	
	/// Prepares the divider.
	private func prepareDivider() {
		dividerColor = Color.darkText.dividers
		layer.addSublayer(divider)
	}
	
	/// Prepares the placeholderLabel.
	private func preparePlaceholderLabel() {
		placeholderColor = Color.darkText.others
		addSubview(placeholderLabel)
	}
	
	/// Prepares the detailLabel.
	private func prepareDetailLabel() {
        detailLabel.font = RobotoFont.regularWithSize(size: 12)
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
