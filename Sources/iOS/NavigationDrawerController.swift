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

@objc
public enum NavigationDrawerPosition : NSInteger {
	case Left
	case Right
}

public extension UIViewController {
	/**
	A convenience property that provides access to the NavigationDrawerController. 
	This is the recommended method of accessing the NavigationDrawerController
	through child UIViewControllers.
	*/
	public var navigationDrawerController: NavigationDrawerController? {
		var viewController: UIViewController? = self
		while nil != viewController {
			if viewController is NavigationDrawerController {
				return viewController as? NavigationDrawerController
			}
			viewController = viewController?.parentViewController
		}
		return nil
	}
}

@objc(NavigationDrawerControllerDelegate)
public protocol NavigationDrawerControllerDelegate {
	/**
	An optional delegation method that is fired before the 
	NavigationDrawerController opens.
	*/
	optional func navigationDrawerWillOpen(navigationDrawerController: NavigationDrawerController, position: NavigationDrawerPosition)
	
	/**
	An optional delegation method that is fired after the
	NavigationDrawerController opened.
	*/
	optional func navigationDrawerDidOpen(navigationDrawerController: NavigationDrawerController, position: NavigationDrawerPosition)
	
	/**
	An optional delegation method that is fired before the
	NavigationDrawerController closes.
	*/
	optional func navigationDrawerWillClose(navigationDrawerController: NavigationDrawerController, position: NavigationDrawerPosition)
	
	/**
	An optional delegation method that is fired after the
	NavigationDrawerController closed.
	*/
	optional func navigationDrawerDidClose(navigationDrawerController: NavigationDrawerController, position: NavigationDrawerPosition)
	
	/**
	An optional delegation method that is fired when the
	NavigationDrawerController pan gesture begins.
	*/
	optional func navigationDrawerPanDidBegin(navigationDrawerController: NavigationDrawerController, point: CGPoint, position: NavigationDrawerPosition)
	
	/**
	An optional delegation method that is fired when the
	NavigationDrawerController pan gesture changes position.
	*/
	optional func navigationDrawerPanDidChange(navigationDrawerController: NavigationDrawerController, point: CGPoint, position: NavigationDrawerPosition)
	
	/**
	An optional delegation method that is fired when the
	NavigationDrawerController pan gesture ends.
	*/
	optional func navigationDrawerPanDidEnd(navigationDrawerController: NavigationDrawerController, point: CGPoint, position: NavigationDrawerPosition)
	
	/**
	An optional delegation method that is fired when the
	NavigationDrawerController tap gesture executes.
	*/
	optional func navigationDrawerDidTap(navigationDrawerController: NavigationDrawerController, point: CGPoint, position: NavigationDrawerPosition)

	/**
	An optional delegation method that is fired when the
	status bar is about to change display, hidden or not.
	*/
	optional func navigationDrawerStatusBarHiddenState(navigationDrawerController: NavigationDrawerController, hidden: Bool)
}

@IBDesignable
@objc(NavigationDrawerController)
public class NavigationDrawerController : RootController, UIGestureRecognizerDelegate {
	/**
	A CGFloat property that is used internally to track
	the original (x) position of the container view when panning.
	*/
	private var originalX: CGFloat = 0
	
	/**
	A UIPanGestureRecognizer property internally used for the
	leftView pan gesture.
	*/
	internal private(set) var leftPanGesture: UIPanGestureRecognizer?
	
	/**
	A UIPanGestureRecognizer property internally used for the
	rightView pan gesture.
	*/
	internal private(set) var rightPanGesture: UIPanGestureRecognizer?
	
	/**
	A UITapGestureRecognizer property internally used for the 
	leftView tap gesture.
	*/
	internal private(set) var leftTapGesture: UITapGestureRecognizer?
	
	/**
	A UITapGestureRecognizer property internally used for the
	rightView tap gesture.
	*/
	internal private(set) var rightTapGesture: UITapGestureRecognizer?
	
	/**
	A CGFloat property that accesses the leftView threshold of
	the NavigationDrawerController. When the panning gesture has
	ended, if the position is beyond the threshold,
	the leftView is opened, if it is below the threshold, the
	leftView is closed. The leftViewThreshold is always at half
	the width of the leftView.
	*/
	@IBInspectable public var leftThreshold: CGFloat = 64
	private var leftViewThreshold: CGFloat = 0
	
	/**
	A CGFloat property that accesses the rightView threshold of
	the NavigationDrawerController. When the panning gesture has
	ended, if the position is beyond the threshold,
	the rightView is closed, if it is below the threshold, the
	rightView is opened. The rightViewThreshold is always at half
	the width of the rightView.
	*/
	@IBInspectable public var rightThreshold: CGFloat = 64
	private var rightViewThreshold: CGFloat = 0
	
	/**
	A NavigationDrawerControllerDelegate property used to bind
	the delegation object.
	*/
	public weak var delegate: NavigationDrawerControllerDelegate?
	
	/**
	A CGFloat property that sets the animation duration of the
	leftView when closing and opening. Defaults to 0.25.
	*/
	@IBInspectable public var animationDuration: CGFloat = 0.25
	
	/**
	A Boolean property that enables and disables the leftView from
	opening and closing. Defaults to true.
	*/
	@IBInspectable public var enabled: Bool {
		get {
			return enabledLeftView || enabledRightView
		}
		set(value) {
			if nil != leftView {
				enabledLeftView = value
			}
			if nil != rightView {
				enabledRightView = value
			}
		}
	}
	
	/**
	A Boolean property that enables and disables the leftView from
	opening and closing. Defaults to true.
	*/
	@IBInspectable public var enabledLeftView: Bool = false {
		didSet {
			enabledLeftPanGesture = enabledLeftView
			enabledLeftTapGesture = enabledLeftView
		}
	}
	
	/// Enables the left pan gesture.
	@IBInspectable public var enabledLeftPanGesture: Bool = false {
		didSet {
			if enabledLeftPanGesture {
				prepareLeftPanGesture()
			} else {
				removeLeftPanGesture()
			}
		}
	}
	
	/// Enables the left tap gesture.
	@IBInspectable public var enabledLeftTapGesture: Bool = false {
		didSet {
			if enabledLeftTapGesture {
				prepareLeftTapGesture()
			} else {
				removeLeftTapGesture()
			}
		}
	}
	
	/**
	A Boolean property that enables and disables the rightView from
	opening and closing. Defaults to true.
	*/
	@IBInspectable public var enabledRightView: Bool = false {
		didSet {
			enabledRightPanGesture = enabledRightView
			enabledRightTapGesture = enabledRightView
		}
	}
	
	/// Enables the right pan gesture.
	@IBInspectable public var enabledRightPanGesture: Bool = false {
		didSet {
			if enabledRightPanGesture {
				prepareRightPanGesture()
			} else {
				removeRightPanGesture()
			}
		}
	}
	
	/// Enables the right tap gesture.
	@IBInspectable public var enabledRightTapGesture: Bool = false {
		didSet {
			if enabledRightTapGesture {
				prepareRightTapGesture()
			} else {
				removeRightTapGesture()
			}
		}
	}
	
	/**
	A Boolean property that triggers the status bar to be hidden
	when the leftView is opened. Defaults to true.
	*/
	@IBInspectable public var enableHideStatusBar: Bool = true
	
	/// Sets the statusBar to hidden or not.
	public private(set) var statusBarHidden: Bool = false
	
	/**
	A MaterialDepth property that is used to set the depth of the
	leftView when opened.
	*/
	public var depth: MaterialDepth = .Depth1
	
	/**
	A MaterialView property that is used to hide and reveal the
	leftViewController. It is very rare that this property will
	need to be accessed externally.
	*/
	public private(set) var leftView: MaterialView?
	
	/**
	A MaterialView property that is used to hide and reveal the
	rightViewController. It is very rare that this property will
	need to be accessed externally.
	*/
	public private(set) var rightView: MaterialView?
	
	/// Indicates whether the leftView or rightView is opened.
	public var opened: Bool {
		return openedLeftView || openedRightView
	}
	
	/// indicates if the leftView is opened.
	public var openedLeftView: Bool {
		guard nil != leftView else {
			return false
		}
		return leftView!.x != -leftViewWidth
	}
	
	/// Indicates if the rightView is opened.
	public var openedRightView: Bool {
		guard nil != rightView else {
			return false
		}
		return rightView!.x != MaterialDevice.width
	}
	
	/**
	Content view controller to encompase the entire component. This is
	primarily used when the StatusBar is being hidden. The alpha value of
	the rootViewController decreases, and shows the StatusBar. To avoid
	this, and to add a hidden transition viewController for complex
	situations, the contentViewController was added.
	*/
	public private(set) lazy var contentViewController: UIViewController = UIViewController()
	
	/**
	A UIViewController property that references the 
	active left UIViewController.
	*/
	public private(set) var leftViewController: UIViewController?
	
	/**
	A UIViewController property that references the
	active right UIViewController.
	*/
	public private(set) var rightViewController: UIViewController?
	
	/**
	A CGFloat property to access the width that the leftView
	opens up to.
	*/
	@IBInspectable public private(set) var leftViewWidth: CGFloat!
	
	/**
	A CGFloat property to access the width that the rightView
	opens up to.
	*/
	@IBInspectable public private(set) var rightViewWidth: CGFloat!
	
	/**
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
	An initializer that initializes the object with an Optional nib and bundle.
	- Parameter nibNameOrNil: An Optional String for the nib.
	- Parameter bundle: An Optional NSBundle where the nib is located.
	*/
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	/**
	An initializer for the NavigationDrawerController.
	- Parameter rootViewController: The main UIViewController.
	- Parameter leftViewController: An Optional left UIViewController.
	- Parameter rightViewController: An Optional right UIViewController.
	*/
	public init(rootViewController: UIViewController, leftViewController: UIViewController? = nil, rightViewController: UIViewController? = nil) {
		super.init(rootViewController: rootViewController)
		self.leftViewController = leftViewController
		self.rightViewController = rightViewController
		prepareView()
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public override func prepareView() {
		super.prepareView()
		prepareContentViewController()
		prepareLeftView()
		prepareRightView()
	}
	
	/// Layout subviews.
	public override func layoutSubviews() {
		if opened {
			hideStatusBar()
		} else {
			showStatusBar()
		}
		
		if let v: MaterialView = leftView {
			v.width = leftViewWidth
			v.height = view.bounds.height
			leftViewThreshold = leftViewWidth / 2
			if let vc: UIViewController = leftViewController {
				vc.view.frame.size.width = v.width
				vc.view.frame.size.height = v.height
				vc.view.center = CGPointMake(v.width / 2, v.height / 2)
			}
		}
		
		if let v: MaterialView = rightView {
			v.width = rightViewWidth
			v.height = view.bounds.height
			rightViewThreshold = view.bounds.width - rightViewWidth / 2
			if let vc: UIViewController = rightViewController {
				vc.view.frame.size.width = v.width
				vc.view.frame.size.height = v.height
				vc.view.center = CGPointMake(v.width / 2, v.height / 2)
			}
		}
	}
	
	public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
		// Ensures the view is hidden.
		if let v: MaterialView = rightView {
			v.position.x = size.width + (openedRightView ? -v.width : v.width) / 2
		}
	}
	
	/**
	A method that is used to set the width of the leftView when 
	opened. This is the recommended method of setting the leftView 
	width.
	- Parameter width: A CGFloat value to set as the new width.
	- Parameter hidden: A Boolean value of whether the leftView
	should be hidden after the width has been updated or not.
	- Parameter animated: A Boolean value that indicates to animate
	the leftView width change.
	*/
	public func setLeftViewWidth(width: CGFloat, hidden: Bool, animated: Bool, duration: NSTimeInterval = 0.5) {
		if let v: MaterialView = leftView {
			leftViewWidth = width
			
			var hide: Bool = hidden
			
			if openedRightView {
				hide = true
			}
			
			if animated {
				v.shadowPathAutoSizeEnabled = false
				
				if hide {
					UIView.animateWithDuration(duration,
						animations: { [weak self] in
							if let s: NavigationDrawerController = self {
								v.bounds.size.width = width
								v.position.x = -width / 2
								s.rootViewController.view.alpha = 1
							}
						}) { [weak self] _ in
							if let s: NavigationDrawerController = self {
								v.shadowPathAutoSizeEnabled = true
								s.layoutSubviews()
								s.hideView(v)
							}
						}
				} else {
					UIView.animateWithDuration(duration,
						animations: { [weak self] in
							if let s: NavigationDrawerController = self {
								v.bounds.size.width = width
								v.position.x = width / 2
								s.rootViewController.view.alpha = 0.5
							}
						}) { [weak self] _ in
							if let s: NavigationDrawerController = self {
								v.shadowPathAutoSizeEnabled = true
								s.layoutSubviews()
								s.showView(v)
							}
						}
				}
			} else {
				v.bounds.size.width = width
				if hide {
					hideView(v)
					v.position.x = -v.width / 2
					rootViewController.view.alpha = 1
				} else {
					v.shadowPathAutoSizeEnabled = false
					
					showView(v)
					v.position.x = width / 2
					rootViewController.view.alpha = 0.5
					v.shadowPathAutoSizeEnabled = true
				}
				layoutSubviews()
			}

		}
	}
	
	/**
	A method that is used to set the width of the rightView when
	opened. This is the recommended method of setting the rightView
	width.
	- Parameter width: A CGFloat value to set as the new width.
	- Parameter hidden: A Boolean value of whether the rightView
	should be hidden after the width has been updated or not.
	- Parameter animated: A Boolean value that indicates to animate
	the rightView width change.
	*/
	public func setRightViewWidth(width: CGFloat, hidden: Bool, animated: Bool, duration: NSTimeInterval = 0.5) {
		if let v: MaterialView = rightView {
			rightViewWidth = width
			
			var hide: Bool = hidden
			
			if openedLeftView {
				hide = true
			}
			
			if animated {
				v.shadowPathAutoSizeEnabled = false
				
				if hide {
					UIView.animateWithDuration(duration,
						animations: { [weak self] in
							if let s: NavigationDrawerController = self {
								v.bounds.size.width = width
								v.position.x = s.view.bounds.width + width / 2
								s.rootViewController.view.alpha = 1
							}
						}) { [weak self] _ in
							if let s: NavigationDrawerController = self {
								v.shadowPathAutoSizeEnabled = true
								s.layoutSubviews()
								s.hideView(v)
							}
						}
				} else {
					UIView.animateWithDuration(duration,
						animations: { [weak self] in
							if let s: NavigationDrawerController = self {
								v.bounds.size.width = width
								v.position.x = s.view.bounds.width - width / 2
								s.rootViewController.view.alpha = 0.5
							}
						}) { [weak self] _ in
							if let s: NavigationDrawerController = self {
								v.shadowPathAutoSizeEnabled = true
								s.layoutSubviews()
								s.showView(v)
							}
						}
				}
			} else {
				v.bounds.size.width = width
				if hide {
					hideView(v)
					v.position.x = view.bounds.width + v.width / 2
					rootViewController.view.alpha = 1
				} else {
					v.shadowPathAutoSizeEnabled = false
					
					showView(v)
					v.position.x = view.bounds.width - width / 2
					rootViewController.view.alpha = 0.5
					v.shadowPathAutoSizeEnabled = true
				}
				layoutSubviews()
			}
		}
	}
	
	/**
	A method that toggles the leftView opened if previously closed,
	or closed if previously opened.
	- Parameter velocity: A CGFloat value that sets the 
	velocity of the user interaction when animating the
	leftView. Defaults to 0.
	*/
	public func toggleLeftView(velocity: CGFloat = 0) {
		openedLeftView ? closeLeftView(velocity) : openLeftView(velocity)
	}
	
	/**
	A method that toggles the rightView opened if previously closed,
	or closed if previously opened.
	- Parameter velocity: A CGFloat value that sets the
	velocity of the user interaction when animating the
	leftView. Defaults to 0.
	*/
	public func toggleRightView(velocity: CGFloat = 0) {
		openedRightView ? closeRightView(velocity) : openRightView(velocity)
	}
	
	/**
	A method that opens the leftView.
	- Parameter velocity: A CGFloat value that sets the
	velocity of the user interaction when animating the
	leftView. Defaults to 0.
	*/
	public func openLeftView(velocity: CGFloat = 0) {
		if enabledLeftView {
			if let v: MaterialView = leftView {
				hideStatusBar()
				showView(v)
				userInteractionEnabled = false
				delegate?.navigationDrawerWillOpen?(self, position: .Left)
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
					animations: {
						v.position.x = v.width / 2
						self.rootViewController.view.alpha = 0.5
					}) { [weak self] _ in
						if let s: NavigationDrawerController = self {
							s.delegate?.navigationDrawerDidOpen?(s, position: .Left)
						}
					}
			}
		}
	}
	
	/**
	A method that opens the rightView.
	- Parameter velocity: A CGFloat value that sets the
	velocity of the user interaction when animating the
	leftView. Defaults to 0.
	*/
	public func openRightView(velocity: CGFloat = 0) {
		if enabledRightView {
			if let v: MaterialView = rightView {
				hideStatusBar()
				showView(v)
				userInteractionEnabled = false
				delegate?.navigationDrawerWillOpen?(self, position: .Right)
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
					animations: { [weak self] in
						if let s: NavigationDrawerController = self {
							v.position.x = s.view.bounds.width - v.width / 2
							s.rootViewController.view.alpha = 0.5
						}
					}) { [weak self] _ in
						if let s: NavigationDrawerController = self {
							s.delegate?.navigationDrawerDidOpen?(s, position: .Right)
						}
					}
			}
		}
	}
	
	/**
	A method that closes the leftView.
	- Parameter velocity: A CGFloat value that sets the
	velocity of the user interaction when animating the
	leftView. Defaults to 0.
	*/
	public func closeLeftView(velocity: CGFloat = 0) {
		if enabledLeftView {
			if let v: MaterialView = leftView {
				userInteractionEnabled = true
				delegate?.navigationDrawerWillClose?(self, position: .Left)
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
					animations: { [weak self] in
						if let s: NavigationDrawerController = self {
							v.position.x = -v.width / 2
							s.rootViewController.view.alpha = 1
						}
					}) { [weak self] _ in
						if let s: NavigationDrawerController = self {
							s.hideView(v)
							s.toggleStatusBar()
							s.delegate?.navigationDrawerDidClose?(s, position: .Left)
						}
					}
			}
		}
	}
	
	/**
	A method that closes the rightView.
	- Parameter velocity: A CGFloat value that sets the
	velocity of the user interaction when animating the
	leftView. Defaults to 0.
	*/
	public func closeRightView(velocity: CGFloat = 0) {
		if enabledRightView {
			if let v: MaterialView = rightView {
				userInteractionEnabled = true
				delegate?.navigationDrawerWillClose?(self, position: .Right)
				UIView.animateWithDuration(Double(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.x / velocity)))),
					animations: { [weak self] in
						if let s: NavigationDrawerController = self {
							v.position.x = s.view.bounds.width + v.width / 2
							s.rootViewController.view.alpha = 1
						}
					}) { [weak self] _ in
						if let s: NavigationDrawerController = self {
							s.hideView(v)
							s.toggleStatusBar()
							s.delegate?.navigationDrawerDidClose?(s, position: .Right)
						}
					}
			}
		}
	}
	
	/**
	Detects the gesture recognizer being used.
	- Parameter gestureRecognizer: A UIGestureRecognizer to detect.
	- Parameter touch: The UITouch event.
	- Returns: A Boolean of whether to continue the gesture or not.
	*/
	public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		if !openedRightView && gestureRecognizer == leftPanGesture && (openedLeftView || isPointContainedWithinLeftThreshold(touch.locationInView(view))) {
			return true
		}
		if !openedLeftView && gestureRecognizer == rightPanGesture && (openedRightView || isPointContainedWithinRighThreshold(touch.locationInView(view))) {
			return true
		}
		if openedLeftView && gestureRecognizer == leftTapGesture {
			return true
		}
		if openedRightView && gestureRecognizer == rightTapGesture {
			return true
		}
		return false
	}
	
	/**
	A method that is fired when the pan gesture is recognized
	for the leftView.
	- Parameter recognizer: A UIPanGestureRecognizer that is
	passed to the handler when recognized.
	*/
	internal func handleLeftViewPanGesture(recognizer: UIPanGestureRecognizer) {
		if enabledLeftView && (openedLeftView || !openedRightView && isPointContainedWithinLeftThreshold(recognizer.locationInView(view))) {
			if let v: MaterialView = leftView {
				let point: CGPoint = recognizer.locationInView(view)
				
				// Animate the panel.
				switch recognizer.state {
				case .Began:
					originalX = v.position.x
					showView(v)
					delegate?.navigationDrawerPanDidBegin?(self, point: point, position: .Left)
				case .Changed:
					let w: CGFloat = v.width
					let translationX: CGFloat = recognizer.translationInView(v).x
					
					v.position.x = originalX + translationX > (w / 2) ? (w / 2) : originalX + translationX
					
					let a: CGFloat = 1 - v.position.x / v.width
					rootViewController.view.alpha = 0.5 < a && v.position.x <= v.width / 2 ? a : 0.5
					
					if translationX >= leftThreshold {
						hideStatusBar()
					}
					
					delegate?.navigationDrawerPanDidChange?(self, point: point, position: .Left)
				case .Ended, .Cancelled, .Failed:
					let p: CGPoint = recognizer.velocityInView(recognizer.view)
					let x: CGFloat = p.x >= 1000 || p.x <= -1000 ? p.x : 0
					
					delegate?.navigationDrawerPanDidEnd?(self, point: point, position: .Left)
					
					if v.x <= -leftViewWidth + leftViewThreshold || x < -1000 {
						closeLeftView(x)
					} else {
						openLeftView(x)
					}
				case .Possible:break
				}
			}
		}
	}
	
	/**
	A method that is fired when the pan gesture is recognized
	for the rightView.
	- Parameter recognizer: A UIPanGestureRecognizer that is
	passed to the handler when recognized.
	*/
	internal func handleRightViewPanGesture(recognizer: UIPanGestureRecognizer) {
		if enabledRightView && (openedRightView || !openedLeftView && isPointContainedWithinRighThreshold(recognizer.locationInView(view))) {
			if let v: MaterialView = rightView {
				let point: CGPoint = recognizer.locationInView(view)
				
				// Animate the panel.
				switch recognizer.state {
				case .Began:
					originalX = v.position.x
					showView(v)
					delegate?.navigationDrawerPanDidBegin?(self, point: point, position: .Right)
				case .Changed:
					let w: CGFloat = v.width
					let translationX: CGFloat = recognizer.translationInView(v).x
					
					v.position.x = originalX + translationX < view.bounds.width - (w / 2) ? view.bounds.width - (w / 2) : originalX + translationX
					
					let a: CGFloat = 1 - (view.bounds.width - v.position.x) / v.width
					rootViewController.view.alpha = 0.5 < a && v.position.x >= v.width / 2 ? a : 0.5
					
					if translationX <= -rightThreshold {
						hideStatusBar()
					}
					
					delegate?.navigationDrawerPanDidChange?(self, point: point, position: .Right)
				case .Ended, .Cancelled, .Failed:
					let p: CGPoint = recognizer.velocityInView(recognizer.view)
					let x: CGFloat = p.x >= 1000 || p.x <= -1000 ? p.x : 0
					
					delegate?.navigationDrawerPanDidEnd?(self, point: point, position: .Right)
					
					if v.x >= rightViewThreshold || x > 1000 {
						closeRightView(x)
					} else {
						openRightView(x)
					}
				case .Possible:break
				}
			}
		}
	}
	
	/**
	A method that is fired when the tap gesture is recognized
	for the leftView.
	- Parameter recognizer: A UITapGestureRecognizer that is
	passed to the handler when recognized.
	*/
	internal func handleLeftViewTapGesture(recognizer: UITapGestureRecognizer) {
		if openedLeftView {
			if let v: MaterialView = leftView {
				delegate?.navigationDrawerDidTap?(self, point: recognizer.locationInView(view), position: .Left)
				if enabledLeftView && openedLeftView && !isPointContainedWithinView(v, point: recognizer.locationInView(v)) {
					closeLeftView()
				}
			}
		}
	}
	
	/**
	A method that is fired when the tap gesture is recognized
	for the rightView.
	- Parameter recognizer: A UITapGestureRecognizer that is
	passed to the handler when recognized.
	*/
	internal func handleRightViewTapGesture(recognizer: UITapGestureRecognizer) {
		if openedRightView {
			if let v: MaterialView = rightView {
				delegate?.navigationDrawerDidTap?(self, point: recognizer.locationInView(view), position: .Right)
				if enabledRightView && openedRightView && !isPointContainedWithinView(v, point: recognizer.locationInView(v)) {
					closeRightView()
				}
			}
		}
	}
	
	/// Prepares the contentViewController.
	private func prepareContentViewController() {
		contentViewController.view.backgroundColor = MaterialColor.black
		prepareViewControllerWithinContainer(contentViewController, container: view)
		view.sendSubviewToBack(contentViewController.view)
	}
	
	/// A method that prepares the leftViewController.
	private func prepareLeftViewController() {
		if let v: MaterialView = leftView {
			prepareViewControllerWithinContainer(leftViewController, container: v)
		}
	}
	
	/// A method that prepares the rightViewController.
	private func prepareRightViewController() {
		if let v: MaterialView = rightView {
			prepareViewControllerWithinContainer(rightViewController, container: v)
		}
	}
	
	/// A method that prepares the leftView.
	private func prepareLeftView() {
		guard let _: UIViewController = leftViewController else {
			return
		}
		
		enabledLeftView = true
		
		leftViewWidth = .iPhone == MaterialDevice.type ? 280 : 320
		leftView = MaterialView()
		leftView!.frame = CGRectMake(0, 0, leftViewWidth, view.frame.height)
		leftView!.backgroundColor = MaterialColor.clear
		view.addSubview(leftView!)
		
		leftView!.hidden = true
		leftView!.position.x = -leftViewWidth / 2
		leftView!.zPosition = 2000
		prepareLeftViewController()
	}
	
	/// A method that prepares the leftView.
	private func prepareRightView() {
		guard let _: UIViewController = rightViewController else {
			return
		}
		
		enabledRightView = true
		
		rightViewWidth = .iPhone == MaterialDevice.type ? 280 : 320
		rightView = MaterialView()
		rightView!.frame = CGRectMake(0, 0, rightViewWidth, view.frame.height)
		rightView!.backgroundColor = MaterialColor.clear
		view.addSubview(rightView!)
		
		rightView!.hidden = true
		rightView!.position.x = view.bounds.width + rightViewWidth / 2
		rightView!.zPosition = 2000
		prepareRightViewController()
	}
	
	/// Prepare the left pan gesture.
	private func prepareLeftPanGesture() {
		if nil == leftPanGesture {
			leftPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleLeftViewPanGesture(_:)))
			leftPanGesture!.delegate = self
			view.addGestureRecognizer(leftPanGesture!)
		}
	}
	
	/// Prepare the left tap gesture.
	private func prepareLeftTapGesture() {
		if nil == leftTapGesture {
			leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLeftViewTapGesture(_:)))
			leftTapGesture!.delegate = self
			leftTapGesture!.cancelsTouchesInView = false
			view.addGestureRecognizer(leftTapGesture!)
		}
	}
	
	/// Prepares the right pan gesture.
	private func prepareRightPanGesture() {
		if nil == rightPanGesture {
			rightPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleRightViewPanGesture(_:)))
			rightPanGesture!.delegate = self
			view.addGestureRecognizer(rightPanGesture!)
		}
	}
	
	/// Prepares the right tap gesture.
	private func prepareRightTapGesture() {
		if nil == rightTapGesture {
			rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleRightViewTapGesture(_:)))
			rightTapGesture!.delegate = self
			rightTapGesture!.cancelsTouchesInView = false
			view.addGestureRecognizer(rightTapGesture!)
		}
	}
	
	/// A method that removes the passed in pan and leftView tap gesture recognizers.
	private func removeLeftViewGestures() {
		removeLeftPanGesture()
		removeLeftTapGesture()
	}
	
	/// Removes the left pan gesture.
	private func removeLeftPanGesture() {
		if let v: UIPanGestureRecognizer = leftPanGesture {
			view.removeGestureRecognizer(v)
			leftPanGesture = nil
		}
	}
	
	/// Removes the left tap gesture.
	private func removeLeftTapGesture() {
		if let v: UITapGestureRecognizer = leftTapGesture {
			view.removeGestureRecognizer(v)
			leftTapGesture = nil
		}
	}
	
	/// A method that removes the passed in pan and rightView tap gesture recognizers.
	private func removeRightViewGestures() {
		removeRightPanGesture()
		removeRightTapGesture()
		
	}
	
	/// Removes the right pan gesture.
	private func removeRightPanGesture() {
		if let v: UIPanGestureRecognizer = rightPanGesture {
			view.removeGestureRecognizer(v)
			rightPanGesture = nil
		}
	}
	
	/// Removes the right tap gesture.
	private func removeRightTapGesture() {
		if let v: UITapGestureRecognizer = rightTapGesture {
			view.removeGestureRecognizer(v)
			rightTapGesture = nil
		}
	}
	
	/// Shows the statusBar.
	private func showStatusBar() {
		if statusBarHidden {
			statusBarHidden = false
			dispatch_async(dispatch_get_main_queue(), { [weak self] in
				if let s: NavigationDrawerController = self {
					if let v: UIWindow = UIApplication.sharedApplication().keyWindow {
						v.windowLevel = UIWindowLevelNormal
						s.delegate?.navigationDrawerStatusBarHiddenState?(s, hidden: false)
					}
				}
			})
		}
	}
	
	/// Hides the statusBar.
	private func hideStatusBar() {
		if enableHideStatusBar {
			if !statusBarHidden {
				statusBarHidden = true
				dispatch_async(dispatch_get_main_queue(), { [weak self] in
					if let s: NavigationDrawerController = self {
						if let v: UIWindow = UIApplication.sharedApplication().keyWindow {
							v.windowLevel = UIWindowLevelStatusBar + 1
							s.delegate?.navigationDrawerStatusBarHiddenState?(s, hidden: true)
						}
					}
				})
			}
		}
	}
	
	/// Toggles the statusBar
	private func toggleStatusBar() {
		if opened || MaterialDevice.isLandscape && .iPhone == MaterialDevice.type {
			hideStatusBar()
		} else {
			showStatusBar()
		}
	}
	
	/**
	A method that determines whether the passed point is
	contained within the bounds of the leftViewThreshold
	and height of the NavigationDrawerController view frame
	property.
	- Parameter point: A CGPoint to test against.
	- Returns: A Boolean of the result, true if yes, false 
	otherwise.
	*/
	private func isPointContainedWithinLeftThreshold(point: CGPoint) -> Bool {
		return point.x <= leftThreshold
	}
	
	/**
	A method that determines whether the passed point is
	contained within the bounds of the rightViewThreshold
	and height of the NavigationDrawerController view frame
	property.
	- Parameter point: A CGPoint to test against.
	- Returns: A Boolean of the result, true if yes, false
	otherwise.
	*/
	private func isPointContainedWithinRighThreshold(point: CGPoint) -> Bool {
		return point.x >= view.bounds.width - rightThreshold
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
	private func isPointContainedWithinView(container: UIView, point: CGPoint) -> Bool {
		return CGRectContainsPoint(container.bounds, point)
	}
	
	/**
	A method that shows a view.
	- Parameter container: A container view.
	*/
	private func showView(container: MaterialView) {
		container.depth = depth
		container.hidden = false
	}
	
	/**
	A method that hides a view.
	- Parameter container: A container view.
	*/
	private func hideView(container: MaterialView) {
		container.depth = .None
		container.hidden = true
	}
}