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

@objc(MenuDirection)
public enum MenuDirection: Int {
    case up
    case down
    case left
    case right
}

public class Menu {
	/// A Boolean that indicates if the menu is open or not.
	public private(set) var isOpened = false

	/// The rectangular bounds that the menu animates.
	public var origin: CGPoint {
		didSet {
			reload()
		}
	}

	/// A preset wrapper around interimSpace.
	public var interimSpacePreset: InterimSpacePreset = .none {
		didSet {
            interimSpace = InterimSpacePresetToValue(preset: interimSpacePreset)
		}
	}

	/// The space between views.
	public var interimSpace: InterimSpace {
		didSet {
			reload()
		}
	}

	/// Enables the animations for the Menu.
	public var isEnabled = true

	/// The direction in which the animation opens the menu.
	public var direction: MenuDirection = .up {
		didSet {
			reload()
		}
	}

	/// An Array of UIViews.
	public var views: [UIView]? {
		didSet {
			reload()
		}
	}

	/// Size of views, not including the first view.
    public var itemSize: CGSize = CGSize(width: 48, height: 48)

	/// An Optional base view size.
	public var baseSize: CGSize?

	/**
	Initializer.
	- Parameter origin: The origin position of the Menu.
	- Parameter interimSpace: The interimSpace size between views.
	*/
	public init(origin: CGPoint, interimSpace: InterimSpace = 16) {
		self.origin = origin
		self.interimSpace = interimSpace
	}
	
	/// Convenience initializer.
	public convenience init() {
		self.init(origin: CGPoint.zero)
	}

	/// Reload the view layout.
	public func reload() {
		isOpened = false
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
	public func open(duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIViewAnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
		if isEnabled {
			disable()
			switch direction {
			case .up:
				openUpAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
			case .down:
				openDownAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
			case .left:
				openLeftAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
			case .right:
				openRightAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
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
	public func close(duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIViewAnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
		if isEnabled {
			disable()
			switch direction {
			case .up:
				closeUpAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
			case .down:
				closeDownAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
			case .left:
				closeLeftAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
			case .right:
				closeRightAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
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
	private func openUpAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v = views {
			var base: UIView?
			for i in 1..<v.count {
				if nil == base {
					base = v[0]
				}
				let view: UIView = v[i]
				view.isHidden = false

				UIView.animate(withDuration: Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [weak self] in
						if let s: Menu = self {
							view.alpha = 1
							view.frame.origin.y = base!.frame.origin.y - CGFloat(i) * s.itemSize.height - CGFloat(i) * s.interimSpace
							animations?(view)
						}
					}) { [weak self] _ in
						if let s: Menu = self {
							s.enable(view: view)
							if view == v.last {
								s.isOpened = true
							}
							completion?(view)
						}
					}
			}
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
	public func closeUpAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v = views {
			for i in 1..<v.count {
				let view: UIView = v[i]

				UIView.animate(withDuration: Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [weak self] in
						if let s: Menu = self {
							view.alpha = 0
							view.frame.origin.y = s.origin.y
							animations?(view)
						}
					}) { [weak self] _ in
						if let s: Menu = self {
							view.isHidden = true
							s.enable(view: view)
							if view == v.last {
								s.isOpened = false
							}
							completion?(view)
						}
					}
			}
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
	private func openDownAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v = views {
			var base: UIView?
			for i in 1..<v.count {
				if nil == base {
					base = v[0]
				}

				let view: UIView = v[i]
				view.isHidden = false

				let h: CGFloat = nil == baseSize ? itemSize.height : baseSize!.height
				UIView.animate(withDuration: Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [weak self] in
						if let s: Menu = self {
							view.alpha = 1
							view.frame.origin.y = base!.frame.origin.y + h + CGFloat(i - 1) * s.itemSize.height + CGFloat(i) * s.interimSpace
							animations?(view)
						}
					}) { [weak self] _ in
						if let s: Menu = self {
							s.enable(view: view)
							if view == v.last {
								s.isOpened = true
							}
							completion?(view)
						}
					}
			}
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
	public func closeDownAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v = views {
			for i in 1..<v.count {
				let view: UIView = v[i]

				let h: CGFloat = nil == baseSize ? itemSize.height : baseSize!.height
				UIView.animate(withDuration: Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [weak self] in
						if let s: Menu = self {
							view.alpha = 0
							view.frame.origin.y = s.origin.y + h
							animations?(view)
						}
					}) { [weak self] _ in
						if let s: Menu = self {
							view.isHidden = true
							s.enable(view: view)
							if view == v.last {
								s.isOpened = false
							}
							completion?(view)
						}
					}
			}
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
	private func openLeftAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v = views {
			var base: UIView?
			for i in 1..<v.count {
				if nil == base {
					base = v[0]
				}

				let view: UIView = v[i]
				view.isHidden = false

				UIView.animate(withDuration: Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [weak self] in
						if let s: Menu = self {
							view.alpha = 1
							view.frame.origin.x = base!.frame.origin.x - CGFloat(i) * s.itemSize.width - CGFloat(i) * s.interimSpace
							animations?(view)
						}
					}) { [weak self] _ in
						if let s: Menu = self {
							s.enable(view: view)
							if view == v.last {
								s.isOpened = true
							}
							completion?(view)
						}
					}
			}
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
	public func closeLeftAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v = views {
			for i in 1..<v.count {
				let view: UIView = v[i]
				UIView.animate(withDuration: Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [weak self] in
						if let s: Menu = self {
							view.alpha = 0
							view.frame.origin.x = s.origin.x
							animations?(view)
						}
					}) { [weak self] _ in
						if let s: Menu = self {
							view.isHidden = true
							s.enable(view: view)
							if view == v.last {
								s.isOpened = false
							}
							completion?(view)
						}
					}
			}
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
	private func openRightAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v = views {
			var base: UIView?
			for i in 1..<v.count {
				if nil == base {
					base = v[0]
				}
				let view: UIView = v[i]
				view.isHidden = false

				let h: CGFloat = nil == baseSize ? itemSize.height : baseSize!.height
				UIView.animate(withDuration: Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [weak self] in
						if let s: Menu = self {
							view.alpha = 1
							view.frame.origin.x = base!.frame.origin.x + h + CGFloat(i - 1) * s.itemSize.width + CGFloat(i) * s.interimSpace
							animations?(view)
						}
					}) { [weak self] _ in
						if let s: Menu = self {
							s.enable(view: view)
							if view == v.last {
								s.isOpened = true
							}
							completion?(view)
						}
					}
			}
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
	public func closeRightAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
		if let v = views {
			for i in 1..<v.count {
				let view: UIView = v[i]
				
				let w: CGFloat = nil == baseSize ? itemSize.width : baseSize!.width
				UIView.animate(withDuration: Double(i) * duration,
					delay: delay,
					usingSpringWithDamping: usingSpringWithDamping,
					initialSpringVelocity: initialSpringVelocity,
					options: options,
					animations: { [weak self] in
						if let s: Menu = self {
							view.alpha = 0
							view.frame.origin.x = s.origin.x + w
							animations?(view)
						}
					}) { [weak self] _ in
						if let s: Menu = self {
							view.isHidden = true
							s.enable(view: view)
							if view == v.last {
								s.isOpened = false
							}
							completion?(view)
						}
					}
			}
		}
	}

	/// Layout the views.
	private func layoutButtons() {
		if let v = views {
			let size: CGSize = nil == baseSize ? itemSize : baseSize!
			for i in 0..<v.count {
				let view: UIView = v[i]
				if 0 == i {
					view.frame.size = size
					view.frame.origin = origin
					view.layer.zPosition = 10000
				} else {
					view.alpha = 0
					view.isHidden = true
					view.frame.size = itemSize
					view.frame.origin.x = origin.x + (size.width - itemSize.width) / 2
					view.frame.origin.y = origin.y + (size.height - itemSize.height) / 2
					view.layer.zPosition = CGFloat(10000 - v.count - i)
				}
			}
		}
	}

	/// Disable the Menu if views exist.
	private func disable() {
		if let v = views {
			if 0 < v.count {
				isEnabled = false
			}
		}
	}

	/**
	Enable the Menu if the last view is equal to the passed in view.
	- Parameter view: UIView that is passed in to compare.
	*/
	private func enable(view: UIView) {
		if let v = views {
			if view == v.last {
				isEnabled = true
			}
		}
	}
}
