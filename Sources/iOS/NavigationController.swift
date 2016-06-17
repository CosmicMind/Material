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
public class NavigationController : UINavigationController, UIGestureRecognizerDelegate {
	/**
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
	An initializer that initializes the object with an Optional nib and bundle.
	- Parameter nibNameOrNil: An Optional String for the nib.
	- Parameter bundle: An Optional NSBundle where the nib is located.
	*/
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	/**
	An initializer that initializes the object with a rootViewController.
	- Parameter rootViewController: A UIViewController for the rootViewController.
	*/
	public override init(rootViewController: UIViewController) {
		super.init(navigationBarClass: NavigationBar.self, toolbarClass: nil)
		setViewControllers([rootViewController], animated: false)
	}
	
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if let v: UIGestureRecognizer = interactivePopGestureRecognizer {
			if let x: NavigationDrawerController = navigationDrawerController {
				if let l: UIPanGestureRecognizer = x.leftPanGesture {
					l.requireGestureRecognizerToFail(v)
				}
				if let r: UIPanGestureRecognizer = x.rightPanGesture {
					r.requireGestureRecognizerToFail(v)
				}
			}
		}
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
	}
	
	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		// Load the initial topItem.
		if let v: NavigationBar = navigationBar as? NavigationBar {
			if let item: UINavigationItem = v.topItem {
				v.layoutNavigationItem(item)
			}
		}
	}
	
	/**
	Detects the gesture recognizer being used. This is necessary when using 
	NavigationDrawerController. It eliminates the conflict in panning.
	- Parameter gestureRecognizer: A UIGestureRecognizer to detect.
	- Parameter touch: The UITouch event.
	- Returns: A Boolean of whether to continue the gesture or not, true yes, false no.
	*/
	public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		return interactivePopGestureRecognizer == gestureRecognizer && nil != navigationBar.backItem
	}
	
	/**
	Delegation method that is called when a new UINavigationItem is about to be pushed.
	This is used to prepare the transitions between UIViewControllers on the stack.
	- Parameter navigationBar: A UINavigationBar that is used in the NavigationController.
	- Parameter item: The UINavigationItem that will be pushed on the stack.
	- Returns: A Boolean value that indicates whether to push the item on to the stack or not. 
	True is yes, false is no.
	*/
	public func navigationBar(navigationBar: UINavigationBar, shouldPushItem item: UINavigationItem) -> Bool {
		if let v: NavigationBar = navigationBar as? NavigationBar {
			let backButton: IconButton = IconButton()
			backButton.pulseColor = MaterialColor.white
			backButton.setImage(v.backButtonImage, forState: .Normal)
			backButton.setImage(v.backButtonImage, forState: .Highlighted)
			backButton.addTarget(self, action: #selector(handleBackButton), forControlEvents: .TouchUpInside)
			
			if var c: Array<UIControl> = item.leftControls {
				c.append(backButton)
				item.leftControls = c
			} else {
				item.leftControls = [backButton]
			}
			
			item.backButton = backButton
			v.layoutNavigationItem(item)
		}
		return true
	}
	
	/// Handler for the back button.
	internal func handleBackButton() {
		popViewControllerAnimated(true)
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
		
		// This ensures the panning gesture is available when going back between views.
		if let v: UIGestureRecognizer = interactivePopGestureRecognizer {
			v.enabled = true
			v.delegate = self
		}
	}
}
