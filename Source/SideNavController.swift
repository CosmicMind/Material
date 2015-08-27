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

public enum SideNavState {
	case Opened
	case Closed
}

@objc(SideNavContainer)
public class SideNavContainer : Printable {
	public private(set) var state: SideNavState
	public private(set) var point: CGPoint
	public private(set) var frame: CGRect
	public var description: String {
		let s: String = .Opened == state ? "Opened" : "Closed"
		return "(state: \(s), point: \(point), frame: \(frame))"
	}
	public init(state: SideNavState, point: CGPoint, frame: CGRect) {
		self.state = state
		self.point = point
		self.frame = frame
	}
}

@objc(SideNavDelegate)
public protocol SideNavDelegate {
	// left
	optional func sideNavDidBeginLeftPan(sideNav: SideNavController, container: SideNavContainer)
	optional func sideNavDidChangeLeftPan(sideNav: SideNavController, container: SideNavContainer)
	optional func sideNavDidEndLeftPan(sideNav: SideNavController, container: SideNavContainer)
	optional func sideNavDidOpenLeftViewContainer(sideNav: SideNavController, container: SideNavContainer)
	optional func sideNavDidCloseLeftViewContainer(sideNav: SideNavController, container: SideNavContainer)
	optional func sideNavDidTapLeft(sideNav: SideNavController, container: SideNavContainer)
	
	// right
	optional func sideNavDidBeginRightPan(sideNav: SideNavController, container: SideNavContainer)
	optional func sideNavDidChangeRightPan(sideNav: SideNavController, container: SideNavContainer)
	optional func sideNavDidEndRightPan(sideNav: SideNavController, container: SideNavContainer)
	optional func sideNavDidOpenRightViewContainer(sideNav: SideNavController, container: SideNavContainer)
	optional func sideNavDidCloseRightViewContainer(sideNav: SideNavController, container: SideNavContainer)
	optional func sideNavDidTapRight(sideNav: SideNavController, container: SideNavContainer)
}

@objc(SideNavController)
public class SideNavController: MaterialViewController, UIGestureRecognizerDelegate {
	/**
		:name:	options
	*/
	public struct options {
		public static var shadowOpacity: Float = 0
		public static var shadowRadius: CGFloat = 0
		public static var shadowOffset: CGSize = CGSizeZero
		public static var contentViewScale: CGFloat = 1
		public static var contentViewOpacity: CGFloat = 0.4
		public static var shouldHideStatusBar: Bool = true
		public static var pointOfNoReturnWidth: CGFloat = 48
		public static var backdropViewContainerBackgroundColor: UIColor = .blackColor()
		public static var animationDuration: CGFloat = 0.5
		public static var leftBezelWidth: CGFloat = 16
		public static var leftViewContainerWidth: CGFloat = 270
		public static var leftPanFromBezel: Bool = true
		public static var rightBezelWidth: CGFloat = 16
		public static var rightViewContainerWidth: CGFloat = 270
		public static var rightPanFromBezel: Bool = true
	}
	
	/**
		:name:	delegate
	*/
	public weak var delegate: SideNavDelegate?
	
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
		return 0 == leftViewContainer.frame.origin.x
	}
	
	/**
		:name:	isRightContainerOpened
	*/
	public var isRightContainerOpened: Bool {
		return rightViewContainer.frame.origin.x == rightOriginX - rightViewContainer.frame.size.width
	}
	
	/**
		:name:	isUserInteractionEnabled
	*/
	public private(set) var isUserInteractionEnabled: Bool {
		get {
			return mainViewContainer.userInteractionEnabled
		}
		set(value) {
			mainViewContainer.userInteractionEnabled = value
		}
	}
	
	/**
		:name:	backdropViewContainer
	*/
	public private(set) var backdropViewContainer: UIView!
	
	/**
		:name:	mainViewContainer
	*/
	public private(set) var mainViewContainer: UIView!
	
	/**
		:name:	leftViewContainer
	*/
	public private(set) var leftViewContainer: UIView!
	
	/**
		:name:	rightViewContainer
	*/
	public private(set) var rightViewContainer: UIView!
	
	/**
		:name:	leftContainer
	*/
	public private(set) var leftContainer: SideNavContainer!
	
	/**
		:name:	rightContainer
	*/
	public private(set) var rightContainer: SideNavContainer!
	
	/**
		:name:	mainViewController
	*/
    public var mainViewController: UIViewController?
	
	/**
		:name:	leftViewController
	*/
	public var leftViewController: UIViewController?
	
	/**
		:name:	rightViewController
	*/
	public var rightViewController: UIViewController?

	/**
		:name:	leftPanGesture
	*/
    public var leftPanGesture: UIPanGestureRecognizer?
	
	/**
		:name:	leftTapGesture
	*/
	public var leftTapGesture: UITapGestureRecognizer?
	
	/**
		:name:	rightPanGesture
	*/
	public var rightPanGesture: UIPanGestureRecognizer?

	
	/**
		:name:	rightTapGesture
	*/
	public var rightTapGesture: UITapGestureRecognizer?
	
	//
	//	:name:	leftOriginX
	//
	private var leftOriginX: CGFloat {
		return -options.leftViewContainerWidth
	}
	
	//
	//	:name:	rightOriginX
	//
	private var rightOriginX: CGFloat {
		return view.bounds.width
	}
	
	/**
		:name:	init
	*/
    public required init(coder aDecoder: NSCoder) {
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
    public convenience init(mainViewController: UIViewController, leftViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.leftViewController = leftViewController
        setupView()
    }
	
	/**
		:name:	init
	*/
    public convenience init(mainViewController: UIViewController, rightViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.rightViewController = rightViewController
        setupView()
    }
	
	/**
		:name:	init
	*/
    public convenience init(mainViewController: UIViewController, leftViewController: UIViewController, rightViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.leftViewController = leftViewController
        self.rightViewController = rightViewController
        setupView()
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
		prepareContainedViewController(mainViewContainer, viewController: mainViewController)
		prepareContainedViewController(leftViewContainer, viewController: leftViewController)
		prepareContainedViewController(rightViewContainer, viewController: rightViewController)
	}
	
	//
	//	:name:	viewWillTransitionToSize
	//
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        mainViewContainer.transform = CGAffineTransformMakeScale(1, 1)
        leftViewContainer.hidden = true
        rightViewContainer.hidden = true
        coordinator.animateAlongsideTransition(nil) { _ in
			self.toggleWindow()
			self.backdropViewContainer.layer.opacity = 0
			self.mainViewContainer.transform = CGAffineTransformMakeScale(1, 1)
			self.isUserInteractionEnabled = true
			
			self.leftViewContainer.frame.origin.x = self.leftOriginX
			self.leftViewContainer.hidden = false
			self.removeShadow(self.leftViewContainer)
			self.prepareLeftGestures()
			
			self.rightViewContainer.frame.origin.x = self.rightOriginX
			self.rightViewContainer.hidden = false
			self.removeShadow(self.rightViewContainer)
			self.prepareRightGestures()
        }
    }
	
	/**
		:name:	toggleLeftViewContainer
	*/
	public func toggleLeftViewContainer(velocity: CGFloat = 0) {
		isLeftContainerOpened ? closeLeftViewContainer(velocity: velocity) : openLeftViewContainer(velocity: velocity)
	}
	
	/**
		:name:	toggleRightViewContainer
	*/
	public func toggleRightViewContainer(velocity: CGFloat = 0) {
		isRightContainerOpened ? closeRightViewContainer(velocity: velocity) : openRightViewContainer(velocity: velocity)
	}
	
	/**
		:name:	openLeftViewContainer
	*/
	public func openLeftViewContainer(velocity: CGFloat = 0) {
		prepareContainerToOpen(&leftViewController, viewContainer: &leftViewContainer, state: leftContainer.state)
		UIView.animateWithDuration(Double(0 == velocity ? options.animationDuration : fmax(0.1, fmin(1, Double(leftViewContainer.frame.origin.x / velocity)))),
			delay: 0,
			options: .CurveEaseInOut,
			animations: { _ in
				self.leftViewContainer.frame.origin.x = 0
				self.backdropViewContainer.layer.opacity = Float(options.contentViewOpacity)
				self.mainViewContainer.transform = CGAffineTransformMakeScale(options.contentViewScale, options.contentViewScale)
			}
		) { _ in
			self.isUserInteractionEnabled = false
			self.leftViewController?.endAppearanceTransition()
		}
		leftContainer.state = .Opened
		delegate?.sideNavDidOpenLeftViewContainer?(self, container: leftContainer)
	}
	
	/**
		:name:	openRightViewContainer
	*/
	public func openRightViewContainer(velocity: CGFloat = 0) {
		prepareContainerToOpen(&rightViewController, viewContainer: &rightViewContainer, state: rightContainer.state)
		UIView.animateWithDuration(Double(0 == velocity ? options.animationDuration : fmax(0.1, fmin(1, Double(fabs(rightViewContainer.frame.origin.x - rightOriginX) / velocity)))),
			delay: 0,
			options: .CurveEaseInOut,
			animations: { _ in
				self.rightViewContainer.frame.origin.x = self.rightOriginX - self.rightViewContainer.frame.size.width
				self.backdropViewContainer.layer.opacity = Float(options.contentViewOpacity)
				self.mainViewContainer.transform = CGAffineTransformMakeScale(options.contentViewScale, options.contentViewScale)
			}
		) { _ in
			self.isUserInteractionEnabled = false
			self.rightViewController?.endAppearanceTransition()
		}
		rightContainer.state = .Opened
		delegate?.sideNavDidOpenRightViewContainer?(self, container: rightContainer)
	}
	
	/**
		:name:	closeLeftViewContainer
	*/
	public func closeLeftViewContainer(velocity: CGFloat = 0) {
		prepareContainerToClose(&leftViewController, state: leftContainer.state)
		UIView.animateWithDuration(Double(0 == velocity ? options.animationDuration : fmax(0.1, fmin(1, fabs(leftViewContainer.frame.origin.x - leftOriginX) / velocity))),
			delay: 0,
			options: .CurveEaseInOut,
			animations: { _ in
				self.leftViewContainer.frame.origin.x = self.leftOriginX
				self.backdropViewContainer.layer.opacity = 0
				self.mainViewContainer.transform = CGAffineTransformMakeScale(1, 1)
			}
		) { _ in
			self.removeShadow(self.leftViewContainer)
			self.isUserInteractionEnabled = true
			self.leftViewController?.endAppearanceTransition()
		}
		leftContainer.state = .Closed
		delegate?.sideNavDidCloseLeftViewContainer?(self, container: leftContainer)
	}
	
	/**
		:name:	closeRightViewContainer
	*/
	public func closeRightViewContainer(velocity: CGFloat = 0) {
		prepareContainerToClose(&rightViewController, state: rightContainer.state)
		UIView.animateWithDuration(Double(0 == velocity ? options.animationDuration : fmax(0.1, fmin(1, fabs(rightViewContainer.frame.origin.x - rightOriginX) / velocity))),
			delay: 0,
			options: .CurveEaseInOut,
			animations: { _ in
				self.rightViewContainer.frame.origin.x = self.rightOriginX
				self.backdropViewContainer.layer.opacity = 0
				self.mainViewContainer.transform = CGAffineTransformMakeScale(1, 1)
			}
		) { _ in
			self.removeShadow(self.rightViewContainer)
			self.isUserInteractionEnabled = true
			self.rightViewController?.endAppearanceTransition()
		}
		rightContainer.state = .Closed
		delegate?.sideNavDidCloseRightViewContainer?(self, container: rightContainer)
	}
	
	/**
		:name:	switchMainViewController
	*/
	public func switchMainViewController(viewController: UIViewController, closeViewContainers: Bool) {
		removeViewController(mainViewController)
		mainViewController = viewController
		prepareContainedViewController(mainViewContainer, viewController: mainViewController)
		if closeViewContainers {
			closeLeftViewContainer()
			closeRightViewContainer()
		}
	}
	
	/**
		:name:	switchLeftViewController
	*/
	public func switchLeftViewController(viewController: UIViewController, closeLeftViewContainerViewContainer: Bool) {
		removeViewController(leftViewController)
		leftViewController = viewController
		prepareContainedViewController(leftViewContainer, viewController: leftViewController)
		if closeLeftViewContainerViewContainer {
			closeLeftViewContainer()
		}
	}
	
	/**
		:name:	switchRightViewController
	*/
	public func switchRightViewController(viewController: UIViewController, closeRightViewContainerViewContainer: Bool) {
		removeViewController(rightViewController)
		rightViewController = viewController
		prepareContainedViewController(rightViewContainer, viewController: rightViewController)
		if closeRightViewContainerViewContainer {
			closeRightViewContainer()
		}
	}
	
	//
	//	:name:	gestureRecognizer
	//
	public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		if gestureRecognizer == leftPanGesture {
			return gesturePanLeftViewController(gestureRecognizer, withTouchPoint: touch.locationInView(view))
		}
		if gestureRecognizer == rightPanGesture {
			return gesturePanRightViewController(gestureRecognizer, withTouchPoint: touch.locationInView(view))
		}
		if gestureRecognizer == leftTapGesture {
			return isLeftContainerOpened && !isPointContainedWithinViewController(&leftViewContainer, point: touch.locationInView(view))
		}
		if gestureRecognizer == rightTapGesture {
			return isRightContainerOpened && !isPointContainedWithinViewController(&rightViewContainer, point: touch.locationInView(view))
		}
		return true
	}
	
	//
	//	:name:	setupView
	//
	internal func setupView() {
		prepareMainContainer()
		prepareBackdropContainer()
		
		prepareContainer(&leftContainer, viewContainer: &leftViewContainer, originX: leftOriginX, width: options.leftViewContainerWidth)
		prepareLeftGestures()
		
		prepareContainer(&rightContainer, viewContainer: &rightViewContainer, originX: rightOriginX, width: options.rightViewContainerWidth)
		prepareRightGestures()
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
		if isRightContainerOpened { return }
		if .Began == gesture.state {
			leftContainer.state = isLeftContainerOpened ? .Opened : .Closed
			leftContainer.point = gesture.locationInView(view)
			leftContainer.frame = leftViewContainer.frame
			delegate?.sideNavDidBeginLeftPan?(self, container: leftContainer)
			leftViewController?.beginAppearanceTransition(!isLeftContainerOpened, animated: true)
			addShadow(leftViewContainer)
			toggleWindow(shouldOpen: true)
		} else if .Changed == gesture.state {
			let v: CGPoint = gesture.translationInView(gesture.view!)
			let r = (leftViewContainer.frame.origin.x - leftOriginX) / leftViewContainer.frame.size.width
			let s: CGFloat = 1 - (1 - options.contentViewScale) * r
			let x: CGFloat = leftContainer.frame.origin.x + v.x
			leftViewContainer.frame.origin.x = x < leftOriginX ? leftOriginX : x > 0 ? 0 : x
			backdropViewContainer.layer.opacity = Float(r * options.contentViewOpacity)
			mainViewContainer.transform = CGAffineTransformMakeScale(s, s)
			if nil != delegate?.sideNavDidChangeLeftPan {
				delegate?.sideNavDidChangeLeftPan?(self, container: SideNavContainer(state: leftContainer.state, point: v, frame: leftContainer.frame))
			}
		} else {
			let v: CGPoint = gesture.velocityInView(gesture.view)
			let x: CGFloat = v.x >= 1000 || v.x <= -1000 ? v.x : 0
			let s: SideNavState = leftViewContainer.frame.origin.x <= CGFloat(floor(leftOriginX)) + options.pointOfNoReturnWidth || v.x <= -1000 ? .Closed : .Opened
			if .Closed == s {
				closeLeftViewContainer(velocity: x)
			} else {
				openLeftViewContainer(velocity: x)
			}
			if nil != delegate?.sideNavDidEndLeftPan {
				delegate?.sideNavDidEndLeftPan?(self, container: SideNavContainer(state: s, point: v, frame: leftContainer.frame))
			}
		}
	}
	
	//
	//	:name:	handleLeftTapGesture
	//
	internal func handleLeftTapGesture(gesture: UIPanGestureRecognizer) {
		delegate?.sideNavDidTapLeft?(self, container: leftContainer)
		closeLeftViewContainer()
	}
	
	//
	//	:name:	handleRightPanGesture
	//
	internal func handleRightPanGesture(gesture: UIPanGestureRecognizer) {
		if isLeftContainerOpened { return }
		if .Began == gesture.state {
			rightContainer.state = isRightContainerOpened ? .Opened : .Closed
			rightContainer.point = gesture.locationInView(view)
			rightContainer.frame = rightViewContainer.frame
			delegate?.sideNavDidBeginRightPan?(self, container: rightContainer)
			rightViewController?.beginAppearanceTransition(!isRightContainerOpened, animated: true)
			addShadow(rightViewContainer)
			toggleWindow(shouldOpen: true)
		} else if .Changed == gesture.state {
			let v: CGPoint = gesture.translationInView(gesture.view!)
			
			let r = (rightOriginX - rightViewContainer.frame.origin.x) / rightViewContainer.frame.size.width
			let s: CGFloat = 1 - (1 - options.contentViewScale) * r
			let m: CGFloat = rightOriginX - rightViewContainer.frame.size.width
			let x: CGFloat = rightContainer.frame.origin.x + gesture.translationInView(gesture.view!).x
			rightViewContainer.frame.origin.x = x > rightOriginX ? rightOriginX : x < m ? m : x
			backdropViewContainer.layer.opacity = Float(r * options.contentViewOpacity)
			mainViewContainer.transform = CGAffineTransformMakeScale(s, s)
			if nil != delegate?.sideNavDidChangeRightPan {
				delegate?.sideNavDidChangeRightPan?(self, container: SideNavContainer(state: rightContainer.state, point: v, frame: rightContainer.frame))
			}
		} else {
			let v: CGPoint = gesture.velocityInView(gesture.view)
			let x: CGFloat = v.x <= -1000 || v.x >= 1000 ? v.x : 0
			let s: SideNavState = rightViewContainer.frame.origin.x >= CGFloat(floor(rightOriginX) - options.pointOfNoReturnWidth) || v.x >= 1000 ? .Closed : .Opened
			if .Closed == s {
				closeRightViewContainer(velocity: x)
			} else {
				openRightViewContainer(velocity: x)
			}
			if nil != delegate?.sideNavDidEndRightPan {
				delegate?.sideNavDidEndRightPan?(self, container: SideNavContainer(state: s, point: v, frame: rightContainer.frame))
			}
		}
	}
	
	//
	//	:name:	handleRightTapGesture
	//
	internal func handleRightTapGesture(gesture: UIPanGestureRecognizer) {
		delegate?.sideNavDidTapRight?(self, container: rightContainer)
		closeRightViewContainer()
	}
	
	//
	//	:name:	addShadow
	//
    private func addShadow(container: UIView) {
        container.layer.shadowOffset = options.shadowOffset
        container.layer.shadowOpacity = options.shadowOpacity
        container.layer.shadowRadius = options.shadowRadius
        container.layer.shadowPath = UIBezierPath(rect: container.bounds).CGPath
		container.layer.masksToBounds = false
    }
	
	//
	//	:name:	removeShadow
	//
    private func removeShadow(container: UIView) {
		container.layer.opacity = 1
        container.layer.masksToBounds = true
    }
	
	//
	//	:name:	toggleWindow
	//
	private func toggleWindow(shouldOpen: Bool = false) {
        if options.shouldHideStatusBar {
            if isViewBasedAppearance {
                UIApplication.sharedApplication().setStatusBarHidden(shouldOpen, withAnimation: .Slide)
			} else {
				dispatch_async(dispatch_get_main_queue(), {
					if let w = UIApplication.sharedApplication().keyWindow {
						w.windowLevel = UIWindowLevelStatusBar + (shouldOpen ? 1 : 0)
					}
				})
			}
        }
    }
	
	//
	//	:name:	removeViewController
	//
    private func removeViewController(viewController: UIViewController?) {
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
        var r: CGRect = CGRectZero
        var t: CGRect = CGRectZero
        let w: CGFloat = options.leftBezelWidth
        CGRectDivide(view.bounds, &r, &t, w, .MinXEdge)
        return CGRectContainsPoint(r, point)
    }
    
	//
	//	:name:	gesturePanRightViewController
	//
	private func gesturePanRightViewController(gesture: UIGestureRecognizer, withTouchPoint point: CGPoint) -> Bool {
        return isRightContainerOpened || options.rightPanFromBezel && isRightPointContainedWithinRect(point)
    }
	
	//
	//	:name:	isRightPointContainedWithinRect
	//
    private func isRightPointContainedWithinRect(point: CGPoint) -> Bool {
        var r: CGRect = CGRectZero
        var t: CGRect = CGRectZero
        let w: CGFloat = rightOriginX - options.rightBezelWidth
        CGRectDivide(view.bounds, &t, &r, w, .MinXEdge)
        return CGRectContainsPoint(r, point)
    }
	
	//
	//	:name:	isPointContainedWithinViewController
	//
	private func isPointContainedWithinViewController(inout viewContainer: UIView!, point: CGPoint) -> Bool {
		return CGRectContainsPoint(viewContainer.frame, point)
	}
	
	//
	//	:name:	prepareMainContainer
	//
	private func prepareMainContainer() {
		mainViewContainer = UIView(frame: view.bounds)
		mainViewContainer.backgroundColor = .clearColor()
		mainViewContainer.autoresizingMask = .FlexibleHeight | .FlexibleWidth
		view.addSubview(mainViewContainer)
	}
	
	//
	//	:name:	prepareBackdropContainer
	//
	private func prepareBackdropContainer() {
		backdropViewContainer = UIView(frame: view.bounds)
		backdropViewContainer.backgroundColor = options.backdropViewContainerBackgroundColor
		backdropViewContainer.autoresizingMask = .FlexibleHeight | .FlexibleWidth
		backdropViewContainer.layer.opacity = 0
		view.addSubview(backdropViewContainer)
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
	private func prepareContainer(inout container: SideNavContainer!, inout viewContainer: UIView!, originX: CGFloat, width: CGFloat) {
		container = SideNavContainer(state: .Closed, point: CGPointZero, frame: CGRectZero)
		var b: CGRect = view.bounds
		b.size.width = width
		b.origin.x = originX
		viewContainer = UIView(frame: b)
		viewContainer.backgroundColor = .clearColor()
		viewContainer.autoresizingMask = .FlexibleHeight
		view.addSubview(viewContainer)
	}
	
	//
	//	:name:	prepareRightGestures
	//
	private func prepareRightGestures() {
		removeGestures(&rightPanGesture, tap: &rightTapGesture)
		addGestures(&rightPanGesture, panSelector: "handleRightPanGesture:", tap: &rightTapGesture, tapSelector: "handleRightTapGesture:")
	}
	
	//
	//	:name:	prepareContainerToOpen
	//
	private func prepareContainerToOpen(inout viewController: UIViewController?, inout viewContainer: UIView!, state: SideNavState) {
		if let vc = viewController {
			vc.beginAppearanceTransition(.Opened == state, animated: true)
			addShadow(viewContainer)
			toggleWindow(shouldOpen: true)
		}
	}
	
	//
	//	:name:	prepareContainerToClose
	//
	private func prepareContainerToClose(inout viewController: UIViewController?, state: SideNavState) {
		if let vc = viewController {
			vc.beginAppearanceTransition(.Opened == state, animated: true)
			toggleWindow()
		}
	}
	
	//
	//	:name:	prepareContainedViewController
	//
	private func prepareContainedViewController(container: UIView, viewController: UIViewController?) {
		if let vc = viewController {
			addChildViewController(vc)
			vc.view.frame = container.bounds
			container.addSubview(vc.view)
			vc.didMoveToParentViewController(self)
		}
	}
}
