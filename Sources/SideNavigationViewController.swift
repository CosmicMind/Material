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
	optional func sideNavigationViewWillOpen(sideNavigationViewController: SideNavigationViewController)
	
	/**
	An optional delegation method that is fired after the
	SideNavigationViewController opened.
	*/
	optional func sideNavigationViewDidOpen(sideNavigationViewController: SideNavigationViewController)
	
	/**
	An optional delegation method that is fired before the
	SideNavigationViewController closes.
	*/
	optional func sideNavigationViewWillClose(sideNavigationViewController: SideNavigationViewController)
	
	/**
	An optional delegation method that is fired after the
	SideNavigationViewController closed.
	*/
	optional func sideNavigationViewDidClose(sideNavigationViewController: SideNavigationViewController)
	
	/**
	An optional delegation method that is fired when the
	SideNavigationViewController pan gesture begins.
	*/
	optional func sideNavigationViewPanDidBegin(sideNavigationViewController: SideNavigationViewController, point: CGPoint)
	
	/**
	An optional delegation method that is fired when the
	SideNavigationViewController pan gesture changes position.
	*/
	optional func sideNavigationViewPanDidChange(sideNavigationViewController: SideNavigationViewController, point: CGPoint)
	
	/**
	An optional delegation method that is fired when the
	SideNavigationViewController pan gesture ends.
	*/
	optional func sideNavigationViewPanDidEnd(sideNavigationViewController: SideNavigationViewController, point: CGPoint)
	
	/**
	An optional delegation method that is fired when the
	SideNavigationViewController tap gesture begins.
	*/
	optional func sideNavigationViewDidTap(sideNavigationViewController: SideNavigationViewController, point: CGPoint)
}

@objc(SideNavigationViewController)
public class SideNavigationViewController: UIViewController, UIGestureRecognizerDelegate {
	/**
	A CGPoint property that is used internally to track
	the original position of the sideView when panning began.
	*/
	private var originalPosition: CGPoint = CGPointZero
	
	/**
	A UIPanGestureRecognizer property internally used for the
	pan gesture.
	*/
	private var sidePanGesture: UIPanGestureRecognizer?
	
	/**
	A UITapGestureRecognizer property internally used for the 
	tap gesture.
	*/
	private var sideTapGesture: UITapGestureRecognizer?
	
	/**
	A CAShapeLayer property that is used as the backdrop when 
	opened. To change the opacity and color of the backdrop, 
	it is recommended to use the backdropOpcaity property and 
	backdropColor property, respectively.
	*/
	public private(set) lazy var backdropLayer: CAShapeLayer = CAShapeLayer()
	
	/**
	A CGFloat property that accesses the horizontal threshold of
	the SideNavigationViewController. When the panning gesture has
	ended, if the position is beyond the horizontal threshold,
	the sideView is opened, if it is below the threshold, the
	sideView is closed. The horizontal threshold is always at half
	the width of the sideView.
	*/
	public private(set) var horizontalThreshold: CGFloat = 0
	
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
	sideView when closing and opening. Defaults to 0.25.
	*/
	public var animationDuration: CGFloat = 0.25
	
	/**
	A Boolean property that enables and disables the sideView from
	opening and closing. Defaults to true.
	*/
	public var enabled: Bool = true {
		didSet {
			if enabled {
				removeGestures(&sidePanGesture, tap: &sideTapGesture)
				prepareGestures(&sidePanGesture, panSelector: "handlePanGesture:", tap: &sideTapGesture, tapSelector: "handleTapGesture:")
			} else {
				removeGestures(&sidePanGesture, tap: &sideTapGesture)
			}
		}
	}
	
	/**
	A Boolean property that triggers the status bar to be hidden
	when the sideView is opened. Defaults to true.
	*/
	public var hideStatusBar: Bool = true
	
	/**
	A MaterialDepth property that is used to set the depth of the
	sideView when opened.
	*/
	public var depth: MaterialDepth = .Depth2
	
	/**
	A MaterialView property that is used to hide and reveal the
	sideViewController. It is very rare that this property will 
	need to be accessed externally.
	*/
	public private(set) var sideView: MaterialView!
	
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
	
	/**
	A Boolean property that indicates whether the sideView 
	is opened.
	*/
	public var opened: Bool {
		return sideView.x != -sideViewWidth
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
	active side UIViewController.
	*/
	public private(set) var sideViewController: UIViewController!
	
	/**
	A CGFloat property to access the width the sideView
	opens up to.
	*/
	public private(set) var sideViewWidth: CGFloat = 240
	
	/**
	An initializer for the SideNavigationViewController.
	- Parameter mainViewController: The main UIViewController.
	- Parameter sideViewController: The side UIViewController.
	*/
	public convenience init(mainViewController: UIViewController, sideViewController: UIViewController) {
		self.init()
		self.mainViewController = mainViewController
		self.sideViewController = sideViewController
		prepareView()
	}
	
	public override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		MaterialAnimation.animationDisabled { [unowned self] in
			self.backdropLayer.frame = self.view.bounds
			self.sideView.width = self.sideViewWidth
			self.sideView.height = self.view.bounds.height
		}
		horizontalThreshold = sideViewWidth / 2
		sideViewController.view.frame.size.width = sideView.width
		sideViewController.view.frame.size.height = sideView.height
		sideViewController.view.center = CGPointMake(sideView.width / 2, sideView.height / 2)
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
			completion: { [unowned self, mainViewController = self.mainViewController] (result: Bool) in
				mainViewController.removeFromParentViewController()
				toViewController.didMoveToParentViewController(self)
				self.mainViewController = toViewController
				self.userInteractionEnabled = !self.opened
				completion?(result)
		})
	}
	
	/**
	A method that is used to set the width of the sideView when 
	opened. This is the recommended method of setting the sideView 
	width.
	- Parameter width: A CGFloat value to set as the new width.
	- Parameter hidden: A Boolean value of whether the sideView
	should be hidden after the width has been updated or not.
	- Parameter animated: A Boolean value that indicates to animate
	the sideView width change.
	*/
	public func setSideViewWidth(width: CGFloat, hidden: Bool, animated: Bool) {
		let w: CGFloat = (hidden ? -width : width) / 2
		sideViewWidth = width
		
		if animated {
			MaterialAnimation.animateWithDuration(0.25, animations: { [unowned self] in
				self.sideView.width = width
				self.sideView.position.x = w
			}) { [unowned self] in
				self.userInteractionEnabled = false
			}
		} else {
			MaterialAnimation.animationDisabled { [unowned self] in
				self.sideView.width = width
				self.sideView.position.x = w
			}
		}
	}
	
	/**
	A method that toggles the sideView opened if previously closed, 
	or closed if previously opened.
	- Parameter velocity: A CGFloat value that sets the 
	velocity of the user interaction when animating the
	sideView. Defaults to 0.
	*/
	public func toggle(velocity: CGFloat = 0) {
		opened ? close(velocity) : open(velocity)
	}
	
	/**
	A method that opens the sideView.
	- Parameter velocity: A CGFloat value that sets the
	velocity of the user interaction when animating the
	sideView. Defaults to 0.
	*/
	public func open(velocity: CGFloat = 0) {
		toggleStatusBar(true)
		backdropLayer.hidden = false
		
		delegate?.sideNavigationViewWillOpen?(self)
		
		MaterialAnimation.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(sideView.x / velocity)))),
		animations: { [unowned self] in
			self.sideView.position = CGPointMake(self.sideView.width / 2, self.sideView.height / 2)
		}) { [unowned self] in
			self.userInteractionEnabled = false
			self.showSideViewDepth()
			self.delegate?.sideNavigationViewDidOpen?(self)
		}
	}
	
	/**
	A method that closes the sideView.
	- Parameter velocity: A CGFloat value that sets the
	velocity of the user interaction when animating the
	sideView. Defaults to 0.
	*/
	public func close(velocity: CGFloat = 0) {
		toggleStatusBar(false)
		backdropLayer.hidden = true
		
		delegate?.sideNavigationViewWillClose?(self)
		
		MaterialAnimation.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(sideView.x / velocity)))),
		animations: { [unowned self] in
			self.sideView.position = CGPointMake(-self.sideView.width / 2, self.sideView.height / 2)
		}) { [unowned self] in
			self.userInteractionEnabled = true
			self.hideSideViewDepth()
			self.delegate?.sideNavigationViewDidClose?(self)
		}
	}
	
	public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		if enabled {
			if gestureRecognizer == sidePanGesture {
				return opened || enabled && isPointContainedWithinRect(touch.locationInView(view))
			}
			if opened && gestureRecognizer == sideTapGesture {
				let point: CGPoint = touch.locationInView(view)
				delegate?.sideNavigationViewDidTap?(self, point: point)
				return !isPointContainedWithinViewController(sideView, point: point)
			}
		}
		return false
	}
	
	/**
	A method that is fired when the pan gesture is recognized
	for the SideNavigationViewController.
	- Parameter recognizer: A UIPanGestureRecognizer that is
	passed to the handler when recognized.
	*/
	internal func handlePanGesture(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .Began:
			backdropLayer.hidden = false
			originalPosition = sideView.position
			toggleStatusBar(true)
			showSideViewDepth()
			delegate?.sideNavigationViewPanDidBegin?(self, point: sideView.position)
		case .Changed:
			let translation: CGPoint = recognizer.translationInView(sideView)
			let w: CGFloat = sideView.width
			
			MaterialAnimation.animationDisabled { [unowned self] in
				self.sideView.position.x = self.originalPosition.x + translation.x > (w / 2) ? (w / 2) : self.originalPosition.x + translation.x
				self.delegate?.sideNavigationViewPanDidChange?(self, point: self.sideView.position)
			}
		case .Ended, .Cancelled, .Failed:
			let point: CGPoint = recognizer.velocityInView(recognizer.view)
			let x: CGFloat = point.x >= 1000 || point.x <= -1000 ? point.x : 0
			
			delegate?.sideNavigationViewPanDidEnd?(self, point: sideView.position)
			
			if sideView.x <= CGFloat(floor(-sideViewWidth)) + horizontalThreshold || point.x <= -1000 {
				close(x)
			} else {
				open(x)
			}
		case .Possible:break
		}
	}
	
	/**
	A method that is fired when the tap gesture is recognized
	for the SideNavigationViewController.
	- Parameter recognizer: A UITapGestureRecognizer that is
	passed to the handler when recognized.
	*/
	internal func handleTapGesture(recognizer: UITapGestureRecognizer) {
		if opened {
			close()
		}
	}
	
	/**
	A method that generally prepares the SideNavigationViewController.
	*/
	private func prepareView() {
		prepareBackdropLayer()
		prepareMainViewController()
		prepareSideView()
	}
	
	/**
	A method that prepares the mainViewController.
	*/
	private func prepareMainViewController() {
		prepareViewControllerWithinContainer(mainViewController, container: view)
		mainViewController.view.frame = view.bounds
	}
	
	/**
	A method that prepares the sideViewController.
	*/
	private func prepareSideViewController() {
		sideViewController.view.clipsToBounds = true
		prepareViewControllerWithinContainer(sideViewController, container: sideView)
	}
	
	/**
	A method that prepares the sideView.
	*/
	private func prepareSideView() {
		sideView = MaterialView()
		sideView.frame = CGRectMake(0, 0, sideViewWidth, view.frame.height)
		sideView.backgroundColor = MaterialColor.clear
		view.addSubview(sideView)
		
		MaterialAnimation.animationDisabled { [unowned self] in
			self.sideView.position.x = -self.sideViewWidth / 2
			self.sideView.zPosition = 1000
		}
		
		prepareSideViewController()
		removeGestures(&sidePanGesture, tap: &sideTapGesture)
		prepareGestures(&sidePanGesture, panSelector: "handlePanGesture:", tap: &sideTapGesture, tapSelector: "handleTapGesture:")
	}
	
	/**
	A method that prepares the backdropLayer.
	*/
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
	- Parameter controller: A UIViewController to add as a child.
	- Parameter container: A UIView that is the parent of the 
	passed in controller view within the view hierarchy.
	*/
	private func prepareViewControllerWithinContainer(controller: UIViewController, container: UIView) {
		addChildViewController(controller)
		container.addSubview(controller.view)
		controller.didMoveToParentViewController(self)
	}
	
	/**
	A method that prepares the gestures used within the 
	SideNavigationViewController.
	- Parameter pan: A UIPanGestureRecognizer that is used to 
	recognize pan gestures.
	- Parameter panSelector: A Selector that is fired when the
	pan gesture is recognized.
	- Parameter tap: A UITapGestureRecognizer that is used to 
	recognize tap gestures.
	- Parameter tapSelector: A Selector that is fired when the
	tap gesture is recognized.
	*/
	private func prepareGestures(inout pan: UIPanGestureRecognizer?, panSelector: Selector, inout tap: UITapGestureRecognizer?, tapSelector: Selector) {
		if nil == pan {
			pan = UIPanGestureRecognizer(target: self, action: panSelector)
			pan!.delegate = self
			view.addGestureRecognizer(pan!)
		}
		if nil == tap {
			tap = UITapGestureRecognizer(target: self, action: tapSelector)
			tap!.delegate = self
			view.addGestureRecognizer(tap!)
		}
	}
	
	/**
	A method that removes the passed in pan and tap gesture 
	recognizers.
	- Parameter pan: A UIPanGestureRecognizer that should be 
	removed from the SideNavigationViewController.
	- Parameter tap: A UITapGestureRecognizer that should be 
	removed from the SideNavigationViewController.
	*/
	private func removeGestures(inout pan: UIPanGestureRecognizer?, inout tap: UITapGestureRecognizer?) {
		if let v: UIPanGestureRecognizer = pan {
			view.removeGestureRecognizer(v)
			pan = nil
		}
		if let v: UITapGestureRecognizer = tap {
			view.removeGestureRecognizer(v)
			tap = nil
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
	contained within the bounds of the horizontalThreshold
	and height of the SideNavigationViewController view frame
	property.
	- Parameter point: A CGPoint to test against.
	- Returns: A Boolean of the result, true if yes, false 
	otherwise.
	*/
	private func isPointContainedWithinRect(point: CGPoint) -> Bool {
		return CGRectContainsPoint(CGRectMake(0, 0, horizontalThreshold, view.frame.height), point)
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
	private func isPointContainedWithinViewController(container: UIView, point: CGPoint) -> Bool {
		return CGRectContainsPoint(container.frame, point)
	}
	
	/**
	A method that adds the depth to the sideView depth property.
	*/
	private func showSideViewDepth() {
		MaterialAnimation.animationDisabled { [unowned self] in
			self.sideView.depth = self.depth
		}
	}
	
	/**
	A method that removes the depth from the sideView depth 
	property.
	*/
	private func hideSideViewDepth() {
		MaterialAnimation.animationDisabled { [unowned self] in
			self.sideView.depth = .None
		}
	}
}