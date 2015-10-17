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
	private var originalPosition: CGPoint!
	
	//
	//	:name:	enabled
	//
	public lazy var enabled: Bool = true
	
	/**
		:name:	hideStatusBar
	*/
	public lazy var hideStatusBar: Bool = true
	
	/**
		:name:	horizontalThreshold
	*/
	public static let horizontalThreshold: CGFloat = 64
	
	/**
		:name:	animationDuration
	*/
	public static let animationDuration: CGFloat = 0.25
	
	/**
		:name:	backdropLayer
	*/
	public private(set) static var backdropLayer: CAShapeLayer = CAShapeLayer()
	
	/**
		:name:	backdropOpacity
	*/
	public static var backdropOpacity: CGFloat = 0.5 {
		didSet {
			backdropLayer.backgroundColor = backdropColor?.colorWithAlphaComponent(backdropOpacity).CGColor
		}
	}
	
	/**
		:name:	backdropColor
	*/
	public static var backdropColor: UIColor? {
		didSet {
			backdropLayer.backgroundColor = backdropColor?.colorWithAlphaComponent(backdropOpacity).CGColor
		}
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
		if let c = leftView {
			return c.frame.origin.x != leftOriginX
		}
		return false
	}
	
	/**
		:name:	isUserInteractionEnabled
	*/
	public private(set) var isUserInteractionEnabled: Bool {
		get {
			return view.userInteractionEnabled
		}
		set(value) {
			view.userInteractionEnabled = value
		}
	}
	
	/**
		:name:	leftView
	*/
	public private(set) var leftView: MaterialView?
	
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
		return -240
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
	public init() {
		super.init(nibName: nil, bundle: nil)
		prepareView()
	}
	
	/**
		:name:	init
	*/
	public convenience init(leftViewController: UIViewController) {
		self.init()
		self.leftViewController = leftViewController
		prepareLeftView()
	}
	
	//
	//	:name:	viewDidLoad
	//
	public override func viewDidLoad() {
		super.viewDidLoad()
		edgesForExtendedLayout = .None
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
		if let vc = leftView {
			let w: CGFloat = vc.width
			let h: CGFloat = vc.height
			let d: Double = Double(0 == velocity ? SideNavigationViewController.animationDuration : fmax(0.1, fmin(1, Double(vc.x / velocity))))
			
			MaterialAnimation.animationWithDuration(d, animations: {
				vc.position = CGPointMake(w / 2, h / 2)
			}) {
				SideNavigationViewController.backdropLayer.hidden = false
				self.isUserInteractionEnabled = false
				self.toggleStatusBar(true)
			}
		}
	}
	
	/**
		:name:	closeLeftViewContainer
	*/
	public func closeLeftViewContainer(velocity: CGFloat = 0) {
		if let vc = leftView {
			let w: CGFloat = vc.width
			let h: CGFloat = vc.height
			let d: Double = Double(0 == velocity ? SideNavigationViewController.animationDuration : fmax(0.1, fmin(1, Double(vc.x / velocity))))
			
			MaterialAnimation.animationWithDuration(d, animations: {
				vc.position = CGPointMake(-w / 2, h / 2)
			}) {
				SideNavigationViewController.backdropLayer.hidden = true
				self.isUserInteractionEnabled = true
				self.toggleStatusBar(false)
			}
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
			return isLeftContainerOpened && !isPointContainedWithinViewController(&leftView, point: touch.locationInView(view))
		}
		return true
	}
	
	//
	//	:name:	prepareView
	//
	internal func prepareView() {
		SideNavigationViewController.backdropColor = MaterialColor.black
		prepareBackdropLayer()
	}
	
	//
	//	:name:	prepareLeftView
	//
	internal func prepareLeftView() {
		let w: CGFloat = view.frame.width
		let h: CGFloat = view.frame.height
		
		// container
		leftView = MaterialView()
		leftView!.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(leftView!)
		MaterialLayout.alignToParentVertically(view, child: leftView!)
		MaterialLayout.width(view, child: leftView!, width: 240)
		
		MaterialAnimation.animationDisabled({
			self.leftView!.position = CGPointMake(-w / 2, h / 2)
			self.leftView!.zPosition = 1000
			self.leftView!.masksToBounds = true
		})
		
		// viewController
		addChildViewController(leftViewController!)
		leftView!.addSubview(leftViewController!.view)
		leftViewController!.didMoveToParentViewController(self)
		MaterialLayout.alignToParent(leftView!, child: leftViewController!.view)
		
		// gestures
		prepareLeftGestures()
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
		if let vc = leftView {
			switch recognizer.state {
			case .Began:
				originalPosition = vc.position
				toggleStatusBar(true)
				SideNavigationViewController.backdropLayer.hidden = false
			case .Changed:
				let translation: CGPoint = recognizer.translationInView(vc)
				let w: CGFloat = vc.width
				MaterialAnimation.animationDisabled({
					vc.position.x = self.originalPosition.x + translation.x > (w / 2) ? (w / 2) : self.originalPosition.x + translation.x
				})
			case .Ended:
				// snap back
				let translation: CGPoint = recognizer.translationInView(vc)
				if SideNavigationViewController.horizontalThreshold <= translation.x {
					openLeftViewContainer(recognizer.velocityInView(view).x)
				} else {
					closeLeftViewContainer(recognizer.velocityInView(view).x)
				}
			default:break
			}
		}
	}
	
	//
	//	:name:	handleLeftTapGesture
	//
	internal func handleLeftTapGesture(gesture: UIPanGestureRecognizer) {
		closeLeftViewContainer()
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
		return isLeftContainerOpened || enabled && isLeftPointContainedWithinRect(point)
	}
	
	//
	//	:name:	isLeftPointContainedWithinRect
	//
	private func isLeftPointContainedWithinRect(point: CGPoint) -> Bool {
		return CGRectContainsPoint(CGRectMake(0, 0, 64, view.frame.height), point)
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
	//	:name:	prepareBackdropLayer
	//
	private func prepareBackdropLayer() {
		MaterialAnimation.animationDisabled({
			SideNavigationViewController.backdropLayer.frame = self.view.bounds
			SideNavigationViewController.backdropLayer.zPosition = 900
			SideNavigationViewController.backdropLayer.hidden = true
		})
		view.layer.addSublayer(SideNavigationViewController.backdropLayer)
	}
	
	//
	//	:name:	prepareLeftGestures
	//
	private func prepareLeftGestures() {
		removeGestures(&leftPanGesture, tap: &leftTapGesture)
		prepareGestures(&leftPanGesture, panSelector: "handleLeftPanGesture:", tap: &leftTapGesture, tapSelector: "handleLeftTapGesture:")
	}
}