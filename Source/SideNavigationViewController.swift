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
	public lazy var horizontalThreshold: CGFloat = 64
	
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
		:name:	backdropLayer
	*/
	public private(set) lazy var backdropLayer: CAShapeLayer = CAShapeLayer()
	
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
		return sideView.position.x == sideViewControllerWidth / 2
	}
	
	/**
		:name:	sideView
	*/
	public private(set) var sideView: MaterialView = MaterialView()
	
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
	public var sideViewControllerWidth: CGFloat = 240 {
		didSet {
			horizontalThreshold = sideViewControllerWidth / 2
			layoutSideView()
		}
	}
	
	/**
		:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
		:name:	init
	*/
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	/**
		:name:	init
	*/
	public convenience init(mainViewController: UIViewController, sideViewController: UIViewController) {
		self.init()
		self.mainViewController = mainViewController
		self.sideViewController = sideViewController
		prepareView()
	}
	
	//
	//	:name:	viewDidLoad
	//
	public override func viewDidLoad() {
		super.viewDidLoad()
		edgesForExtendedLayout = .None
	}

	public override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		layoutBackdropLayer()
		layoutSideView()
	}
	
	/**
		:name:	toggleSideViewContainer
	*/
	public func toggleSideViewContainer(velocity: CGFloat = 0) {
		opened ? close(velocity) : open(velocity)
	}
	
	/**
		:name:	open
	*/
	public func open(velocity: CGFloat = 0) {
		toggleStatusBar(true)
		MaterialAnimation.animationWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(sideView.x / velocity)))),
		animations: {
			self.sideView.position.x = self.sideViewControllerWidth / 2
			self.backdropLayer.hidden = false
		}) {
			self.userInteractionEnabled = false
		}
	}
	
	/**
		:name:	close
	*/
	public func close(velocity: CGFloat = 0) {
		toggleStatusBar(false)
		MaterialAnimation.animationWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(sideView.x / velocity)))),
		animations: {
			self.sideView.position.x = -self.sideViewControllerWidth / 2
			self.backdropLayer.hidden = true
		}) {
			self.userInteractionEnabled = true
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
	
	//
	//	:name:	prepareView
	//
	internal func prepareView() {
		backdropColor = MaterialColor.black
		prepareBackdropLayer()
		prepareMainView()
		prepareSideView()
	}
	
	//
	//	:name:	prepareMainView
	//
	internal func prepareMainView() {
		prepareViewControllerWithinContainer(mainViewController, container: view)
		mainViewController.view.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignToParent(view, child: mainViewController.view)
	}
	
	//
	//	:name:	prepareSideView
	//
	internal func prepareSideView() {
		MaterialAnimation.animationDisabled {
			self.sideView.frame = CGRectMake(0, 0, self.sideViewControllerWidth, self.view.bounds.height)
			self.sideView.position = CGPointMake(-self.sideViewControllerWidth / 2, self.view.bounds.height / 2)
		}
		sideView.backgroundColor = MaterialColor.blue.accent3
		sideView.zPosition = 1000
		view.addSubview(sideView)
		prepareLeftGestures()
		prepareViewControllerWithinContainer(sideViewController, container: sideView)
	}
	
	//
	//	:name:	layoutSideView
	//
	internal func layoutSideView() {
		MaterialAnimation.animationDisabled {
			self.sideView.width = self.sideViewControllerWidth
			self.sideView.height = self.view.bounds.height
			self.sideView.position = CGPointMake((self.opened ? 1 : -1) * self.sideViewControllerWidth / 2, self.view.bounds.height / 2)
//			self.sideViewController.view.frame = self.sideView.bounds
		}
	}
	
	//
	//	:name:	handlePanGesture
	//
	internal func handlePanGesture(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .Began:
			toggleStatusBar(true)
			originalPosition = sideView.position
			backdropLayer.hidden = false
		case .Changed:
			let translation: CGPoint = recognizer.translationInView(view)
			let x: CGFloat = self.sideViewControllerWidth / 2
			MaterialAnimation.animationDisabled {
				self.sideView.position.x = self.originalPosition.x + translation.x > x ? x : self.originalPosition.x + translation.x
			}
		case .Ended:
			let point: CGPoint = recognizer.velocityInView(recognizer.view)
			let x: CGFloat = point.x >= 1000 || point.x <= -1000 ? point.x : 0
			if sideView.x <= CGFloat(floor(-sideViewControllerWidth)) + horizontalThreshold || point.x <= -1000 {
				close(x)
			} else {
				open(x)
			}
		default:break
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
	//	:name:	prepareGestures
	//
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
	//	:name:	removeGestures
	//
	private func removeGestures(inout pan: UIPanGestureRecognizer?, inout tap: UITapGestureRecognizer?) {
		if let v = pan {
			view.removeGestureRecognizer(v)
			v.delegate = nil
			pan = nil
		}
		if let v = tap {
			view.removeGestureRecognizer(v)
			v.delegate = nil
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
		return opened || enabled && isPointContainedWithinHorizontalThreshold(point)
	}
	
	//
	//	:name:	isPointContainedWithinHorizontalThreshold
	//
	private func isPointContainedWithinHorizontalThreshold(point: CGPoint) -> Bool {
		return CGRectContainsPoint(CGRectMake(0, 0, horizontalThreshold, view.bounds.height), point)
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
		view.layer.addSublayer(backdropLayer)
	}
	
	//
	//	:name:	layoutBackdropLayer
	//
	private func layoutBackdropLayer() {
		MaterialAnimation.animationDisabled {
			self.backdropLayer.frame = self.view.bounds
			self.backdropLayer.zPosition = 900
			self.backdropLayer.hidden = true
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
	//	:name:	prepareLeftGestures
	//
	private func prepareLeftGestures() {
		removeGestures(&sidePanGesture, tap: &sideTapGesture)
		prepareGestures(&sidePanGesture, panSelector: "handlePanGesture:", tap: &sideTapGesture, tapSelector: "handleTapGesture:")
	}
}