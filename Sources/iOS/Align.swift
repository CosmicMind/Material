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

public class Align {
	/// UIView context.
	internal weak var context: UIView?
	
	init(context: UIView?) {
		self.context = context
	}
	
	/// Edges
	public func edges(child: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
		if let v: UIView = context {
			MaterialLayout.alignToParent(v, child: child, top: top, left: left, bottom: bottom, right: right)
		}
	}
	
	/// TopLeft
	public func topLeft(child: UIView, top: CGFloat = 0, left: CGFloat = 0) {
		if let v: UIView = context {
			MaterialLayout.alignFromTopLeft(v, child: child, top: top, left: left)
		}
	}
	
	/// TopRight
	public func topRight(child: UIView, top: CGFloat = 0, right: CGFloat = 0) {
		if let v: UIView = context {
			MaterialLayout.alignFromTopRight(v, child: child, top: top, right: right)
		}
	}
	
	/// BottomLeft
	public func bottomLeft(child: UIView, bottom: CGFloat = 0, left: CGFloat = 0) {
		if let v: UIView = context {
			MaterialLayout.alignFromBottomLeft(v, child: child, bottom: bottom, left: left)
		}
	}
	
	/// BottomRight
	public func bottomRight(child: UIView, bottom: CGFloat = 0, right: CGFloat = 0) {
		if let v: UIView = context {
			MaterialLayout.alignFromBottomRight(v, child: child, bottom: bottom, right: right)
		}
	}
	
	/// Top
	public func top(child: UIView, top: CGFloat = 0) {
		if let v: UIView = context {
			MaterialLayout.alignFromTop(v, child: child, top: top)
		}
	}
	
	/// Left
	public func left(child: UIView, left: CGFloat = 0) {
		if let v: UIView = context {
			MaterialLayout.alignFromLeft(v, child: child, left: left)
		}
	}
	
	/// Bottom
	public func bottom(child: UIView, bottom: CGFloat = 0) {
		if let v: UIView = context {
			MaterialLayout.alignFromBottom(v, child: child, bottom: bottom)
		}
	}
	
	/// Right
	public func right(child: UIView, right: CGFloat = 0) {
		if let v: UIView = context {
			MaterialLayout.alignFromRight(v, child: child, right: right)
		}
	}
	
	/// Center
	public func center(child: UIView, constantX: CGFloat = 0, constantY: CGFloat = 0) {
		if let v: UIView = context {
			MaterialLayout.center(v, child: child, constantX: constantX, constantY: constantY)
		}
	}
	
	/// CenterHorizontally
	public func centerHorizontally(child: UIView, constant: CGFloat = 0) {
		if let v: UIView = context {
			MaterialLayout.centerHorizontally(v, child: child, constant: constant)
		}
	}
	
	/// CenterVertically
	public func centerVertically(child: UIView, constant: CGFloat = 0) {
		if let v: UIView = context {
			MaterialLayout.centerVertically(v, child: child, constant: constant)
		}
	}
}

/// A memory reference to the AlignKey instance for UIView extensions.
private var AlignKey: UInt8 = 0

/// MaterialLayout extension for UIView.
public extension UIView {
	/// Align reference.
	public private(set) var align: Align {
		get {
			return MaterialAssociatedObject(self, key: &AlignKey) {
				return Align(context: self)
			}
		}
		set(value) {
			MaterialAssociateObject(self, key: &AlignKey, value: value)
		}
	}
}
