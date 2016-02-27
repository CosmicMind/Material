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
	A convenience property that provides access to the NavigationBarViewController.
	This is the recommended method of accessing the NavigationBarViewController
	through child UIViewControllers.
	*/
	public var navigationBarViewController: NavigationBarViewController? {
		var viewController: UIViewController? = self
		while nil != viewController {
			if viewController is NavigationBarViewController {
				return viewController as? NavigationBarViewController
			}
			viewController = viewController?.parentViewController
		}
		return nil
	}
}

@objc(NavigationBarViewControllerDelegate)
public protocol NavigationBarViewControllerDelegate : MaterialDelegate {
	/// Delegation method that executes when the floatingViewController will open.
	optional func navigationBarViewControllerWillOpenFloatingViewController(navigationBarViewController: NavigationBarViewController)
	
	/// Delegation method that executes when the floatingViewController will close.
	optional func navigationBarViewControllerWillCloseFloatingViewController(navigationBarViewController: NavigationBarViewController)
	
	/// Delegation method that executes when the floatingViewController did open.
	optional func navigationBarViewControllerDidOpenFloatingViewController(navigationBarViewController: NavigationBarViewController)
	
	/// Delegation method that executes when the floatingViewController did close.
	optional func navigationBarViewControllerDidCloseFloatingViewController(navigationBarViewController: NavigationBarViewController)
}

@objc(NavigationBarViewController)
public class NavigationBarViewController: StatusBarViewController {
	/// Internal reference to the floatingViewController.
	private var internalFloatingViewController: UIViewController?
	
	/// Reference to the NavigationBarView.
	public private(set) lazy var navigationBarView: NavigationBarView = NavigationBarView()
	
	/// Delegation handler.
	public weak var delegate: NavigationBarViewControllerDelegate?
	
	/// A floating UIViewController.
	public var floatingViewController: UIViewController? {
		get {
			return internalFloatingViewController
		}
		set(value) {
			if let v: UIViewController = internalFloatingViewController {
				delegate?.navigationBarViewControllerWillCloseFloatingViewController?(self)
				internalFloatingViewController = nil
				UIView.animateWithDuration(0.5,
					animations: { [unowned self] in
						v.view.center.y = 2 * self.view.bounds.height
						self.navigationBarView.alpha = 1
						self.mainViewController.view.alpha = 1
					}) { [unowned self] _ in
						v.willMoveToParentViewController(nil)
						v.view.removeFromSuperview()
						v.removeFromParentViewController()
						self.userInteractionEnabled = true
						self.navigationBarView.userInteractionEnabled = true
						dispatch_async(dispatch_get_main_queue()) { [unowned self] in
							self.delegate?.navigationBarViewControllerDidCloseFloatingViewController?(self)
						}
					}
			}
			
			if let v: UIViewController = value {
				// Add the noteViewController! to the view.
				addChildViewController(v)
				v.view.frame = view.bounds
				v.view.center.y = 2 * view.bounds.height
				v.view.hidden = true
				view.insertSubview(v.view, aboveSubview: navigationBarView)
				v.view.layer.zPosition = 1500
				v.didMoveToParentViewController(self)
				
				// Animate the noteButton out and the noteViewController! in.
				v.view.hidden = false
				internalFloatingViewController = v
				userInteractionEnabled = false
				navigationBarView.userInteractionEnabled = false
				delegate?.navigationBarViewControllerWillOpenFloatingViewController?(self)
				UIView.animateWithDuration(0.5,
					animations: { [unowned self] in
						v.view.center.y = self.view.bounds.height / 2
						self.navigationBarView.alpha = 0.5
						self.mainViewController.view.alpha = 0.5
					}) { [unowned self] _ in
						dispatch_async(dispatch_get_main_queue()) { [unowned self] in
							self.delegate?.navigationBarViewControllerDidOpenFloatingViewController?(self)
						}
					}
			}
		}
	}
	
	public override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		layoutSubviews()
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called at the end
	when subclassing.
	*/
	public override func prepareView() {
		super.prepareView()
		prepareNavigationBarView()
	}
	
	/// Prepares the NavigationBarView.
	private func prepareNavigationBarView() {
		navigationBarView.delegate = self
		navigationBarView.zPosition = 1000
		view.addSubview(navigationBarView)
	}
	
	/// Layout subviews.
	private func layoutSubviews() {
		let size: CGSize = UIScreen.mainScreen().bounds.size
		let h: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
		mainViewController.view.frame = CGRectMake(0, navigationBarView.height, size.width, size.height - navigationBarView.height - (20 >= h ? 0 : h - 20))
	}
}

extension NavigationBarViewController : NavigationBarViewDelegate {
	/// Monitor layout changes.
	public func navigationBarViewDidChangeLayout(navigationBarView: NavigationBarView) {
		layoutSubviews()
	}
}