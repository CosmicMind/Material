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

public extension UIViewController {
	/**
	A convenience property that provides access to the ToolbarController.
	This is the recommended method of accessing the ToolbarController
	through child UIViewControllers.
	*/
	public var toolbarController: ToolbarController? {
		var viewController: UIViewController? = self
		while nil != viewController {
			if viewController is ToolbarController {
				return viewController as? ToolbarController
			}
			viewController = viewController?.parentViewController
		}
		return nil
	}
}

@objc(ToolbarControllerDelegate)
public protocol ToolbarControllerDelegate : MaterialDelegate {
	/// Delegation method that executes when the floatingViewController will open.
	optional func toolbarControllerWillOpenFloatingViewController(toolbarController: ToolbarController)
	
	/// Delegation method that executes when the floatingViewController will close.
	optional func toolbarControllerWillCloseFloatingViewController(toolbarController: ToolbarController)
	
	/// Delegation method that executes when the floatingViewController did open.
	optional func toolbarControllerDidOpenFloatingViewController(toolbarController: ToolbarController)
	
	/// Delegation method that executes when the floatingViewController did close.
	optional func toolbarControllerDidCloseFloatingViewController(toolbarController: ToolbarController)
}

@objc(ToolbarController)
public class ToolbarController : BarController {
	/// Internal reference to the floatingViewController.
	private var internalFloatingViewController: UIViewController?
	
	/// Reference to the Toolbar.
	public private(set) var toolbar: Toolbar!
	
	/// Delegation handler.
	public weak var delegate: ToolbarControllerDelegate?
	
	/// A floating UIViewController.
	public var floatingViewController: UIViewController? {
		get {
			return internalFloatingViewController
		}
		set(value) {
			if let v: UIViewController = internalFloatingViewController {
				v.view.layer.rasterizationScale = MaterialDevice.scale
				v.view.layer.shouldRasterize = true
				delegate?.toolbarControllerWillCloseFloatingViewController?(self)
				internalFloatingViewController = nil
				UIView.animateWithDuration(0.5,
					animations: { [weak self] in
						if let s: ToolbarController = self {
							v.view.center.y = 2 * s.view.bounds.height
							s.toolbar.alpha = 1
							s.rootViewController.view.alpha = 1
						}
					}) { [weak self] _ in
						if let s: ToolbarController = self {
							v.willMoveToParentViewController(nil)
							v.view.removeFromSuperview()
							v.removeFromParentViewController()
							v.view.layer.shouldRasterize = false
							s.userInteractionEnabled = true
							s.toolbar.userInteractionEnabled = true
							dispatch_async(dispatch_get_main_queue()) { [weak self] in
								if let s: ToolbarController = self {
									s.delegate?.toolbarControllerDidCloseFloatingViewController?(s)
								}
							}
						}
					}
			}
			
			if let v: UIViewController = value {
				// Add the noteViewController! to the view.
				addChildViewController(v)
				v.view.frame = view.bounds
				v.view.center.y = 2 * view.bounds.height
				v.view.hidden = true
				view.insertSubview(v.view, aboveSubview: toolbar)
				v.view.layer.zPosition = 1500
				v.didMoveToParentViewController(self)
				
				// Animate the noteButton out and the noteViewController! in.
				v.view.hidden = false
				v.view.layer.rasterizationScale = MaterialDevice.scale
				v.view.layer.shouldRasterize = true
				view.layer.rasterizationScale = MaterialDevice.scale
				view.layer.shouldRasterize = true
				internalFloatingViewController = v
				userInteractionEnabled = false
				toolbar.userInteractionEnabled = false
				delegate?.toolbarControllerWillOpenFloatingViewController?(self)
				UIView.animateWithDuration(0.5,
					animations: { [weak self] in
						if let s: ToolbarController = self {
							v.view.center.y = s.view.bounds.height / 2
							s.toolbar.alpha = 0.5
							s.rootViewController.view.alpha = 0.5
						}
					}) { [weak self] _ in
						if let s: ToolbarController = self {
							v.view.layer.shouldRasterize = false
							s.view.layer.shouldRasterize = false
							dispatch_async(dispatch_get_main_queue()) { [weak self] in
								if let s: ToolbarController = self {
									s.delegate?.toolbarControllerDidOpenFloatingViewController?(s)
								}
							}
						}
					}
			}
		}
	}
	
	public override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		layoutSubviews()
	}
	
	/// Layout subviews.
	public func layoutSubviews() {
		if let v: Toolbar = toolbar {
			v.grid.layoutInset.top = .iPhone == MaterialDevice.type && MaterialDevice.isLandscape ? 0 : 20
			
			let h: CGFloat = MaterialDevice.height
			let w: CGFloat = MaterialDevice.width
			let p: CGFloat = v.intrinsicContentSize().height + v.grid.layoutInset.top + v.grid.layoutInset.bottom
			
			v.width = w + v.grid.layoutInset.left + v.grid.layoutInset.right
			v.height = p
			
			rootViewController.view.frame.origin.y = p
			rootViewController.view.frame.size.height = h - p
		}
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public override func prepareView() {
		super.prepareView()
		prepareToolbar()
	}
	
	/// Prepares the Toolbar.
	private func prepareToolbar() {
		if nil == toolbar {
			toolbar = Toolbar()
			toolbar.zPosition = 1000
			view.addSubview(toolbar)
		}
	}
}