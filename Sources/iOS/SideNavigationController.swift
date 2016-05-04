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

@objc
public enum SideNavigationPosition : NSInteger {
	case Left
	case Right
}

public extension UIViewController {
	/**
	A convenience property that provides access to the SideNavigationController. 
	This is the recommended method of accessing the SideNavigationController
	through child UIViewControllers.
	*/
	public var sideNavigationController: SideNavigationController? {
		var viewController: UIViewController? = self
		while nil != viewController {
			if viewController is SideNavigationController {
				return viewController as? SideNavigationController
			}
			viewController = viewController?.parentViewController
		}
		return nil
	}
}

@objc(SideNavigationControllerDelegate)
public protocol SideNavigationControllerDelegate {
	/**
	An optional delegation method that is fired before the 
	SideNavigationController opens.
	*/
	optional func sideNavigationWillOpen(sideNavigationController: SideNavigationController, position: SideNavigationPosition)
	
	/**
	An optional delegation method that is fired after the
	SideNavigationController opened.
	*/
	optional func sideNavigationDidOpen(sideNavigationController: SideNavigationController, position: SideNavigationPosition)
	
	/**
	An optional delegation method that is fired before the
	SideNavigationController closes.
	*/
	optional func sideNavigationWillClose(sideNavigationController: SideNavigationController, position: SideNavigationPosition)
	
	/**
	An optional delegation method that is fired after the
	SideNavigationController closed.
	*/
	optional func sideNavigationDidClose(sideNavigationController: SideNavigationController, position: SideNavigationPosition)
	
	/**
	An optional delegation method that is fired when the
	SideNavigationController pan gesture begins.
	*/
	optional func sideNavigationPanDidBegin(sideNavigationController: SideNavigationController, point: CGPoint, position: SideNavigationPosition)
	
	/**
	An optional delegation method that is fired when the
	SideNavigationController pan gesture changes position.
	*/
	optional func sideNavigationPanDidChange(sideNavigationController: SideNavigationController, point: CGPoint, position: SideNavigationPosition)
	
	/**
	An optional delegation method that is fired when the
	SideNavigationController pan gesture ends.
	*/
	optional func sideNavigationPanDidEnd(sideNavigationController: SideNavigationController, point: CGPoint, position: SideNavigationPosition)
	
	/**
	An optional delegation method that is fired when the
	SideNavigationController tap gesture executes.
	*/
	optional func sideNavigationDidTap(sideNavigationController: SideNavigationController, point: CGPoint, position: SideNavigationPosition)

	/**
	An optional delegation method that is fired when the
	status bar is about to change display, hidden or not.
	*/
	optional func sideNavigationStatusBarHiddenState(sideNavigationController: SideNavigationController, hidden: Bool)
}

@IBDesignable
@objc(SideNavigationController)
public class SideNavigationController : UIViewController, UIGestureRecognizerDelegate {
	/// A Boolean to determine if the statusBar will be hidden.
	private var willHideStatusBar: Bool = false
	
	/**
	A CGFloat property that is used internally to track
	the original (x) position of the container view when panning.
	*/
	private var originalX: CGFloat = 0
	
	/**
	A UIPanGestureRecognizer property internally used for the
	leftView pan gesture.
	*/
	internal private(set) var panLeftViewGesture: UIPanGestureRecognizer?
	
	/**
	A UIPanGestureRecognizer property internally used for the
	rightView pan gesture.
	*/
	internal private(set) var panRightViewGesture: UIPanGestureRecognizer?
	
	/**
	A UITapGestureRecognizer property internally used for the 
	leftView tap gesture.
	*/
	internal private(set) var tapLeftViewGesture: UITapGestureRecognizer?
	
	/**
	A UITapGestureRecognizer property internally used for the
	rightView tap gesture.
	*/
	internal private(set) var tapRightViewGesture: UITapGestureRecognizer?
	
	/**
	A CGFloat property that accesses the leftView threshold of
	the SideNavigationController. When the panning gesture has
	ended, if the position is beyond the threshold,
	the leftView is opened, if it is below the threshold, the
	leftView is closed. The leftViewThreshold is always at half
	the width of the leftView.
	*/
	@IBInspectable public var leftThreshold: CGFloat = 32
	private var leftViewThreshold: CGFloat = 0
	
	/**
	A CGFloat property that accesses the rightView threshold of
	the SideNavigationController. When the panning gesture has
	ended, if the position is beyond the threshold,
	the rightView is closed, if it is below the threshold, the
	rightView is opened. The rightViewThreshold is always at half
	the width of the rightView.
	*/
	@IBInspectable public var rightThreshold: CGFloat = 32
	private var rightViewThreshold: CGFloat = 0
	
	/// Sets the animation type for the statusBar when hiding.
	public var statusBarUpdateAnimation: UIStatusBarAnimation = .Fade
	
	/// Sets the statusBar style.
	public var statusBarStyle: UIStatusBarStyle = .Default
	
	/// Sets the statusBar to hidden or not.
	public var statusBarHidden: Bool {
		get {
			return MaterialDevice.statusBarHidden
		}
		set(value) {
			MaterialDevice.statusBarHidden = value
		}
	}
	
	/**
	A SideNavigationControllerDelegate property used to bind
	the delegation object.
	*/
	public weak var delegate: SideNavigationControllerDelegate?
	
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
	A CGFloat property that sets the animation duration of the
	leftView when closing and opening. Defaults to 0.25.
	*/
	@IBInspectable public var animationDuration: CGFloat = 0.25
	
	/**
	A Boolean property that enables and disables the leftView from
	opening and closing. Defaults to true.
	*/
	@IBInspectable public var enabled: Bool {
		get {
			return enabledLeftView || enabledRightView
		}
		set(value) {
			if nil != leftView {
				enabledLeftView = value
			}
			if nil != rightView {
				enabledRightView = value
			}
		}
	}
	
	/**
	A Boolean property that enables and disables the leftView from
	opening and closing. Defaults to true.
	*/
	@IBInspectable public var enabledLeftView: Bool = true {
		didSet {
			if enabledLeftView {
				prepareLeftViewGestures()
			} else {
				removeLeftViewGestures()
			}
		}
	}
	
	/**
	A Boolean property that enables and disables the rightView from
	opening and closing. Defaults to true.
	*/
	@IBInspectable public var enabledRightView: Bool = true {
		didSet {
			if enabledRightView {
				prepareRightViewGestures()
			} else {
				removeRightViewGestures()
			}
		}
	}
	
	/**
	A Boolean property that triggers the status bar to be hidden
	when the leftView is opened. Defaults to true.
	*/
	@IBInspectable public var enableHideStatusbar: Bool = true
	
	/**
	A MaterialDepth property that is used to set the depth of the
	leftView when opened.
	*/
	public var depth: MaterialDepth = .Depth1
	
	/**
	A MaterialView property that is used to hide and reveal the
	leftViewController. It is very rare that this property will
	need to be accessed externally.
	*/
	public private(set) var leftView: MaterialView?
	
	/**
	A MaterialView property that is used to hide and reveal the
	rightViewController. It is very rare that this property will
	need to be accessed externally.
	*/
	public private(set) var rightView: MaterialView?
	
	/// Indicates whether the leftView or rightView is opened.
	public var opened: Bool {
		return openedLeftView || openedRightView
	}
	
	/// indicates if the leftView is opened.
	public var openedLeftView: Bool {
		guard nil != leftView else {
			return false
		}
		return leftView!.x != -leftViewWidth
	}
	
	/// Indicates if the rightView is opened.
	public var openedRightView: Bool {
		guard nil != rightView else {
			return false
		}
		return rightView!.x != MaterialDevice.width
	}
	
	/**
	A UIViewController property that references the active 
	main UIViewController. To swap the rootViewController, it 
	is recommended to use the transitionFromRootViewController
	helper method.
	*/
	public private(set) var rootViewController: UIViewController!
	
	/**
	A UIViewController property that references the 
	active left UIViewController.
	*/
	public private(set) var leftViewController: UIViewController?
	
	/**
	A UIViewController property that references the
	active right UIViewController.
	*/
	public private(set) var rightViewController: UIViewController?
	
	/**
	A CGFloat property to access the width that the leftView
	opens up to.
	*/
	@IBInspectable public private(set) var leftViewWidth: CGFloat!
	
	/**
	A CGFloat property to access the width that the rightView
	opens up to.
	*/
	@IBInspectable public private(set) var rightViewWidth: CGFloat!
	
	/**
	An initializer for the SideNavigationController.
	- Parameter rootViewController: The main UIViewController.
	- Parameter leftViewController: An Optional left UIViewController.
	- Parameter rightViewController: An Optional right UIViewController.
	*/
	public convenience init(rootViewController: UIViewController, leftViewController: UIViewController? = nil, rightViewController: UIViewController? = nil) {
		self.init()
		self.rootViewController = rootViewController
		self.leftViewController = leftViewController
		self.rightViewController = rightViewController
		prepareView()
	}
	
	public override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		layoutSubviews()
	}
	
	public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
		// Portrait will be Lanscape when this method is done.
		if MaterialDevice.isPortrait && .iPhone == MaterialDevice.type {
			hideStatusBar()
		} else {
			showStatusBar()
		}
		closeLeftView()
		closeRightView()
		
		// Ensures the view is hidden.
		if let v: MaterialView = rightView {
			v.position.x = size.width + v.width / 2
		}
	}
	
	public override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
		return statusBarUpdateAnimation
	}
	
	public override func prefersStatusBarHidden() -> Bool {
		return willHideStatusBar
	}
	
	public override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return statusBarStyle
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
			completion: { [unowned self] (result: Bool) in
				toViewController.didMoveToParentViewController(self)
				self.rootViewController.removeFromParentViewController()
				self.rootViewController = toViewController
				self.rootViewController.view.clipsToBounds = true
				self.rootViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
				self.view.sendSubviewToBack(self.rootViewController.view)
				completion?(result)
			})
	}
	
	/**
	A method that is used to set the width of the leftView when 
	opened. This is the recommended method of setting the leftView 
	width.
	- Parameter width: A CGFloat value to set as the new width.
	- Parameter hidden: A Boolean value of whether the leftView
	should be hidden after the width has been updated or not.
	- Parameter animated: A Boolean value that indicates to animate
	the leftView width change.
	*/
	public func setLeftViewWidth(width: CGFloat, hidden: Bool, animated: Bool, duration: NSTimeInterval = 0.5) {
		if let v: MaterialView = leftView {
			leftViewWidth = width
			
			var hide: Bool = hidden
			
			if openedRightView {
				hide = true
			}
			
			if animated {
				v.shadowPathAutoSizeEnabled = false
				
				if hide {
					UIView.animateWithDuration(duration,
						animations: { [unowned self] in
							v.bounds.size.width = width
							v.position.x = -width / 2
							self.rootViewController.view.alpha = 1
						}) { [unowned self] _ in
							v.shadowPathAutoSizeEnabled = true
							self.layoutSubviews()
							self.hideView(v)
						}
				} else {
					UIView.animateWithDuration(duration,
						animations: { [unowned self] in
							v.bounds.size.width = width
							v.position.x = width / 2
							self.rootViewController.view.alpha = 0.5
						}) { [unowned self] _ in
							v.shadowPathAutoSizeEnabled = true
							self.layoutSubviews()
							self.showView(v)
						}
				}
			} else {
				v.bounds.size.width = width
				if hide {
					hideView(v)
					v.position.x = -v.width / 2
					rootViewController.view.alpha = 1
				} else {
					v.shadowPathAutoSizeEnabled = false
					
					showView(v)
					v.position.x = width / 2
					rootViewController.view.alpha = 0.5
					v.shadowPathAutoSizeEnabled = true
				}
				layoutSubviews()
			}

		}
	}
	
	/**
	A method that is used to set the width of the rightView when
	opened. This is the recommended method of setting the rightView
	width.
	- Parameter width: A CGFloat value to set as the new width.
	- Parameter hidden: A Boolean value of whether the rightView
	should be hidden after the width has been updated or not.
	- Parameter animated: A Boolean value that indicates to animate
	the rightView width change.
	*/
	public func setRightViewWidth(width: CGFloat, hidden: Bool, animated: Bool, duration: NSTimeInterval = 0.5) {
		if let v: MaterialView = rightView {
			rightViewWidth = width
			
			var hide: Bool = hidden
			
			if openedLeftView {
				hide = true
			}
			
			if animated {
				v.shadowPathAutoSizeEnabled = false
				
				if hide {
					UIView.animateWithDuration(duration,
						animations: { [unowned self] in
							v.bounds.size.width = width
							v.position.x = self.view.bounds.width + width / 2
							self.rootViewController.view.alpha = 1
						}) { [unowned self] _ in
							v.shadowPathAutoSizeEnabled = true
							self.layoutSubviews()
							self.hideView(v)
						}
				} else {
					UIView.animateWithDuration(duration,
						animations: { [unowned self] in
							v.bounds.size.width = width
							v.position.x = self.view.bounds.width - width / 2
							self.rootViewController.view.alpha = 0.5
						}) { [unowned self] _ in
							v.shadowPathAutoSizeEnabled = true
							self.layoutSubviews()
							self.showView(v)
						}
				}
			} else {
				v.bounds.size.width = width
				if hide {
					hideView(v)
					v.position.x = view.bounds.width + v.width / 2
					rootViewController.view.alpha = 1
				} else {
					v.shadowPathAutoSizeEnabled = false
					
					showView(v)
					v.position.x = view.bounds.width - width / 2
					rootViewController.view.alpha = 0.5
					v.shadowPathAutoSizeEnabled = true
				}
				layoutSubviews()
			}
		}
	}
	
	/**
	A method that toggles the leftView opened if previously closed,
	or closed if previously opened.
	- Parameter velocity: A CGFloat value that sets the 
	velocity of the user interaction when animating the
	leftView. Defaults to 0.
	*/
	public func toggleLeftView(velocity: CGFloat = 0) {
		openedLeftView ? closeLeftView(velocity) : openLeftView(velocity)
	}
	
	/**
	A method that toggles the rightView opened if previously closed,
	or closed if previously opened.
	- Parameter velocity: A CGFloat value that sets the
	velocity of the user interaction when animating the
	leftView. Defaults to 0.
	*/
	public func toggleRightView(velocity: CGFloat = 0) {
		openedRightView ? closeRightView(velocity) : openRightView(velocity)
	}
	
	/**
	A method that opens the leftView.
	- Parameter velocity: A CGFloat value that sets the
	velocity of the user interaction when animating the
	leftView. Defaults to 0.
	*/
	public func openLeftView(velocity: CGFloat = 0) {
		if enabledLeftView {
			if let v: MaterialView = leftView {
				hideStatusBar()
				showView(v)
				userInteractionEnabled = false
				delegate?.sideNavigationWillOpen?(self, position: .Left)
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
					animations: {
						v.position.x = v.width / 2
						self.rootViewController.view.alpha = 0.5
					}) { [unowned self] _ in
						self.delegate?.sideNavigationDidOpen?(self, position: .Left)
					}
			}
		}
	}
	
	/**
	A method that opens the rightView.
	- Parameter velocity: A CGFloat value that sets the
	velocity of the user interaction when animating the
	leftView. Defaults to 0.
	*/
	public func openRightView(velocity: CGFloat = 0) {
		if enabledRightView {
			if let v: MaterialView = rightView {
				hideStatusBar()
				showView(v)
				userInteractionEnabled = false
				delegate?.sideNavigationWillOpen?(self, position: .Right)
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
					animations: { [unowned self] in
						v.position.x = self.view.bounds.width - v.width / 2
						self.rootViewController.view.alpha = 0.5
					}) { [unowned self] _ in
						self.delegate?.sideNavigationDidOpen?(self, position: .Right)
					}
			}
		}
	}
	
	/**
	A method that closes the leftView.
	- Parameter velocity: A CGFloat value that sets the
	velocity of the user interaction when animating the
	leftView. Defaults to 0.
	*/
	public func closeLeftView(velocity: CGFloat = 0) {
		if enabledLeftView {
			if let v: MaterialView = leftView {
				userInteractionEnabled = true
				delegate?.sideNavigationWillClose?(self, position: .Left)
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
					animations: { [unowned self] in
						v.position.x = -v.width / 2
						self.rootViewController.view.alpha = 1
					}) { [unowned self] _ in
						self.hideView(v)
						self.toggleStatusBar()
						self.delegate?.sideNavigationDidClose?(self, position: .Left)
					}
			}
		}
	}
	
	/**
	A method that closes the rightView.
	- Parameter velocity: A CGFloat value that sets the
	velocity of the user interaction when animating the
	leftView. Defaults to 0.
	*/
	public func closeRightView(velocity: CGFloat = 0) {
		if enabledRightView {
			if let v: MaterialView = rightView {
				showStatusBar()
				userInteractionEnabled = true
				delegate?.sideNavigationWillClose?(self, position: .Right)
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
					animations: { [unowned self] in
						v.position.x = self.view.bounds.width + v.width / 2
						self.rootViewController.view.alpha = 1
					}) { [unowned self] _ in
						self.hideView(v)
						self.toggleStatusBar()
						self.delegate?.sideNavigationDidClose?(self, position: .Right)
					}
			}
		}
	}
	
	/**
	Detects the gesture recognizer being used.
	- Parameter gestureRecognizer: A UIGestureRecognizer to detect.
	- Parameter touch: The UITouch event.
	- Returns: A Boolean of whether to continue the gesture or not.
	*/
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if !openedRightView && gestureRecognizer == panLeftViewGesture && (openedLeftView || isPointContainedWithinLeftThreshold(touch.locationInView(view))) && leftView != nil {
            return true
        }
        if !openedLeftView && gestureRecognizer == panRightViewGesture && (openedRightView || isPointContainedWithinRighThreshold(touch.locationInView(view))) && rightView != nil {
            return true
        }
        if openedLeftView && gestureRecognizer == tapLeftViewGesture {
            return true
        }
        if openedRightView && gestureRecognizer == tapRightViewGesture {
            return true
        }
        return false
    }
	
	/**
	A method that is fired when the pan gesture is recognized
	for the leftView.
	- Parameter recognizer: A UIPanGestureRecognizer that is
	passed to the handler when recognized.
	*/
	internal func handleLeftViewPanGesture(recognizer: UIPanGestureRecognizer) {
		if enabledLeftView && (openedLeftView || !openedRightView && isPointContainedWithinLeftThreshold(recognizer.locationInView(view))) {
			if let v: MaterialView = leftView {
				let point: CGPoint = recognizer.locationInView(view)
				
				// Animate the panel.
				switch recognizer.state {
				case .Began:
					originalX = v.position.x
					showView(v)
					delegate?.sideNavigationPanDidBegin?(self, point: point, position: .Left)
				case .Changed:
					let w: CGFloat = v.width
					let translationX: CGFloat = recognizer.translationInView(v).x
					
					v.position.x = originalX + translationX > (w / 2) ? (w / 2) : originalX + translationX
					
					let a: CGFloat = 1 - v.position.x / v.width
					rootViewController.view.alpha = 0.5 < a && v.position.x <= v.width / 2 ? a : 0.5
					
					if translationX >= leftThreshold {
						hideStatusBar()
					}
					
					delegate?.sideNavigationPanDidChange?(self, point: point, position: .Left)
				case .Ended, .Cancelled, .Failed:
					let p: CGPoint = recognizer.velocityInView(recognizer.view)
					let x: CGFloat = p.x >= 1000 || p.x <= -1000 ? p.x : 0
					
					delegate?.sideNavigationPanDidEnd?(self, point: point, position: .Left)
					
					if v.x <= -leftViewWidth + leftViewThreshold || x < -1000 {
						closeLeftView(x)
					} else {
						openLeftView(x)
					}
				case .Possible:break
				}
			}
		}
	}
	
	/**
	A method that is fired when the pan gesture is recognized
	for the rightView.
	- Parameter recognizer: A UIPanGestureRecognizer that is
	passed to the handler when recognized.
	*/
	internal func handleRightViewPanGesture(recognizer: UIPanGestureRecognizer) {
		if enabledRightView && (openedRightView || !openedLeftView && isPointContainedWithinRighThreshold(recognizer.locationInView(view))) {
			if let v: MaterialView = rightView {
				let point: CGPoint = recognizer.locationInView(view)
				
				// Animate the panel.
				switch recognizer.state {
				case .Began:
					originalX = v.position.x
					showView(v)
					delegate?.sideNavigationPanDidBegin?(self, point: point, position: .Right)
				case .Changed:
					let w: CGFloat = v.width
					let translationX: CGFloat = recognizer.translationInView(v).x
					
					v.position.x = originalX + translationX < view.bounds.width - (w / 2) ? view.bounds.width - (w / 2) : originalX + translationX
					
					let a: CGFloat = 1 - (view.bounds.width - v.position.x) / v.width
					rootViewController.view.alpha = 0.5 < a && v.position.x >= v.width / 2 ? a : 0.5
					
					if translationX <= view.bounds.width - rightThreshold {
						hideStatusBar()
					}
					
					delegate?.sideNavigationPanDidChange?(self, point: point, position: .Right)
				case .Ended, .Cancelled, .Failed:
					let p: CGPoint = recognizer.velocityInView(recognizer.view)
					let x: CGFloat = p.x >= 1000 || p.x <= -1000 ? p.x : 0
					
					delegate?.sideNavigationPanDidEnd?(self, point: point, position: .Right)
					
					if v.x >= rightViewThreshold || x > 1000 {
						closeRightView(x)
					} else {
						openRightView(x)
					}
				case .Possible:break
				}
			}
		}
	}
	
	/**
	A method that is fired when the tap gesture is recognized
	for the leftView.
	- Parameter recognizer: A UITapGestureRecognizer that is
	passed to the handler when recognized.
	*/
	internal func handleLeftViewTapGesture(recognizer: UITapGestureRecognizer) {
		if openedLeftView {
			if let v: MaterialView = leftView {
				delegate?.sideNavigationDidTap?(self, point: recognizer.locationInView(view), position: .Left)
				if enabledLeftView && openedLeftView && !isPointContainedWithinView(v, point: recognizer.locationInView(v)) {
					closeLeftView()
				}
			}
		}
	}
	
	/**
	A method that is fired when the tap gesture is recognized
	for the rightView.
	- Parameter recognizer: A UITapGestureRecognizer that is
	passed to the handler when recognized.
	*/
	internal func handleRightViewTapGesture(recognizer: UITapGestureRecognizer) {
		if openedRightView {
			if let v: MaterialView = rightView {
				delegate?.sideNavigationDidTap?(self, point: recognizer.locationInView(view), position: .Right)
				if enabledRightView && openedRightView && !isPointContainedWithinView(v, point: recognizer.locationInView(v)) {
					closeRightView()
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
		prepareRootViewController()
		prepareLeftView()
		prepareRightView()
		prepareLeftViewController()
		prepareRightViewController()
		prepareLeftViewGestures()
		prepareRightViewGestures()
	}
	
	/// A method that prepares the rootViewController.
	private func prepareRootViewController() {
		rootViewController.view.clipsToBounds = true
        rootViewController.view.frame = view.bounds
		rootViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		prepareViewControllerWithinContainer(rootViewController, container: view)
	}
	
	/// A method that prepares the leftViewController.
	private func prepareLeftViewController() {
		if let v: MaterialView = leftView {
			leftViewController?.view.clipsToBounds = true
			leftViewController?.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
			prepareViewControllerWithinContainer(leftViewController, container: v)
		}
	}
	
	/// A method that prepares the rightViewController.
	private func prepareRightViewController() {
		if let v: MaterialView = rightView {
			rightViewController?.view.clipsToBounds = true
			leftViewController?.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
			prepareViewControllerWithinContainer(rightViewController, container: v)
		}
	}
	
	/// A method that prepares the leftView.
	private func prepareLeftView() {
		if nil == leftViewController {
			enabledLeftView = false
		} else {
			leftViewWidth = .iPhone == MaterialDevice.type ? 280 : 320
			leftView = MaterialView()
			leftView!.frame = CGRectMake(0, 0, leftViewWidth, view.frame.height)
			leftView!.backgroundColor = MaterialColor.clear
			view.addSubview(leftView!)
			
			leftView!.hidden = true
			leftView!.position.x = -leftViewWidth / 2
			leftView!.zPosition = 2000
		}
	}
	
	/// A method that prepares the leftView.
	private func prepareRightView() {
		if nil == rightViewController {
			enabledRightView = false
		} else {
			rightViewWidth = .iPhone == MaterialDevice.type ? 280 : 320
			rightView = MaterialView()
			rightView!.frame = CGRectMake(0, 0, rightViewWidth, view.frame.height)
			rightView!.backgroundColor = MaterialColor.clear
			view.addSubview(rightView!)
			
			rightView!.hidden = true
			rightView!.position.x = view.bounds.width + rightViewWidth / 2
			rightView!.zPosition = 2000
		}
	}
	
	/**
	A method that adds the passed in controller as a child of 
	the SideNavigationController within the passed in 
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
	
	/// A method that prepares the gestures used within the leftView.
	private func prepareLeftViewGestures() {
		if nil == panLeftViewGesture {
			panLeftViewGesture = UIPanGestureRecognizer(target: self, action: #selector(handleLeftViewPanGesture(_:)))
			panLeftViewGesture!.delegate = self
			view.addGestureRecognizer(panLeftViewGesture!)
		}
		
		if nil == tapLeftViewGesture {
			tapLeftViewGesture = UITapGestureRecognizer(target: self, action: #selector(handleLeftViewTapGesture(_:)))
			tapLeftViewGesture!.delegate = self
			tapLeftViewGesture!.cancelsTouchesInView = false
			view.addGestureRecognizer(tapLeftViewGesture!)
		}
	}
	
	/// A method that prepares the gestures used within the rightView.
	private func prepareRightViewGestures() {
		if nil == panRightViewGesture {
			panRightViewGesture = UIPanGestureRecognizer(target: self, action: #selector(handleRightViewPanGesture(_:)))
			panRightViewGesture!.delegate = self
			view.addGestureRecognizer(panRightViewGesture!)
		}
		
		if nil == tapRightViewGesture {
			tapRightViewGesture = UITapGestureRecognizer(target: self, action: #selector(handleRightViewTapGesture(_:)))
			tapRightViewGesture!.delegate = self
			tapRightViewGesture!.cancelsTouchesInView = false
			view.addGestureRecognizer(tapRightViewGesture!)
		}
	}
	
	/// A method that removes the passed in pan and leftView tap gesture recognizers.
	private func removeLeftViewGestures() {
		if let v: UIPanGestureRecognizer = panLeftViewGesture {
			view.removeGestureRecognizer(v)
			panLeftViewGesture = nil
		}
		if let v: UITapGestureRecognizer = tapLeftViewGesture {
			view.removeGestureRecognizer(v)
			tapLeftViewGesture = nil
		}
	}
	
	/// A method that removes the passed in pan and rightView tap gesture recognizers.
	private func removeRightViewGestures() {
		if let v: UIPanGestureRecognizer = panRightViewGesture {
			view.removeGestureRecognizer(v)
			panRightViewGesture = nil
		}
		if let v: UITapGestureRecognizer = tapRightViewGesture {
			view.removeGestureRecognizer(v)
			tapRightViewGesture = nil
		}
	}
	
	/// Shows the statusBar.
	private func showStatusBar() {
		if statusBarHidden {
			willHideStatusBar = false
			UIView.animateWithDuration(NSTimeInterval(UINavigationControllerHideShowBarDuration),
				animations: { [weak self] in
					self?.setNeedsStatusBarAppearanceUpdate()
					self?.statusBarHidden = false
				})
			delegate?.sideNavigationStatusBarHiddenState?(self, hidden: false)
		}
	}
	
	/// Hides the statusBar.
	private func hideStatusBar() {
		if enableHideStatusbar {
			willHideStatusBar = true
			if !statusBarHidden {
				UIView.animateWithDuration(NSTimeInterval(UINavigationControllerHideShowBarDuration),
					animations: { [weak self] in
						self?.setNeedsStatusBarAppearanceUpdate()
						self?.statusBarHidden = true
					})
				delegate?.sideNavigationStatusBarHiddenState?(self, hidden: true)
			}
		}
	}
	
	/// Toggles the statusBar
	private func toggleStatusBar() {
		if opened || MaterialDevice.isLandscape && .iPhone == MaterialDevice.type {
			hideStatusBar()
		} else {
			showStatusBar()
		}
	}
	
	/**
	A method that determines whether the passed point is
	contained within the bounds of the leftViewThreshold
	and height of the SideNavigationController view frame
	property.
	- Parameter point: A CGPoint to test against.
	- Returns: A Boolean of the result, true if yes, false 
	otherwise.
	*/
	private func isPointContainedWithinLeftThreshold(point: CGPoint) -> Bool {
		return point.x <= leftThreshold
	}
	
	/**
	A method that determines whether the passed point is
	contained within the bounds of the rightViewThreshold
	and height of the SideNavigationController view frame
	property.
	- Parameter point: A CGPoint to test against.
	- Returns: A Boolean of the result, true if yes, false
	otherwise.
	*/
	private func isPointContainedWithinRighThreshold(point: CGPoint) -> Bool {
		return point.x >= view.bounds.width - rightThreshold
	}
	
	/**
	A method that determines whether the passed in point is
	contained within the bounds of the passed in container view.
	- Parameter container: A UIView that sets the bounds to test
	against.
	- Parameter point: A CGPoint to test whether or not it is 
	within the bounds of the container parameter.
	- Returns: A Boolean of the result, true if yes, false
	otherwise.
	*/
	private func isPointContainedWithinView(container: UIView, point: CGPoint) -> Bool {
		return CGRectContainsPoint(container.bounds, point)
	}
	
	/**
	A method that shows a view.
	- Parameter container: A container view.
	*/
	private func showView(container: MaterialView) {
		container.depth = depth
		container.hidden = false
	}
	
	/**
	A method that hides a view.
	- Parameter container: A container view.
	*/
	private func hideView(container: MaterialView) {
		container.depth = .None
		container.hidden = true
	}
	
	/// Layout subviews.
	private func layoutSubviews() {
		if let v: MaterialView = leftView {
			v.width = leftViewWidth
			v.height = view.bounds.height
			leftViewThreshold = leftViewWidth / 2
			if let vc: UIViewController = leftViewController {
				vc.view.frame.size.width = v.width
				vc.view.frame.size.height = v.height
				vc.view.center = CGPointMake(v.width / 2, v.height / 2)
			}
		}
		
		if let v: MaterialView = rightView {
			v.width = rightViewWidth
			v.height = view.bounds.height
			rightViewThreshold = view.bounds.width - rightViewWidth / 2
			if let vc: UIViewController = rightViewController {
				vc.view.frame.size.width = v.width
				vc.view.frame.size.height = v.height
				vc.view.center = CGPointMake(v.width / 2, v.height / 2)
			}
		}
	}
}