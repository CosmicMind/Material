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
	case Light
	case Dark
}

public enum MaterialSwitchState {
	case On
	case Off
}

public enum MaterialSwitchSize {
	case Small
	case Normal
	case Large
}

public protocol MaterialSwitchDelegate {
	func materialSwitchStateChanged(control: MaterialSwitch, state: MaterialSwitchState)
}

public class MaterialSwitch: UIControl {
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
	
	public override var enabled: Bool {
		didSet {
			
		}
	}
	
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
	public private(set) var track: MaterialView {
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
	
	/// MaterialSwitch state.
	public var switchState: MaterialSwitchState = .Off {
		didSet {
			setSwitchState(switchState, animated: false)
		}
	}
	
	/// MaterialSwitch style.
	public var switchStyle: MaterialSwitchStyle = .Light {
		didSet {
			switch switchStyle {
			case .Light:
				buttonOnColor = MaterialColor.blue.lighten3
				buttonOffColor = MaterialColor.grey.lighten3
				trackOnColor = MaterialColor.blue.lighten3
				trackOffColor = MaterialColor.grey.lighten1
				buttonOnDisabledColor = MaterialColor.blue.darken1
				trackOnDisabledColor = MaterialColor.grey.darken4
				buttonOffDisabledColor = MaterialColor.blue.darken1
				trackOffDisabledColor = MaterialColor.grey.darken4
			case .Dark:
				buttonOnColor = MaterialColor.blueGrey.base
				buttonOffColor = MaterialColor.grey.base
				trackOnColor = MaterialColor.blueGrey.darken1
				trackOffColor = MaterialColor.grey.darken3
				buttonOnDisabledColor = MaterialColor.blueGrey.darken1
				trackOnDisabledColor = MaterialColor.grey.darken4
				buttonOffDisabledColor = MaterialColor.blueGrey.darken1
				trackOffDisabledColor = MaterialColor.grey.darken4
			}
		}
	}
	
	/// MaterialSwitch size.
	public var switchSize: MaterialSwitchSize = .Normal {
		didSet {
			switch switchSize {
			case .Small:
				frame = CGRectMake(0, 0, 30, 25)
				trackThickness = 13
				buttonDiameter = 18
			case .Normal:
				frame = CGRectMake(0, 0, 40, 30)
				trackThickness = 17
				buttonDiameter = 24
			case .Large:
				frame = CGRectMake(0, 0, 50, 40)
				trackThickness = 23
				buttonDiameter = 31
			}
			
			track.frame = CGRectMake(0, (height - trackThickness) / 2, width, trackThickness)
			track.cornerRadius = min(track.height, track.width) / 2
			
			button.frame = CGRectMake(0, (height - buttonDiameter) / 2, buttonDiameter, buttonDiameter)
			onPosition = width - buttonDiameter
			offPosition = 0
		}
	}
	
	/**
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		track = MaterialView(frame: CGRectZero)
		button = FabButton(frame: CGRectZero)
		super.init(coder: aDecoder)
		prepareTrack()
		prepareButton()
		prepareSwitchSize(.Normal)
		prepareSwitchStyle(.Light)
		prepareSwitchState(.Off)
	}
	
	/**
	An initializer that sets the state, style, and size of the MaterialSwitch instance.
	- Parameter state: A MaterialSwitchState value.
	- Parameter style: A MaterialSwitchStyle value.
	- Parameter size: A MaterialSwitchSize value.
	*/
	public init(state: MaterialSwitchState = .On, style: MaterialSwitchStyle = .Light, size: MaterialSwitchSize = .Normal) {
		track = MaterialView(frame: CGRectZero)
		button = FabButton(frame: CGRectZero)
		super.init(frame: CGRectZero)
		prepareTrack()
		prepareButton()
		prepareSwitchSize(size)
		prepareSwitchStyle(style)
		prepareSwitchState(state)
	}

	public override func willMoveToSuperview(newSuperview: UIView?) {
		super.willMoveToSuperview(newSuperview)
		styleForState(switchState)
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public func prepareView() {
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTapped"))
	}
	
	/**
	Toggle the MaterialSwitch state, if On will be Off, and if Off will be On.
	- Parameter completion: An Optional completion block.
	*/
	public func toggle(completion: ((control: MaterialSwitch) -> Void)? = nil) {
		setSwitchState(.On == switchState ? .Off : .On, animated: true, completion: completion)
	}
	
	/**
	Set the switchState property with an option to animate.
	- Parameter state: The MaterialSwitchState to set.
	- Parameter animated: A Boolean indicating to set the animation or not.
	- Parameter completion: An Optional completion block.
	*/
	public func setSwitchState(state: MaterialSwitchState, animated: Bool = true, completion: ((control: MaterialSwitch) -> Void)? = nil) {
		func t() {
			button.x = .On == state ? onPosition + bounceOffset : offPosition - bounceOffset
			styleForState(state)
		}
		
		func c() {
			if switchState != state {
				sendActionsForControlEvents(.ValueChanged)
				switchState = state
				delegate?.materialSwitchStateChanged(self, state: state)
			}
		}
		
		if animated {
			userInteractionEnabled = false
			UIView.animateWithDuration(0.15,
				delay: 0.05,
				options: .CurveEaseInOut,
				animations: {
					t()
				}) { [unowned self] _ in
					c()
					UIView.animateWithDuration(0.15,
						animations: { [unowned self] in
							self.button.x = .On == state ? self.onPosition : self.offPosition
						}) { [unowned self] _ in
							self.userInteractionEnabled = true
							completion?(control: self)
						}
				}
		} else {
			t()
			c()
			completion?(control: self)
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
	
	/**
	Handle the TouchDown event.
	- Parameter sender: A UIButton.
	*/
	internal func handleTouchDown(sender: UIButton) {
		
	}
	
	/// Prepares the track.
	private func prepareTrack() {
		addSubview(track)
	}
	
	/// Prepares the button.
	private func prepareButton() {
		button.pulseColor = nil
		button.addTarget(self, action: "handleTouchDown:", forControlEvents: .TouchDown)
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
		switchState = state
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
			track.backgroundColor = trackOnColor
		} else {
			button.backgroundColor = buttonOffColor
			track.backgroundColor = trackOffColor
		}
	}
	
	/**
	Updates the coloring for the disabled state.
	- Parameter state: MaterialSwitchState.
	*/
	private func updateColorForDisabledState(state: MaterialSwitchState) {
		if .On == state {
			button.backgroundColor = buttonOnDisabledColor
			track.backgroundColor = buttonOnDisabledColor
		} else {
			button.backgroundColor = buttonOffDisabledColor
			track.backgroundColor = buttonOffDisabledColor
		}
	}
}
