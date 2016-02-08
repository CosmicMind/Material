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
	A convenience property that provides access to the SideNavigationViewController. 
	This is the recommended method of accessing the SideNavigationViewController
	through child UIViewControllers.
	*/
	public var sideNavigationViewController: SideNavigationViewController? {
		var viewController: UIViewController? = self
		while nil != viewController {
			if viewController is SideNavigationViewController {
				return viewController as? SideNavigationViewController
			}
			viewController = viewController?.parentViewController
		}
		return nil
	}
}

@objc(SideNavigationViewControllerDelegate)
public protocol SideNavigationViewControllerDelegate {
	/**
	An optional delegation method that is fired before the 
	SideNavigationViewController opens.
	*/
	optional func sideNavigationViewWillOpen(sideNavigationViewController: SideNavigationViewController, position: SideNavigationPosition)
	
	/**
	An optional delegation method that is fired after the
	SideNavigationViewController opened.
	*/
	optional func sideNavigationViewDidOpen(sideNavigationViewController: SideNavigationViewController, position: SideNavigationPosition)
	
	/**
	An optional delegation method that is fired before the
	SideNavigationViewController closes.
	*/
	optional func sideNavigationViewWillClose(sideNavigationViewController: SideNavigationViewController, position: SideNavigationPosition)
	
	/**
	An optional delegation method that is fired after the
	SideNavigationViewController closed.
	*/
	optional func sideNavigationViewDidClose(sideNavigationViewController: SideNavigationViewController, position: SideNavigationPosition)
	
	/**
	An optional delegation method that is fired when the
	SideNavigationViewController pan gesture begins.
	*/
	optional func sideNavigationViewPanDidBegin(sideNavigationViewController: SideNavigationViewController, point: CGPoint, position: SideNavigationPosition)
	
	/**
	An optional delegation method that is fired when the
	SideNavigationViewController pan gesture changes position.
	*/
	optional func sideNavigationViewPanDidChange(sideNavigationViewController: SideNavigationViewController, point: CGPoint, position: SideNavigationPosition)
	
	/**
	An optional delegation method that is fired when the
	SideNavigationViewController pan gesture ends.
	*/
	optional func sideNavigationViewPanDidEnd(sideNavigationViewController: SideNavigationViewController, point: CGPoint, position: SideNavigationPosition)
	
	/**
	An optional delegation method that is fired when the
	SideNavigationViewController tap gesture executes.
	*/
	optional func sideNavigationViewDidTap(sideNavigationViewController: SideNavigationViewController, point: CGPoint, position: SideNavigationPosition)
}

@objc(SideNavigationViewController)
public class SideNavigationViewController: UIViewController, UIGestureRecognizerDelegate {
	/**
	A CGFloat property that is used internally to track
	the original (x) position of the container view when panning.
	*/
	private var originalX: CGFloat = 0
	
	/**
	A UIPanGestureRecognizer property internally used for the
	pan gesture.
	*/
	private var panGesture: UIPanGestureRecognizer?
	
	/**
	A UITapGestureRecognizer property internally used for the 
	tap gesture.
	*/
	private var tapGesture: UITapGestureRecognizer?
	
	/**
	A CAShapeLayer property that is used as the backdrop when 
	opened. To change the opacity and color of the backdrop, 
	it is recommended to use the backdropOpcaity property and 
	backdropColor property, respectively.
	*/
	public private(set) lazy var backdropLayer: CAShapeLayer = CAShapeLayer()
	
	/**
	A CGFloat property that accesses the leftView threshold of
	the SideNavigationViewController. When the panning gesture has
	ended, if the position is beyond the threshold,
	the leftView is opened, if it is below the threshold, the
	leftView is closed. The leftViewThreshold is always at half
	the width of the leftView.
	*/
	public private(set) var leftViewThreshold: CGFloat = 0
	
	/**
	A CGFloat property that accesses the rightView threshold of
	the SideNavigationViewController. When the panning gesture has
	ended, if the position is beyond the threshold,
	the rightView is closed, if it is below the threshold, the
	rightView is opened. The rightViewThreshold is always at half
	the width of the rightView.
	*/
	public private(set) var rightViewThreshold: CGFloat = 0
	
	/**
	A SideNavigationViewControllerDelegate property used to bind
	the delegation object.
	*/
	public weak var delegate: SideNavigationViewControllerDelegate?
	
	/**
	A Boolean property used to enable and disable interactivity
	with the mainViewController.
	*/
	public var userInteractionEnabled: Bool {
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
	public var animationDuration: CGFloat = 0.25
	
	/**
	A Boolean property that enables and disables the leftView from
	opening and closing. Defaults to true.
	*/
	public var enabled: Bool {
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
	public var enabledLeftView: Bool = false {
		didSet {
			if enabledLeftView {
				prepareGestures(panSelector: "handlePanGesture:", tapSelector: "handleTapGesture:")
			} else if !enabledRightView {
				removeGestures()
			}
		}
	}
	
	/**
	A Boolean property that enables and disables the rightView from
	opening and closing. Defaults to true.
	*/
	public var enabledRightView: Bool = false {
		didSet {
			if enabledRightView {
				prepareGestures(panSelector: "handlePanGesture:", tapSelector: "handleTapGesture:")
			} else if !enabledLeftView {
				removeGestures()
			}
		}
	}
	
	/**
	A Boolean property that triggers the status bar to be hidden
	when the leftView is opened. Defaults to true.
	*/
	public var hideStatusBar: Bool = true
	
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
	
	/// A CGFloat property to set the backdropLayer color opacity.
	public var backdropOpacity: CGFloat = 0.5 {
		didSet {
			backdropLayer.backgroundColor = backdropColor?.colorWithAlphaComponent(backdropOpacity).CGColor
		}
	}
	
	/// A UIColor property to set the backdropLayer color.
	public var backdropColor: UIColor? {
		didSet {
			backdropLayer.backgroundColor = backdropColor?.colorWithAlphaComponent(backdropOpacity).CGColor
		}
	}
	
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
		return rightView!.x != view.bounds.width
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
	public private(set) var leftViewWidth: CGFloat = 240
	
	/**
	A CGFloat property to access the width that the rightView
	opens up to.
	*/
	public private(set) var rightViewWidth: CGFloat = 240
	
	/**
	An initializer for the SideNavigationViewController.
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
	
	public override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		if let v: MaterialView = rightView {
			v.x = view.bounds.height - (openedRightView ? rightViewWidth : 0)
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
	public func transitionFromMainViewController(toViewController: UIViewController, duration: NSTimeInterval, options: UIViewAnimationOptions, animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
		mainViewController.willMoveToParentViewController(nil)
		addChildViewController(toViewController)
		toViewController.view.frame = view.bounds
		transitionFromViewController(mainViewController,
			toViewController: toViewController,
			duration: duration,
			options: options,
			animations: animations,
			completion: { [unowned self] (result: Bool) in
				toViewController.didMoveToParentViewController(self)
				self.mainViewController.removeFromParentViewController()
				self.mainViewController = toViewController
				self.userInteractionEnabled = !self.opened
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
			layoutSubviews()
			
			if openedRightView {
				hidden = true
			} else {
				backdropLayer.hidden = hidden
			}
			
			if animated {
				if hidden {
					UIView.animateWithDuration(duration,
						animations: {
							v.width = width
							v.position = CGPointMake(-width / 2, v.height / 2)
						}) { _ in
							self.userInteractionEnabled = true
							self.hideDepth(v)
							self.hideView(v)
						}
				} else {
					showView(v)
					UIView.animateWithDuration(duration,
						animations: {
							v.width = width
							v.position = CGPointMake(width / 2, v.height / 2)
						}) { _ in
							self.userInteractionEnabled = true
							self.showDepth(v)
						}
				}
			} else {
				v.width = width
				if hidden {
					hideView(v)
					v.position = CGPointMake(-v.width / 2, v.height / 2)
					hideDepth(v)
				} else {
					showView(v)
					v.position = CGPointMake(v.width / 2, v.height / 2)
					showDepth(v)
				}
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
			layoutSubviews()
			
			if openedLeftView {
				hidden = true
			} else {
				backdropLayer.hidden = hidden
			}
			
			if animated {
				if hidden {
					UIView.animateWithDuration(duration,
						animations: {
							v.width = width
							v.position = CGPointMake(self.view.bounds.width + width / 2, v.height / 2)
						}) { _ in
							self.userInteractionEnabled = true
							self.hideDepth(v)
							self.hideView(v)
						}
				} else {
					showView(v)
					UIView.animateWithDuration(duration,
						animations: {
							v.width = width
							v.position = CGPointMake(self.view.bounds.width - width / 2, v.height / 2)
						}) { _ in
							self.userInteractionEnabled = true
							self.showDepth(v)
						}
				}
			} else {
				v.width = width
				if hidden {
					hideView(v)
					v.position = CGPointMake(self.view.bounds.width + v.width / 2, v.height / 2)
					hideDepth(v)
				} else {
					showView(v)
					v.position = CGPointMake(self.view.bounds.width - v.width / 2, v.height / 2)
					showDepth(v)
				}
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
				toggleStatusBar(true)
				showView(v)
				
				backdropLayer.hidden = false
				
				delegate?.sideNavigationViewWillOpen?(self, position: .Left)
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
				animations: {
					v.position = CGPointMake(v.width / 2, v.height / 2)
				}) { _ in
					self.userInteractionEnabled = false
					self.showDepth(v)
					self.delegate?.sideNavigationViewDidOpen?(self, position: .Left)
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
				toggleStatusBar(true)
				showView(v)
				
				backdropLayer.hidden = false
				
				delegate?.sideNavigationViewWillOpen?(self, position: .Right)
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
					animations: {
						v.position = CGPointMake(self.view.bounds.width - v.width / 2, v.height / 2)
				}) { _ in
					self.userInteractionEnabled = false
					self.showDepth(v)
					self.delegate?.sideNavigationViewDidOpen?(self, position: .Right)
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
			toggleStatusBar(false)
			backdropLayer.hidden = true
			
			if let v: MaterialView = leftView {
				delegate?.sideNavigationViewWillClose?(self, position: .Left)
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
				animations: {
					v.position = CGPointMake(-v.width / 2, v.height / 2)
				}) { _ in
					self.userInteractionEnabled = true
					self.hideDepth(v)
					self.hideView(v)
					self.delegate?.sideNavigationViewDidClose?(self, position: .Left)
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
			toggleStatusBar(false)
			backdropLayer.hidden = true
			
			if let v: MaterialView = rightView {
				delegate?.sideNavigationViewWillClose?(self, position: .Right)
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
				animations: {
					v.position = CGPointMake(self.view.bounds.width + v.width / 2, v.height / 2)
				}) { _ in
					self.userInteractionEnabled = true
					self.hideDepth(v)
					self.hideView(v)
					self.delegate?.sideNavigationViewDidClose?(self, position: .Right)
				}
			}
		}
	}
	
	public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		if gestureRecognizer == panGesture {
			return opened || isPointContainedWithinLeftViewThreshold(touch.locationInView(view)) || isPointContainedWithinRightViewThreshold(touch.locationInView(view))
		}
		return opened && gestureRecognizer == tapGesture
	}
	
	/**
	A method that is fired when the pan gesture is recognized
	for the SideNavigationViewController.
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
					backdropLayer.hidden = false
					originalX = v.position.x
					
					toggleStatusBar(true)
					showView(v)
					
					delegate?.sideNavigationViewPanDidBegin?(self, point: point, position: .Right)
				case .Changed:
					let w: CGFloat = v.width
					let translationX: CGFloat = recognizer.translationInView(v).x
					
					v.position.x = originalX + translationX < view.bounds.width - (w / 2) ? view.bounds.width - (w / 2) : originalX + translationX
					delegate?.sideNavigationViewPanDidChange?(self, point: point, position: .Right)
				case .Ended, .Cancelled, .Failed:
					let p: CGPoint = recognizer.velocityInView(recognizer.view)
					let x: CGFloat = p.x >= 1000 || p.x <= -1000 ? p.x : 0
					
					delegate?.sideNavigationViewPanDidEnd?(self, point: point, position: .Right)
					
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
					backdropLayer.hidden = false
					originalX = v.position.x
					
					toggleStatusBar(true)
					showView(v)
					
					delegate?.sideNavigationViewPanDidBegin?(self, point: point, position: .Left)
				case .Changed:
					let w: CGFloat = v.width
					let translationX: CGFloat = recognizer.translationInView(v).x
					
					v.position.x = originalX + translationX > (w / 2) ? (w / 2) : originalX + translationX
					delegate?.sideNavigationViewPanDidChange?(self, point: point, position: .Left)
				case .Ended, .Cancelled, .Failed:
					let p: CGPoint = recognizer.velocityInView(recognizer.view)
					let x: CGFloat = p.x >= 1000 || p.x <= -1000 ? p.x : 0
					
					delegate?.sideNavigationViewPanDidEnd?(self, point: point, position: .Left)
					
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
	for the SideNavigationViewController.
	- Parameter recognizer: A UITapGestureRecognizer that is
	passed to the handler when recognized.
	*/
	internal func handleTapGesture(recognizer: UITapGestureRecognizer) {
		if openedLeftView {
			if let v: MaterialView = leftView {
				delegate?.sideNavigationViewDidTap?(self, point: recognizer.locationInView(view), position: .Left)
				if enabledLeftView && openedLeftView && !isPointContainedWithinView(v, point: recognizer.locationInView(v)) {
					closeLeftView()
				}
			}
		}
		if openedRightView {
			if let v: MaterialView = rightView {
				delegate?.sideNavigationViewDidTap?(self, point: recognizer.locationInView(view), position: .Right)
				if enabledRightView && openedRightView && !isPointContainedWithinView(v, point: recognizer.locationInView(v)) {
					closeRightView()
				}
			}
		}
	}
	
	/// A method that generally prepares the SideNavigationViewController.
	private func prepareView() {
		prepareBackdropLayer()
		prepareMainViewController()
		prepareLeftView()
		prepareRightView()
		prepareLeftViewController()
		prepareRightViewController()
		enabled = true
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
			leftView = MaterialView()
			leftView!.frame = CGRectMake(0, 0, leftViewWidth, view.frame.height)
			leftView!.backgroundColor = MaterialColor.clear
			view.addSubview(leftView!)
			
			leftView!.hidden = true
			leftView!.position.x = -leftViewWidth / 2
			leftView!.zPosition = 1000
		} else {
			enabledLeftView = false
		}
	}
	
	/// A method that prepares the leftView.
	private func prepareRightView() {
		if nil != rightViewController {
			rightView = MaterialView()
			rightView!.frame = CGRectMake(0, 0, rightViewWidth, view.frame.height)
			rightView!.backgroundColor = MaterialColor.clear
			view.addSubview(rightView!)
			
			rightView!.hidden = true
			rightView!.position.x = view.bounds.width + rightViewWidth / 2
			rightView!.zPosition = 1000
		} else {
			enabledRightView = false
		}
	}
	
	/// A method that prepares the backdropLayer.
	private func prepareBackdropLayer() {
		backdropColor = MaterialColor.black
		backdropLayer.zPosition = 900
		backdropLayer.hidden = true
		view.layer.addSublayer(backdropLayer)
	}
	
	/**
	A method that adds the passed in controller as a child of 
	the SideNavigationViewController within the passed in 
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
	SideNavigationViewController.
	- Parameter panSelector: A Selector that is fired when the
	pan gesture is recognized.
	- Parameter tapSelector: A Selector that is fired when the
	tap gesture is recognized.
	*/
	private func prepareGestures(panSelector panSelector: Selector, tapSelector: Selector) {
		if nil == panGesture {
			panGesture = UIPanGestureRecognizer(target: self, action: panSelector)
			panGesture!.delegate = self
			view.addGestureRecognizer(panGesture!)
		}
		
		if nil == tapGesture {
			tapGesture = UITapGestureRecognizer(target: self, action: tapSelector)
			tapGesture!.cancelsTouchesInView = false
			tapGesture!.delegate = self
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
	
	/**
	A method to toggle the status bar from a reveal state to 
	hidden state. The hideStatusBar property needs to be set 
	to true in order for this method to have any affect.
	- Parameter hide: A Boolean indicating to show or hide
	the status bar.
	*/
	private func toggleStatusBar(hide: Bool = false) {
		if hideStatusBar {
			UIApplication.sharedApplication().statusBarHidden = hide
		}
	}
	
	/**
	A method that determines whether the passed point is
	contained within the bounds of the leftViewThreshold
	and height of the SideNavigationViewController view frame
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
	and height of the SideNavigationViewController view frame
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
	A method that adds the depth to the passed in container view.
	- Parameter container: A container view.
	*/
	private func showDepth(container: MaterialView) {
		container.depth = depth
	}
	
	/**
	A method that removes the depth from the passed in container view.
	- Parameter container: A container view.
	*/
	private func hideDepth(container: MaterialView) {
		container.depth = .None
	}
	
	/**
	A method that shows a view.
	- Parameter container: A container view.
	*/
	private func showView(container: UIView) {
		container.hidden = false
	}
	
	/**
	A method that hides a view.
	- Parameter container: A container view.
	*/
	private func hideView(container: UIView) {
		container.hidden = true
	}
	
	/// Layout subviews.
	private func layoutSubviews() {
		MaterialAnimation.animationDisabled { [unowned self] in
			self.backdropLayer.frame = self.view.bounds
		}
		
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