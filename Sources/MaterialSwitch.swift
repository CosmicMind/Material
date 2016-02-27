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

public protocol MaterialSwitchDelegate {
	/**
	A MaterialSwitch delegate method for state changes.
	- Parameter control: MaterialSwitch control.
	- Parameter state: The new state for the control.
	*/
	func materialSwitchStateChanged(control: MaterialSwitch)
}

public class MaterialSwitch: UIControl {
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
	public var x: CGFloat {
		get {
			return layer.frame.origin.x
		}
		set(value) {
			layer.frame.origin.x = value
		}
	}
	
	/// A property that accesses the layer.frame.origin.y property.
	public var y: CGFloat {
		get {
			return layer.frame.origin.y
		}
		set(value) {
			layer.frame.origin.y = value
		}
	}
	
	/// A property that accesses the layer.frame.origin.width property.
	public var width: CGFloat {
		get {
			return layer.frame.size.width
		}
		set(value) {
			layer.frame.size.width = value
		}
	}
	
	/// A property that accesses the layer.frame.origin.height property.
	public var height: CGFloat {
		get {
			return layer.frame.size.height
		}
		set(value) {
			layer.frame.size.height = value
		}
	}
	
	/// An Optional delegation method.
	public var delegate: MaterialSwitchDelegate?
	
	/// Indicates if the animation should bounce.
	public var bounceable: Bool = true {
		didSet {
			bounceOffset = bounceable ? 3 : 0
		}
	}
	
	/// Button on color.
	public var buttonOnColor: UIColor = MaterialColor.clear
	
	/// Button off color.
	public var buttonOffColor: UIColor = MaterialColor.clear
	
	/// Track on color.
	public var trackOnColor: UIColor = MaterialColor.clear
	
	/// Track off color.
	public var trackOffColor: UIColor = MaterialColor.clear
	
	/// Button on disabled color.
	public var buttonOnDisabledColor: UIColor = MaterialColor.clear
	
	/// Track on disabled color.
	public var trackOnDisabledColor: UIColor = MaterialColor.clear
	
	/// Button off disabled color.
	public var buttonOffDisabledColor: UIColor = MaterialColor.clear
	
	/// Track off disabled color.
	public var trackOffDisabledColor: UIColor = MaterialColor.clear
	
	/// Track view reference.
	public private(set) var trackLayer: MaterialLayer {
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
	
	public override var enabled: Bool {
		didSet {
			styleForState(internalSwitchState)
		}
	}
	
	public override var selected: Bool {
		get {
			return .On == internalSwitchState
		}
		set(value) {
			setOn(selected, animated: true)
		}
	}
	
	public override var highlighted: Bool {
		get {
			return .On == internalSwitchState
		}
		set(value) {
			setOn(highlighted, animated: true)
		}
	}
	
	public override var state: UIControlState {
		if enabled {
			return selected ? [.Selected, .Highlighted] : [.Normal]
		}
		return selected ? [.Selected, .Highlighted, .Disabled] : [.Normal, .Disabled]
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
	
	/// A boolean indicating if the switch is on or not.
	public var on: Bool {
		get {
			return .On == internalSwitchState
		}
		set(value) {
			setOn(on, animated: true)
		}
	}
	
	/// MaterialSwitch style.
	public var switchStyle: MaterialSwitchStyle = .Default {
		didSet {
			switch switchStyle {
			case .LightContent:
				buttonOnColor = MaterialColor.lightBlue.darken3
				trackOnColor = MaterialColor.lightBlue.lighten3
				buttonOffColor = MaterialColor.blueGrey.lighten4
				trackOffColor = MaterialColor.blueGrey.lighten3
				buttonOnDisabledColor = MaterialColor.grey.lighten2
				trackOnDisabledColor = MaterialColor.grey.lighten3
				buttonOffDisabledColor = MaterialColor.grey.lighten2
				trackOffDisabledColor = MaterialColor.grey.lighten3
			case .Default:
				buttonOnColor = MaterialColor.lightBlue.lighten1
				trackOnColor = MaterialColor.lightBlue.lighten2.colorWithAlphaComponent(0.5)
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
		trackLayer = MaterialLayer(frame: CGRectZero)
		button = FabButton(frame: CGRectZero)
		super.init(coder: aDecoder)
		prepareView()
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
		trackLayer = MaterialLayer(frame: CGRectZero)
		button = FabButton(frame: CGRectZero)
		super.init(frame: CGRectZero)
		prepareView()
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
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public func prepareView() {
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTapped:"))
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
		setSwitchState(on == true ? .On : .Off, animated: animated, completion: completion)
	}
	
	/**
	Set the switchState property with an option to animate.
	- Parameter state: The MaterialSwitchState to set.
	- Parameter animated: A Boolean indicating to set the animation or not.
	- Parameter completion: An Optional completion block.
	*/
	public func setSwitchState(state: MaterialSwitchState, animated: Bool = true, completion: ((control: MaterialSwitch) -> Void)? = nil) {
		if internalSwitchState != state {
			internalSwitchState = state
			if animated {
				animateToState(state) { [unowned self] _ in
					self.sendActionsForControlEvents(.ValueChanged)
					self.delegate?.materialSwitchStateChanged(self)
				}
			} else {
				button.x = .On == state ? self.onPosition : self.offPosition
				styleForState(state)
				sendActionsForControlEvents(.ValueChanged)
				delegate?.materialSwitchStateChanged(self)
				completion?(control: self)
			}
		}
	}
	
	/// Handles the tap gesture.
	internal func handleTapped(recognizer: UITapGestureRecognizer) {
		if true == CGRectContainsPoint(trackLayer.frame, layer.convertPoint(recognizer.locationInView(self), fromLayer: layer)) {
			setSwitchState(.On == internalSwitchState ? .Off : .On)
		}
	}
	
	/// Handles the TouchUpInside event.
	internal func handleTouchUpInside() {
		toggle()
	}
	
	/**
	Handle the TouchUpOutside and TouchCancel events.
	- Parameter sender: A UIButton.
	- Parameter event: A UIEvent.
	*/
	internal func handleTouchUpOutsideOrCanceled(sender: FabButton, event: UIEvent) {
		if let v: UITouch = event.touchesForView(sender)?.first {
			let t: CGPoint = v.previousLocationInView(sender)
			let p: CGPoint = v.locationInView(sender)
			let q: CGFloat = sender.x + p.x - t.x
			setSwitchState(q > (width - button.width) / 2 ? .On : .Off, animated: true)
		}
	}
	
	/**
	Handle the TouchDragInside event.
	- Parameter sender: A UIButton.
	- Parameter event: A UIEvent.
	*/
	internal func handleTouchDragInside(sender: FabButton, event: UIEvent) {
		if let v = event.touchesForView(sender)?.first {
			let t: CGPoint = v.previousLocationInView(sender)
			let p: CGPoint = v.locationInView(sender)
			let q: CGFloat = max(min(sender.x + (p.x - t.x), onPosition), offPosition)
			if q != sender.x {
				sender.x = q
			}
		}
	}
	
	/// Prepares the track.
	private func prepareTrack() {
		layer.addSublayer(trackLayer)
	}
	
	/// Prepares the button.
	private func prepareButton() {
		button.pulseColor = nil
		button.addTarget(self, action: "handleTouchUpOutsideOrCanceled:event:", forControlEvents: .TouchUpOutside)
		button.addTarget(self, action: "handleTouchUpInside", forControlEvents: .TouchUpInside)
		button.addTarget(self, action: "handleTouchDragInside:event:", forControlEvents: .TouchDragInside)
		button.addTarget(self, action: "handleTouchUpOutsideOrCanceled:event:", forControlEvents: .TouchCancel)
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
			updateColorForEnabledState(state)
		} else {
			updateColorForDisabledState(state)
		}
	}
	
	/**
	Updates the coloring for the enabled state.
	- Parameter state: MaterialSwitchState.
	*/
	private func updateColorForEnabledState(state: MaterialSwitchState) {
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
		trackLayer.cornerRadius = min(trackLayer.height, trackLayer.width) / 2
		
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
			animations: { [unowned self] in
				self.button.x = .On == state ? self.onPosition + self.bounceOffset : self.offPosition - self.bounceOffset
				self.styleForState(state)
			}) { [unowned self] _ in
				UIView.animateWithDuration(0.15,
					animations: { [unowned self] in
						self.button.x = .On == state ? self.onPosition : self.offPosition
					}) { [unowned self] _ in
						self.userInteractionEnabled = true
						completion?(control: self)
					}
			}
	}
}