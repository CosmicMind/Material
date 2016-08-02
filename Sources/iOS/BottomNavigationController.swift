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

public class BottomNavigationFadeAnimatedTransitioning : NSObject, UIViewControllerAnimatedTransitioning {
	public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let fromView : UIView = transitionContext.view(forKey: UITransitionContextFromViewKey)!
		let toView : UIView = transitionContext.view(forKey: UITransitionContextToViewKey)!
		toView.alpha = 0
		
		transitionContext.containerView().addSubview(fromView)
		transitionContext.containerView().addSubview(toView)
		
		UIView.animate(withDuration: transitionDuration(using: transitionContext),
			animations: { _ in
				toView.alpha = 1
				fromView.alpha = 0
			}) { _ in
				transitionContext.completeTransition(true)
			}
	}
	
	public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.35
	}
}

@objc(BottomNavigationTransitionAnimation)
public enum BottomNavigationTransitionAnimation: Int {
	case none
	case fade
}

@IBDesignable
public class BottomNavigationController : UITabBarController, UITabBarControllerDelegate {
	/// The transition animation to use when selecting a new tab.
	public var transitionAnimation: BottomNavigationTransitionAnimation = .fade
	
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
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	public init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
	}
	
	public override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		layoutSubviews()
	}
	
	public func layoutSubviews() {
		if let v: Array<UITabBarItem> = tabBar.items {
			for item in v {
				if .phone == Device.userInterfaceIdiom {
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
		view.contentScaleFactor = Device.scale
		delegate = self
		prepareTabBar()
	}
	
	/// Handles transitions when tabBarItems are pressed.
	public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		let fVC: UIViewController? = fromVC
		let tVC: UIViewController? = toVC
		if nil == fVC || nil == tVC {
			return nil
		}
		return .fade == transitionAnimation ? BottomNavigationFadeAnimatedTransitioning() : nil
	}
	
	/// Prepares the tabBar.
	private func prepareTabBar() {
		tabBar.depthPreset = .depth1
        let image = UIImage.imageWithColor(color: Color.clear, size: CGSize(width: 1, height: 1))
		tabBar.shadowImage = image
		tabBar.backgroundImage = image
		tabBar.backgroundColor = Color.white
	}
}
