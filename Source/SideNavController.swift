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
	optional func sideNavDidBeginLeftPan(nav: SideNavController, container: SideNavContainer)
	optional func sideNavDidChangeLeftPan(nav: SideNavController, container: SideNavContainer)
	optional func sideNavDidEndLeftPan(nav: SideNavController, container: SideNavContainer)
	optional func sideNavDidOpenLeftViewContainer(nav: SideNavController, container: SideNavContainer)
	optional func sideNavDidCloseLeftViewContainer(nav: SideNavController, container: SideNavContainer)
	optional func sideNavDidTapLeft(nav: SideNavController, container: SideNavContainer)
	
	// right
	optional func sideNavDidBeginRightPan(nav: SideNavController, container: SideNavContainer)
	optional func sideNavDidChangeRightPan(nav: SideNavController, container: SideNavContainer)
	optional func sideNavDidEndRightPan(nav: SideNavController, container: SideNavContainer)
	optional func sideNavDidOpenRightViewContainer(nav: SideNavController, container: SideNavContainer)
	optional func sideNavDidCloseRightViewContainer(nav: SideNavController, container: SideNavContainer)
	optional func sideNavDidTapRight(nav: SideNavController, container: SideNavContainer)
    
    // bottom
    optional func sideNavDidBeginBottomPan(nav: SideNavController, container: SideNavContainer)
    optional func sideNavDidChangeBottomPan(nav: SideNavController, container: SideNavContainer)
    optional func sideNavDidEndBottomPan(nav: SideNavController, container: SideNavContainer)
    optional func sideNavDidOpenBottomViewContainer(nav: SideNavController, container: SideNavContainer)
    optional func sideNavDidCloseBottomViewContainer(nav: SideNavController, container: SideNavContainer)
    optional func sideNavDidTapBottom(nav: SideNavController, container: SideNavContainer)
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
        public static var pointOfNoReturnheight: CGFloat = 48
		public static var backdropViewContainerBackgroundColor: UIColor = .blackColor()
		public static var animationDuration: CGFloat = 0.5
		public static var leftBezelWidth: CGFloat = 16
		public static var leftViewContainerWidth: CGFloat = 240
		public static var leftPanFromBezel: Bool = true
		public static var rightBezelWidth: CGFloat = 16
		public static var rightViewContainerWidth: CGFloat = 240
		public static var rightPanFromBezel: Bool = true
        public static var bottomBezelHeight: CGFloat = 16
        public static var bottomViewContainerHeight: CGFloat = 270
        public static var bottomPanFromBezel: Bool = true
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
		return 0 == leftViewContainer?.frame.origin.x
	}
	
	/**
		:name:	isRightContainerOpened
	*/
	public var isRightContainerOpened: Bool {
		if let c = rightViewContainer {
			return c.frame.origin.x == rightOriginX - c.frame.size.width
		}
		return false
	}
    
    /**
        :name:	isBottomContainerOpened
    */
    public var isBottomContainerOpened: Bool {
        if let c = bottomViewContainer {
            return c.frame.origin.y == bottomOriginY - c.frame.size.height
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
		:name:	rightViewContainer
	*/
	public private(set) var rightViewContainer: UIView?
    
    /**
        :name:	bottomViewContainer
    */
    public private(set) var bottomViewContainer: UIView?
	
	/**
		:name:	leftContainer
	*/
	public private(set) var leftContainer: SideNavContainer?
	
	/**
		:name:	rightContainer
	*/
	public private(set) var rightContainer: SideNavContainer?
    
    /**
    :name:	bottomContainer
    */
    public private(set) var bottomContainer: SideNavContainer?
	
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
    :name:	leftViewController
    */
    public var bottomViewController: UIViewController?

	/**
		:name:	leftPanGesture
	*/
    public var leftPanGesture: UIPanGestureRecognizer?
	
	/**
		:name:	leftTapGesture
	*/
	public var leftTapGesture: UITapGestureRecognizer?
	
    /**
        :name:	rightTapGesture
    */
    public var rightTapGesture: UITapGestureRecognizer?
    
    /**
        :name:	rightTapGesture
    */
    public var bottomTapGesture: UITapGestureRecognizer?
    
	/**
		:name:	rightPanGesture
	*/
	public var rightPanGesture: UIPanGestureRecognizer?
    
    /**
        :name:	rightPanGesture
    */
    public var bottomPanGesture: UIPanGestureRecognizer?
	
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
    
    //
    //	:name:	bottomOriginY
    //
    private var bottomOriginY: CGFloat {
        return view.bounds.height
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
		prepareView()
		prepareLeftView()
    }
	
	/**
		:name:	init
	*/
    public convenience init(mainViewController: UIViewController, rightViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.rightViewController = rightViewController
		prepareView()
		prepareRightView()
    }
    
    /**
        :name:	init
    */
    public convenience init(mainViewController: UIViewController, bottomViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.bottomViewController = bottomViewController
        setupView()
        setupBottomView()
    }
	
	/**
		:name:	init
	*/
    public convenience init(mainViewController: UIViewController, leftViewController: UIViewController, rightViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.leftViewController = leftViewController
        self.rightViewController = rightViewController
        prepareView()
		prepareLeftView()
		prepareRightView()
    }
    
    /**
        :name:	init
    */
    public convenience init(mainViewController: UIViewController, leftViewController: UIViewController, bottomViewController: UIViewController, rightViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.leftViewController = leftViewController
        self.bottomViewController = bottomViewController
        self.rightViewController = rightViewController
        setupView()
        setupLeftView()
        setupBottomView()
        setupRightView()
    }
    
    /**
    :name:	init
    */
    public convenience init(mainViewController: UIViewController, bottomViewController: UIViewController, rightViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.bottomViewController = bottomViewController
        self.rightViewController = rightViewController
        setupView()
        setupBottomView()
        setupRightView()
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
		prepareContainedViewController(&mainViewContainer, viewController: &mainViewController)
		prepareContainedViewController(&leftViewContainer, viewController: &leftViewController)
		prepareContainedViewController(&rightViewContainer, viewController: &rightViewController)
        prepareContainedViewController(&bottomViewContainer, viewController: &bottomViewController)
	}
	
	//
	//	:name:	viewWillTransitionToSize
	//
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        mainViewContainer?.transform = CGAffineTransformMakeScale(1, 1)
        leftViewContainer?.hidden = true
        rightViewContainer?.hidden = true
        bottomViewContainer?.hidden = true
        coordinator.animateAlongsideTransition(nil) { _ in
			self.toggleWindow()
			self.backdropViewContainer?.layer.opacity = 0
			self.mainViewContainer?.transform = CGAffineTransformMakeScale(1, 1)
			self.isUserInteractionEnabled = true
			
			if let vc = self.leftViewContainer {
				vc.frame.origin.x = self.leftOriginX
				vc.hidden = false
				self.removeShadow(&self.leftViewContainer)
				self.prepareLeftGestures()
			}
			
			if let vc = self.rightViewContainer {
				vc.frame.origin.x = self.rightOriginX
				vc.hidden = false
				self.removeShadow(&self.rightViewContainer)
				self.prepareRightGestures()
			}
            
            if let vc = self.bottomViewContainer {
                vc.frame.origin.y = self.bottomOriginY
                vc.hidden = false
                self.removeShadow(&self.bottomViewContainer)
                self.prepareBottomGestures()
            }
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
		if let vc = leftViewContainer {
			if let c = leftContainer {
				prepareContainerToOpen(&leftViewController, viewContainer: &leftViewContainer, state: c.state)
				UIView.animateWithDuration(Double(0 == velocity ? options.animationDuration : fmax(0.1, fmin(1, Double(vc.frame.origin.x / velocity)))),
					delay: 0,
					options: .CurveEaseInOut,
					animations: { _ in
						vc.frame.origin.x = 0
						self.backdropViewContainer?.layer.opacity = Float(options.contentViewOpacity)
						self.mainViewContainer?.transform = CGAffineTransformMakeScale(options.contentViewScale, options.contentViewScale)
					}
				) { _ in
					self.isUserInteractionEnabled = false
					self.leftViewController?.endAppearanceTransition()
				}
				c.state = .Opened
				delegate?.sideNavDidOpenLeftViewContainer?(self, container: c)
			}
		}
	}
	
	/**
		:name:	openRightViewContainer
	*/
	public func openRightViewContainer(velocity: CGFloat = 0) {
		if let vc = rightViewContainer {
			if let c = rightContainer {
				prepareContainerToOpen(&rightViewController, viewContainer: &rightViewContainer, state: c.state)
				UIView.animateWithDuration(Double(0 == velocity ? options.animationDuration : fmax(0.1, fmin(1, Double(fabs(vc.frame.origin.x - rightOriginX) / velocity)))),
					delay: 0,
					options: .CurveEaseInOut,
					animations: { _ in
						vc.frame.origin.x = self.rightOriginX - vc.frame.size.width
						self.backdropViewContainer?.layer.opacity = Float(options.contentViewOpacity)
						self.mainViewContainer?.transform = CGAffineTransformMakeScale(options.contentViewScale, options.contentViewScale)
					}
				) { _ in
					self.isUserInteractionEnabled = false
					self.rightViewController?.endAppearanceTransition()
				}
				c.state = .Opened
				delegate?.sideNavDidOpenRightViewContainer?(self, container: c)
			}
		}
	}
    
    /**
    :name:	openRightViewContainer
    */
    public func openBottomViewContainer(velocity: CGFloat = 0) {
        if let vc = bottomViewContainer {
            if let c = bottomContainer {
                prepareContainerToOpen(&bottomViewController, viewContainer: &bottomViewContainer, state: c.state)
                UIView.animateWithDuration(Double(0 == velocity ? options.animationDuration : fmax(0.1, fmin(1, Double(fabs(vc.frame.origin.y - bottomOriginY) / velocity)))),
                    delay: 0,
                    options: .CurveEaseInOut,
                    animations: { _ in
                        vc.frame.origin.y = self.bottomOriginY - vc.frame.size.height
                        self.backdropViewContainer?.layer.opacity = Float(options.contentViewOpacity)
                        self.mainViewContainer?.transform = CGAffineTransformMakeScale(options.contentViewScale, options.contentViewScale)
                    }
                    ) { _ in
                        self.isUserInteractionEnabled = false
                        self.rightViewController?.endAppearanceTransition()
                }
                c.state = .Opened
                delegate?.sideNavDidOpenRightViewContainer?(self, container: c)
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
					self.leftViewController?.endAppearanceTransition()
				}
				c.state = .Closed
				delegate?.sideNavDidCloseLeftViewContainer?(self, container: c)
			}
		}
	}
	
	/**
		:name:	closeRightViewContainer
	*/
	public func closeRightViewContainer(velocity: CGFloat = 0) {
		if let vc = rightViewContainer {
			if let c = rightContainer {
				prepareContainerToClose(&rightViewController, state: c.state)
				UIView.animateWithDuration(Double(0 == velocity ? options.animationDuration : fmax(0.1, fmin(1, fabs(vc.frame.origin.x - rightOriginX) / velocity))),
					delay: 0,
					options: .CurveEaseInOut,
					animations: { _ in
						vc.frame.origin.x = self.rightOriginX
						self.backdropViewContainer?.layer.opacity = 0
						self.mainViewContainer?.transform = CGAffineTransformMakeScale(1, 1)
					}
				) { _ in
					self.removeShadow(&self.rightViewContainer)
					self.isUserInteractionEnabled = true
					self.rightViewController?.endAppearanceTransition()
				}
				c.state = .Closed
				delegate?.sideNavDidCloseRightViewContainer?(self, container: c)
			}
		}
	}

    /**
        :name:	closeRightViewContainer
    */
    public func closeBottomViewContainer(velocity: CGFloat = 0) {
        if let vc = bottomViewContainer {
            if let c = bottomContainer {
                prepareContainerToClose(&bottomViewController, state: c.state)
                UIView.animateWithDuration(Double(0 == velocity ? options.animationDuration : fmax(0.1, fmin(1, fabs(vc.frame.origin.y - bottomOriginY) / velocity))),
                    delay: 0,
                    options: .CurveEaseInOut,
                    animations: { _ in
                        vc.frame.origin.y = self.bottomOriginY
                        self.backdropViewContainer?.layer.opacity = 0
                        self.mainViewContainer?.transform = CGAffineTransformMakeScale(1, 1)
                    }
                    ) { _ in
                        self.removeShadow(&self.bottomViewContainer)
                        self.isUserInteractionEnabled = true
                        self.bottomViewController?.endAppearanceTransition()
                }
                c.state = .Closed
                delegate?.sideNavDidCloseBottomViewContainer?(self, container: c)
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
			closeRightViewContainer()
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
	
	/**
		:name:	switchRightViewController
	*/
	public func switchRightViewController(viewController: UIViewController, closeRightViewContainerViewContainer: Bool) {
		removeViewController(&rightViewController)
		rightViewController = viewController
		prepareContainedViewController(&rightViewContainer, viewController: &rightViewController)
		if closeRightViewContainerViewContainer {
			closeRightViewContainer()
		}
	}
    
    /**
        :name:	switchBottomViewController
    */
    public func switchBottomViewController(viewController: UIViewController, closeBottomViewContainerViewContainer: Bool) {
        removeViewController(&rightViewController)
        rightViewController = viewController
        prepareContainedViewController(&rightViewContainer, viewController: &rightViewController)
        if closeBottomViewContainerViewContainer {
            closeBottomViewContainer()
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
        if gestureRecognizer == bottomPanGesture {
            return gesturePanBottomViewController(gestureRecognizer, withTouchPoint: touch.locationInView(view))
        }
		if gestureRecognizer == leftTapGesture {
			return isLeftContainerOpened && !isPointContainedWithinViewController(&leftViewContainer, point: touch.locationInView(view))
		}
		if gestureRecognizer == rightTapGesture {
			return isRightContainerOpened && !isPointContainedWithinViewController(&rightViewContainer, point: touch.locationInView(view))
		}
        if gestureRecognizer == bottomTapGesture {
            return isBottomContainerOpened && !isPointContainedWithinViewController(&bottomViewContainer, point: touch.locationInView(view))
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
	internal func setupLeftView() {
        	prepareContainer(&leftContainer, viewContainer: &leftViewContainer, originX: leftOriginX, originY: 0, width: options.leftViewContainerWidth, height: view.bounds.size.height)
		prepareLeftGestures()
	}
	
	//
	//	:name:	prepareRightView
	//
	internal func setupRightView() {
        	prepareContainer(&rightContainer, viewContainer: &rightViewContainer, originX: rightOriginX, originY: 0, width: options.rightViewContainerWidth, height: view.bounds.size.height)
		prepareRightGestures()
	}
    
    //
    //	:name:	setupBottomView
    //
    internal func setupBottomView() {
        prepareContainer(&bottomContainer, viewContainer: &bottomViewContainer, originX: 0, originY: bottomOriginY, width: view.bounds.size.width, height: options.bottomViewContainerHeight)
        prepareBottomGestures()
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
		if let vc = leftViewContainer {
			if let c = leftContainer {
				if .Began == gesture.state {
					leftViewController?.beginAppearanceTransition(!isLeftContainerOpened, animated: true)
					addShadow(&leftViewContainer)
					toggleWindow(shouldOpen: true)
					c.state = isLeftContainerOpened ? .Opened : .Closed
					c.point = gesture.locationInView(view)
					c.frame = vc.frame
					delegate?.sideNavDidBeginLeftPan?(self, container: c)
				} else if .Changed == gesture.state {
					c.point = gesture.translationInView(gesture.view!)
					let r = (vc.frame.origin.x - leftOriginX) / vc.frame.size.width
					let s: CGFloat = 1 - (1 - options.contentViewScale) * r
					let x: CGFloat = c.frame.origin.x + c.point.x
					vc.frame.origin.x = x < leftOriginX ? leftOriginX : x > 0 ? 0 : x
					backdropViewContainer?.layer.opacity = Float(r * options.contentViewOpacity)
					mainViewContainer?.transform = CGAffineTransformMakeScale(s, s)
					delegate?.sideNavDidChangeLeftPan?(self, container: c)
				} else {
					c.point = gesture.velocityInView(gesture.view)
					let x: CGFloat = c.point.x >= 1000 || c.point.x <= -1000 ? c.point.x : 0
					c.state = vc.frame.origin.x <= CGFloat(floor(leftOriginX)) + options.pointOfNoReturnWidth || c.point.x <= -1000 ? .Closed : .Opened
					if .Closed == c.state {
						closeLeftViewContainer(velocity: x)
					} else {
						openLeftViewContainer(velocity: x)
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
	//	:name:	handleRightPanGesture
	//
	internal func handleRightPanGesture(gesture: UIPanGestureRecognizer) {
		if isLeftContainerOpened { return }
		if let vc = rightViewContainer {
			if let c = rightContainer {
				if .Began == gesture.state {
					c.point = gesture.locationInView(view)
					c.state = isRightContainerOpened ? .Opened : .Closed
					c.frame = vc.frame
					rightViewController?.beginAppearanceTransition(!isRightContainerOpened, animated: true)
					addShadow(&rightViewContainer)
					toggleWindow(shouldOpen: true)
					delegate?.sideNavDidBeginRightPan?(self, container: c)
				} else if .Changed == gesture.state {
					c.point = gesture.translationInView(gesture.view!)
					let r = (rightOriginX - vc.frame.origin.x) / vc.frame.size.width
					let s: CGFloat = 1 - (1 - options.contentViewScale) * r
					let m: CGFloat = rightOriginX - vc.frame.size.width
					let x: CGFloat = c.frame.origin.x + c.point.x
					vc.frame.origin.x = x > rightOriginX ? rightOriginX : x < m ? m : x
					backdropViewContainer?.layer.opacity = Float(r * options.contentViewOpacity)
					mainViewContainer?.transform = CGAffineTransformMakeScale(s, s)
					delegate?.sideNavDidChangeRightPan?(self, container: c)
				} else {
					c.point = gesture.velocityInView(gesture.view)
					let x: CGFloat = c.point.x <= -1000 || c.point.x >= 1000 ? c.point.x : 0
					c.state = vc.frame.origin.x >= CGFloat(floor(rightOriginX) - options.pointOfNoReturnWidth) || c.point.x >= 1000 ? .Closed : .Opened
					if .Closed == c.state {
						closeRightViewContainer(velocity: x)
					} else {
						openRightViewContainer(velocity: x)
					}
					delegate?.sideNavDidEndRightPan?(self, container: c)
				}
			}
		}
	}
	
	//
	//	:name:	handleRightTapGesture
	//
	internal func handleRightTapGesture(gesture: UIPanGestureRecognizer) {
		if let c = rightContainer {
			delegate?.sideNavDidTapRight?(self, container: c)
			closeRightViewContainer()
		}
	}
    
    //
    //	:name:	handleRightPanGesture
    //
    internal func handleBottomPanGesture(gesture: UIPanGestureRecognizer) {
        if  isLeftContainerOpened || isRightContainerOpened { return }
        if .Began == gesture.state {
            if let vc = bottomViewContainer {
                if let c = bottomContainer {
                    bottomViewController?.beginAppearanceTransition(!isBottomContainerOpened, animated: true)
                    addShadow(&bottomViewContainer)
                    toggleWindow(shouldOpen: true)
                    c.state = isBottomContainerOpened ? .Opened : .Closed
                    c.point = gesture.locationInView(view)
                    c.frame = vc.frame
                    delegate?.sideNavDidBeginBottomPan?(self, container: c)
                }
            }
        } else if .Changed == gesture.state {
            if let vc = bottomViewContainer {
                if let c = bottomContainer {
                    c.point = gesture.translationInView(gesture.view!)
                    let r = (bottomOriginY - vc.frame.origin.y) / vc.frame.size.height
                    let s: CGFloat = 1 - (1 - options.contentViewScale) * r
                    let m: CGFloat = bottomOriginY - vc.frame.size.height
                    let y: CGFloat = c.frame.origin.y + c.point.y
                    vc.frame.origin.y = y > bottomOriginY ? bottomOriginY : y < m ? m : y
                    backdropViewContainer?.layer.opacity = Float(r * options.contentViewOpacity)
                    mainViewContainer?.transform = CGAffineTransformMakeScale(s, s)
                    delegate?.sideNavDidChangeBottomPan?(self, container: c)
                }
            }
        } else {
            if let vc = bottomViewContainer {
                if let c = bottomContainer {
                    c.point = gesture.velocityInView(gesture.view)
                    let y: CGFloat = c.point.y <= -1000 || c.point.y >= 1000 ? c.point.y : 0
                    c.state = vc.frame.origin.y >= CGFloat(floor(bottomOriginY) - options.pointOfNoReturnheight) || c.point.y >= 1000 ? .Closed : .Opened
                    if .Closed == c.state {
                        closeBottomViewContainer(velocity: y)
                    } else {
                        openBottomViewContainer(velocity: y)
                    }
                    delegate?.sideNavDidEndBottomPan?(self, container: c)
                }
            }
        }
    }
    
    //
    //	:name:	handleRightTapGesture
    //
    internal func handleBottomTapGesture(gesture: UIPanGestureRecognizer) {
        if let c = bottomContainer {
            delegate?.sideNavDidTapBottom?(self, container: c)
            closeBottomViewContainer()
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
    //	:name:	gesturePanRightViewController
    //
    private func gesturePanRightViewController(gesture: UIGestureRecognizer, withTouchPoint point: CGPoint) -> Bool {
        return isRightContainerOpened || options.rightPanFromBezel && isRightPointContainedWithinRect(point)
    }
    
    //
    //	:name:	gesturePanRightViewController
    //
    private func gesturePanBottomViewController(gesture: UIGestureRecognizer, withTouchPoint point: CGPoint) -> Bool {
        return isBottomContainerOpened || options.bottomPanFromBezel && isBottomPointContainedWithinRect(point)
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
    //	:name:	isBottomPointContainedWithinRect
    //
    private func isBottomPointContainedWithinRect(point: CGPoint) -> Bool {
        var r: CGRect = CGRectZero
        var t: CGRect = CGRectZero
        let h: CGFloat = bottomOriginY - options.bottomBezelHeight
        CGRectDivide(view.bounds, &t, &r, h, .MinYEdge)
        return CGRectContainsPoint(r, point)
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
		mainViewContainer!.backgroundColor = .clearColor()
		mainViewContainer!.autoresizingMask = .FlexibleHeight | .FlexibleWidth
		view.addSubview(mainViewContainer!)
	}
	
	//
	//	:name:	prepareBackdropContainer
	//
	private func prepareBackdropContainer() {
		backdropViewContainer = UIView(frame: view.bounds)
		backdropViewContainer!.backgroundColor = options.backdropViewContainerBackgroundColor
		backdropViewContainer!.autoresizingMask = .FlexibleHeight | .FlexibleWidth
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
    //	:name:	prepareRightGestures
    //
    private func prepareRightGestures() {
        removeGestures(&rightPanGesture, tap: &rightTapGesture)
        addGestures(&rightPanGesture, panSelector: "handleRightPanGesture:", tap: &rightTapGesture, tapSelector: "handleRightTapGesture:")
    }
    
    //
    //	:name:	prepareBottomGestures
    //
    private func prepareBottomGestures() {
        removeGestures(&bottomPanGesture, tap: &bottomTapGesture)
        addGestures(&bottomPanGesture, panSelector: "handleBottomPanGesture:", tap: &bottomTapGesture, tapSelector: "handleBottomTapGesture:")
    }
	
	//
	//	:name:	prepareContainer
	//
    private func prepareContainer(inout container: SideNavContainer?, inout viewContainer: UIView?, originX: CGFloat, originY: CGFloat, width: CGFloat, height: CGFloat) {
		container = SideNavContainer(state: .Closed, point: CGPointZero, frame: CGRectZero)
		var b: CGRect = view.bounds
		b.size.width = width
        b.size.height = height
		b.origin.x = originX
        b.origin.y = originY
		viewContainer = UIView(frame: b)
		viewContainer!.backgroundColor = .clearColor()
		viewContainer!.autoresizingMask = .FlexibleHeight
		view.addSubview(viewContainer!)
	}
	
	//
	//	:name:	prepareContainerToOpen
	//
	private func prepareContainerToOpen(inout viewController: UIViewController?, inout viewContainer: UIView?, state: SideNavState) {
		viewController?.beginAppearanceTransition(.Opened == state, animated: true)
		addShadow(&viewContainer)
		toggleWindow(shouldOpen: true)
	}
	
	//
	//	:name:	prepareContainerToClose
	//
	private func prepareContainerToClose(inout viewController: UIViewController?, state: SideNavState) {
		viewController?.beginAppearanceTransition(.Opened == state, animated: true)
		toggleWindow()
	}
	
	//
	//	:name:	prepareContainedViewController
	//
	private func prepareContainedViewController(inout viewContainer: UIView?, inout viewController: UIViewController?) {
		if let vc = viewController {
			if let c = viewContainer {
				addChildViewController(vc)
				vc.view.frame = c.bounds
				c.addSubview(vc.view)
				vc.didMoveToParentViewController(self)
			}
		}
	}
}
