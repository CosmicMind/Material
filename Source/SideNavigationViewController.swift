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
	//	:name:	leftPanGesture
	//
	internal var leftPanGesture: UIPanGestureRecognizer?
	
	//
	//	:name:	leftTapGesture
	//
	internal var leftTapGesture: UITapGestureRecognizer?
	
	//
	//	:name:	isViewBasedAppearance
	//
	internal var isViewBasedAppearance: Bool {
		return 0 == NSBundle.mainBundle().objectForInfoDictionaryKey("UIViewControllerBasedStatusBarAppearance") as? Int
	}
	
	//
	//	:name:	isUserInteractionEnabled
	//
	internal var isUserInteractionEnabled: Bool {
		get {
			return mainViewController!.view.userInteractionEnabled
		}
		set(value) {
			mainViewController!.view.userInteractionEnabled = value
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
		:name:	isLeftContainerOpened
	*/
	public var isLeftContainerOpened: Bool {
		return leftView?.x != -leftViewControllerWidth
	}
	
	/**
		:name:	leftView
	*/
	public private(set) var leftView: MaterialView?
	
	/**
		:name:	maintViewController
	*/
	public var mainViewController: UIViewController?
	
	/**
		:name:	leftViewController
	*/
	public var leftViewController: UIViewController?
	
	/**
		:name:	leftViewControllerWidth
	*/
	public var leftViewControllerWidth: CGFloat = 240 {
		didSet {
			if let v = leftView {
				v.width = leftViewControllerWidth
				MaterialAnimation.animationDisabled({
					v.position = CGPointMake(-v.width / 2, v.height / 2)
				})
			}
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
	public convenience init(mainViewController: UIViewController, leftViewController: UIViewController) {
		self.init()
		self.mainViewController = mainViewController
		self.leftViewController = leftViewController
		prepareView()
		prepareMainView()
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
		isLeftContainerOpened ? closeLeftViewContainer(velocity) : openLeftViewContainer(velocity)
	}
	
	/**
		:name:	openLeftViewContainer
	*/
	public func openLeftViewContainer(velocity: CGFloat = 0) {
		if let vc = leftView {
			let w: CGFloat = vc.width
			let h: CGFloat = vc.height
			let d: Double = Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(vc.x / velocity))))
			
			MaterialAnimation.animationWithDuration(d, animations: {
				vc.position = CGPointMake(w / 2, h / 2)
				self.backdropLayer.hidden = false
			}) {
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
			let d: Double = Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(vc.x / velocity))))
			
			MaterialAnimation.animationWithDuration(d, animations: {
				vc.position = CGPointMake(-w / 2, h / 2)
				self.backdropLayer.hidden = true
			}) {
				self.isUserInteractionEnabled = true
				self.toggleStatusBar(false)
			}
		}
	}
	
	//
	//	:name:	gestureRecognizer
	//
	public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		if !enabled {
			return false
		}
		if gestureRecognizer == leftPanGesture {
			return gesturePanLeftViewController(gestureRecognizer, withTouchPoint: touch.locationInView(view))
		}
		if gestureRecognizer == leftTapGesture {
			return isLeftContainerOpened && !isPointContainedWithinViewController(leftView!, point: touch.locationInView(view))
		}
		return false
	}
	
	//
	//	:name:	prepareView
	//
	internal func prepareView() {
		backdropColor = MaterialColor.black
		prepareBackdropLayer()
	}
	
	//
	//	:name:	prepareMainView
	//
	internal func prepareMainView() {
		prepareViewControllerWithinContainer(mainViewController!, container: view)
	}
	
	//
	//	:name:	prepareLeftView
	//
	internal func prepareLeftView() {
		// container
		leftView = MaterialView(frame: CGRectMake(0, 0, leftViewControllerWidth, view.frame.height))
		view.addSubview(leftView!)
		
		MaterialAnimation.animationDisabled({
			self.leftView!.position = CGPointMake(-self.leftView!.width / 2, self.leftView!.height / 2)
			self.leftView!.zPosition = 1000
			self.leftView!.masksToBounds = true
		})
		
		prepareViewControllerWithinContainer(leftViewController!, container: leftView!)
		
		// gestures
		prepareLeftGestures()
	}
	
	//
	//	:name:	handleLeftPanGesture
	//
	internal func handleLeftPanGesture(recognizer: UIPanGestureRecognizer) {
		if let v = leftView {
			switch recognizer.state {
			case .Began:
				originalPosition = v.position
				toggleStatusBar(true)
				backdropLayer.hidden = false
			case .Changed:
				let translation: CGPoint = recognizer.translationInView(v)
				let w: CGFloat = v.width
				MaterialAnimation.animationDisabled({
					v.position.x = self.originalPosition.x + translation.x > (w / 2) ? (w / 2) : self.originalPosition.x + translation.x
				})
			case .Ended:
				let point: CGPoint = recognizer.velocityInView(recognizer.view)
				let x: CGFloat = point.x >= 1000 || point.x <= -1000 ? point.x : 0
				if v.x <= CGFloat(floor(-leftViewControllerWidth)) + horizontalThreshold || point.x <= -1000 {
					closeLeftViewContainer(x)
				} else {
					openLeftViewContainer(x)
				}
			default:break
			}
		}
	}
	
	//
	//	:name:	handleLeftTapGesture
	//
	internal func handleLeftTapGesture(recognizer: UIPanGestureRecognizer) {
		if let _ = leftView {
			closeLeftViewContainer()
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
	//	:name:	gesturePanLeftViewController
	//
	private func gesturePanLeftViewController(gesture: UIGestureRecognizer, withTouchPoint point: CGPoint) -> Bool {
		return isLeftContainerOpened || enabled && isLeftPointContainedWithinRect(point)
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
		MaterialAnimation.animationDisabled({
			self.backdropLayer.frame = self.view.bounds
			self.backdropLayer.zPosition = 900
			self.backdropLayer.hidden = true
		})
		view.layer.addSublayer(backdropLayer)
	}
	
	//
	//	:name:	prepareViewControllerWithinContainer
	//
	private func prepareViewControllerWithinContainer(controller: UIViewController, container: UIView) {
		controller.view.translatesAutoresizingMaskIntoConstraints = false
		addChildViewController(controller)
		container.addSubview(controller.view)
		controller.didMoveToParentViewController(self)
		MaterialLayout.alignToParent(container, child: controller.view)
	}
	
	//
	//	:name:	prepareLeftGestures
	//
	private func prepareLeftGestures() {
		removeGestures(&leftPanGesture, tap: &leftTapGesture)
		prepareGestures(&leftPanGesture, panSelector: "handleLeftPanGesture:", tap: &leftTapGesture, tapSelector: "handleLeftTapGesture:")
	}
}