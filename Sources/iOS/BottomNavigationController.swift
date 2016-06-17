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

public class BottomNavigationFadeAnimatedTransitioning : NSObject, UIViewControllerAnimatedTransitioning {
	public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		let fromView : UIView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
		let toView : UIView = transitionContext.viewForKey(UITransitionContextToViewKey)!
		toView.alpha = 0
		
		transitionContext.containerView()!.addSubview(fromView)
		transitionContext.containerView()!.addSubview(toView)
		
		UIView.animateWithDuration(transitionDuration(transitionContext),
			animations: { _ in
				toView.alpha = 1
				fromView.alpha = 0
			}) { _ in
				transitionContext.completeTransition(true)
			}
	}
	
	public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 0.35
	}
}

public enum BottomNavigationTransitionAnimation {
	case None
	case Fade
}

@IBDesignable
public class BottomNavigationController : UITabBarController, UITabBarControllerDelegate {
	/// The transition animation to use when selecting a new tab.
	public var transitionAnimation: BottomNavigationTransitionAnimation = .Fade
	
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
	
	public init() {
		super.init(nibName: nil, bundle: nil)
		prepareView()
	}
	
	public override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		layoutSubviews()
	}
	
	public func layoutSubviews() {
		if let v: Array<UITabBarItem> = tabBar.items {
			for item in v {
				if .iPhone == MaterialDevice.type {
					if nil == item.title {
						let inset: CGFloat = 7
						item.imageInsets = UIEdgeInsetsMake(inset, 0, -inset, 0)
					} else {
						let inset: CGFloat = 6
						item.titlePositionAdjustment.vertical = -inset
					}
				} else {
					if nil == item.title {
						let inset: CGFloat = 9
						item.imageInsets = UIEdgeInsetsMake(inset, 0, -inset, 0)
					} else {
						let inset: CGFloat = 3
						item.imageInsets = UIEdgeInsetsMake(inset, 0, -inset, 0)
						item.titlePositionAdjustment.vertical = -inset
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
	public func prepareView() {
		view.clipsToBounds = true
		view.contentScaleFactor = MaterialDevice.scale
		delegate = self
		prepareTabBar()
	}
	
	/// Handles transitions when tabBarItems are pressed.
	public func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		let fVC: UIViewController? = fromVC
		let tVC: UIViewController? = toVC
		if nil == fVC || nil == tVC {
			return nil
		}
		return .Fade == transitionAnimation ? BottomNavigationFadeAnimatedTransitioning() : nil
	}
	
	/// Prepares the tabBar.
	private func prepareTabBar() {
		tabBar.depth = .Depth1
		let image: UIImage? = UIImage.imageWithColor(MaterialColor.clear, size: CGSizeMake(1, 1))
		tabBar.shadowImage = image
		tabBar.backgroundImage = image
		tabBar.backgroundColor = MaterialColor.white
	}
}
