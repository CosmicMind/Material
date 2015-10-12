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

public enum SideNavigationViewState {
	case Opened
	case Closed
}

@objc(SideNavigationViewContainer)
public class SideNavigationViewContainer : NSObject {
	/**
	:name:	state
	*/
	public private(set) var state: SideNavigationViewState
	
	/**
	:name:	point
	*/
	public private(set) var point: CGPoint
	
	/**
	:name:	frame
	*/
	public private(set) var frame: CGRect
	
	/**
	:name:	description
	*/
	public override var description: String {
		let s: String = .Opened == state ? "Opened" : "Closed"
		return "(state: \(s), point: \(point), frame: \(frame))"
	}
	
	/**
	:name:	init
	*/
	public init(state: SideNavigationViewState, point: CGPoint, frame: CGRect) {
		self.state = state
		self.point = point
		self.frame = frame
	}
}

@objc(SideNavigationViewDelegate)
public protocol SideNavigationViewDelegate {
	// left
	optional func sideNavDidBeginLeftPan(nav: SideNavigationViewController, container: SideNavigationViewContainer)
	optional func sideNavDidChangeLeftPan(nav: SideNavigationViewController, container: SideNavigationViewContainer)
	optional func sideNavDidEndLeftPan(nav: SideNavigationViewController, container: SideNavigationViewContainer)
	optional func sideNavDidOpenLeftViewContainer(nav: SideNavigationViewController, container: SideNavigationViewContainer)
	optional func sideNavDidCloseLeftViewContainer(nav: SideNavigationViewController, container: SideNavigationViewContainer)
	optional func sideNavDidTapLeft(nav: SideNavigationViewController, container: SideNavigationViewContainer)
}

@objc(SideNavigationViewController)
public class SideNavigationViewController: UIViewController, UIGestureRecognizerDelegate {
	/**
	:name:	default options
	*/
	public struct defaultOptions {
		public static var bezelWidth: CGFloat = 48
		public static var bezelHeight: CGFloat = 48
		public static var containerWidth: CGFloat = 240
		public static var containerHeight: CGFloat = 240
		public static var defaultAnimationDuration: CGFloat = 0.3
		public static var threshold: CGFloat = 48
		public static var panningEnabled: Bool = true
	}
	
	/**
	:name:	options
	*/
	public struct options {
		public static var shadowOpacity: Float = 0
		public static var shadowRadius: CGFloat = 0
		public static var shadowOffset: CGSize = CGSizeZero
		public static var backdropScale: CGFloat = 1
		public static var backdropOpacity: CGFloat = 0.5
		public static var hideStatusBar: Bool = true
		public static var horizontalThreshold: CGFloat = defaultOptions.threshold
		public static var verticalThreshold: CGFloat = defaultOptions.threshold
		public static var backdropBackgroundColor: UIColor = MaterialColor.black
		public static var animationDuration: CGFloat = defaultOptions.defaultAnimationDuration
		public static var leftBezelWidth: CGFloat = defaultOptions.bezelWidth
		public static var leftViewContainerWidth: CGFloat = defaultOptions.containerWidth
		public static var leftPanFromBezel: Bool = defaultOptions.panningEnabled
	}
	
	/**
	:name:	delegate
	*/
	public weak var delegate: SideNavigationViewDelegate?
	
	/**
	:name:	isViewBasedAppearance
	*/
	public var isViewBasedAppearance: Bool {
		return 0 == NSBundle.mainBundle().objectForInfoDictionaryKey("UIViewControllerBasedStatusBarAppearance") as? Int
	}
	
	/**
	:name:	isLeftContainerOpened
	*/
	public var isLeftContainerOpened: Bool {
		if let c = leftViewContainer {
			return c.frame.origin.x != leftOriginX
		}
		return false
	}
	
	/**
	:name:	isUserInteractionEnabled
	*/
	public var isUserInteractionEnabled: Bool {
		get {
			return mainViewContainer!.userInteractionEnabled
		}
		set(value) {
			mainViewContainer?.userInteractionEnabled = value
		}
	}
	
	/**
	:name:	backdropViewContainer
	*/
	public private(set) var backdropViewContainer: UIView?
	
	/**
	:name:	mainViewContainer
	*/
	public private(set) var mainViewContainer: UIView?
	
	/**
	:name:	leftViewContainer
	*/
	public private(set) var leftViewContainer: UIView?
	
	/**
	:name:	leftContainer
	*/
	public private(set) var leftContainer: SideNavigationViewContainer?
	
	/**
	:name:	mainViewController
	*/
	public var mainViewController: UIViewController?
	
	/**
	:name:	leftViewController
	*/
	public var leftViewController: UIViewController?
	
	/**
	:name:	leftPanGesture
	*/
	public var leftPanGesture: UIPanGestureRecognizer?
	
	/**
	:name:	leftTapGesture
	*/
	public var leftTapGesture: UITapGestureRecognizer?
	
	//
	//	:name:	leftOriginX
	//
	private var leftOriginX: CGFloat {
		return -options.leftViewContainerWidth
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
	public convenience init(mainViewController: UIViewController) {
		self.init()
		self.mainViewController = mainViewController
		prepareView()
	}
	
	/**
	:name:	init
	*/
	public convenience init(mainViewController: UIViewController, leftViewController: UIViewController) {
		self.init()
		self.mainViewController = mainViewController
		self.leftViewController = leftViewController
		prepareView()
		prepareLeftView()
	}
	
	//
	//	:name:	viewDidLoad
	//
	public override func viewDidLoad() {
		super.viewDidLoad()
		edgesForExtendedLayout = .None
	}
	
	//
	//	:name:	viewWillLayoutSubviews
	//
	public override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		if nil != mainViewController {
			prepareContainedViewController(&mainViewContainer, viewController: &mainViewController)
		}
		
		if nil != leftViewController {
			prepareContainedViewController(&leftViewContainer, viewController: &leftViewController)
		}
	}
	
	/**
	:name:	toggleLeftViewContainer
	*/
	public func toggleLeftViewContainer(velocity: CGFloat = 0) {
		isLeftContainerOpened ? closeLeftViewContainer(velocity) : openLeftViewContainer(velocity)
	}
	
	/**
	:name:	openLeftViewContainer
	*/
	public func openLeftViewContainer(velocity: CGFloat = 0) {
		if let vc = leftViewContainer {
			if let c = leftContainer {
				prepareContainerToOpen(&leftViewController, viewContainer: &leftViewContainer, state: c.state)
				UIView.animateWithDuration(Double(0 == velocity ? options.animationDuration : fmax(0.1, fmin(1, Double(vc.frame.origin.x / velocity)))),
					delay: 0,
					options: .CurveEaseInOut,
					animations: { _ in
						vc.frame.origin.x = 0
						self.backdropViewContainer?.layer.opacity = Float(options.backdropOpacity)
						self.mainViewContainer?.transform = CGAffineTransformMakeScale(options.backdropScale, options.backdropScale)
					}
					) { _ in
						self.isUserInteractionEnabled = false
				}
				c.state = .Opened
				delegate?.sideNavDidOpenLeftViewContainer?(self, container: c)
			}
		}
	}
	
	/**
	:name:	closeLeftViewContainer
	*/
	public func closeLeftViewContainer(velocity: CGFloat = 0) {
		if let vc = leftViewContainer {
			if let c = leftContainer {
				prepareContainerToClose(&leftViewController, state: c.state)
				UIView.animateWithDuration(Double(0 == velocity ? options.animationDuration : fmax(0.1, fmin(1, fabs(vc.frame.origin.x - leftOriginX) / velocity))),
					delay: 0,
					options: .CurveEaseInOut,
					animations: { _ in
						vc.frame.origin.x = self.leftOriginX
						self.backdropViewContainer?.layer.opacity = 0
						self.mainViewContainer?.transform = CGAffineTransformMakeScale(1, 1)
					}
					) { _ in
						self.removeShadow(&self.leftViewContainer)
						self.isUserInteractionEnabled = true
				}
				c.state = .Closed
				delegate?.sideNavDidCloseLeftViewContainer?(self, container: c)
			}
		}
	}
	
	/**
	:name:	switchMainViewController
	*/
	public func switchMainViewController(viewController: UIViewController, closeViewContainers: Bool) {
		removeViewController(&mainViewController)
		mainViewController = viewController
		prepareContainedViewController(&mainViewContainer, viewController: &mainViewController)
		if closeViewContainers {
			closeLeftViewContainer()
		}
	}
	
	/**
	:name:	switchLeftViewController
	*/
	public func switchLeftViewController(viewController: UIViewController, closeLeftViewContainerViewContainer: Bool) {
		removeViewController(&leftViewController)
		leftViewController = viewController
		prepareContainedViewController(&leftViewContainer, viewController: &leftViewController)
		if closeLeftViewContainerViewContainer {
			closeLeftViewContainer()
		}
	}
	
	//
	//	:name:	gestureRecognizer
	//
	public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		if gestureRecognizer == leftPanGesture {
			return gesturePanLeftViewController(gestureRecognizer, withTouchPoint: touch.locationInView(view))
		}
		if gestureRecognizer == leftTapGesture {
			return isLeftContainerOpened && !isPointContainedWithinViewController(&leftViewContainer, point: touch.locationInView(view))
		}
		return true
	}
	
	//
	//	:name:	prepareView
	//
	internal func prepareView() {
		prepareMainContainer()
		prepareBackdropContainer()
	}
	
	//
	//	:name:	prepareLeftView
	//
	internal func prepareLeftView() {
		prepareContainer(&leftContainer, viewContainer: &leftViewContainer, originX: leftOriginX, originY: 0, width: options.leftViewContainerWidth, height: view.bounds.size.height)
		prepareLeftGestures()
	}
	
	//
	//	:name:	addGestures
	//
	private func addGestures(inout pan: UIPanGestureRecognizer?, panSelector: Selector, inout tap: UITapGestureRecognizer?, tapSelector: Selector) {
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
	//	:name:	handleLeftPanGesture
	//
	internal func handleLeftPanGesture(gesture: UIPanGestureRecognizer) {
		if let vc = leftViewContainer {
			if let c = leftContainer {
				if .Began == gesture.state {
					addShadow(&leftViewContainer)
					toggleStatusBar(true)
					c.state = isLeftContainerOpened ? .Opened : .Closed
					c.point = gesture.locationInView(view)
					c.frame = vc.frame
					delegate?.sideNavDidBeginLeftPan?(self, container: c)
				} else if .Changed == gesture.state {
					c.point = gesture.translationInView(gesture.view!)
					let r = (vc.frame.origin.x - leftOriginX) / vc.frame.size.width
					let s: CGFloat = 1 - (1 - options.backdropScale) * r
					let x: CGFloat = c.frame.origin.x + c.point.x
					vc.frame.origin.x = x < leftOriginX ? leftOriginX : x > 0 ? 0 : x
					backdropViewContainer?.layer.opacity = Float(r * options.backdropOpacity)
					mainViewContainer?.transform = CGAffineTransformMakeScale(s, s)
					delegate?.sideNavDidChangeLeftPan?(self, container: c)
				} else {
					c.point = gesture.velocityInView(gesture.view)
					let x: CGFloat = c.point.x >= 1000 || c.point.x <= -1000 ? c.point.x : 0
					c.state = vc.frame.origin.x <= CGFloat(floor(leftOriginX)) + options.horizontalThreshold || c.point.x <= -1000 ? .Closed : .Opened
					if .Closed == c.state {
						closeLeftViewContainer(x)
					} else {
						openLeftViewContainer(x)
					}
					delegate?.sideNavDidEndLeftPan?(self, container: c)
				}
			}
		}
	}
	
	//
	//	:name:	handleLeftTapGesture
	//
	internal func handleLeftTapGesture(gesture: UIPanGestureRecognizer) {
		if let c = leftContainer {
			delegate?.sideNavDidTapLeft?(self, container: c)
			closeLeftViewContainer()
		}
	}
	
	//
	//	:name:	addShadow
	//
	private func addShadow(inout viewContainer: UIView?) {
		if let vc = viewContainer {
			vc.layer.shadowOffset = options.shadowOffset
			vc.layer.shadowOpacity = options.shadowOpacity
			vc.layer.shadowRadius = options.shadowRadius
			vc.layer.shadowPath = UIBezierPath(rect: vc.bounds).CGPath
			vc.layer.masksToBounds = false
		}
	}
	
	//
	//	:name:	removeShadow
	//
	private func removeShadow(inout viewContainer: UIView?) {
		if let vc = viewContainer {
			vc.layer.opacity = 1
			vc.layer.masksToBounds = true
		}
	}
	
	//
	//	:name:	toggleStatusBar
	//
	private func toggleStatusBar(hide: Bool = false) {
		if options.hideStatusBar {
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
	private func removeViewController(inout viewController: UIViewController?) {
		if let vc = viewController {
			vc.willMoveToParentViewController(nil)
			vc.view.removeFromSuperview()
			vc.removeFromParentViewController()
		}
	}
	
	//
	//	:name:	gesturePanLeftViewController
	//
	private func gesturePanLeftViewController(gesture: UIGestureRecognizer, withTouchPoint point: CGPoint) -> Bool {
		return isLeftContainerOpened || options.leftPanFromBezel && isLeftPointContainedWithinRect(point)
	}
	
	//
	//	:name:	isLeftPointContainedWithinRect
	//
	private func isLeftPointContainedWithinRect(point: CGPoint) -> Bool {
		return CGRectContainsPoint(CGRectMake(0, 0, options.leftBezelWidth, view.bounds.size.height), point)
	}
	
	//
	//	:name:	isPointContainedWithinViewController
	//
	private func isPointContainedWithinViewController(inout viewContainer: UIView?, point: CGPoint) -> Bool {
		if let vc = viewContainer {
			return CGRectContainsPoint(vc.frame, point)
		}
		return false
	}
	
	//
	//	:name:	prepareMainContainer
	//
	private func prepareMainContainer() {
		mainViewContainer = UIView(frame: view.bounds)
		mainViewContainer!.backgroundColor = MaterialColor.clear
		mainViewContainer!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
		view.addSubview(mainViewContainer!)
	}
	
	//
	//	:name:	prepareBackdropContainer
	//
	private func prepareBackdropContainer() {
		backdropViewContainer = UIView(frame: view.bounds)
		backdropViewContainer!.backgroundColor = options.backdropBackgroundColor
		backdropViewContainer!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
		backdropViewContainer!.layer.opacity = 0
		view.addSubview(backdropViewContainer!)
	}
	
	//
	//	:name:	prepareLeftGestures
	//
	private func prepareLeftGestures() {
		removeGestures(&leftPanGesture, tap: &leftTapGesture)
		addGestures(&leftPanGesture, panSelector: "handleLeftPanGesture:", tap: &leftTapGesture, tapSelector: "handleLeftTapGesture:")
	}
	
	//
	//	:name:	prepareContainer
	//
	private func prepareContainer(inout container: SideNavigationViewContainer?, inout viewContainer: UIView?, originX: CGFloat, originY: CGFloat, width: CGFloat, height: CGFloat) {
		container = SideNavigationViewContainer(state: .Closed, point: CGPointZero, frame: CGRectZero)
		viewContainer = UIView(frame: CGRectMake(originX, originY, width, height))
		viewContainer!.backgroundColor = MaterialColor.clear
		viewContainer!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
		view.addSubview(viewContainer!)
	}
	
	//
	//	:name:	prepareContainerToOpen
	//
	private func prepareContainerToOpen(inout viewController: UIViewController?, inout viewContainer: UIView?, state: SideNavigationViewState) {
		addShadow(&viewContainer)
		toggleStatusBar(true)
	}
	
	//
	//	:name:	prepareContainerToClose
	//
	private func prepareContainerToClose(inout viewController: UIViewController?, state: SideNavigationViewState) {
		toggleStatusBar()
	}
	
	//
	//	:name:	prepareContainedViewController
	//
	private func prepareContainedViewController(inout viewContainer: UIView?, inout viewController: UIViewController?) {
		if let vc = viewController {
			if let c = viewContainer {
				addChildViewController(vc)
				vc.view.frame = c.frame
				c.addSubview(vc.view)
				vc.didMoveToParentViewController(self)
			}
		}
	}
}
