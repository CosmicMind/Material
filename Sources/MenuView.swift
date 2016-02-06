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

public struct MenuViewItem {
	/// UIButton.
	public var button: UIButton
	
	/// Title UILabel.
	public var titleLabel: UILabel?
	
	public init(button: UIButton, titleLabel: UILabel? = nil) {
		self.button = button
		self.titleLabel = titleLabel
	}
}

public class MenuView : MaterialView {
	public private(set) var opened: Bool = false
	
	public var menuItems: Array<MenuViewItem>? {
		didSet {
			reloadView()
		}
	}
	
	public var itemSize: CGSize = CGSizeMake(48, 48)
	
	public var baseItemSize: CGSize = CGSizeMake(56, 56)
	
	public func reloadView() {
		// Clear the subviews.
		for v in subviews {
			v.removeFromSuperview()
		}
		
		if let v: Array<MenuViewItem> = menuItems {
			for var i: Int = 0, l: Int = v.count; i < l; ++i {
				let item: MenuViewItem = v[i]
				
				if 0 == i {
					item.button.frame.size = baseItemSize
					item.button.frame.origin.x = width - baseItemSize.width - 16
					item.button.frame.origin.y = height - baseItemSize.height - 16
					addSubview(item.button)
				} else {
					item.button.hidden = true
					item.button.frame.size = itemSize
					item.button.frame.origin.x = width - (baseItemSize.width + itemSize.width) / 2 - 16
					item.button.frame.origin.y = height - itemSize.height - 16
					insertSubview(item.button, belowSubview: v[i - 1].button)
				}
			}
		}
	}
	
	public func open() {
		if let v: Array<MenuViewItem> = menuItems {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let item: MenuViewItem = v[i]
				UIView.animateWithDuration(Double(i) * 0.15,
					animations: { [unowned self] in
						item.button.hidden = false
						item.button.center.y = self.height - CGFloat(i + 1) * (item.button.bounds.height) - CGFloat(i) * 16
					},
					completion: { _ in
						(item.button as? MaterialButton)?.pulse()
					})
			}
			opened = true
		}
	}
	
	public func close() {
		if let v: Array<MenuViewItem> = menuItems {
			for var i: Int = 1, l: Int = v.count; i < l; ++i {
				let item: MenuViewItem = v[i]
				UIView.animateWithDuration(0.15,
					animations: { [unowned self] in
						item.button.center.y = self.height - item.button.bounds.height - 16
					},
					completion: { _ in
						item.button.hidden = true
					})
			}
			opened = false
		}
	}
}