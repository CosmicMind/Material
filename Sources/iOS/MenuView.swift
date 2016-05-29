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

@objc(MenuViewDelegate)
public protocol MenuViewDelegate : MaterialDelegate {
    /// Gets called when the user taps outside menu buttons.
    optional func menuViewDidTapOutside(menuView: MenuView)
    
}

public class MenuView : MaterialPulseView {
	/// References the Menu instance.
	public private(set) lazy var menu: Menu = Menu()
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public override func prepareView() {
		super.prepareView()
		pulseAnimation = .None
		clipsToBounds = false
		backgroundColor = nil
	}

	/**
	Opens the menu with a callback.
	- Parameter completion: An Optional callback that is executed when
	all menu items have been opened.
	*/
	public func open(completion: (() -> Void)? = nil) {
		if true == menu.views?.first?.userInteractionEnabled {
			menu.views?.first?.userInteractionEnabled = false
			menu.open { [weak self] (v: UIView) in
				if self?.menu.views?.last == v {
					self?.menu.views?.first?.userInteractionEnabled = true
					completion?()
				}
			}
		}
	}
	
	/**
	Closes the menu with a callback.
	- Parameter completion: An Optional callback that is executed when
	all menu items have been closed.
	*/
	public func close(completion: (() -> Void)? = nil) {
		if true == menu.views?.first?.userInteractionEnabled {
			menu.views?.first?.userInteractionEnabled = false
			menu.close { [weak self] (v: UIView) in
				if self?.menu.views?.last == v {
					self?.menu.views?.first?.userInteractionEnabled = true
					completion?()
				}
			}
		}
	}
	
	public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		/**
		Since the subviews will be outside the bounds of this view,
		we need to look at the subviews to see if we have a hit.
		*/
        guard !hidden else {
            return nil
        }
		
		for v in subviews {
			let p: CGPoint = v.convertPoint(point, fromView: self)
			if CGRectContainsPoint(v.bounds, p) {
				return v.hitTest(p, withEvent: event)
			}
		}
		
		if menu.opened {
			(delegate as? MenuViewDelegate)?.menuViewDidTapOutside?(self)
		}
		
		return super.hitTest(point, withEvent: event)
	}
}