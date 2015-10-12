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
	/**
		:name:	default options
	*/
	public struct defaultOptions {
		public static var bezelWidth: CGFloat = 48
		public static var bezelHeight: CGFloat = 48
		public static var containerWidth: CGFloat = 240
		public static var containerHeight: CGFloat = 240
		public static var defaultAnimationDuration: CGFloat = 0.25
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
	
	//
	//	:name:	originalPosition
	//
	private var originalPosition: CGPoint!
	
	/**
		:name:	backdropLayer
	*/
	public private(set) lazy var backdropLayer: MaterialLayer = MaterialLayer()
	
	/**
		:name:	mainViewContainer
	*/
	public private(set) var mainViewContainer: MaterialView?
	
	/**
		:name:	leftViewContainer
	*/
	public private(set) var leftViewContainer: MaterialView?
	
	/**
		:name:	mainViewController
	*/
	public var mainViewController: UIViewController?
	
	/**
		:name:	leftViewController
	*/
	public var leftViewController: UIViewController?
	
	/**
		:name:	leftAnimation
	*/
	private var leftAnimation: CAAnimation?
	
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
//			prepareContainedViewController(&leftViewContainer, viewController: &leftViewController)
		}
	}
	
	/**
		:name:	toggleLeftViewContainer
	*/
	public func toggleLeftViewContainer(velocity: CGFloat = 0) {
		openLeftViewContainer(velocity)
	}
	
	/**
		:name:	openLeftViewContainer
	*/
	public func openLeftViewContainer(velocity: CGFloat = 0) {
		if let vc = leftViewContainer {
			
			let w: CGFloat = vc.width
			let h: CGFloat = vc.height
			let d: Double = Double(0 == velocity ? options.animationDuration : fmax(0.1, fmin(1, Double(vc.frame.origin.x / velocity))))
			
			vc.shadowDepth = .None
			
			MaterialAnimation.animationWithDuration(d, animations: {
				vc.position = CGPointMake(w / 2, h / 2)
				self.backdropLayer.opacity = Float(options.backdropOpacity)
			}) {
				self.isUserInteractionEnabled = false
//					vc.shadowDepth = .Depth2
			}
			
//				print(vc.frame)
//				let a: CABasicAnimation = MaterialAnimation.position(CGPointMake(w / 2, h / 2), duration: d)
//				a.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//				vc.animation(a)
//				
////				
//				UIView.animateWithDuration(d,
//					delay: 0,
//					options: .CurveEaseInOut,
//					animations: { _ in
//						vc.frame.origin.x = 0
//						self.backdropViewContainer?.layer.opacity = Float(options.backdropOpacity)
//						self.mainViewContainer?.transform = CGAffineTransformMakeScale(options.backdropScale, options.backdropScale)
//					}
//					) { _ in
//						self.isUserInteractionEnabled = false
//				}
//				c.state = .Opened
//				delegate?.sideNavDidOpenLeftViewContainer?(self, container: c)
			
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
		prepareContainer(&leftViewContainer, originX: leftOriginX, originY: 0, width: options.leftViewContainerWidth, height: view.bounds.size.height)
		prepareLeftGestures()
		
//		leftViewContainer!.layer.speed = 0
		let w: CGFloat = leftViewContainer!.width
		let h: CGFloat = leftViewContainer!.height
//		leftAnimation = MaterialAnimation.position(CGPointMake(w / 2, h / 2), duration: 1)
//		leftViewContainer!.position = CGPointMake(-(w / 2), h / 2)
//		leftViewContainer!.animation(leftAnimation!)
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
	internal func handleLeftPanGesture(recognizer: UIPanGestureRecognizer) {
		if let vc = leftViewContainer {
			switch recognizer.state {
			case .Began:
				originalPosition = vc.position
				toggleStatusBar(true)
			case .Changed:
				let translation: CGPoint = recognizer.translationInView(vc)
				let w: CGFloat = leftViewContainer!.width
				
				MaterialAnimation.animationDisabled({
					vc.position.x = self.originalPosition.x + translation.x > (w / 2) ? (w / 2) : self.originalPosition.x + translation.x
					self.backdropLayer.opacity = Float(vc.position.x / (w / 2)) / 2
				})
			case .Ended:
				self.isUserInteractionEnabled = false
				// snap back
				let a: CABasicAnimation = MaterialAnimation.position(CGPointMake(vc.width / 2, vc.height / 2), duration: 0.25)
				a.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
				vc.animation(a)
				
				break
				
			default:break
			}
		}
	}
	
	//
	//	:name:	handleLeftTapGesture
	//
	internal func handleLeftTapGesture(gesture: UIPanGestureRecognizer) {
		
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
	private func isPointContainedWithinViewController(inout viewContainer: MaterialView?, point: CGPoint) -> Bool {
		if let vc = viewContainer {
			return CGRectContainsPoint(vc.frame, point)
		}
		return false
	}
	
	//
	//	:name:	prepareMainContainer
	//
	private func prepareMainContainer() {
		mainViewContainer = MaterialView(frame: view.bounds)
		mainViewContainer!.backgroundColor = MaterialColor.clear
		mainViewContainer!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
		view.addSubview(mainViewContainer!)
	}
	
	//
	//	:name:	prepareBackdropContainer
	//
	private func prepareBackdropContainer() {
		backdropLayer.frame = view.bounds
		backdropLayer.backgroundColor = options.backdropBackgroundColor.CGColor
		backdropLayer.opacity = 0
		view.layer.addSublayer(backdropLayer)
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
	private func prepareContainer(inout viewContainer: MaterialView?, originX: CGFloat, originY: CGFloat, width: CGFloat, height: CGFloat) {
		viewContainer = MaterialView(frame: CGRectMake(originX, originY, width, height))
		viewContainer!.backgroundColor = MaterialColor.red.base
		viewContainer!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
		view.addSubview(viewContainer!)
	}
	
	//
	//	:name:	prepareContainedViewController
	//
	private func prepareContainedViewController(inout viewContainer: MaterialView?, inout viewController: UIViewController?) {
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
