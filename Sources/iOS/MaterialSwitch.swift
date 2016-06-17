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

public enum MaterialSwitchStyle {
	case LightContent
	case Default
}

public enum MaterialSwitchState {
	case On
	case Off
}

public enum MaterialSwitchSize {
	case Small
	case Default
	case Large
}

@objc(MaterialSwitchDelegate)
public protocol MaterialSwitchDelegate {
	/**
	A MaterialSwitch delegate method for state changes.
	- Parameter control: MaterialSwitch control.
	*/
	func materialSwitchStateChanged(control: MaterialSwitch)
}

@objc(MaterialSwitch)
@IBDesignable
public class MaterialSwitch : UIControl {
	/// An internal reference to the switchState public property.
	private var internalSwitchState: MaterialSwitchState = .Off
	
	/// Track thickness.
	private var trackThickness: CGFloat = 0
	
	/// Button diameter.
	private var buttonDiameter: CGFloat = 0
	
	/// Position when in the .On state.
	private var onPosition: CGFloat = 0
	
	/// Position when in the .Off state.
	private var offPosition: CGFloat = 0
	
	/// The bounce offset when animating.
	private var bounceOffset: CGFloat = 3
	
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
	
	/// An Optional delegation method.
	public weak var delegate: MaterialSwitchDelegate?
	
	/// Indicates if the animation should bounce.
	@IBInspectable public var bounceable: Bool = true {
		didSet {
			bounceOffset = bounceable ? 3 : 0
		}
	}
	
	/// Button on color.
	@IBInspectable public var buttonOnColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
		}
	}
	
	/// Button off color.
	@IBInspectable public var buttonOffColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
		}
	}
	
	/// Track on color.
	@IBInspectable public var trackOnColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
		}
	}
	
	/// Track off color.
	@IBInspectable public var trackOffColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
		}
	}
	
	/// Button on disabled color.
	@IBInspectable public var buttonOnDisabledColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
		}
	}
	
	/// Track on disabled color.
	@IBInspectable public var trackOnDisabledColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
		}
	}
	
	/// Button off disabled color.
	@IBInspectable public var buttonOffDisabledColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
		}
	}
	
	/// Track off disabled color.
	@IBInspectable public var trackOffDisabledColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
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
	
	@IBInspectable public override var enabled: Bool {
		didSet {
			styleForState(internalSwitchState)
		}
	}
	
	/// A boolean indicating if the switch is on or not.
	@IBInspectable public var on: Bool {
		get {
			return .On == internalSwitchState
		}
		set(value) {
			setOn(value, animated: true)
		}
	}

	/// MaterialSwitch state.
	public var switchState: MaterialSwitchState {
		get {
			return internalSwitchState
		}
		set(value) {
			if value != internalSwitchState {
				internalSwitchState = value
			}
		}
	}
	
	/// MaterialSwitch style.
	public var switchStyle: MaterialSwitchStyle = .Default {
		didSet {
			switch switchStyle {
			case .LightContent:
				buttonOnColor = MaterialColor.blue.darken2
				trackOnColor = MaterialColor.blue.lighten3
				buttonOffColor = MaterialColor.blueGrey.lighten4
				trackOffColor = MaterialColor.blueGrey.lighten3
				buttonOnDisabledColor = MaterialColor.grey.lighten2
				trackOnDisabledColor = MaterialColor.grey.lighten3
				buttonOffDisabledColor = MaterialColor.grey.lighten2
				trackOffDisabledColor = MaterialColor.grey.lighten3
			case .Default:
				buttonOnColor = MaterialColor.blue.lighten1
				trackOnColor = MaterialColor.blue.lighten2.colorWithAlphaComponent(0.5)
				buttonOffColor = MaterialColor.blueGrey.lighten3
				trackOffColor = MaterialColor.blueGrey.lighten4.colorWithAlphaComponent(0.5)
				buttonOnDisabledColor = MaterialColor.grey.darken3
				trackOnDisabledColor = MaterialColor.grey.lighten1.colorWithAlphaComponent(0.2)
				buttonOffDisabledColor = MaterialColor.grey.darken3
				trackOffDisabledColor = MaterialColor.grey.lighten1.colorWithAlphaComponent(0.2)
			}
		}
	}
	
	/// MaterialSwitch size.
	public var switchSize: MaterialSwitchSize = .Default {
		didSet {
			switch switchSize {
			case .Small:
				trackThickness = 13
				buttonDiameter = 18
				frame = CGRectMake(0, 0, 30, 25)
			case .Default:
				trackThickness = 17
				buttonDiameter = 24
				frame = CGRectMake(0, 0, 40, 30)
			case .Large:
				trackThickness = 23
				buttonDiameter = 31
				frame = CGRectMake(0, 0, 50, 40)
			}
		}
	}
	
	public override var frame: CGRect {
		didSet {
			layoutSwitch()
		}
	}
	
	public override var bounds: CGRect {
		didSet {
			layoutSwitch()
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
		prepareSwitchSize(.Default)
		prepareSwitchStyle(.LightContent)
		prepareSwitchState(.Off)
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
		prepareSwitchSize(.Default)
		prepareSwitchStyle(.LightContent)
		prepareSwitchState(.Off)
	}
	
	/**
	An initializer that sets the state, style, and size of the MaterialSwitch instance.
	- Parameter state: A MaterialSwitchState value.
	- Parameter style: A MaterialSwitchStyle value.
	- Parameter size: A MaterialSwitchSize value.
	*/
	public init(state: MaterialSwitchState = .Off, style: MaterialSwitchStyle = .Default, size: MaterialSwitchSize = .Default) {
		trackLayer = CAShapeLayer()
		button = FabButton()
		super.init(frame: CGRectNull)
		prepareTrack()
		prepareButton()
		prepareSwitchSize(size)
		prepareSwitchStyle(style)
		prepareSwitchState(state)
	}
	
	public override func willMoveToSuperview(newSuperview: UIView?) {
		super.willMoveToSuperview(newSuperview)
		styleForState(internalSwitchState)
	}
	
	public override func intrinsicContentSize() -> CGSize {
		switch switchSize {
		case .Small:
			return CGSizeMake(30, 25)
		case .Default:
			return CGSizeMake(40, 30)
		case .Large:
			return CGSizeMake(50, 40)
		}
	}
	
	/**
	Toggle the MaterialSwitch state, if On will be Off, and if Off will be On.
	- Parameter completion: An Optional completion block.
	*/
	public func toggle(completion: ((control: MaterialSwitch) -> Void)? = nil) {
		setSwitchState(.On == internalSwitchState ? .Off : .On, animated: true, completion: completion)
	}
	
	/**
	Sets the switch on or off.
	- Parameter on: A bool of whether the switch should be in the on state or not.
	- Parameter animated: A Boolean indicating to set the animation or not.
	*/
	public func setOn(on: Bool, animated: Bool, completion: ((control: MaterialSwitch) -> Void)? = nil) {
		setSwitchState(on ? .On : .Off, animated: animated, completion: completion)
	}
	
	/**
	Set the switchState property with an option to animate.
	- Parameter state: The MaterialSwitchState to set.
	- Parameter animated: A Boolean indicating to set the animation or not.
	- Parameter completion: An Optional completion block.
	*/
	public func setSwitchState(state: MaterialSwitchState, animated: Bool = true, completion: ((control: MaterialSwitch) -> Void)? = nil) {
		if enabled && internalSwitchState != state {
			internalSwitchState = state
			if animated {
				animateToState(state) { [weak self] _ in
					if let s: MaterialSwitch = self {
						s.sendActionsForControlEvents(.ValueChanged)
						completion?(control: s)
						s.delegate?.materialSwitchStateChanged(s)
					}
				}
			} else {
				button.x = .On == state ? self.onPosition : self.offPosition
				styleForState(state)
				sendActionsForControlEvents(.ValueChanged)
				completion?(control: self)
				delegate?.materialSwitchStateChanged(self)
			}
		}
	}
	
	/**
	Handle the TouchUpOutside and TouchCancel events.
	- Parameter sender: A UIButton.
	- Parameter event: A UIEvent.
	*/
	@objc(handleTouchUpOutsideOrCanceled:event:)
	internal func handleTouchUpOutsideOrCanceled(sender: FabButton, event: UIEvent) {
		if let v: UITouch = event.touchesForView(sender)?.first {
			let q: CGFloat = sender.x + v.locationInView(sender).x - v.previousLocationInView(sender).x
			setSwitchState(q > (width - button.width) / 2 ? .On : .Off, animated: true)
		}
	}
	
	/// Handles the TouchUpInside event.
	internal func handleTouchUpInside() {
		toggle()
	}
	
	/**
	Handle the TouchDragInside event.
	- Parameter sender: A UIButton.
	- Parameter event: A UIEvent.
	*/
	@objc(handleTouchDragInside:event:)
	internal func handleTouchDragInside(sender: FabButton, event: UIEvent) {
		if let v = event.touchesForView(sender)?.first {
			let q: CGFloat = max(min(sender.x + v.locationInView(sender).x - v.previousLocationInView(sender).x, onPosition), offPosition)
			if q != sender.x {
				sender.x = q
			}
		}
	}
	
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if true == CGRectContainsPoint(trackLayer.frame, layer.convertPoint(touches.first!.locationInView(self), fromLayer: layer)) {
			setOn(.On != internalSwitchState, animated: true)
		}
	}
	
	/// Prepares the track.
	private func prepareTrack() {
		layer.addSublayer(trackLayer)
	}
	
	/// Prepares the button.
	private func prepareButton() {
		button.pulseAnimation = .None
		button.addTarget(self, action: #selector(handleTouchUpInside), forControlEvents: .TouchUpInside)
		button.addTarget(self, action: #selector(handleTouchDragInside), forControlEvents: .TouchDragInside)
		button.addTarget(self, action: #selector(handleTouchUpOutsideOrCanceled), forControlEvents: .TouchCancel)
		button.addTarget(self, action: #selector(handleTouchUpOutsideOrCanceled), forControlEvents: .TouchUpOutside)
		addSubview(button)
	}
	
	/**
	Prepares the switchState property. This is used mainly to allow
	init to set the state value and have an effect.
	- Parameter state: The MaterialSwitchState to set.
	*/
	private func prepareSwitchState(state: MaterialSwitchState) {
		setSwitchState(state, animated: false)
	}
	
	/**
	Prepares the switchStyle property. This is used mainly to allow
	init to set the state value and have an effect.
	- Parameter style: The MaterialSwitchStyle to set.
	*/
	private func prepareSwitchStyle(style: MaterialSwitchStyle) {
		switchStyle = style
	}
	
	/**
	Prepares the switchSize property. This is used mainly to allow
	init to set the size value and have an effect.
	- Parameter size: The MaterialSwitchSize to set.
	*/
	private func prepareSwitchSize(size: MaterialSwitchSize) {
		switchSize = size
	}
	
	/**
	Updates the style based on the state.
	- Parameter state: The MaterialSwitchState to set the style to.
	*/
	private func styleForState(state: MaterialSwitchState) {
		if enabled {
			updateColorForState(state)
		} else {
			updateColorForDisabledState(state)
		}
	}
	
	/**
	Updates the coloring for the enabled state.
	- Parameter state: MaterialSwitchState.
	*/
	private func updateColorForState(state: MaterialSwitchState) {
		if .On == state {
			button.backgroundColor = buttonOnColor
			trackLayer.backgroundColor = trackOnColor.CGColor
		} else {
			button.backgroundColor = buttonOffColor
			trackLayer.backgroundColor = trackOffColor.CGColor
		}
	}
	
	/**
	Updates the coloring for the disabled state.
	- Parameter state: MaterialSwitchState.
	*/
	private func updateColorForDisabledState(state: MaterialSwitchState) {
		if .On == state {
			button.backgroundColor = buttonOnDisabledColor
			trackLayer.backgroundColor = trackOnDisabledColor.CGColor
		} else {
			button.backgroundColor = buttonOffDisabledColor
			trackLayer.backgroundColor = trackOffDisabledColor.CGColor
		}
	}
	
	/// Laout the button and track views.
	private func layoutSwitch() {
		var w: CGFloat = 0
		switch switchSize {
		case .Small:
			w = 30
		case .Default:
			w = 40
		case .Large:
			w = 50
		}
		
		let px: CGFloat = (width - w) / 2
		
		trackLayer.frame = CGRectMake(px, (height - trackThickness) / 2, w, trackThickness)
		trackLayer.cornerRadius = min(trackLayer.frame.height, trackLayer.frame.width) / 2
		
		button.frame = CGRectMake(px, (height - buttonDiameter) / 2, buttonDiameter, buttonDiameter)
		onPosition = width - px - buttonDiameter
		offPosition = px
		
		if .On == internalSwitchState {
			button.x = onPosition
		}
	}
	
	/**
	Set the switchState property with an animate.
	- Parameter state: The MaterialSwitchState to set.
	- Parameter completion: An Optional completion block.
	*/
	private func animateToState(state: MaterialSwitchState, completion: ((control: MaterialSwitch) -> Void)? = nil) {
		userInteractionEnabled = false
		UIView.animateWithDuration(0.15,
			delay: 0.05,
			options: .CurveEaseInOut,
			animations: { [weak self] in
				if let s: MaterialSwitch = self {
					s.button.x = .On == state ? s.onPosition + s.bounceOffset : s.offPosition - s.bounceOffset
					s.styleForState(state)
				}
			}) { [weak self] _ in
				UIView.animateWithDuration(0.15,
					animations: { [weak self] in
						if let s: MaterialSwitch = self {
							s.button.x = .On == state ? s.onPosition : s.offPosition
						}
					}) { [weak self] _ in
						if let s: MaterialSwitch = self {
							s.userInteractionEnabled = true
							completion?(control: s)
						}
					}
			}
	}
}