/*
* Copyright (C) 2015 - 20spacing, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
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

public class Menu {
	/// A Boolean that indicates if the menu is open or not.
	public private(set) var opened: Bool = false
	
	/// The rectangular bounds that the menu animates.
	public var origin: CGPoint {
		didSet {
			reloadLayout()
		}
	}
	
	/// The space between buttons.
	public var spacing: CGFloat {
		didSet {
			reloadLayout()
		}
	}
	
	/// Enables the animations for the Menu.
	public var enabled: Bool = true
	
	/// The direction in which the animation opens the menu.
	public var direction: MaterialDirection = .Up {
		didSet {
			reloadLayout()
		}
	}
	
	/// An Array of UIButtons.
	public var buttons: Array<UIButton>? {
		didSet {
			reloadLayout()
		}
	}
	
	/// Size of buttons, not including the first button.
	public var buttonSize: CGSize = CGSizeMake(48, 48)
	
	/// An Optional base button size.
	public var baseSize: CGSize?
	
	/**
	Initializer.
	- Parameter origin: The origin position of the Menu.
	- Parameter spacing: The spacing size between buttons.
	*/
	public init(origin: CGPoint, spacing: CGFloat = 16) {
		self.origin = origin
		self.spacing = spacing
	}
	
	/// Reload the button layout.
	public func reloadLayout() {
		opened = false
		layoutButtons()
	}
	
	/**
	Open the Menu component with animation options.
	- Parameter duration: The time for each button's animation.
	- Parameter delay: A delay time for each button's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each button's animation.
	- Parameter completion: A completion block to execute on each button's animation.
	*/
	public func open(duration duration: NSTimeInterval = 0.15, delay: NSTimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIViewAnimationOptions = [], animations: ((UIButton) -> Void)? = nil, completion: ((UIButton) -> Void)? = nil) {
		if enabled {
			disable()
			switch direction {
			case .Up:
				openUpAnimation(duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
			case .Down:
				openDownAnimation(duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
			case .Left:
				openLeftAnimation(duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
			case .Right:
				openRightAnimation(duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
			}
		}
	}
	
	/**
	Close the Menu component with animation options.
	- Parameter duration: The time for each button's animation.
	- Parameter delay: A delay time for each button's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each button's animation.
	- Parameter completion: A completion block to execute on each button's animation.
	*/
	public func close(duration duration: NSTimeInterval = 0.15, delay: NSTimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIViewAnimationOptions = [], animations: ((UIButton) -> Void)? = nil, completion: ((UIButton) -> Void)? = nil) {
		if enabled {
			disable()
			switch direction {
			case .Up:
				closeUpAnimation(duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
			case .Down:
				closeDownAnimation(duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
			case .Left:
				closeLeftAnimation(duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
			case .Right:
				closeRightAnimation(duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
			}
		}
	}
	
	/**
	Open the Menu component with animation options in the Up direction.
	- Parameter duration: The time for each button's animation.
	- Parameter delay: A delay time for each button's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each button's animation.
	- Parameter completion: A completion block to execute on each button's animation.
	*/
	private func openUpAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIButton) -> Void)?, completion: ((UIButton) -> Void)?) {
		if let v: Array<UIButton> = buttons {
			var base: UIButton?
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				if nil == base {
					base = v[0]
				}
				let button: UIButton = v[i]
				button.hidden = false
				
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						button.alpha = 1
						button.frame.origin.y = base!.frame.origin.y - CGFloat(i) * self.buttonSize.height - CGFloat(i) * self.spacing
						animations?(button)
					}, completion: { [unowned self] _ in
						completion?(button)
						self.enable(button)
					})
			}
			opened = true
		}
	}
	
	/**
	Close the Menu component with animation options in the Up direction.
	- Parameter duration: The time for each button's animation.
	- Parameter delay: A delay time for each button's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each button's animation.
	- Parameter completion: A completion block to execute on each button's animation.
	*/
	public func closeUpAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIButton) -> Void)?, completion: ((UIButton) -> Void)?) {
		if let v: Array<UIButton> = buttons {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let button: UIButton = v[i]
				
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						button.alpha = 0
						button.frame.origin.y = self.origin.y
						animations?(button)
					}, completion: { [unowned self] _ in
						button.hidden = true
						completion?(button)
						self.enable(button)
					})
			}
			opened = false
		}
	}
	
	/**
	Open the Menu component with animation options in the Down direction.
	- Parameter duration: The time for each button's animation.
	- Parameter delay: A delay time for each button's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each button's animation.
	- Parameter completion: A completion block to execute on each button's animation.
	*/
	private func openDownAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIButton) -> Void)?, completion: ((UIButton) -> Void)?) {
		if let v: Array<UIButton> = buttons {
			var base: UIButton?
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				if nil == base {
					base = v[0]
				}
				
				let button: UIButton = v[i]
				button.hidden = false
				
				let h: CGFloat = nil == baseSize ? buttonSize.height : baseSize!.height
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						button.alpha = 1
						button.frame.origin.y = base!.frame.origin.y + h + CGFloat(i - 1) * self.buttonSize.height + CGFloat(i) * self.spacing
						animations?(button)
					}, completion: { [unowned self] _ in
						completion?(button)
						self.enable(button)
					})
			}
			opened = true
		}
	}
	
	/**
	Close the Menu component with animation options in the Down direction.
	- Parameter duration: The time for each button's animation.
	- Parameter delay: A delay time for each button's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each button's animation.
	- Parameter completion: A completion block to execute on each button's animation.
	*/
	public func closeDownAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIButton) -> Void)?, completion: ((UIButton) -> Void)?) {
		if let v: Array<UIButton> = buttons {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let button: UIButton = v[i]
				
				let h: CGFloat = nil == baseSize ? buttonSize.height : baseSize!.height
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						button.alpha = 0
						button.frame.origin.y = self.origin.y + h
						animations?(button)
					}, completion: { [unowned self] _ in
						button.hidden = true
						completion?(button)
						self.enable(button)
					})
			}
			opened = false
		}
	}
	
	/**
	Open the Menu component with animation options in the Left direction.
	- Parameter duration: The time for each button's animation.
	- Parameter delay: A delay time for each button's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each button's animation.
	- Parameter completion: A completion block to execute on each button's animation.
	*/
	private func openLeftAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIButton) -> Void)?, completion: ((UIButton) -> Void)?) {
		if let v: Array<UIButton> = buttons {
			var base: UIButton?
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				if nil == base {
					base = v[0]
				}
				
				let button: UIButton = v[i]
				button.hidden = false
				
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						button.alpha = 1
						button.frame.origin.x = base!.frame.origin.x - CGFloat(i) * self.buttonSize.width - CGFloat(i) * self.spacing
						animations?(button)
					}, completion: { [unowned self] _ in
						completion?(button)
						self.enable(button)
					})
			}
			opened = true
		}
	}
	
	/**
	Close the Menu component with animation options in the Left direction.
	- Parameter duration: The time for each button's animation.
	- Parameter delay: A delay time for each button's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each button's animation.
	- Parameter completion: A completion block to execute on each button's animation.
	*/
	public func closeLeftAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIButton) -> Void)?, completion: ((UIButton) -> Void)?) {
		if let v: Array<UIButton> = buttons {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let button: UIButton = v[i]
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						button.alpha = 0
						button.frame.origin.x = self.origin.x
						animations?(button)
					}, completion: { [unowned self] _ in
						button.hidden = true
						completion?(button)
						self.enable(button)
					})
			}
			opened = false
		}
	}
	
	/**
	Open the Menu component with animation options in the Right direction.
	- Parameter duration: The time for each button's animation.
	- Parameter delay: A delay time for each button's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each button's animation.
	- Parameter completion: A completion block to execute on each button's animation.
	*/
	private func openRightAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIButton) -> Void)?, completion: ((UIButton) -> Void)?) {
		if let v: Array<UIButton> = buttons {
			var base: UIButton?
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				if nil == base {
					base = v[0]
				}
				let button: UIButton = v[i]
				button.hidden = false
				
				let h: CGFloat = nil == baseSize ? buttonSize.height : baseSize!.height
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						button.alpha = 1
						button.frame.origin.x = base!.frame.origin.x + h + CGFloat(i - 1) * self.buttonSize.width + CGFloat(i) * self.spacing
						animations?(button)
					}, completion: { [unowned self] _ in
						completion?(button)
						self.enable(button)
					})
			}
			opened = true
		}
	}
	
	/**
	Close the Menu component with animation options in the Right direction.
	- Parameter duration: The time for each button's animation.
	- Parameter delay: A delay time for each button's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each button's animation.
	- Parameter completion: A completion block to execute on each button's animation.
	*/
	public func closeRightAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIButton) -> Void)?, completion: ((UIButton) -> Void)?) {
		if let v: Array<UIButton> = buttons {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let button: UIButton = v[i]
				
				let w: CGFloat = nil == baseSize ? buttonSize.width : baseSize!.width
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						button.alpha = 0
						button.frame.origin.x = self.origin.x + w
						animations?(button)
					}, completion: { [unowned self] _ in
						button.hidden = true
						completion?(button)
						self.enable(button)
					})
			}
			opened = false
		}
	}
	
	/// Layout the buttons.
	private func layoutButtons() {
		if let v: Array<UIButton> = buttons {
			let size: CGSize = nil == baseSize ? buttonSize : baseSize!
			for var i: Int = 0, l: Int = v.count; i < l; ++i {
				let button: UIButton = v[i]
				if 0 == i {
					button.frame.size = size
					button.frame.origin = origin
					button.layer.zPosition = 10000
				} else {
					button.alpha = 0
					button.hidden = true
					button.frame.size = buttonSize
					button.frame.origin.x = origin.x + (size.width - buttonSize.width) / 2
					button.frame.origin.y = origin.y + (size.height - buttonSize.height) / 2
					button.layer.zPosition = CGFloat(10000 - i)
				}
			}
		}
	}
	
	/// Disable the Menu if buttons exist.
	private func disable() {
		if let _: Array<UIButton> = buttons {
			enabled = false
		}
	}
	
	/**
	Enable the Menu if the last button is equal to the passed in button.
	- Parameter button: UIButton that is passed in to compare.
	*/
	private func enable(button: UIButton) {
		if let v: Array<UIButton> = buttons {
			if button == v.last {
				enabled = true
			}
		}
	}
}