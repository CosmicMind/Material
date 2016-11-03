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

@objc(SwitchStyle)
public enum SwitchStyle: Int {
	case light
	case dark
}

@objc(SwitchState)
public enum SwitchState: Int {
	case on
	case off
}

@objc(SwitchSize)
public enum SwitchSize: Int {
	case small
	case medium
	case large
}

@objc(SwitchDelegate)
public protocol SwitchDelegate {
	/**
     A Switch delegate method for state changes.
     - Parameter control: Switch control.
     - Parameter state: SwitchState value.
     */
    func switchDidChangeState(control: Switch, state: SwitchState)
}

open class Switch: UIControl {
    /// Will layout the view.
    open var willLayout: Bool {
        return 0 < width && 0 < height && nil != superview
    }
    
    /// An internal reference to the switchState public property.
	private var internalSwitchState = SwitchState.off
	
	/// Track thickness.
	private var trackThickness: CGFloat = 0
	
	/// Button diameter.
	private var buttonDiameter: CGFloat = 0
	
	/// Position when in the .on state.
	private var onPosition: CGFloat = 0
	
	/// Position when in the .off state.
	private var offPosition: CGFloat = 0
	
	/// The bounce offset when animating.
	private var bounceOffset: CGFloat = 3
		
	/// An Optional delegation method.
	open weak var delegate: SwitchDelegate?
	
	/// Indicates if the animation should bounce.
	@IBInspectable
    open var bounceable = true {
		didSet {
			bounceOffset = bounceable ? 3 : 0
		}
	}
	
	/// Button on color.
	@IBInspectable
    open var buttonOnColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Button off color.
	@IBInspectable
    open var buttonOffColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Track on color.
	@IBInspectable
    open var trackOnColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Track off color.
	@IBInspectable
    open var trackOffColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Button on disabled color.
	@IBInspectable
    open var buttonOnDisabledColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Track on disabled color.
	@IBInspectable
    open var trackOnDisabledColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Button off disabled color.
	@IBInspectable
    open var buttonOffDisabledColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Track off disabled color.
	@IBInspectable
    open var trackOffDisabledColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Track view reference.
	open private(set) var track: UIView {
		didSet {
			prepareTrack()
		}
	}
	
	/// Button view reference.
	open private(set) var button: FabButton {
		didSet {
			prepareButton()
		}
	}
	
	@IBInspectable
    open override var isEnabled: Bool {
		didSet {
			styleForState(state: internalSwitchState)
		}
	}
	
	/// A boolean indicating if the switch is on or not.
	@IBInspectable
    public var on: Bool {
		get {
			return .on == internalSwitchState
		}
		set(value) {
			setOn(on: value, animated: true)
		}
	}

	/// Switch state.
	public var switchState: SwitchState {
		get {
			return internalSwitchState
		}
		set(value) {
			if value != internalSwitchState {
				internalSwitchState = value
			}
		}
	}
	
	/// Switch style.
	public var switchStyle = SwitchStyle.dark {
		didSet {
			switch switchStyle {
			case .light:
				buttonOnColor = Color.blue.darken2
				trackOnColor = Color.blue.lighten3
				buttonOffColor = Color.blueGrey.lighten4
				trackOffColor = Color.grey.lighten3
				buttonOnDisabledColor = Color.grey.lighten2
				trackOnDisabledColor = Color.grey.lighten3
				buttonOffDisabledColor = Color.grey.lighten2
				trackOffDisabledColor = Color.grey.lighten3
			case .dark:
				buttonOnColor = Color.blue.lighten1
				trackOnColor = Color.blue.lighten2.withAlphaComponent(0.5)
				buttonOffColor = Color.grey.lighten3
				trackOffColor = Color.blueGrey.lighten4.withAlphaComponent(0.5)
				buttonOnDisabledColor = Color.grey.darken3
				trackOnDisabledColor = Color.grey.lighten1.withAlphaComponent(0.2)
				buttonOffDisabledColor = Color.grey.darken3
				trackOffDisabledColor = Color.grey.lighten1.withAlphaComponent(0.2)
			}
		}
	}
	
	/// Switch size.
	public var switchSize = SwitchSize.medium {
		didSet {
			switch switchSize {
			case .small:
				trackThickness = 12
				buttonDiameter = 18
			case .medium:
				trackThickness = 18
				buttonDiameter = 24
			case .large:
				trackThickness = 24
				buttonDiameter = 32
			}
            
            frame.size = intrinsicContentSize
		}
	}
	
    open override var intrinsicContentSize: CGSize {
        switch switchSize {
        case .small:
            return CGSize(width: 24, height: 24)
        case .medium:
            return CGSize(width: 30, height: 30)
        case .large:
            return CGSize(width: 36, height: 36)
        }
    }
	
	/**
     An initializer that initializes the object with a NSCoder object.
     - Parameter aDecoder: A NSCoder instance.
     */
	public required init?(coder aDecoder: NSCoder) {
		track = UIView()
		button = FabButton()
		super.init(coder: aDecoder)
		prepare()
	}
	
	/**
     An initializer that initializes the object with a CGRect object.
     If AutoLayout is used, it is better to initilize the instance
     using the init(state:style:size:) initializer, or set the CGRect
     to CGRectNull.
     - Parameter frame: A CGRect instance.
     */
	public override init(frame: CGRect) {
		track = UIView()
		button = FabButton()
		super.init(frame: frame)
		prepare()
	}
	
	/**
     An initializer that sets the state, style, and size of the Switch instance.
     - Parameter state: A SwitchState value.
     - Parameter style: A SwitchStyle value.
     - Parameter size: A SwitchSize value.
     */
	public init(state: SwitchState = .off, style: SwitchStyle = .dark, size: SwitchSize = .medium) {
		track = UIView()
		button = FabButton()
		super.init(frame: .zero)
        prepare()
        prepareSwitchState(state: state)
        prepareSwitchStyle(style: style)
        prepareSwitchSize(size: size)
	}
	
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard willLayout else {
            return
        }
        
        reload()
    }
    
	open override func willMove(toSuperview newSuperview: UIView?) {
		super.willMove(toSuperview: newSuperview)
		styleForState(state: internalSwitchState)
	}
	
	/**
     Toggle the Switch state, if On will be Off, and if Off will be On.
     - Parameter completion: An Optional completion block.
     */
	open func toggle(completion: ((Switch) -> Void)? = nil) {
		setSwitchState(state: .on == internalSwitchState ? .off : .on, animated: true, completion: completion)
	}
	
	/**
     Sets the switch on or off.
     - Parameter on: A bool of whether the switch should be in the on state or not.
     - Parameter animated: A Boolean indicating to set the animation or not.
     */
	open func setOn(on: Bool, animated: Bool, completion: ((Switch) -> Void)? = nil) {
		setSwitchState(state: on ? .on : .off, animated: animated, completion: completion)
	}
	
	/**
     Set the switchState property with an option to animate.
     - Parameter state: The SwitchState to set.
     - Parameter animated: A Boolean indicating to set the animation or not.
     - Parameter completion: An Optional completion block.
     */
	open func setSwitchState(state: SwitchState, animated: Bool = true, completion: ((Switch) -> Void)? = nil) {
        guard isEnabled && internalSwitchState != state else {
            return
        }
        
        internalSwitchState = state
        
        if animated {
            animateToState(state: state) { [weak self] _ in
                guard let s = self else {
                    return
                }
                
                s.sendActions(for: .valueChanged)
                completion?(s)
                s.delegate?.switchDidChangeState(control: s, state: s.internalSwitchState)
            }
        } else {
            button.x = .on == state ? self.onPosition : self.offPosition
            styleForState(state: state)
            sendActions(for: .valueChanged)
            completion?(self)
            delegate?.switchDidChangeState(control: self, state: internalSwitchState)
        }
	}
	
	/**
     Handle the TouchUpOutside and TouchCancel events.
     - Parameter sender: A UIButton.
     - Parameter event: A UIEvent.
     */
	@objc
	internal func handleTouchUpOutsideOrCanceled(sender: FabButton, event: UIEvent) {
		guard let v = event.touches(for: sender)?.first else {
            return
        }
        
        let q: CGFloat = sender.x + v.location(in: sender).x - v.previousLocation(in: sender).x
        setSwitchState(state: q > (width - button.width) / 2 ? .on : .off, animated: true)
	}
	
	/// Handles the TouchUpInside event.
	@objc
    internal func handleTouchUpInside() {
		toggle()
	}
	
	/**
     Handle the TouchDragInside event.
     - Parameter sender: A UIButton.
     - Parameter event: A UIEvent.
     */
	@objc
	internal func handleTouchDragInside(sender: FabButton, event: UIEvent) {
        guard let v = event.touches(for: sender)?.first else {
            return
        }
        
        let q: CGFloat = max(min(sender.x + v.location(in: sender).x - v.previousLocation(in: sender).x, onPosition), offPosition)
        	
        guard q != sender.x else {
            return
        }
        
        sender.x = q
	}
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard track.frame.contains(layer.convert(touches.first!.location(in: self), from: layer)) else {
            return
        }
        
        setOn(on: .on != internalSwitchState, animated: true)
	}
    
    /**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
    open func prepare() {
        contentScaleFactor = Device.scale
        prepareTrack()
        prepareButton()
        prepareSwitchState()
        prepareSwitchStyle()
        prepareSwitchSize()
    }
    
    /// Reloads the view.
    open func reload() {
        let w: CGFloat = intrinsicContentSize.width
        let px: CGFloat = (width - w) / 2
        
        track.frame = CGRect(x: px, y: (height - trackThickness) / 2, width: w, height: trackThickness)
        track.cornerRadius = min(w, trackThickness) / 2
        
        button.frame = CGRect(x: px, y: (height - buttonDiameter) / 2, width: buttonDiameter, height: buttonDiameter)
        onPosition = width - px - buttonDiameter
        offPosition = px
        
        if .on == internalSwitchState {
            button.x = onPosition
        }
    }
	
	/// Prepares the track.
	private func prepareTrack() {
		addSubview(track)
	}
	
	/// Prepares the button.
	private func prepareButton() {
		button.addTarget(self, action: #selector(handleTouchUpInside), for: .touchUpInside)
		button.addTarget(self, action: #selector(handleTouchDragInside), for: .touchDragInside)
		button.addTarget(self, action: #selector(handleTouchUpOutsideOrCanceled), for: .touchCancel)
		button.addTarget(self, action: #selector(handleTouchUpOutsideOrCanceled), for: .touchUpOutside)
		addSubview(button)
	}
	
	/**
     Prepares the switchState property. This is used mainly to allow
     init to set the state value and have an effect.
     - Parameter state: The SwitchState to set.
     */
	private func prepareSwitchState(state: SwitchState = .off) {
		setSwitchState(state: state, animated: false)
	}
	
	/**
     Prepares the switchStyle property. This is used mainly to allow
     init to set the state value and have an effect.
     - Parameter style: The SwitchStyle to set.
     */
	private func prepareSwitchStyle(style: SwitchStyle = .light) {
		switchStyle = style
	}
	
	/**
     Prepares the switchSize property. This is used mainly to allow
     init to set the size value and have an effect.
     - Parameter size: The SwitchSize to set.
     */
	private func prepareSwitchSize(size: SwitchSize = .medium) {
		switchSize = size
	}
	
	/**
     Updates the style based on the state.
     - Parameter state: The SwitchState to set the style to.
     */
	private func styleForState(state: SwitchState) {
		if isEnabled {
            updateColorForState(state: state)
		} else {
			updateColorForDisabledState(state: state)
		}
	}
	
	/**
     Updates the coloring for the enabled state.
     - Parameter state: SwitchState.
     */
	private func updateColorForState(state: SwitchState) {
		if .on == state {
			button.backgroundColor = buttonOnColor
			track.backgroundColor = trackOnColor
		} else {
			button.backgroundColor = buttonOffColor
			track.backgroundColor = trackOffColor
		}
	}
	
	/**
     Updates the coloring for the disabled state.
     - Parameter state: SwitchState.
     */
	private func updateColorForDisabledState(state: SwitchState) {
		if .on == state {
			button.backgroundColor = buttonOnDisabledColor
			track.backgroundColor = trackOnDisabledColor
		} else {
			button.backgroundColor = buttonOffDisabledColor
			track.backgroundColor = trackOffDisabledColor
		}
	}
	
	/**
     Set the switchState property with an animate.
     - Parameter state: The SwitchState to set.
     - Parameter completion: An Optional completion block.
     */
	private func animateToState(state: SwitchState, completion: ((Switch) -> Void)? = nil) {
		isUserInteractionEnabled = false
		UIView.animate(withDuration: 0.15,
			delay: 0.05,
			options: [.curveEaseIn, .curveEaseOut],
			animations: { [weak self] in
                guard let s = self else {
                    return
                }
                
                s.button.x = .on == state ? s.onPosition + s.bounceOffset : s.offPosition - s.bounceOffset
                s.styleForState(state: state)
			}) { [weak self] _ in
				UIView.animate(withDuration: 0.15,
					animations: { [weak self] in
                        guard let s = self else {
                            return
                        }
                        
                        s.button.x = .on == state ? s.onPosition : s.offPosition
					}) { [weak self] _ in
                        guard let s = self else {
                            return
                        }
                        
                        s.isUserInteractionEnabled = true
                        completion?(s)
					}
			}
	}
}
