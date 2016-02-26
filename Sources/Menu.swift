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

public enum MenuDirection {
	case Up
	case Down
	case Left
	case Right
}

public class Menu {
	/// A Boolean that indicates if the menu is open or not.
	public private(set) var opened: Bool = false
	
	/// The rectangular bounds that the menu animates.
	public var origin: CGPoint {
		didSet {
			reloadLayout()
		}
	}
	
	/// A preset wrapper around spacing.
	public var spacingPreset: MaterialSpacing = .None {
		didSet {
			spacing = MaterialSpacingToValue(spacingPreset)
		}
	}
	
	/// The space between views.
	public var spacing: CGFloat {
		didSet {
			reloadLayout()
		}
	}
	
	/// Enables the animations for the Menu.
	public var enabled: Bool = true
	
	/// The direction in which the animation opens the menu.
	public var direction: MenuDirection = .Up {
		didSet {
			reloadLayout()
		}
	}
	
	/// An Array of UIViews.
	public var views: Array<UIView>? {
		didSet {
			reloadLayout()
		}
	}
	
	/// Size of views, not including the first view.
	public var itemViewSize: CGSize = CGSizeMake(48, 48)
	
	/// An Optional base view size.
	public var baseViewSize: CGSize?
	
	/**
	Initializer.
	- Parameter origin: The origin position of the Menu.
	- Parameter spacing: The spacing size between views.
	*/
	public init(origin: CGPoint, spacing: CGFloat = 16) {
		self.origin = origin
		self.spacing = spacing
	}
	
	/// Reload the view layout.
	public func reloadLayout() {
		opened = false
		layoutButtons()
	}
	
	/**
	Open the Menu component with animation options.
	- Parameter duration: The time for each view's animation.
	- Parameter delay: A delay time for each view's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each view's animation.
	- Parameter completion: A completion block to execute on each view's animation.
	*/
	public func open(duration duration: NSTimeInterval = 0.15, delay: NSTimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIViewAnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
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
	- Parameter duration: The time for each view's animation.
	- Parameter delay: A delay time for each view's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each view's animation.
	- Parameter completion: A completion block to execute on each view's animation.
	*/
	public func close(duration duration: NSTimeInterval = 0.15, delay: NSTimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIViewAnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
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
	- Parameter duration: The time for each view's animation.
	- Parameter delay: A delay time for each view's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each view's animation.
	- Parameter completion: A completion block to execute on each view's animation.
	*/
	private func openUpAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v: Array<UIView> = views {
			var base: UIView?
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				if nil == base {
					base = v[0]
				}
				let view: UIView = v[i]
				view.hidden = false
				
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						view.alpha = 1
						view.frame.origin.y = base!.frame.origin.y - CGFloat(i) * self.itemViewSize.height - CGFloat(i) * self.spacing
						animations?(view)
					}) { [unowned self] _ in
						completion?(view)
						self.enable(view)
					}
			}
			opened = true
		}
	}
	
	/**
	Close the Menu component with animation options in the Up direction.
	- Parameter duration: The time for each view's animation.
	- Parameter delay: A delay time for each view's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each view's animation.
	- Parameter completion: A completion block to execute on each view's animation.
	*/
	public func closeUpAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v: Array<UIView> = views {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let view: UIView = v[i]
				
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						view.alpha = 0
						view.frame.origin.y = self.origin.y
						animations?(view)
					}) { [unowned self] _ in
						view.hidden = true
						completion?(view)
						self.enable(view)
					}
			}
			opened = false
		}
	}
	
	/**
	Open the Menu component with animation options in the Down direction.
	- Parameter duration: The time for each view's animation.
	- Parameter delay: A delay time for each view's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each view's animation.
	- Parameter completion: A completion block to execute on each view's animation.
	*/
	private func openDownAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v: Array<UIView> = views {
			var base: UIView?
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				if nil == base {
					base = v[0]
				}
				
				let view: UIView = v[i]
				view.hidden = false
				
				let h: CGFloat = nil == baseViewSize ? itemViewSize.height : baseViewSize!.height
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						view.alpha = 1
						view.frame.origin.y = base!.frame.origin.y + h + CGFloat(i - 1) * self.itemViewSize.height + CGFloat(i) * self.spacing
						animations?(view)
					}) { [unowned self] _ in
						completion?(view)
						self.enable(view)
					}
			}
			opened = true
		}
	}
	
	/**
	Close the Menu component with animation options in the Down direction.
	- Parameter duration: The time for each view's animation.
	- Parameter delay: A delay time for each view's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each view's animation.
	- Parameter completion: A completion block to execute on each view's animation.
	*/
	public func closeDownAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v: Array<UIView> = views {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let view: UIView = v[i]
				
				let h: CGFloat = nil == baseViewSize ? itemViewSize.height : baseViewSize!.height
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						view.alpha = 0
						view.frame.origin.y = self.origin.y + h
						animations?(view)
					}) { [unowned self] _ in
						view.hidden = true
						completion?(view)
						self.enable(view)
					}
			}
			opened = false
		}
	}
	
	/**
	Open the Menu component with animation options in the Left direction.
	- Parameter duration: The time for each view's animation.
	- Parameter delay: A delay time for each view's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each view's animation.
	- Parameter completion: A completion block to execute on each view's animation.
	*/
	private func openLeftAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v: Array<UIView> = views {
			var base: UIView?
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				if nil == base {
					base = v[0]
				}
				
				let view: UIView = v[i]
				view.hidden = false
				
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						view.alpha = 1
						view.frame.origin.x = base!.frame.origin.x - CGFloat(i) * self.itemViewSize.width - CGFloat(i) * self.spacing
						animations?(view)
					}) { [unowned self] _ in
						completion?(view)
						self.enable(view)
					}
			}
			opened = true
		}
	}
	
	/**
	Close the Menu component with animation options in the Left direction.
	- Parameter duration: The time for each view's animation.
	- Parameter delay: A delay time for each view's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each view's animation.
	- Parameter completion: A completion block to execute on each view's animation.
	*/
	public func closeLeftAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v: Array<UIView> = views {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let view: UIView = v[i]
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						view.alpha = 0
						view.frame.origin.x = self.origin.x
						animations?(view)
					}) { [unowned self] _ in
						view.hidden = true
						completion?(view)
						self.enable(view)
					}
			}
			opened = false
		}
	}
	
	/**
	Open the Menu component with animation options in the Right direction.
	- Parameter duration: The time for each view's animation.
	- Parameter delay: A delay time for each view's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each view's animation.
	- Parameter completion: A completion block to execute on each view's animation.
	*/
	private func openRightAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v: Array<UIView> = views {
			var base: UIView?
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				if nil == base {
					base = v[0]
				}
				let view: UIView = v[i]
				view.hidden = false
				
				let h: CGFloat = nil == baseViewSize ? itemViewSize.height : baseViewSize!.height
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						view.alpha = 1
						view.frame.origin.x = base!.frame.origin.x + h + CGFloat(i - 1) * self.itemViewSize.width + CGFloat(i) * self.spacing
						animations?(view)
					}) { [unowned self] _ in
						completion?(view)
						self.enable(view)
					}
			}
			opened = true
		}
	}
	
	/**
	Close the Menu component with animation options in the Right direction.
	- Parameter duration: The time for each view's animation.
	- Parameter delay: A delay time for each view's animation.
	- Parameter usingSpringWithDamping: A damping ratio for the animation.
	- Parameter initialSpringVelocity: The initial velocity for the animation.
	- Parameter options: Options to pass to the animation.
	- Parameter animations: An animation block to execute on each view's animation.
	- Parameter completion: A completion block to execute on each view's animation.
	*/
	public func closeRightAnimation(duration: NSTimeInterval, delay: NSTimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v: Array<UIView> = views {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let view: UIView = v[i]
				
				let w: CGFloat = nil == baseViewSize ? itemViewSize.width : baseViewSize!.width
				UIView.animateWithDuration(Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [unowned self] in
						view.alpha = 0
						view.frame.origin.x = self.origin.x + w
						animations?(view)
					}) { [unowned self] _ in
						view.hidden = true
						completion?(view)
						self.enable(view)
					}
			}
			opened = false
		}
	}
	
	/// Layout the views.
	private func layoutButtons() {
		if let v: Array<UIView> = views {
			let size: CGSize = nil == baseViewSize ? itemViewSize : baseViewSize!
			for var i: Int = 0, l: Int = v.count; i < l; ++i {
				let view: UIView = v[i]
				if 0 == i {
					view.frame.size = size
					view.frame.origin = origin
					view.layer.zPosition = 10000
				} else {
					view.alpha = 0
					view.hidden = true
					view.frame.size = itemViewSize
					view.frame.origin.x = origin.x + (size.width - itemViewSize.width) / 2
					view.frame.origin.y = origin.y + (size.height - itemViewSize.height) / 2
					view.layer.zPosition = CGFloat(10000 - v.count - i)
				}
			}
		}
	}
	
	/// Disable the Menu if views exist.
	private func disable() {
		if let v: Array<UIView> = views {
			if 0 < v.count {
				enabled = false
			}
		}
	}
	
	/**
	Enable the Menu if the last view is equal to the passed in view.
	- Parameter view: UIView that is passed in to compare.
	*/
	private func enable(view: UIView) {
		if let v: Array<UIView> = views {
			if view == v.last {
				enabled = true
			}
		}
	}
}