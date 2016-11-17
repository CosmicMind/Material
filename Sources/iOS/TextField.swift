/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

@objc(TextFieldDelegate)
public protocol TextFieldDelegate: UITextFieldDelegate {
    /**
     A delegation method that is executed when the textField changed.
     - Parameter textField: A UITextField.
     - Parameter didChange text: An optional String.
     */
    @objc
    optional func textField(textField: UITextField, didChange text: String?)

    /**
     A delegation method that is executed when the textField will clear.
     - Parameter textField: A UITextField.
     - Parameter willClear text: An optional String.
     */
    @objc
    optional func textField(textField: UITextField, willClear text: String?)
    
    /**
     A delegation method that is executed when the textField is cleared.
     - Parameter textField: A UITextField.
     - Parameter didClear text: An optional String.
     */
    @objc
    optional func textField(textField: UITextField, didClear text: String?)
}

open class TextField: UITextField {
    /// Will layout the view.
    open var willLayout: Bool {
        return 0 < width && 0 < height && nil != superview
    }
    
    /// Default size when using AutoLayout.
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 32)
    }
    
    /// A Boolean that indicates if the placeholder label is animated.
    @IBInspectable
    open var isPlaceholderAnimated = true
    
    /// A Boolean that indicates if the TextField is in an animating state.
	open internal(set) var isAnimating = false
	
    /// A boolean indicating whether the text is empty.
    open var isEmpty: Bool {
        return true == text?.isEmpty
    }
    
    open override var leftView: UIView? {
        didSet {
            prepareLeftView()
            layoutSubviews()
        }
    }
    
    /// The leftView width value.
    open var leftViewWidth: CGFloat {
        guard nil != leftView else {
            return 0
        }
        
        return leftViewOffset + height
    }
    
    /// The leftView width value.
    open var leftViewOffset: CGFloat = 16
    
    /// Placeholder normal text
    @IBInspectable
    open var leftViewNormalColor = Color.darkText.others {
        didSet {
            updateLeftViewColor()
        }
    }
    
    /// Placeholder active text
    @IBInspectable
    open var leftViewActiveColor = Color.blue.base {
        didSet {
            updateLeftViewColor()
        }
    }
    
    /// Divider normal height.
    @IBInspectable
    open var dividerNormalHeight: CGFloat = 1 {
        didSet {
            guard !isEditing else {
                return
            }
            
            dividerThickness = dividerNormalHeight
        }
    }
    
    
	/// Divider active height.
	@IBInspectable
    open var dividerActiveHeight: CGFloat = 2 {
        didSet {
            guard isEditing else {
                return
            }
            
            dividerThickness = dividerActiveHeight
        }
    }
	
	/// Divider normal color.
	@IBInspectable
    open var dividerNormalColor = Color.darkText.dividers {
        didSet {
            guard !isEditing else {
                return
            }
            
            dividerColor = dividerNormalColor
        }
    }
	
	/// Divider active color.
	@IBInspectable
    open var dividerActiveColor = Color.blue.base {
		didSet {
            guard isEditing else {
                return
            }
            
            dividerColor = dividerActiveColor
		}
	}
	
	/// The placeholderLabel font value.
	@IBInspectable
    open override var font: UIFont? {
		didSet {
			placeholderLabel.font = font
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
            layoutSubviews()
		}
	}
	
	/// The placeholder UILabel.
	@IBInspectable
    open fileprivate(set) var placeholderLabel = UILabel()
	
	/// Placeholder normal text
	@IBInspectable
    open var placeholderNormalColor = Color.darkText.others {
		didSet {
            updatePlaceholderLabelColor()
		}
	}
	
	/// Placeholder active text
	@IBInspectable
    open var placeholderActiveColor = Color.blue.base {
		didSet {
            updatePlaceholderLabelColor()
		}
	}
	
	/// This property adds a padding to placeholder y position animation
	@IBInspectable
    open var placeholderVerticalOffset: CGFloat = 0
	
	/// The detailLabel UILabel that is displayed.
	@IBInspectable
    open fileprivate(set) var detailLabel = UILabel()
	
	/// The detailLabel text value.
	@IBInspectable
    open var detail: String? {
		get {
			return detailLabel.text
		}
		set(value) {
			detailLabel.text = value
            layoutSubviews()
		}
	}
	
	/// Detail text
	@IBInspectable
    open var detailColor = Color.darkText.others {
		didSet {
            updateDetailLabelColor()
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
	
    /// A reference to the clearIconButton.
    open fileprivate(set) var clearIconButton: IconButton?
    
	/// Enables the clearIconButton.
	@IBInspectable
    open var isClearIconButtonEnabled: Bool {
		get {
			return nil != clearIconButton
		}
		set(value) {
            guard value else {
                clearIconButton?.removeTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
                clearIconButton = nil
                return
            }
            
            guard nil == clearIconButton else {
                return
            }
            
            clearIconButton = IconButton(image: Icon.cm.clear, tintColor: placeholderNormalColor)
            clearIconButton!.contentEdgeInsetsPreset = .none
            clearIconButton!.pulseAnimation = .none
            clearButtonMode = .never
            rightViewMode = .whileEditing
            rightView = clearIconButton
            isClearIconButtonAutoHandled = isClearIconButtonAutoHandled ? true : false
            
            layoutSubviews()
		}
	}
	
	/// Enables the automatic handling of the clearIconButton.
	@IBInspectable
    open var isClearIconButtonAutoHandled = true {
		didSet {
			clearIconButton?.removeTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
			
            guard isClearIconButtonAutoHandled else {
                return
			}
            
            clearIconButton?.addTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
		}
	}
    
    /// A reference to the visibilityIconButton.
    open fileprivate(set) var visibilityIconButton: IconButton?
	
	/// Enables the visibilityIconButton.
	@IBInspectable
    open var isVisibilityIconButtonEnabled: Bool {
		get {
			return nil != visibilityIconButton
		}
		set(value) {
            guard value else {
                visibilityIconButton?.removeTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
                visibilityIconButton = nil
                return
            }
            
            guard nil == visibilityIconButton else {
                return
            }
            
            visibilityIconButton = IconButton(image: Icon.visibility, tintColor: placeholderNormalColor.withAlphaComponent(isSecureTextEntry ? 0.38 : 0.54))
            visibilityIconButton!.contentEdgeInsetsPreset = .none
            visibilityIconButton!.pulseAnimation = .none
            isSecureTextEntry = true
            clearButtonMode = .never
            rightViewMode = .whileEditing
            rightView = visibilityIconButton
            isVisibilityIconButtonAutoHandled = isVisibilityIconButtonAutoHandled ? true : false
            
            layoutSubviews()
		}
	}
	
	/// Enables the automatic handling of the visibilityIconButton.
	@IBInspectable
    open var isVisibilityIconButtonAutoHandled: Bool = true {
		didSet {
			visibilityIconButton?.removeTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
			
            guard isVisibilityIconButtonAutoHandled else {
                return
			}
            
            visibilityIconButton?.addTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
		}
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
        reload()
	}
	
	open override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
        layoutShape()
	}
    
	/**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
	open func prepare() {
		clipsToBounds = false
		borderStyle = .none
		backgroundColor = nil
		contentScaleFactor = Screen.scale
        
        prepareDivider()
		preparePlaceholderLabel()
		prepareDetailLabel()
		prepareTargetHandlers()
        prepareTextAlignment()
	}
    
	/// Ensures that the components are sized correctly.
	open func reload() {
        guard willLayout && !isAnimating else {
            return
        }
        
        layoutPlaceholderLabel()
        layoutDetailLabel()
        layoutButton(button: clearIconButton)
        layoutButton(button: visibilityIconButton)
        layoutDivider()
        layoutLeftView()
    }
}

extension TextField {
    /// Prepares the divider.
    fileprivate func prepareDivider() {
        dividerColor = dividerNormalColor
    }
    
    /// Prepares the placeholderLabel.
    fileprivate func preparePlaceholderLabel() {
        font = RobotoFont.regular(with: 16)
        placeholderNormalColor = Color.darkText.others
        addSubview(placeholderLabel)
    }
    
    /// Prepares the detailLabel.
    fileprivate func prepareDetailLabel() {
        detailLabel.font = RobotoFont.regular(with: 12)
        detailLabel.numberOfLines = 0
        detailColor = Color.darkText.others
        addSubview(detailLabel)
    }
    
    /// Prepares the leftView.
    fileprivate func prepareLeftView() {
        leftView?.contentMode = .left
        updateLeftViewColor()
    }
    
    /// Prepares the target handlers.
    fileprivate func prepareTargetHandlers() {
        addTarget(self, action: #selector(handleEditingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
        addTarget(self, action: #selector(handleEditingDidEnd), for: .editingDidEnd)
    }
    
    /// Prepares the textAlignment.
    fileprivate func prepareTextAlignment() {
        textAlignment = .rightToLeft == Application.userInterfaceLayoutDirection ? .right : .left
    }
}

extension TextField {
    /// Updates the leftView tint color.
    fileprivate func updateLeftViewColor() {
        leftView?.tintColor = isEditing ? leftViewActiveColor : leftViewNormalColor
    }
    
    /// Updates the placeholderLabel text color.
    fileprivate func updatePlaceholderLabelColor() {
        tintColor = placeholderActiveColor
        placeholderLabel.textColor = isEditing ? placeholderActiveColor : placeholderNormalColor
    }
    
    /// Updates the detailLabel text color.
    fileprivate func updateDetailLabelColor() {
        detailLabel.textColor = detailColor
    }
}

extension TextField {
    /// Layout the placeholderLabel.
    fileprivate func layoutPlaceholderLabel() {
        let w = leftViewWidth
        let h = 0 == height ? intrinsicContentSize.height : height
        
        guard isEditing || !isEmpty || !isPlaceholderAnimated else {
            placeholderLabel.frame = CGRect(x: w, y: 0, width: width - w, height: h)
            return
        }
        
        placeholderLabel.transform = CGAffineTransform.identity
        placeholderLabel.frame = CGRect(x: w, y: 0, width: width - w, height: h)
        placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        switch textAlignment {
        case .left, .natural:
            placeholderLabel.x = w
        case .right:
            placeholderLabel.x = width - placeholderLabel.width
        default:break
        }
        
        placeholderLabel.y = -placeholderLabel.height + placeholderVerticalOffset
    }
    
    /// Layout the detailLabel.
    fileprivate func layoutDetailLabel() {
        let c = dividerContentEdgeInsets
        detailLabel.sizeToFit()
        detailLabel.x = c.left
        detailLabel.y = height + detailVerticalOffset
        detailLabel.width = width - c.left - c.right
    }
    
    /// Layout the a button.
    fileprivate func layoutButton(button: UIButton?) {
        guard 0 < width && 0 < height else {
            return
        }
        
        button?.frame = CGRect(x: width - height, y: 0, width: height, height: height)
    }
    
    /// Layout the divider.
    fileprivate func layoutDivider() {
        divider.reload()
    }
    
    /// Layout the leftView.
    fileprivate func layoutLeftView() {
        guard let v = leftView else {
            return
        }
        
        let w = leftViewWidth
        v.frame = CGRect(x: 0, y: 0, width: w, height: height)
        dividerContentEdgeInsets.left = w
    }
}

extension TextField {
    /// Handles the text editing did begin state.
    @objc
    fileprivate func handleEditingDidBegin() {
        leftViewEditingBeginAnimation()
        placeholderEditingDidBeginAnimation()
        dividerEditingDidBeginAnimation()
        
    }
    
    // Live updates the textField text.
    @objc
    fileprivate func handleEditingChanged(textField: UITextField) {
        (delegate as? TextFieldDelegate)?.textField?(textField: self, didChange: textField.text)
    }
    
    /// Handles the text editing did end state.
    @objc
    fileprivate func handleEditingDidEnd() {
        leftViewEditingEndAnimation()
        placeholderEditingDidEndAnimation()
        dividerEditingDidEndAnimation()
    }
    
    /// Handles the clearIconButton TouchUpInside event.
    @objc
    fileprivate func handleClearIconButton() {
        guard nil == delegate?.textFieldShouldClear || true == delegate?.textFieldShouldClear?(self) else {
            return
        }
        
        let t = text
        
        (delegate as? TextFieldDelegate)?.textField?(textField: self, willClear: t)
        
        text = nil
        
        (delegate as? TextFieldDelegate)?.textField?(textField: self, didClear: t)
    }
    
    /// Handles the visibilityIconButton TouchUpInside event.
    @objc
    fileprivate func handleVisibilityIconButton() {
        isSecureTextEntry = !isSecureTextEntry
        
        if !isSecureTextEntry {
            super.font = nil
            font = placeholderLabel.font
        }
        
        visibilityIconButton?.tintColor = visibilityIconButton?.tintColor.withAlphaComponent(isSecureTextEntry ? 0.38 : 0.54)
    }
}

extension TextField {
    /// The animation for leftView when editing begins.
    fileprivate func leftViewEditingBeginAnimation() {
        updateLeftViewColor()
    }
    
    /// The animation for leftView when editing ends.
    fileprivate func leftViewEditingEndAnimation() {
        updateLeftViewColor()
    }
    
    /// The animation for the divider when editing begins.
    fileprivate func dividerEditingDidBeginAnimation() {
        dividerThickness = dividerActiveHeight
        dividerColor = dividerActiveColor
    }
    
    /// The animation for the divider when editing ends.
    fileprivate func dividerEditingDidEndAnimation() {
        dividerThickness = dividerNormalHeight
        dividerColor = dividerNormalColor
    }
    
    /// The animation for the placeholder when editing begins.
    fileprivate func placeholderEditingDidBeginAnimation() {
        updatePlaceholderLabelColor()
        
        guard isPlaceholderAnimated else {
            return
        }
        
        guard isEmpty && !isAnimating else {
            return
        }
        
        isAnimating = true
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            guard let s = self else {
                return
            }
            
            s.placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            
            switch s.textAlignment {
            case .left, .natural:
                s.placeholderLabel.x = s.leftViewWidth
            case .right:
                s.placeholderLabel.x = s.width - s.placeholderLabel.width
            default:break
            }
            
            s.placeholderLabel.y = -s.placeholderLabel.height + s.placeholderVerticalOffset
        }) { [weak self] _ in
            self?.isAnimating = false
        }
    }
    
    /// The animation for the placeholder when editing ends.
    fileprivate func placeholderEditingDidEndAnimation() {
        updatePlaceholderLabelColor()
        
        guard isPlaceholderAnimated else {
            return
        }
        
        guard isEmpty && !isAnimating else {
            return
        }
        
        isAnimating = true
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            guard let s = self else {
                return
            }
            
            s.placeholderLabel.transform = CGAffineTransform.identity
            s.placeholderLabel.x = s.leftViewWidth
            s.placeholderLabel.y = 0
        }) { [weak self] _ in
            self?.isAnimating = false
        }
    }
}
