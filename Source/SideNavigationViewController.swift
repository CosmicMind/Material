//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

public extension UIViewController {
	/**
		:name:	sideNavigationViewController
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

@objc(SideNavigationViewController)
public class SideNavigationViewController: UIViewController, UIGestureRecognizerDelegate {
	//
	//	:name:	originalPosition
	//
	private lazy var originalPosition: CGPoint = CGPointZero
	
	//
	//	:name:	sidePanGesture
	//
	internal var sidePanGesture: UIPanGestureRecognizer?
	
	//
	//	:name:	sideTapGesture
	//
	internal var sideTapGesture: UITapGestureRecognizer?
	
	//
	//	:name:	isViewBasedAppearance
	//
	internal var isViewBasedAppearance: Bool {
		return 0 == NSBundle.mainBundle().objectForInfoDictionaryKey("UIViewControllerBasedStatusBarAppearance") as? Int
	}
	
	/**
		:name:	userInteractionEnabled
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
		:name:	horizontalThreshold
	*/
	public lazy var horizontalThreshold: CGFloat = 0
	
	/**
		:name:	animationDuration
	*/
	public lazy var animationDuration: CGFloat = 0.25
	
	/**
		:name:	enabled
	*/
	public lazy var enabled: Bool = true
	
	/**
		:name:	hideStatusBar
	*/
	public lazy var hideStatusBar: Bool = true
	
	/**
		:name:	enableShadowDepth
	*/
	public var enableShadowDepth: Bool = true {
		didSet {
			if !enableShadowDepth {
				sideView.shadowDepth = .None
			}
		}
	}
	
	/**
		:name:	shadowDepth
	*/
	public var shadowDepth: MaterialDepth = .Depth2 {
		didSet {
			if !enableShadowDepth && .None != sideView.shadowDepth {
				sideView.shadowDepth = shadowDepth
			}
		}
	}
	
	/**
		:name:	backdropLayer
	*/
	public private(set) lazy var backdropLayer: CAShapeLayer = CAShapeLayer()
	
	/**
		:name:	sideView
	*/
	public private(set) lazy var sideView: MaterialView = MaterialView()
	
	/**
		:name:	backdropOpacity
	*/
	public var backdropOpacity: CGFloat = 0.5 {
		didSet {
			backdropLayer.backgroundColor = backdropColor?.colorWithAlphaComponent(backdropOpacity).CGColor
		}
	}
	
	/**
		:name:	backdropColor
	*/
	public var backdropColor: UIColor? {
		didSet {
			backdropLayer.backgroundColor = backdropColor?.colorWithAlphaComponent(backdropOpacity).CGColor
		}
	}
	
	/**
		:name:	opened
	*/
	public var opened: Bool {
		return sideView.x != -sideViewControllerWidth
	}
	
	/**
		:name:	maintViewController
	*/
	public var mainViewController: UIViewController!
	
	/**
		:name:	sideViewController
	*/
	public var sideViewController: UIViewController!
	
	/**
		:name:	sideViewControllerWidth
	*/
	public private(set) var sideViewControllerWidth: CGFloat = 240
	
	/**
		:name:	init
	*/
	public convenience init(mainViewController: UIViewController, sideViewController: UIViewController) {
		self.init()
		self.mainViewController = mainViewController
		self.sideViewController = sideViewController
		prepareView()
		prepareMainView()
		prepareSideView()
	}
	
	/**
		:name:	viewWillLayoutSubviews
	*/
	public override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		layoutBackdropLayer()
		horizontalThreshold = sideViewControllerWidth / 2
		sideView.width = sideViewControllerWidth
		sideView.height = view.bounds.height
		sideViewController.view.frame.size.width = sideView.width
		sideViewController.view.frame.size.height = sideView.height
		sideViewController.view.center = CGPointMake(sideView.width / 2, sideView.height / 2)
	}
	
	/**
		:name:	setSideViewControllerWidth
	*/
	public func setSideViewControllerWidth(width: CGFloat, hidden: Bool, animated: Bool) {
		sideViewControllerWidth = width
		
		let w: CGFloat = (hidden ? -width : width) / 2
		
		if animated {
			MaterialAnimation.animateWithDuration(0.25, animations: {
				self.sideView.width = width
				self.sideView.position.x = w
			}) {
					self.userInteractionEnabled = false
			}
		} else {
			MaterialAnimation.animationDisabled {
				self.sideView.width = width
				self.sideView.position.x = w
			}
		}
	}
	
	/**
		:name:	toggle
	*/
	public func toggle(velocity: CGFloat = 0) {
		opened ? close(velocity) : open(velocity)
	}
	
	/**
		:name:	open
	*/
	public func open(velocity: CGFloat = 0) {
		toggleStatusBar(true)
		backdropLayer.hidden = false
		MaterialAnimation.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(sideView.x / velocity)))),
		animations: {
			self.sideView.position = CGPointMake(self.sideView.width / 2, self.sideView.height / 2)
		}) {
			self.userInteractionEnabled = false
			if self.enableShadowDepth {
				self.sideView.shadowDepth = self.shadowDepth
			}
		}
	}
	
	/**
		:name:	close
	*/
	public func close(velocity: CGFloat = 0) {
		toggleStatusBar(false)
		backdropLayer.hidden = true
		MaterialAnimation.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(sideView.x / velocity)))),
		animations: {
			self.sideView.position = CGPointMake(-self.sideView.width / 2, self.sideView.height / 2)
		}) {
			self.userInteractionEnabled = true
			if self.enableShadowDepth {
				self.sideView.shadowDepth = .None
			}
		}
	}
	
	/**
		:name:	gestureRecognizer
	*/
	public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		if !enabled {
			return false
		}
		if gestureRecognizer == sidePanGesture {
			return gesturePanSideViewController(gestureRecognizer, withTouchPoint: touch.locationInView(view))
		}
		if gestureRecognizer == sideTapGesture {
			return opened && !isPointContainedWithinViewController(sideView, point: touch.locationInView(view))
		}
		return false
	}
	
	/**
		:name:	prepareGestures
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
	
	//
	//	:name:	prepareView
	//
	internal func prepareView() {
		prepareBackdropLayer()
	}
	
	//
	//	:name:	prepareMainView
	//
	internal func prepareMainView() {
		prepareViewControllerWithinContainer(mainViewController, container: view)
		mainViewController.view.frame = view.bounds
	}
	
	//
	//	:name:	prepareSideView
	//
	internal func prepareSideView() {
		// container
		sideView.frame = CGRectMake(0, 0, sideViewControllerWidth, view.frame.height)
		sideView.backgroundColor = MaterialColor.clear
		view.addSubview(sideView)
		
		MaterialAnimation.animationDisabled {
			self.sideView.position.x = -self.sideViewControllerWidth / 2
			self.sideView.zPosition = 1000
		}
		
		sideViewController.view.clipsToBounds = true
		prepareViewControllerWithinContainer(sideViewController, container: sideView)
		
		// gestures
		prepareGestures()
	}
	
	//
	//	:name:	handlePanGesture
	//
	internal func handlePanGesture(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .Began:
			if enableShadowDepth {
				sideView.shadowDepth = shadowDepth
			}
			backdropLayer.hidden = false
			originalPosition = sideView.position
			toggleStatusBar(true)
		case .Changed:
			let translation: CGPoint = recognizer.translationInView(sideView)
			let w: CGFloat = sideView.width
			MaterialAnimation.animationDisabled {
				self.sideView.position.x = self.originalPosition.x + translation.x > (w / 2) ? (w / 2) : self.originalPosition.x + translation.x
			}
		case .Ended, .Cancelled, .Failed:
			let point: CGPoint = recognizer.velocityInView(recognizer.view)
			let x: CGFloat = point.x >= 1000 || point.x <= -1000 ? point.x : 0
			if sideView.x <= CGFloat(floor(-sideViewControllerWidth)) + horizontalThreshold || point.x <= -1000 {
				close(x)
			} else {
				open(x)
			}
		case .Possible:break
		}
	}
	
	//
	//	:name:	handleTapGesture
	//
	internal func handleTapGesture(recognizer: UIPanGestureRecognizer) {
		if opened {
			close()
		}
	}
	
	//
	//	:name:	removeGestures
	//
	private func removeGestures(inout pan: UIPanGestureRecognizer?, inout tap: UITapGestureRecognizer?) {
		if let g = pan {
			view.removeGestureRecognizer(g)
			pan = nil
		}
		if let g = tap {
			view.removeGestureRecognizer(g)
			tap = nil
		}
	}
	
	//
	//	:name:	toggleStatusBar
	//
	private func toggleStatusBar(hide: Bool = false) {
		if hideStatusBar {
			if isViewBasedAppearance {
				UIApplication.sharedApplication().setStatusBarHidden(hide, withAnimation: .Slide)
			} else {
				dispatch_async(dispatch_get_main_queue(), {
					if let w = UIApplication.sharedApplication().keyWindow {
						w.windowLevel = hide ? UIWindowLevelStatusBar + 1 : 0
					}
				})
			}
		}
	}
	
	//
	//	:name:	removeViewController
	//
	private func removeViewController(controller: UIViewController) {
		controller.willMoveToParentViewController(nil)
		controller.view.removeFromSuperview()
		controller.removeFromParentViewController()
	}
	
	//
	//	:name:	gesturePanSideViewController
	//
	private func gesturePanSideViewController(gesture: UIGestureRecognizer, withTouchPoint point: CGPoint) -> Bool {
		return opened || enabled && isLeftPointContainedWithinRect(point)
	}
	
	//
	//	:name:	isLeftPointContainedWithinRect
	//
	private func isLeftPointContainedWithinRect(point: CGPoint) -> Bool {
		return CGRectContainsPoint(CGRectMake(0, 0, horizontalThreshold, view.frame.height), point)
	}
	
	//
	//	:name:	isPointContainedWithinViewController
	//
	private func isPointContainedWithinViewController(container: UIView, point: CGPoint) -> Bool {
		return CGRectContainsPoint(container.frame, point)
	}
	
	//
	//	:name:	prepareBackdropLayer
	//
	private func prepareBackdropLayer() {
		backdropColor = MaterialColor.black
		backdropLayer.zPosition = 900
		backdropLayer.hidden = true
		view.layer.addSublayer(backdropLayer)
	}
	
	//
	//	:name:	layoutBackdropLayer
	//
	private func layoutBackdropLayer() {
		MaterialAnimation.animationDisabled {
			self.backdropLayer.frame = self.view.bounds
		}
	}
	
	//
	//	:name:	prepareViewControllerWithinContainer
	//
	private func prepareViewControllerWithinContainer(controller: UIViewController, container: UIView) {
		addChildViewController(controller)
		container.addSubview(controller.view)
		controller.didMoveToParentViewController(self)
	}
	
	//
	//	:name:	prepareGestures
	//
	private func prepareGestures() {
		removeGestures(&sidePanGesture, tap: &sideTapGesture)
		prepareGestures(&sidePanGesture, panSelector: "handlePanGesture:", tap: &sideTapGesture, tapSelector: "handleTapGesture:")
	}
}