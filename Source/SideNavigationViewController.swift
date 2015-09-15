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

extension UIViewController {
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
	
	// right
	optional func sideNavDidBeginRightPan(nav: SideNavigationViewController, container: SideNavigationViewContainer)
	optional func sideNavDidChangeRightPan(nav: SideNavigationViewController, container: SideNavigationViewContainer)
	optional func sideNavDidEndRightPan(nav: SideNavigationViewController, container: SideNavigationViewContainer)
	optional func sideNavDidOpenRightViewContainer(nav: SideNavigationViewController, container: SideNavigationViewContainer)
	optional func sideNavDidCloseRightViewContainer(nav: SideNavigationViewController, container: SideNavigationViewContainer)
	optional func sideNavDidTapRight(nav: SideNavigationViewController, container: SideNavigationViewContainer)
    
    // bottom
    optional func sideNavDidBeginBottomPan(nav: SideNavigationViewController, container: SideNavigationViewContainer)
    optional func sideNavDidChangeBottomPan(nav: SideNavigationViewController, container: SideNavigationViewContainer)
    optional func sideNavDidEndBottomPan(nav: SideNavigationViewController, container: SideNavigationViewContainer)
    optional func sideNavDidOpenBottomViewContainer(nav: SideNavigationViewController, container: SideNavigationViewContainer)
    optional func sideNavDidCloseBottomViewContainer(nav: SideNavigationViewController, container: SideNavigationViewContainer)
    optional func sideNavDidTapBottom(nav: SideNavigationViewController, container: SideNavigationViewContainer)
    
    // top
    optional func sideNavDidBeginTopPan(nav: SideNavigationViewController, container: SideNavigationViewContainer)
    optional func sideNavDidChangeTopPan(nav: SideNavigationViewController, container: SideNavigationViewContainer)
    optional func sideNavDidEndTopPan(nav: SideNavigationViewController, container: SideNavigationViewContainer)
    optional func sideNavDidOpenTopViewContainer(nav: SideNavigationViewController, container: SideNavigationViewContainer)
    optional func sideNavDidCloseTopViewContainer(nav: SideNavigationViewController, container: SideNavigationViewContainer)
    optional func sideNavDidTapTop(nav: SideNavigationViewController, container: SideNavigationViewContainer)
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
		public static var backdropBackgroundColor: UIColor = MaterialTheme.black.color
		public static var animationDuration: CGFloat = defaultOptions.defaultAnimationDuration
		public static var leftBezelWidth: CGFloat = defaultOptions.bezelWidth
		public static var leftViewContainerWidth: CGFloat = defaultOptions.containerWidth
		public static var leftPanFromBezel: Bool = defaultOptions.panningEnabled
		public static var rightBezelWidth: CGFloat = defaultOptions.bezelWidth
		public static var rightViewContainerWidth: CGFloat = defaultOptions.containerWidth
		public static var rightPanFromBezel: Bool = defaultOptions.panningEnabled
        public static var bottomBezelHeight: CGFloat = defaultOptions.bezelHeight
        public static var bottomViewContainerHeight: CGFloat = defaultOptions.containerHeight
        public static var bottomPanFromBezel: Bool = defaultOptions.panningEnabled
        public static var topBezelHeight: CGFloat = defaultOptions.bezelHeight
        public static var topViewContainerHeight: CGFloat = defaultOptions.containerHeight
        public static var topPanFromBezel: Bool = defaultOptions.panningEnabled
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
		:name:	isRightContainerOpened
	*/
	public var isRightContainerOpened: Bool {
		if let c = rightViewContainer {
			return c.frame.origin.x != rightOriginX
		}
		return false
	}
    
    /**
        :name:	isBottomContainerOpened
    */
    public var isBottomContainerOpened: Bool {
        if let c = bottomViewContainer {
            return c.frame.origin.y != bottomOriginY
        }
        return false
    }
    
    /**
		:name:	isTopContainerOpened
    */
    public var isTopContainerOpened: Bool {
        if let c = topViewContainer {
            return c.frame.origin.y != topOriginY
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
		:name:	bottomViewContainer
    */
    public private(set) var topViewContainer: UIView?
	
	/**
		:name:	leftContainer
	*/
	public private(set) var leftContainer: SideNavigationViewContainer?
	
	/**
		:name:	rightContainer
	*/
	public private(set) var rightContainer: SideNavigationViewContainer?
    
    /**
		:name:	bottomContainer
    */
    public private(set) var bottomContainer: SideNavigationViewContainer?
    
    /**
		:name:	topContainer
    */
    public private(set) var topContainer: SideNavigationViewContainer?
	
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
		:name:	topViewController
    */
    public var topViewController: UIViewController?

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
		:name:	topTapGesture
    */
    public var topTapGesture: UITapGestureRecognizer?
    
	/**
		:name:	rightPanGesture
	*/
	public var rightPanGesture: UIPanGestureRecognizer?
    
    /**
        :name:	rightPanGesture
    */
    public var bottomPanGesture: UIPanGestureRecognizer?
    
    /**
		:name:	rightPanGesture
    */
    public var topPanGesture: UIPanGestureRecognizer?
	
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
    
    //
    //	:name:	topOriginY
    //
    private var topOriginY: CGFloat {
        return -options.topViewContainerHeight
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
        prepareView()
        prepareBottomView()
    }

    /**
		:name:	init
    */
    public convenience init(mainViewController: UIViewController, topViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.topViewController = topViewController
        prepareView()
        prepareTopView()
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
    public convenience init(mainViewController: UIViewController, leftViewController: UIViewController, bottomViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.leftViewController = leftViewController
        self.bottomViewController = bottomViewController
        prepareView()
        prepareLeftView()
        prepareBottomView()
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
        prepareView()
        prepareLeftView()
        prepareBottomView()
        prepareRightView()
    }
    
    /**
		:name:	init
    */
    public convenience init(mainViewController: UIViewController, leftViewController: UIViewController, bottomViewController: UIViewController, rightViewController: UIViewController, topViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.leftViewController = leftViewController
        self.bottomViewController = bottomViewController
        self.rightViewController = rightViewController
        self.topViewController = topViewController
        prepareView()
        prepareLeftView()
        prepareBottomView()
        prepareRightView()
        prepareTopView()
    }
    
    /**
		:name:	init
    */
    public convenience init(mainViewController: UIViewController, bottomViewController: UIViewController, rightViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.bottomViewController = bottomViewController
        self.rightViewController = rightViewController
        prepareView()
        prepareBottomView()
        prepareRightView()
    }

    /**
		:name:	init
    */
    public convenience init(mainViewController: UIViewController, bottomViewController: UIViewController, topViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.bottomViewController = bottomViewController
        self.topViewController = topViewController
        prepareView()
        prepareBottomView()
        prepareTopView()
    }
    
    /**
		:name:	init
    */
    public convenience init(mainViewController: UIViewController, rightViewController: UIViewController, topViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.rightViewController = rightViewController
        self.topViewController = topViewController
        prepareView()
        prepareRightView()
        prepareTopView()
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
        if mainViewController != nil {
            prepareContainedViewController(&mainViewContainer, viewController: &mainViewController)
        }
        if leftViewController != nil {
            prepareContainedViewController(&leftViewContainer, viewController: &leftViewController)
        }
        if rightViewController != nil {
            prepareContainedViewController(&rightViewContainer, viewController: &rightViewController)
        }
        if bottomViewController != nil {
            prepareContainedViewController(&bottomViewContainer, viewController: &bottomViewController)
        }
        if topViewController != nil {
            prepareContainedViewController(&topViewContainer, viewController: &topViewController)
        }
	}
		
	/**
		:name:	toggleLeftViewContainer
	*/
	public func toggleLeftViewContainer(velocity: CGFloat = 0) {
		isLeftContainerOpened ? closeLeftViewContainer(velocity) : openLeftViewContainer(velocity)
	}
	
	/**
		:name:	toggleRightViewContainer
	*/
	public func toggleRightViewContainer(velocity: CGFloat = 0) {
		isRightContainerOpened ? closeRightViewContainer(velocity) : openRightViewContainer(velocity)
	}
    
    /**
		:name:	toggleBottomViewContainer
    */
    public func toggleBottomViewContainer(velocity: CGFloat = 0) {
        isBottomContainerOpened ? closeBottomViewContainer(velocity) : openBottomViewContainer(velocity)
    }
    
    /**
		:name:	toggleTopViewContainer
    */
    public func toggleTopViewContainer(velocity: CGFloat = 0) {
        isTopContainerOpened ? closeTopViewContainer(velocity) : openTopViewContainer(velocity)
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
						self.backdropViewContainer?.layer.opacity = Float(options.backdropOpacity)
						self.mainViewContainer?.transform = CGAffineTransformMakeScale(options.backdropScale, options.backdropScale)
					}
				) { _ in
					self.isUserInteractionEnabled = false
				}
				c.state = .Opened
				delegate?.sideNavDidOpenRightViewContainer?(self, container: c)
			}
		}
	}
    
    /**
		:name:	openBottomViewContainer
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
                        self.backdropViewContainer?.layer.opacity = Float(options.backdropOpacity)
                        self.mainViewContainer?.transform = CGAffineTransformMakeScale(options.backdropScale, options.backdropScale)
                    }
                    ) { _ in
                        self.isUserInteractionEnabled = false
                }
                c.state = .Opened
                delegate?.sideNavDidOpenRightViewContainer?(self, container: c)
            }
        }
    }
    
    /**
		:name:	openTopViewContainer
    */
    public func openTopViewContainer(velocity: CGFloat = 0) {
        if let vc = topViewContainer {
            if let c = topContainer {
                prepareContainerToOpen(&topViewController, viewContainer: &topViewContainer, state: c.state)
                UIView.animateWithDuration(Double(0 == velocity ? options.animationDuration : fmax(0.1, fmin(1, Double(fabs(vc.frame.origin.y + topOriginY) / velocity)))),
                    delay: 0,
                    options: .CurveEaseInOut,
                    animations: { _ in
                        vc.frame.origin.y = self.topOriginY + vc.frame.size.height
                        self.backdropViewContainer?.layer.opacity = Float(options.backdropOpacity)
                        self.mainViewContainer?.transform = CGAffineTransformMakeScale(options.backdropScale, options.backdropScale)
                    }
                    ) { _ in
                        self.isUserInteractionEnabled = false
                }
                c.state = .Opened
                delegate?.sideNavDidOpenTopViewContainer?(self, container: c)
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
				}
				c.state = .Closed
				delegate?.sideNavDidCloseRightViewContainer?(self, container: c)
			}
		}
	}

    /**
        :name:	closeBottomViewContainer
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
                }
                c.state = .Closed
                delegate?.sideNavDidCloseBottomViewContainer?(self, container: c)
            }
        }
    }

    /**
		:name:	closeBottomViewContainer
    */
    public func closeTopViewContainer(velocity: CGFloat = 0) {
        if let vc = topViewContainer {
            if let c = topContainer {
                prepareContainerToClose(&topViewController, state: c.state)
                UIView.animateWithDuration(Double(0 == velocity ? options.animationDuration : fmax(0.1, fmin(1, fabs(vc.frame.origin.y - topOriginY) / velocity))),
                    delay: 0,
                    options: .CurveEaseInOut,
                    animations: { _ in
                        vc.frame.origin.y = self.topOriginY
                        self.backdropViewContainer?.layer.opacity = 0
                        self.mainViewContainer?.transform = CGAffineTransformMakeScale(1, 1)
                    }
                    ) { _ in
                        self.removeShadow(&self.topViewContainer)
                        self.isUserInteractionEnabled = true
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
    
    /**
		:name:	switchTopViewController
    */
    public func switchTopViewController(viewController: UIViewController, closeTopViewContainerViewContainer: Bool) {
        removeViewController(&topViewController)
        topViewController = viewController
        prepareContainedViewController(&topViewContainer, viewController: &topViewController)
        if closeTopViewContainerViewContainer {
            closeTopViewContainer()
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
        if gestureRecognizer == topPanGesture {
            return gesturePanTopViewController(gestureRecognizer, withTouchPoint: touch.locationInView(view))
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
        if gestureRecognizer == topTapGesture {
            return isTopContainerOpened && !isPointContainedWithinViewController(&topViewContainer, point: touch.locationInView(view))
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
	//	:name:	prepareRightView
	//
	internal func prepareRightView() {
        	prepareContainer(&rightContainer, viewContainer: &rightViewContainer, originX: rightOriginX, originY: 0, width: options.rightViewContainerWidth, height: view.bounds.size.height)
		prepareRightGestures()
	}
    
    //
    //	:name:	prepareBottomView
    //
    internal func prepareBottomView() {
        prepareContainer(&bottomContainer, viewContainer: &bottomViewContainer, originX: 0, originY: bottomOriginY, width: view.bounds.size.width, height: options.bottomViewContainerHeight)
        prepareBottomGestures()
    }
    
    //
    //	:name:	prepareBottomView
    //
    internal func prepareTopView() {
        prepareContainer(&topContainer, viewContainer: &topViewContainer, originX: 0, originY: topOriginY, width: view.bounds.size.width, height: options.topViewContainerHeight)
        prepareTopGestures()
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
		if isRightContainerOpened || isBottomContainerOpened || isTopContainerOpened { return }
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
	//	:name:	handleRightPanGesture
	//
	internal func handleRightPanGesture(gesture: UIPanGestureRecognizer) {
		if isLeftContainerOpened || isBottomContainerOpened || isTopContainerOpened { return }
		if let vc = rightViewContainer {
			if let c = rightContainer {
				if .Began == gesture.state {
					c.point = gesture.locationInView(view)
					c.state = isRightContainerOpened ? .Opened : .Closed
					c.frame = vc.frame
					addShadow(&rightViewContainer)
					toggleStatusBar(true)
					delegate?.sideNavDidBeginRightPan?(self, container: c)
				} else if .Changed == gesture.state {
					c.point = gesture.translationInView(gesture.view!)
					let r = (rightOriginX - vc.frame.origin.x) / vc.frame.size.width
					let m: CGFloat = rightOriginX - vc.frame.size.width
					let x: CGFloat = c.frame.origin.x + c.point.x
					vc.frame.origin.x = x > rightOriginX ? rightOriginX : x < m ? m : x
					backdropViewContainer?.layer.opacity = Float(r * options.backdropOpacity)
					delegate?.sideNavDidChangeRightPan?(self, container: c)
				} else {
					c.point = gesture.velocityInView(gesture.view)
					let x: CGFloat = c.point.x <= -1000 || c.point.x >= 1000 ? c.point.x : 0
					c.state = vc.frame.origin.x >= CGFloat(floor(rightOriginX) - options.horizontalThreshold) || c.point.x >= 1000 ? .Closed : .Opened
					if .Closed == c.state {
						closeRightViewContainer(x)
					} else {
						openRightViewContainer(x)
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
    //	:name:	handleBottomPanGesture
    //
    internal func handleBottomPanGesture(gesture: UIPanGestureRecognizer) {
        if  isLeftContainerOpened || isRightContainerOpened || isTopContainerOpened { return }
		if let vc = bottomViewContainer {
			if let c = bottomContainer {
				if .Began == gesture.state {
					addShadow(&bottomViewContainer)
					toggleStatusBar(true)
					c.state = isBottomContainerOpened ? .Opened : .Closed
					c.point = gesture.locationInView(view)
					c.frame = vc.frame
					delegate?.sideNavDidBeginBottomPan?(self, container: c)
				} else if .Changed == gesture.state {
					c.point = gesture.translationInView(gesture.view!)
					let r = (bottomOriginY - vc.frame.origin.y) / vc.frame.size.height
					let m: CGFloat = bottomOriginY - vc.frame.size.height
					let y: CGFloat = c.frame.origin.y + c.point.y
					vc.frame.origin.y = y > bottomOriginY ? bottomOriginY : y < m ? m : y
					backdropViewContainer?.layer.opacity = Float(r * options.backdropOpacity)
					delegate?.sideNavDidChangeBottomPan?(self, container: c)
				} else {
					c.point = gesture.velocityInView(gesture.view)
					let y: CGFloat = c.point.y <= -1000 || c.point.y >= 1000 ? c.point.y : 0
					c.state = vc.frame.origin.y >= CGFloat(floor(bottomOriginY) - options.verticalThreshold) || c.point.y >= 1000 ? .Closed : .Opened
					if .Closed == c.state {
						closeBottomViewContainer(y)
					} else {
						openBottomViewContainer(y)
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
    //	:name:	handleTopPanGesture
    //
    internal func handleTopPanGesture(gesture: UIPanGestureRecognizer) {
        if  isLeftContainerOpened || isRightContainerOpened || isBottomContainerOpened { return }
		if let vc = topViewContainer {
			if let c = topContainer {
				if .Began == gesture.state {
					addShadow(&topViewContainer)
					toggleStatusBar(true)
					c.state = isTopContainerOpened ? .Opened : .Closed
					c.point = gesture.locationInView(view)
					c.frame = vc.frame
					delegate?.sideNavDidBeginTopPan?(self, container: c)
				} else if .Changed == gesture.state {
					c.point = gesture.translationInView(gesture.view!)
					let r = (topOriginY - vc.frame.origin.y) / vc.frame.size.height
					let m: CGFloat = topOriginY + vc.frame.size.height
					let y: CGFloat = c.frame.origin.y + c.point.y // increase origin y
					vc.frame.origin.y = y < topOriginY ? topOriginY : y < m ? y : m
					backdropViewContainer?.layer.opacity = Float(abs(r) * options.backdropOpacity)
					delegate?.sideNavDidChangeTopPan?(self, container: c)
				} else {
					c.point = gesture.velocityInView(gesture.view)
					let y: CGFloat = c.point.y <= -1000 || c.point.y >= 1000 ? c.point.y : 0
					c.state = vc.frame.origin.y >= CGFloat(floor(topOriginY) + options.verticalThreshold) || c.point.y >= 1000 ? .Opened : .Closed
					if .Closed == c.state {
						closeTopViewContainer(y)
					} else {
						openTopViewContainer(y)
					}
					delegate?.sideNavDidEndTopPan?(self, container: c)
				}
			}
		}
    }
    
    //
    //	:name:	handleRightTapGesture
    //
    internal func handleTopTapGesture(gesture: UIPanGestureRecognizer) {
        if let c = topContainer {
            delegate?.sideNavDidTapTop?(self, container: c)
            closeTopViewContainer()
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
    //	:name:	gesturePanTopViewController
    //
    private func gesturePanTopViewController(gesture: UIGestureRecognizer, withTouchPoint point: CGPoint) -> Bool {
        return isTopContainerOpened || options.topPanFromBezel && isTopPointContainedWithinRect(point)
    }
    
	//
	//	:name:	isLeftPointContainedWithinRect
	//
    private func isLeftPointContainedWithinRect(point: CGPoint) -> Bool {
        return CGRectContainsPoint(CGRectMake(0, 0, options.leftBezelWidth, view.bounds.size.height), point)
    }
    
	//
	//	:name:	isRightPointContainedWithinRect
	//
    private func isRightPointContainedWithinRect(point: CGPoint) -> Bool {
        return CGRectContainsPoint(CGRectMake(CGRectGetMaxX(view.bounds) - options.rightBezelWidth, 0, options.rightBezelWidth, view.bounds.size.height), point)
    }
    
    //
    //	:name:	isBottomPointContainedWithinRect
    //
    private func isBottomPointContainedWithinRect(point: CGPoint) -> Bool {
        return CGRectContainsPoint(CGRectMake(0, CGRectGetMaxY(view.bounds) - options.bottomBezelHeight, view.bounds.size.width, options.bottomBezelHeight), point)
    }
    
    //
    //	:name:	isTopPointContainedWithinRect
    //
    private func isTopPointContainedWithinRect(point: CGPoint) -> Bool {
        return CGRectContainsPoint(CGRectMake(0, 0, view.bounds.size.width, options.topBezelHeight), point)
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
		mainViewContainer!.backgroundColor = MaterialTheme.clear.color
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
    //	:name:	prepareBottomGestures
    //
    private func prepareTopGestures() {
        removeGestures(&topPanGesture, tap: &topTapGesture)
        addGestures(&topPanGesture, panSelector: "handleTopPanGesture:", tap: &topTapGesture, tapSelector: "handleTopTapGesture:")
    }
	
	//
	//	:name:	prepareContainer
	//
    private func prepareContainer(inout container: SideNavigationViewContainer?, inout viewContainer: UIView?, originX: CGFloat, originY: CGFloat, width: CGFloat, height: CGFloat) {
		container = SideNavigationViewContainer(state: .Closed, point: CGPointZero, frame: CGRectZero)
		var b: CGRect = view.bounds
		b.size.width = width
        b.size.height = height
		b.origin.x = originX
        b.origin.y = originY
		viewContainer = UIView(frame: b)
		viewContainer!.backgroundColor = MaterialTheme.clear.color
		viewContainer!.autoresizingMask = .FlexibleHeight
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
				vc.view.translatesAutoresizingMaskIntoConstraints = false
				addChildViewController(vc)
				c.addSubview(vc.view)
				Layout.expandToParent(c, child: vc.view)
				vc.didMoveToParentViewController(self)
			}
		}
	}
}
