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

public enum MenuLayoutDirection {
	case Up
	case Down
	case Left
	case Right
}

public enum MenuLayoutPosition {
	case TopLeft
	case TopRight
	case BottomLeft
	case BottomRight
}

public struct MenuLayoutItem {
	/// UIButton.
	public var button: UIButton
	
	/// Title UILabel.
	public var titleLabel: UILabel?
	
	public init(button: UIButton, titleLabel: UILabel? = nil) {
		self.button = button
		self.titleLabel = titleLabel
	}
}

public class MenuLayout {
	public var width: CGFloat = UIScreen.mainScreen().bounds.width
	public var height: CGFloat = UIScreen.mainScreen().bounds.height
	
	/// A Boolean that indicates if the menu is open or not.
	public private(set) var opened: Bool = false
	
	/// Animation duration.
	public var duration: Double = 0.07
	
	/// The position of the menu. 
	public var position: MenuLayoutPosition = .BottomRight {
		didSet {
			reloadLayout()
		}
	}
	
	/// The direction in which the animation opens the menu.
	public var direction: MenuLayoutDirection = .Up
	
	/// An Array of MenuLayoutItems.
	public var items: Array<MenuLayoutItem>? {
		didSet {
			reloadLayout()
		}
	}
	
	public var itemSize: CGSize = CGSizeMake(48, 48)
	
	public var baseSize: CGSize = CGSizeMake(56, 56)
	
	public init() {
		
	}
	
	public func reloadLayout() {
		opened = false
		switch position {
		case .TopLeft:
			layoutTopLeft()
		case .TopRight:
			layoutTopRight()
		case .BottomLeft:
			layoutBottomLeft()
		case .BottomRight:
			layoutBottomRight()
		}
	}
	
	public func open(completion: ((MenuLayoutItem) -> Void)? = nil) {
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
	
	public func close(completion: ((MenuLayoutItem) -> Void)? = nil) {
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
	
	private func openUpAnimation(completion: ((MenuLayoutItem) -> Void)? = nil) {
		if let v: Array<MenuLayoutItem> = items {
			var base: MenuLayoutItem?
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				if nil == base {
					base = v[0]
				}
				let item: MenuLayoutItem = v[i]
				item.button.hidden = false
				UIView.animateWithDuration(Double(i) * duration,
					animations: { [unowned self] in
						item.button.alpha = 1
						item.button.frame.origin.y = base!.button.frame.origin.y - CGFloat(i) * self.itemSize.height - CGFloat(i) * 16
					},
					completion: { _ in
						completion?(item)
					})
			}
			opened = true
		}
	}
	
	public func closeUpAnimation(completion: ((MenuLayoutItem) -> Void)? = nil) {
		if let v: Array<MenuLayoutItem> = items {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let item: MenuLayoutItem = v[i]
				UIView.animateWithDuration(Double(i) * duration,
					animations: { [unowned self] in
						item.button.alpha = 0
						item.button.frame.origin.y = self.height - item.button.bounds.height - 16
					},
					completion: { _ in
						item.button.hidden = true
						completion?(item)
					})
			}
			opened = false
		}
	}
	
	private func openDownAnimation(completion: ((MenuLayoutItem) -> Void)? = nil) {
		if let v: Array<MenuLayoutItem> = items {
			var base: MenuLayoutItem?
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				if nil == base {
					base = v[0]
				}
				let item: MenuLayoutItem = v[i]
				item.button.hidden = false
				UIView.animateWithDuration(Double(i) * duration,
					animations: { [unowned self] in
						item.button.alpha = 1
						item.button.frame.origin.y = base!.button.frame.origin.y + self.baseSize.height + CGFloat(i - 1) * self.itemSize.height + CGFloat(i) * 16
					},
					completion: { _ in
						completion?(item)
					})
			}
			opened = true
		}
	}
	
	public func closeDownAnimation(completion: ((MenuLayoutItem) -> Void)? = nil) {
		if let v: Array<MenuLayoutItem> = items {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let item: MenuLayoutItem = v[i]
				UIView.animateWithDuration(Double(i) * duration,
					animations: {
						item.button.alpha = 0
						item.button.frame.origin.y = 16
					},
					completion: { _ in
						item.button.hidden = true
						completion?(item)
					})
			}
			opened = false
		}
	}
	
	private func openLeftAnimation(completion: ((MenuLayoutItem) -> Void)? = nil) {
		if let v: Array<MenuLayoutItem> = items {
			var base: MenuLayoutItem?
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				if nil == base {
					base = v[0]
				}
				let item: MenuLayoutItem = v[i]
				item.button.hidden = false
				UIView.animateWithDuration(Double(i) * duration,
					animations: { [unowned self] in
						item.button.alpha = 1
						item.button.frame.origin.x = base!.button.frame.origin.x - CGFloat(i) * self.itemSize.width - CGFloat(i) * 16
					},
					completion: { _ in
						completion?(item)
					})
			}
			opened = true
		}
	}
	
	public func closeLeftAnimation(completion: ((MenuLayoutItem) -> Void)? = nil) {
		if let v: Array<MenuLayoutItem> = items {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let item: MenuLayoutItem = v[i]
				UIView.animateWithDuration(Double(i) * duration,
					animations: { [unowned self] in
						item.button.alpha = 0
						item.button.frame.origin.x = self.width - item.button.bounds.width - 16
					},
					completion: { _ in
						item.button.hidden = true
						completion?(item)
					})
			}
			opened = false
		}
	}
	
	private func openRightAnimation(completion: ((MenuLayoutItem) -> Void)? = nil) {
		if let v: Array<MenuLayoutItem> = items {
			var base: MenuLayoutItem?
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				if nil == base {
					base = v[0]
				}
				let item: MenuLayoutItem = v[i]
				item.button.hidden = false
				UIView.animateWithDuration(Double(i) * duration,
					animations: { [unowned self] in
						item.button.alpha = 1
						item.button.frame.origin.x = base!.button.frame.origin.x + self.baseSize.width + CGFloat(i - 1) * self.itemSize.width + CGFloat(i) * 16
					},
					completion: { _ in
						completion?(item)
					})
			}
			opened = true
		}
	}
	
	public func closeRightAnimation(completion: ((MenuLayoutItem) -> Void)? = nil) {
		if let v: Array<MenuLayoutItem> = items {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let item: MenuLayoutItem = v[i]
				UIView.animateWithDuration(Double(i) * duration,
					animations: {
						item.button.alpha = 0
						item.button.frame.origin.x = 16
					},
					completion: { _ in
						item.button.hidden = true
						completion?(item)
					})
			}
			opened = false
		}
	}
	
	private func layoutTopLeft() {
		if let v: Array<MenuLayoutItem> = items {
			for var i: Int = 0, l: Int = v.count; i < l; ++i {
				let item: MenuLayoutItem = v[i]
				if 0 == i {
					item.button.frame.size = baseSize
					item.button.frame.origin.x = 16
					item.button.frame.origin.y = 16
					item.button.layer.zPosition = 10000
				} else {
					item.button.alpha = 0
					item.button.frame.size = itemSize
					item.button.frame.origin.x = (baseSize.width - itemSize.width) / 2 + 16
					item.button.frame.origin.y = (baseSize.height - itemSize.height) / 2 + 16
					item.button.layer.zPosition = CGFloat(10000 - i)
				}
			}
		}
	}
	
	private func layoutTopRight() {
		if let v: Array<MenuLayoutItem> = items {
			for var i: Int = 0, l: Int = v.count; i < l; ++i {
				let item: MenuLayoutItem = v[i]
				if 0 == i {
					item.button.frame.size = baseSize
					item.button.frame.origin.x = width - baseSize.width - 16
					item.button.frame.origin.y = 16
					item.button.layer.zPosition = 10000
				} else {
					item.button.alpha = 0
					item.button.frame.size = itemSize
					item.button.frame.origin.x = width - (baseSize.width + itemSize.width) / 2 - 16
					item.button.frame.origin.y = (baseSize.height - itemSize.height) / 2 + 16
					item.button.layer.zPosition = CGFloat(10000 - i)
				}
			}
		}
	}
	
	private func layoutBottomLeft() {
		if let v: Array<MenuLayoutItem> = items {
			for var i: Int = 0, l: Int = v.count; i < l; ++i {
				let item: MenuLayoutItem = v[i]
				if 0 == i {
					item.button.frame.size = baseSize
					item.button.frame.origin.x = 16
					item.button.frame.origin.y = height - baseSize.height - 16
					item.button.layer.zPosition = 10000
				} else {
					item.button.alpha = 0
					item.button.frame.size = itemSize
					item.button.frame.origin.x = (baseSize.width - itemSize.width) / 2 + 16
					item.button.frame.origin.y = height - (baseSize.height + itemSize.height) / 2 - 16
					item.button.layer.zPosition = CGFloat(10000 - i)
				}
			}
		}
	}
	
	private func layoutBottomRight() {
		if let v: Array<MenuLayoutItem> = items {
			for var i: Int = 0, l: Int = v.count; i < l; ++i {
				let item: MenuLayoutItem = v[i]
				if 0 == i {
					item.button.frame.size = baseSize
					item.button.frame.origin.x = width - baseSize.width - 16
					item.button.frame.origin.y = height - baseSize.height - 16
					item.button.layer.zPosition = 10000
				} else {
					item.button.alpha = 0
					item.button.frame.size = itemSize
					item.button.frame.origin.x = width - (baseSize.width + itemSize.width) / 2 - 16
					item.button.frame.origin.y = height - (baseSize.height + itemSize.height) / 2 - 16
					item.button.layer.zPosition = CGFloat(10000 - i)
				}
			}
		}
	}
}