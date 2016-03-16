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

/// A memory reference to the NavigationItem instance.
private var NavigationItemKey: UInt8 = 0

public class NavigationItem {
	/// Portrait inset.
	public var portraitInset: CGFloat
	
	/// Landscape inset.
	public var landscapeInset: CGFloat
	
	/// Detail View.
	public var detailView: UIView?
	
	/// Title label.
	public var titleLabel: UILabel?
	
	/// Detail label.
	public var detailLabel: UILabel?
	
	/// Left controls.
	public var leftControls: Array<UIControl>?
	
	/// Right controls.
	public var rightControls: Array<UIControl>?
	
	public init(portraitInset: CGFloat, landscapeInset: CGFloat) {
		self.portraitInset = portraitInset
		self.landscapeInset = landscapeInset
	}
}

public extension UINavigationItem {
	/// NavigationBarControls reference.
	public internal(set) var item: NavigationItem {
		get {
			return MaterialAssociatedObject(self, key: &NavigationItemKey) {
				return NavigationItem(portraitInset: .iPad == MaterialDevice.type || "iPhone 6s Plus" == MaterialDevice.model || "iPhone 6 Plus" == MaterialDevice.model ? -20 : -16, landscapeInset: -20)
			}
		}
		set(value) {
			MaterialAssociateObject(self, key: &NavigationItemKey, value: value)
		}
	}
	
	/// Portrait inset.
	public var portraitInset: CGFloat {
		get {
			return item.portraitInset
		}
		set(value) {
			item.portraitInset = value
		}
	}
	
	/// Landscape inset.
	public var landscapeInset: CGFloat {
		get {
			return item.landscapeInset
		}
		set(value) {
			item.landscapeInset = value
		}
	}
	
	/// Detail View.
	public var detailView: UIView? {
		get {
			return item.detailView
		}
		set(value) {
			item.detailView = value
		}
	}
	
	/// Title Label.
	public var titleLabel: UILabel? {
		get {
			return item.titleLabel
		}
		set(value) {
			item.titleLabel = value
		}
	}
	
	/// Detail Label.
	public var detailLabel: UILabel? {
		get {
			return item.detailLabel
		}
		set(value) {
			item.detailLabel = value
		}
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