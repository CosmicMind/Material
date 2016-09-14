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
     */
	func switchStateChanged(control: Switch)
}

@objc(Switch)
open class Switch: UIControl {
	/// An internal reference to the switchState public property.
	private var internalSwitchState: SwitchState = .off
	
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
    public var bounceable = true {
		didSet {
			bounceOffset = bounceable ? 3 : 0
		}
	}
	
	/// Button on color.
	@IBInspectable
    public var buttonOnColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Button off color.
	@IBInspectable
    public var buttonOffColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Track on color.
	@IBInspectable
    public var trackOnColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Track off color.
	@IBInspectable
    public var trackOffColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Button on disabled color.
	@IBInspectable
    public var buttonOnDisabledColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Track on disabled color.
	@IBInspectable
    public var trackOnDisabledColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Button off disabled color.
	@IBInspectable
    public var buttonOffDisabledColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Track off disabled color.
	@IBInspectable
    public var trackOffDisabledColor = Color.clear {
		didSet {
			styleForState(state: switchState)
		}
	}
	
	/// Track view reference.
	public private(set) var trackLayer: CAShapeLayer {
		didSet {
			prepareTrack()
		}
	}
	
	/// Button view reference.
	public private(set) var button: FabButton {
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
	public var switchStyle: SwitchStyle = .dark {
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
	public var switchSize: SwitchSize = .medium {
		didSet {
			switch switchSize {
			case .small:
				trackThickness = 13
				buttonDiameter = 18
                frame = CGRect(x: 0, y: 0, width: 30, height: 25)
			case .medium:
				trackThickness = 17
				buttonDiameter = 24
                frame = CGRect(x: 0, y: 0, width: 40, height: 30)
			case .large:
				trackThickness = 23
				buttonDiameter = 31
                frame = CGRect(x: 0, y: 0, width: 50, height: 40)
			}
		}
	}
	
	open override var frame: CGRect {
		didSet {
			layoutSwitch()
		}
	}
	
	open override var bounds: CGRect {
		didSet {
			layoutSwitch()
		}
	}
    
    open override var intrinsicContentSize: CGSize {
        switch switchSize {
        case .small:
            return CGSize(width: 30, height: 25)
        case .medium:
            return CGSize(width: 40, height: 30)
        case .large:
            return CGSize(width: 50, height: 40)
        }
    }
	
	/**
     An initializer that initializes the object with a NSCoder object.
     - Parameter aDecoder: A NSCoder instance.
     */
	public required init?(coder aDecoder: NSCoder) {
		trackLayer = CAShapeLayer()
		button = FabButton()
		super.init(coder: aDecoder)
		prepareTrack()
		prepareButton()
		prepareSwitchSize(size: .medium)
		prepareSwitchStyle(style: .light)
		prepareSwitchState(state: .off)
	}
	
	/**
     An initializer that initializes the object with a CGRect object.
     If AutoLayout is used, it is better to initilize the instance
     using the init(state:style:size:) initializer, or set the CGRect
     to CGRectNull.
     - Parameter frame: A CGRect instance.
     */
	public override init(frame: CGRect) {
		trackLayer = CAShapeLayer()
		button = FabButton()
		super.init(frame: frame)
		prepareTrack()
		prepareButton()
		prepareSwitchSize(size: .medium)
		prepareSwitchStyle(style: .light)
		prepareSwitchState(state: .off)
	}
	
	/**
     An initializer that sets the state, style, and size of the Switch instance.
     - Parameter state: A SwitchState value.
     - Parameter style: A SwitchStyle value.
     - Parameter size: A SwitchSize value.
     */
	public init(state: SwitchState = .off, style: SwitchStyle = .dark, size: SwitchSize = .medium) {
		trackLayer = CAShapeLayer()
		button = FabButton()
		super.init(frame: CGRect.null)
		prepareTrack()
		prepareButton()
		prepareSwitchSize(size: size)
        prepareSwitchStyle(style: style)
        prepareSwitchState(state: state)
	}
	
	open override func willMove(toSuperview newSuperview: UIView?) {
		super.willMove(toSuperview: newSuperview)
		styleForState(state: internalSwitchState)
	}
	
	/**
     Toggle the Switch state, if On will be Off, and if Off will be On.
     - Parameter completion: An Optional completion block.
     */
	public func toggle(completion: ((Switch) -> Void)? = nil) {
		setSwitchState(state: .on == internalSwitchState ? .off : .on, animated: true, completion: completion)
	}
	
	/**
     Sets the switch on or off.
     - Parameter on: A bool of whether the switch should be in the on state or not.
     - Parameter animated: A Boolean indicating to set the animation or not.
     */
	public func setOn(on: Bool, animated: Bool, completion: ((Switch) -> Void)? = nil) {
		setSwitchState(state: on ? .on : .off, animated: animated, completion: completion)
	}
	
	/**
     Set the switchState property with an option to animate.
     - Parameter state: The SwitchState to set.
     - Parameter animated: A Boolean indicating to set the animation or not.
     - Parameter completion: An Optional completion block.
     */
	public func setSwitchState(state: SwitchState, animated: Bool = true, completion: ((Switch) -> Void)? = nil) {
		if isEnabled && internalSwitchState != state {
			internalSwitchState = state
			if animated {
                animateToState(state: state) { [weak self] _ in
					if let s: Switch = self {
						s.sendActions(for: .valueChanged)
						completion?(s)
						s.delegate?.switchStateChanged(control: s)
					}
				}
			} else {
				button.x = .on == state ? self.onPosition : self.offPosition
				styleForState(state: state)
				sendActions(for: .valueChanged)
				completion?(self)
				delegate?.switchStateChanged(control: self)
			}
		}
	}
	
	/**
     Handle the TouchUpOutside and TouchCancel events.
     - Parameter sender: A UIButton.
     - Parameter event: A UIEvent.
     */
	@objc
	internal func handleTouchUpOutsideOrCanceled(sender: FabButton, event: UIEvent) {
		if let v: UITouch = event.touches(for: sender)?.first {
			let q: CGFloat = sender.x + v.location(in: sender).x - v.previousLocation(in: sender).x
			setSwitchState(state: q > (width - button.width) / 2 ? .on : .off, animated: true)
		}
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
		if let v = event.touches(for: sender)?.first {
			let q: CGFloat = max(min(sender.x + v.location(in: sender).x - v.previousLocation(in: sender).x, onPosition), offPosition)
			if q != sender.x {
				sender.x = q
			}
		}
	}
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if true == trackLayer.frame.contains(layer.convert(touches.first!.location(in: self), from: layer)) {
			setOn(on: .on != internalSwitchState, animated: true)
		}
	}
	
	/// Prepares the track.
	private func prepareTrack() {
		layer.addSublayer(trackLayer)
	}
	
	/// Prepares the button.
	private func prepareButton() {
		button.pulseAnimation = .none
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
	private func prepareSwitchState(state: SwitchState) {
		setSwitchState(state: state, animated: false)
	}
	
	/**
     Prepares the switchStyle property. This is used mainly to allow
     init to set the state value and have an effect.
     - Parameter style: The SwitchStyle to set.
     */
	private func prepareSwitchStyle(style: SwitchStyle) {
		switchStyle = style
	}
	
	/**
     Prepares the switchSize property. This is used mainly to allow
     init to set the size value and have an effect.
     - Parameter size: The SwitchSize to set.
     */
	private func prepareSwitchSize(size: SwitchSize) {
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
			trackLayer.backgroundColor = trackOnColor.cgColor
		} else {
			button.backgroundColor = buttonOffColor
			trackLayer.backgroundColor = trackOffColor.cgColor
		}
	}
	
	/**
     Updates the coloring for the disabled state.
     - Parameter state: SwitchState.
     */
	private func updateColorForDisabledState(state: SwitchState) {
		if .on == state {
			button.backgroundColor = buttonOnDisabledColor
			trackLayer.backgroundColor = trackOnDisabledColor.cgColor
		} else {
			button.backgroundColor = buttonOffDisabledColor
			trackLayer.backgroundColor = trackOffDisabledColor.cgColor
		}
	}
	
	/// Laout the button and track views.
	private func layoutSwitch() {
		var w: CGFloat = 0
		switch switchSize {
		case .small:
			w = 30
		case .medium:
			w = 40
		case .large:
			w = 50
		}
		
		let px: CGFloat = (width - w) / 2
		
        trackLayer.frame = CGRect(x: px, y: (height - trackThickness) / 2, width: w, height: trackThickness)
		trackLayer.cornerRadius = min(trackLayer.frame.height, trackLayer.frame.width) / 2
		
        button.frame = CGRect(x: px, y: (height - buttonDiameter) / 2, width: buttonDiameter, height: buttonDiameter)
		onPosition = width - px - buttonDiameter
		offPosition = px
		
		if .on == internalSwitchState {
			button.x = onPosition
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
				if let s: Switch = self {
					s.button.x = .on == state ? s.onPosition + s.bounceOffset : s.offPosition - s.bounceOffset
					s.styleForState(state: state)
				}
			}) { [weak self] _ in
				UIView.animate(withDuration: 0.15,
					animations: { [weak self] in
						if let s: Switch = self {
							s.button.x = .on == state ? s.onPosition : s.offPosition
						}
					}) { [weak self] _ in
						if let s: Switch = self {
							s.isUserInteractionEnabled = true
							completion?(s)
						}
					}
			}
	}
}
