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
	/**
	A CGFloat property that is used internally to track
	the original (x) position of the container view when panning.
	*/
	private var originalX: CGFloat = 0
	
	/**
	A UIPanGestureRecognizer property internally used for the
	pan gesture.
	*/
	internal private(set) var panGesture: UIPanGestureRecognizer?
	
	/**
	A UITapGestureRecognizer property internally used for the 
	tap gesture.
	*/
	internal private(set) var tapGesture: UITapGestureRecognizer?
	
	/**
	A CGFloat property that accesses the leftView threshold of
	the SideNavigationController. When the panning gesture has
	ended, if the position is beyond the threshold,
	the leftView is opened, if it is below the threshold, the
	leftView is closed. The leftViewThreshold is always at half
	the width of the leftView.
	*/
	@IBInspectable public var leftThreshold: CGFloat?
	private var leftViewThreshold: CGFloat = 0
	
	/**
	A CGFloat property that accesses the rightView threshold of
	the SideNavigationController. When the panning gesture has
	ended, if the position is beyond the threshold,
	the rightView is closed, if it is below the threshold, the
	rightView is opened. The rightViewThreshold is always at half
	the width of the rightView.
	*/
	@IBInspectable public var rightThreshold: CGFloat?
	private var rightViewThreshold: CGFloat = 0
	
	/**
	A SideNavigationControllerDelegate property used to bind
	the delegation object.
	*/
	public weak var delegate: SideNavigationControllerDelegate?
	
	/**
	A Boolean property used to enable and disable interactivity
	with the mainViewController.
	*/
	@IBInspectable public var userInteractionEnabled: Bool {
		get {
			return mainViewController.view.userInteractionEnabled
		}
		set(value) {
			mainViewController.view.userInteractionEnabled = value
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
	@IBInspectable public var enabledLeftView: Bool = true
	
	/**
	A Boolean property that enables and disables the rightView from
	opening and closing. Defaults to true.
	*/
	@IBInspectable public var enabledRightView: Bool = true
	
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
	main UIViewController. To swap the mainViewController, it 
	is recommended to use the transitionFromMainViewController
	helper method.
	*/
	public private(set) var mainViewController: UIViewController!
	
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
	- Parameter mainViewController: The main UIViewController.
	- Parameter leftViewController: An Optional left UIViewController.
	- Parameter rightViewController: An Optional right UIViewController.
	*/
	public convenience init(mainViewController: UIViewController, leftViewController: UIViewController? = nil, rightViewController: UIViewController? = nil) {
		self.init()
		self.mainViewController = mainViewController
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
		if !MaterialDevice.landscape && .iPhone == MaterialDevice.type {
			hideStatusBar()
		} else {
			showStatusBar()
		}
		if let v: MaterialView = rightView {
			v.x = size.width - (openedRightView ? rightViewWidth : 0)
		}
	}
	
	/**
	A method to swap mainViewController objects.
	- Parameter toViewController: The UIViewController to swap 
	with the active mainViewController.
	- Parameter duration: A NSTimeInterval that sets the
	animation duration of the transition.
	- Parameter options: UIViewAnimationOptions thst are used 
	when animating the transition from the active mainViewController
	to the toViewController.
	- Parameter animations: An animation block that is executed during
	the transition from the active mainViewController
	to the toViewController.
	- Parameter completion: A completion block that is execited after
	the transition animation from the active mainViewController
	to the toViewController has completed.
	*/
	public func transitionFromMainViewController(toViewController: UIViewController, duration: NSTimeInterval = 0.5, options: UIViewAnimationOptions = [], animations: (() -> Void)? = nil, completion: ((Bool) -> Void)? = nil) {
		mainViewController.willMoveToParentViewController(nil)
		addChildViewController(toViewController)
		toViewController.view.frame = mainViewController.view.frame
		transitionFromViewController(mainViewController,
			toViewController: toViewController,
			duration: duration,
			options: options,
			animations: animations,
			completion: { [unowned self] (result: Bool) in
				toViewController.didMoveToParentViewController(self)
				self.mainViewController.removeFromParentViewController()
				self.mainViewController = toViewController
				self.view.sendSubviewToBack(self.mainViewController.view)
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
	public func setLeftViewWidth(width: CGFloat, var hidden: Bool, animated: Bool, duration: NSTimeInterval = 0.5) {
		if let v: MaterialView = leftView {
			leftViewWidth = width
			
			if openedRightView {
				hidden = true
			}
			
			if animated {
				v.shadowPathAutoSizeEnabled = false
				
				if hidden {
					UIView.animateWithDuration(duration,
						animations: { [unowned self] in
							v.bounds.size.width = width
							v.position.x = -width / 2
							self.mainViewController.view.alpha = 1
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
							self.mainViewController.view.alpha = 0.5
						}) { [unowned self] _ in
							v.shadowPathAutoSizeEnabled = true
							self.layoutSubviews()
							self.showView(v)
						}
				}
			} else {
				v.bounds.size.width = width
				if hidden {
					hideView(v)
					v.position.x = -v.width / 2
					mainViewController.view.alpha = 1
				} else {
					v.shadowPathAutoSizeEnabled = false
					
					showView(v)
					v.position.x = width / 2
					mainViewController.view.alpha = 0.5
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
	public func setRightViewWidth(width: CGFloat, var hidden: Bool, animated: Bool, duration: NSTimeInterval = 0.5) {
		if let v: MaterialView = rightView {
			rightViewWidth = width
			
			if openedLeftView {
				hidden = true
			}
			
			if animated {
				v.shadowPathAutoSizeEnabled = false
				
				if hidden {
					UIView.animateWithDuration(duration,
						animations: { [unowned self] in
							v.bounds.size.width = width
							v.position.x = self.view.bounds.width + width / 2
							self.mainViewController.view.alpha = 1
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
							self.mainViewController.view.alpha = 0.5
						}) { [unowned self] _ in
							v.shadowPathAutoSizeEnabled = true
							self.layoutSubviews()
							self.showView(v)
						}
				}
			} else {
				v.bounds.size.width = width
				if hidden {
					hideView(v)
					v.position.x = view.bounds.width + v.width / 2
					mainViewController.view.alpha = 1
				} else {
					v.shadowPathAutoSizeEnabled = false
					
					showView(v)
					v.position.x = view.bounds.width - width / 2
					mainViewController.view.alpha = 0.5
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
				
				delegate?.sideNavigationWillOpen?(self, position: .Left)
				mainViewController.view.alpha = 0.5
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
					animations: {
						v.position.x = v.width / 2
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
				
				delegate?.sideNavigationWillOpen?(self, position: .Right)
				mainViewController.view.alpha = 0.5
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
					animations: { [unowned self] in
						v.position.x = self.view.bounds.width - v.width / 2
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
				delegate?.sideNavigationWillClose?(self, position: .Left)
				mainViewController.view.alpha = 1
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
					animations: {
						v.position.x = -v.width / 2
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
				delegate?.sideNavigationWillClose?(self, position: .Right)
				mainViewController.view.alpha = 1
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
					animations: { [unowned self] in
						v.position.x = self.view.bounds.width + v.width / 2
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
		if gestureRecognizer == panGesture {
			return opened || isPointContainedWithinLeftViewThreshold(touch.locationInView(view)) || isPointContainedWithinRightViewThreshold(touch.locationInView(view))
		}
		return opened && gestureRecognizer == tapGesture
	}
	
	/**
	A method that is fired when the pan gesture is recognized
	for the SideNavigationController.
	- Parameter recognizer: A UIPanGestureRecognizer that is
	passed to the handler when recognized.
	*/
	internal func handlePanGesture(recognizer: UIPanGestureRecognizer) {
		// Deterine which view to pan.
		if enabledRightView && (openedRightView || !openedLeftView && isPointContainedWithinRightViewThreshold(recognizer.locationInView(view))) {
			if let v: MaterialView = rightView {
				let point: CGPoint = recognizer.locationInView(view)
				
				// Animate the panel.
				switch recognizer.state {
				case .Began:
					originalX = v.position.x
					
					hideStatusBar()
					showView(v)
					
					delegate?.sideNavigationPanDidBegin?(self, point: point, position: .Right)
				case .Changed:
					let w: CGFloat = v.width
					let translationX: CGFloat = recognizer.translationInView(v).x
					
					v.position.x = originalX + translationX < view.bounds.width - (w / 2) ? view.bounds.width - (w / 2) : originalX + translationX
					
					let a: CGFloat = 1 - (view.bounds.width - v.position.x) / v.width
					mainViewController.view.alpha = 0.5 < a ? a : 0.5
					
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
		} else if enabledLeftView && (openedLeftView || !openedRightView && isPointContainedWithinLeftViewThreshold(recognizer.locationInView(view))) {
			if let v: MaterialView = leftView {
				let point: CGPoint = recognizer.locationInView(view)
				
				// Animate the panel.
				switch recognizer.state {
				case .Began:
					originalX = v.position.x
					
					hideStatusBar()
					showView(v)
					
					delegate?.sideNavigationPanDidBegin?(self, point: point, position: .Left)
				case .Changed:
					let w: CGFloat = v.width
					let translationX: CGFloat = recognizer.translationInView(v).x
					
					v.position.x = originalX + translationX > (w / 2) ? (w / 2) : originalX + translationX
					
					let a: CGFloat = 1 - v.position.x / v.width
					mainViewController.view.alpha = 0.5 < a ? a : 0.5
					
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
	A method that is fired when the tap gesture is recognized
	for the SideNavigationController.
	- Parameter recognizer: A UITapGestureRecognizer that is
	passed to the handler when recognized.
	*/
	internal func handleTapGesture(recognizer: UITapGestureRecognizer) {
		if openedLeftView {
			if let v: MaterialView = leftView {
				delegate?.sideNavigationDidTap?(self, point: recognizer.locationInView(view), position: .Left)
				if enabledLeftView && openedLeftView && !isPointContainedWithinView(v, point: recognizer.locationInView(v)) {
					closeLeftView()
				}
			}
		}
		if openedRightView {
			if let v: MaterialView = rightView {
				delegate?.sideNavigationDidTap?(self, point: recognizer.locationInView(view), position: .Right)
				if enabledRightView && openedRightView && !isPointContainedWithinView(v, point: recognizer.locationInView(v)) {
					closeRightView()
				}
			}
		}
	}
	
	/// A method that generally prepares the SideNavigationController.
	private func prepareView() {
		prepareMainViewController()
		prepareLeftView()
		prepareRightView()
		prepareLeftViewController()
		prepareRightViewController()
		prepareGestures()
	}
	
	/// A method that prepares the mainViewController.
	private func prepareMainViewController() {
		prepareViewControllerWithinContainer(mainViewController, container: view)
		mainViewController.view.frame = view.bounds
	}
	
	/// A method that prepares the leftViewController.
	private func prepareLeftViewController() {
		if let v: MaterialView = leftView {
			leftViewController?.view.clipsToBounds = true
			prepareViewControllerWithinContainer(leftViewController, container: v)
		}
	}
	
	/// A method that prepares the rightViewController.
	private func prepareRightViewController() {
		if let v: MaterialView = rightView {
			rightViewController?.view.clipsToBounds = true
			prepareViewControllerWithinContainer(rightViewController, container: v)
		}
	}
	
	/// A method that prepares the leftView.
	private func prepareLeftView() {
		if nil != leftViewController {
			leftViewWidth = .iPhone == MaterialDevice.type ? 280 : 320
			leftView = MaterialView()
			leftView!.frame = CGRectMake(0, 0, leftViewWidth, view.frame.height)
			leftView!.backgroundColor = MaterialColor.clear
			view.addSubview(leftView!)
			
			leftView!.hidden = true
			leftView!.position.x = -leftViewWidth / 2
			leftView!.zPosition = 2000
		} else {
			enabledLeftView = false
		}
	}
	
	/// A method that prepares the leftView.
	private func prepareRightView() {
		if nil != rightViewController {
			rightViewWidth = .iPhone == MaterialDevice.type ? 280 : 320
			rightView = MaterialView()
			rightView!.frame = CGRectMake(0, 0, rightViewWidth, view.frame.height)
			rightView!.backgroundColor = MaterialColor.clear
			view.addSubview(rightView!)
			
			rightView!.hidden = true
			rightView!.position.x = view.bounds.width + rightViewWidth / 2
			rightView!.zPosition = 2000
		} else {
			enabledRightView = false
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
			v.didMoveToParentViewController(self)
		}
	}
	
	/**
	A method that prepares the gestures used within the 
	SideNavigationController.
	*/
	private func prepareGestures() {
		if nil == panGesture {
			panGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
			panGesture!.delegate = self
			view.addGestureRecognizer(panGesture!)
		}
		
		if nil == tapGesture {
			tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
			tapGesture!.delegate = self
			tapGesture!.cancelsTouchesInView = false
			view.addGestureRecognizer(tapGesture!)
		}
	}
	
	/**
	A method that removes the passed in pan and tap gesture 
	recognizers.
	*/
	private func removeGestures() {
		if let v: UIPanGestureRecognizer = panGesture {
			view.removeGestureRecognizer(v)
			panGesture = nil
		}
		if let v: UITapGestureRecognizer = tapGesture {
			view.removeGestureRecognizer(v)
			tapGesture = nil
		}
	}
	
	/// Shows the statusBar.
	private func showStatusBar() {
		userInteractionEnabled = false
		UIView.animateWithDuration(NSTimeInterval(UINavigationControllerHideShowBarDuration),
			animations: { [weak self] in
				self?.setNeedsStatusBarAppearanceUpdate()
				MaterialDevice.statusBarHidden = false
			}) { [weak self] _ in
				if false == self?.opened {
					self?.userInteractionEnabled = true
				}
			}
		delegate?.sideNavigationStatusBarHiddenState?(self, hidden: false)
	}
	
	/// Hides the statusBar.
	private func hideStatusBar() {
		if enableHideStatusbar {
			userInteractionEnabled = false
			UIView.animateWithDuration(NSTimeInterval(UINavigationControllerHideShowBarDuration),
				animations: { [weak self] in
					self?.setNeedsStatusBarAppearanceUpdate()
					MaterialDevice.statusBarHidden = true
				}) { [weak self] _ in
					if false == self?.opened {
						self?.userInteractionEnabled = true
					}
				}
			delegate?.sideNavigationStatusBarHiddenState?(self, hidden: true)
		}
	}
	
	/// Toggles the statusBar
	private func toggleStatusBar() {
		if opened || MaterialDevice.landscape && .iPhone == MaterialDevice.type {
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
	private func isPointContainedWithinLeftViewThreshold(point: CGPoint) -> Bool {
		return point.x <= leftViewThreshold
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
	private func isPointContainedWithinRightViewThreshold(point: CGPoint) -> Bool {
		return point.x >= rightViewThreshold
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
		userInteractionEnabled = false
		container.depth = depth
		container.hidden = false
	}
	
	/**
	A method that hides a view.
	- Parameter container: A container view.
	*/
	private func hideView(container: MaterialView) {
		userInteractionEnabled = true
		container.depth = .None
		container.hidden = true
	}
	
	/// Layout subviews.
	private func layoutSubviews() {
		toggleStatusBar()
		
		if let v: MaterialView = leftView {
			v.width = leftViewWidth
			v.height = view.bounds.height
			leftViewThreshold = nil == leftThreshold ? leftViewWidth / 2 : leftThreshold!
			if let vc: UIViewController = leftViewController {
				vc.view.frame.size.width = v.width
				vc.view.frame.size.height = v.height
				vc.view.center = CGPointMake(v.width / 2, v.height / 2)
			}
		}
		
		if let v: MaterialView = rightView {
			v.width = rightViewWidth
			v.height = view.bounds.height
			rightViewThreshold = nil == rightThreshold ? view.bounds.width - rightViewWidth / 2 : view.bounds.width - rightThreshold!
			if let vc: UIViewController = rightViewController {
				vc.view.frame.size.width = v.width
				vc.view.frame.size.height = v.height
				vc.view.center = CGPointMake(v.width / 2, v.height / 2)
			}
		}
	}
}