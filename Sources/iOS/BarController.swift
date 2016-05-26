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

@IBDesignable
public class BarController : UIViewController {
	/// Device status bar style.
	public var statusBarStyle: UIStatusBarStyle {
		get {
			return MaterialDevice.statusBarStyle
		}
		set(value) {
			MaterialDevice.statusBarStyle = value
		}
	}
	
	/**
	A Boolean property used to enable and disable interactivity
	with the rootViewController.
	*/
	@IBInspectable public var userInteractionEnabled: Bool {
		get {
			return rootViewController.view.userInteractionEnabled
		}
		set(value) {
			rootViewController.view.userInteractionEnabled = value
		}
	}
	
	/**
	A UIViewController property that references the active
	main UIViewController. To swap the rootViewController, it
	is recommended to use the transitionFromRootViewController
	helper method.
	*/
	public private(set) var rootViewController: UIViewController!
	
	/**
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepareView()
	}
	
	/**
	An initializer that initializes the object with an Optional nib and bundle.
	- Parameter nibNameOrNil: An Optional String for the nib.
	- Parameter bundle: An Optional NSBundle where the nib is located.
	*/
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		prepareView()
	}
	
	/**
	An initializer for the BarController.
	- Parameter rootViewController: The main UIViewController.
	*/
	public init(rootViewController: UIViewController) {
		super.init(nibName: nil, bundle: nil)
		self.rootViewController = rootViewController
		prepareView()
	}
	
	/**
	A method to swap rootViewController objects.
	- Parameter toViewController: The UIViewController to swap
	with the active rootViewController.
	- Parameter duration: A NSTimeInterval that sets the
	animation duration of the transition.
	- Parameter options: UIViewAnimationOptions thst are used
	when animating the transition from the active rootViewController
	to the toViewController.
	- Parameter animations: An animation block that is executed during
	the transition from the active rootViewController
	to the toViewController.
	- Parameter completion: A completion block that is execited after
	the transition animation from the active rootViewController
	to the toViewController has completed.
	*/
	public func transitionFromRootViewController(toViewController: UIViewController, duration: NSTimeInterval = 0.5, options: UIViewAnimationOptions = [], animations: (() -> Void)? = nil, completion: ((Bool) -> Void)? = nil) {
		rootViewController.willMoveToParentViewController(nil)
		addChildViewController(toViewController)
		toViewController.view.frame = rootViewController.view.frame
		transitionFromViewController(rootViewController,
			toViewController: toViewController,
			duration: duration,
			options: options,
			animations: animations,
			completion: { [weak self] (result: Bool) in
				if let s: BarController = self {
					toViewController.didMoveToParentViewController(s)
					s.rootViewController.removeFromParentViewController()
					s.rootViewController = toViewController
					s.rootViewController.view.clipsToBounds = true
					s.rootViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
					s.view.sendSubviewToBack(s.rootViewController.view)
					completion?(result)
				}
			})
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public func prepareView() {
		view.clipsToBounds = true
		view.contentScaleFactor = MaterialDevice.scale
		prepareRootViewController()
	}
	
	/// A method that prepares the rootViewController.
	private func prepareRootViewController() {
		rootViewController.view.clipsToBounds = true
		rootViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		prepareViewControllerWithinContainer(rootViewController, container: view)
	}
	
	/**
	A method that adds the passed in controller as a child of
	the BarController within the passed in
	container view.
	- Parameter viewController: A UIViewController to add as a child.
	- Parameter container: A UIView that is the parent of the
	passed in controller view within the view hierarchy.
	*/
	private func prepareViewControllerWithinContainer(viewController: UIViewController?, container: UIView) {
		if let v: UIViewController = viewController {
			addChildViewController(v)
			container.addSubview(v.view)
			container.sendSubviewToBack(v.view)
			v.didMoveToParentViewController(self)
		}
	}
}
