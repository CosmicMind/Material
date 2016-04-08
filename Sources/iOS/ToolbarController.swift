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
public class ToolbarController : StatusBarViewController {
	/// The height of the StatusBar.
	@IBInspectable public override var heightForStatusBar: CGFloat {
		get {
			return toolbar.heightForStatusBar
		}
		set(value) {
			toolbar.heightForStatusBar = value
		}
	}
	
	/// The height when in Portrait orientation mode.
	@IBInspectable public override var heightForPortraitOrientation: CGFloat {
		get {
			return toolbar.heightForPortraitOrientation
		}
		set(value) {
			toolbar.heightForPortraitOrientation = value
		}
	}
	
	/// The height when in Landscape orientation mode.
	@IBInspectable public override var heightForLandscapeOrientation: CGFloat {
		get {
			return toolbar.heightForLandscapeOrientation
		}
		set(value) {
			toolbar.heightForLandscapeOrientation = value
		}
	}
	
	/// Internal reference to the floatingViewController.
	private var internalFloatingViewController: UIViewController?
	
	/// Reference to the Toolbar.
	public private(set) lazy var toolbar: Toolbar = Toolbar()
	
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
					animations: { [unowned self] in
						v.view.center.y = 2 * self.view.bounds.height
						self.toolbar.alpha = 1
						self.rootViewController.view.alpha = 1
					}) { [unowned self] _ in
						v.willMoveToParentViewController(nil)
						v.view.removeFromSuperview()
						v.removeFromParentViewController()
						v.view.layer.shouldRasterize = false
						self.userInteractionEnabled = true
						self.toolbar.userInteractionEnabled = true
						dispatch_async(dispatch_get_main_queue()) { [unowned self] in
							self.delegate?.toolbarControllerDidCloseFloatingViewController?(self)
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
					animations: { [unowned self] in
						v.view.center.y = self.view.bounds.height / 2
						self.toolbar.alpha = 0.5
						self.rootViewController.view.alpha = 0.5
					}) { [unowned self] _ in
						v.view.layer.shouldRasterize = false
						self.view.layer.shouldRasterize = false
						dispatch_async(dispatch_get_main_queue()) { [unowned self] in
							self.delegate?.toolbarControllerDidOpenFloatingViewController?(self)
						}
				}
			}
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
		toolbar.zPosition = 1000
		view.addSubview(toolbar)
	}
}