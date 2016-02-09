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
	/// The rectangular bounds that the menu animates.
	public var origin: CGPoint
	
	/// The space between buttons.
	public var spacing: CGFloat
	
	/// A Boolean that indicates if the menu is open or not.
	public private(set) var opened: Bool = false
	
	/// Animation duration.
	public var duration: Double = 0.07
	
	/// The direction in which the animation opens the menu.
	public var direction: MaterialDirection = .Up
	
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
	
	public init(origin: CGPoint, spacing: CGFloat = 16) {
		self.origin = origin
		self.spacing = spacing
	}
	
	public func reloadLayout() {
		opened = false
		layoutButtons()
	}
	
	public func open(completion: ((UIButton) -> Void)? = nil) {
		switch direction {
		case .Up:
			openUpAnimation(completion)
		case .Down:
			openDownAnimation(completion)
		case .Left:
			openLeftAnimation(completion)
		case .Right:
			openRightAnimation(completion)
		}
	}
	
	public func close(completion: ((UIButton) -> Void)? = nil) {
		switch direction {
		case .Up:
			closeUpAnimation(completion)
		case .Down:
			closeDownAnimation(completion)
		case .Left:
			closeLeftAnimation(completion)
		case .Right:
			closeRightAnimation(completion)
		}
	}
	
	private func openUpAnimation(completion: ((UIButton) -> Void)? = nil) {
		if let v: Array<UIButton> = buttons {
			var base: UIButton?
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				if nil == base {
					base = v[0]
				}
				let button: UIButton = v[i]
				button.hidden = false
				UIView.animateWithDuration(Double(i) * duration,
					animations: { [unowned self] in
						button.alpha = 1
						button.frame.origin.y = base!.frame.origin.y - CGFloat(i) * self.buttonSize.height - CGFloat(i) * self.spacing
					},
					completion: { _ in
						completion?(button)
					})
			}
			opened = true
		}
	}
	
	public func closeUpAnimation(completion: ((UIButton) -> Void)? = nil) {
		if let v: Array<UIButton> = buttons {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let button: UIButton = v[i]
				UIView.animateWithDuration(Double(i) * duration,
					animations: { [unowned self] in
						button.alpha = 0
						button.frame.origin.y = self.origin.y
					},
					completion: { _ in
						button.hidden = true
						completion?(button)
					})
			}
			opened = false
		}
	}
	
	private func openDownAnimation(completion: ((UIButton) -> Void)? = nil) {
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
					animations: { [unowned self] in
						button.alpha = 1
						button.frame.origin.y = base!.frame.origin.y + h + CGFloat(i - 1) * self.buttonSize.height + CGFloat(i) * self.spacing
					},
					completion: { _ in
						completion?(button)
					})
			}
			opened = true
		}
	}
	
	public func closeDownAnimation(completion: ((UIButton) -> Void)? = nil) {
		if let v: Array<UIButton> = buttons {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let button: UIButton = v[i]
				
				let h: CGFloat = nil == baseSize ? buttonSize.height : baseSize!.height
				UIView.animateWithDuration(Double(i) * duration,
					animations: {
						button.alpha = 0
						button.frame.origin.y = self.origin.y + h
					},
					completion: { _ in
						button.hidden = true
						completion?(button)
					})
			}
			opened = false
		}
	}
	
	private func openLeftAnimation(completion: ((UIButton) -> Void)? = nil) {
		if let v: Array<UIButton> = buttons {
			var base: UIButton?
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				if nil == base {
					base = v[0]
				}
				let button: UIButton = v[i]
				button.hidden = false
				UIView.animateWithDuration(Double(i) * duration,
					animations: { [unowned self] in
						button.alpha = 1
						button.frame.origin.x = base!.frame.origin.x - CGFloat(i) * self.buttonSize.width - CGFloat(i) * self.spacing
					},
					completion: { _ in
						completion?(button)
					})
			}
			opened = true
		}
	}
	
	public func closeLeftAnimation(completion: ((UIButton) -> Void)? = nil) {
		if let v: Array<UIButton> = buttons {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let button: UIButton = v[i]
				UIView.animateWithDuration(Double(i) * duration,
					animations: { [unowned self] in
						button.alpha = 0
						button.frame.origin.x = self.origin.x
					},
					completion: { _ in
						button.hidden = true
						completion?(button)
					})
			}
			opened = false
		}
	}
	
	private func openRightAnimation(completion: ((UIButton) -> Void)? = nil) {
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
					animations: { [unowned self] in
						button.alpha = 1
						button.frame.origin.x = base!.frame.origin.x + h + CGFloat(i - 1) * self.buttonSize.width + CGFloat(i) * self.spacing
					},
					completion: { _ in
						completion?(button)
					})
			}
			opened = true
		}
	}
	
	public func closeRightAnimation(completion: ((UIButton) -> Void)? = nil) {
		if let v: Array<UIButton> = buttons {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let button: UIButton = v[i]
				
				let w: CGFloat = nil == baseSize ? buttonSize.width : baseSize!.width
				UIView.animateWithDuration(Double(i) * duration,
					animations: {
						button.alpha = 0
						button.frame.origin.x = self.origin.x + w
					},
					completion: { _ in
						button.hidden = true
						completion?(button)
					})
			}
			opened = false
		}
	}
	
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
}