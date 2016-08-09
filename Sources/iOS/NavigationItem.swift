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

/// A memory reference to the NavigationItem instance.
private var MaterialAssociatedObjectNavigationItemKey: UInt8 = 0

public class MaterialAssociatedObjectNavigationItem {
	/**
	A boolean indicating whether keys are being observed
	on the UINavigationItem.
	*/
	internal var observed: Bool = false
	
	/// Back Button.
	public var backButton: IconButton?
	
	/// Content View.
	public var contentView: UIView?
	
	/// Title label.
	public private(set) var titleLabel: UILabel!
	
	/// Detail label.
	public private(set) var detailLabel: UILabel!
	
	/// Left controls.
	public var leftControls: Array<UIControl>?
	
	/// Right controls.
	public var rightControls: Array<UIControl>?
	
	/// Initializer.
	public init() {
		prepareTitleLabel()
		prepareDetailLabel()
	}
    
    /// Reloads the subviews for the NavigationBar.
    internal func reloadNavigationBar() {
        guard let navigationBar = contentView?.superview?.superview as? NavigationBar else {
            return
        }
        navigationBar.layoutSubviews()
    }
	
	/// Prepares the titleLabel.
	private func prepareTitleLabel() {
		titleLabel = UILabel()
		titleLabel.font = RobotoFont.mediumWithSize(size: 17)
		titleLabel.textAlignment = .center
	}
	
	/// Prepares the detailLabel.
	private func prepareDetailLabel() {
		detailLabel = UILabel()
		detailLabel.font = RobotoFont.regularWithSize(size: 12)
		detailLabel.textAlignment = .center
	}
}

extension UINavigationItem {
	/// NavigationItem reference.
	public internal(set) var item: MaterialAssociatedObjectNavigationItem {
		get {
			return AssociatedObject(base: self, key: &MaterialAssociatedObjectNavigationItemKey) {
				return MaterialAssociatedObjectNavigationItem()
			}
		}
		set(value) {
			AssociateObject(base: self, key: &MaterialAssociatedObjectNavigationItemKey, value: value)
		}
	}
	
	/// Back Button.
	public internal(set) var backButton: IconButton? {
		get {
			return item.backButton
		}
		set(value) {
			item.backButton = value
		}
	}
	
	/// Content View.
	public internal(set) var contentView: UIView? {
		get {
			return item.contentView
		}
		set(value) {
			item.contentView = value
		}
	}
	
	@nonobjc
	public var title: String? {
		get {
			return titleLabel.text
		}
		set(value) {
			titleLabel.text = value
            item.reloadNavigationBar()
		}
	}
	
	/// Title Label.
	public var titleLabel: UILabel {
		return item.titleLabel
	}
	
	/// Detail text.
	public var detail: String? {
		get {
			return detailLabel.text
		}
		set(value) {
			detailLabel.text = value
            item.reloadNavigationBar()
		}
	}
	
	/// Detail Label.
	public var detailLabel: UILabel {
		return item.detailLabel
	}
	
	/// Left side UIControls.
	public var leftControls: Array<UIControl>? {
		get {
			return item.leftControls
		}
		set(value) {
			item.leftControls = value
		}
	}
	
	/// Right side UIControls.
	public var rightControls: Array<UIControl>? {
		get {
			return item.rightControls
		}
		set(value) {
			item.rightControls = value
		}
	}
}
