/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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
 *	*	Neither the name of CosmicMind nor the names of its
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

@objc(BottomSheetPosition)
public enum BottomSheetPosition: Int {
    case left
    case right
}

extension UIViewController {
    /**
     A convenience property that provides access to the BottomSheetController.
     This is the recommended method of accessing the BottomSheetController
     through child UIViewControllers.
     */
    public var bottomSheetController: BottomSheetController? {
        var viewController: UIViewController? = self
        while nil != viewController {
            if viewController is BottomSheetController {
                return viewController as? BottomSheetController
            }
            viewController = viewController?.parent
        }
        return nil
    }
}

@objc(BottomSheetControllerDelegate)
public protocol BottomSheetControllerDelegate {
    /**
     An optional delegation method that is fired before the
     BottomSheetController opens.
     - Parameter bottomSheetController: A BottomSheetController.
     */
    @objc
    optional func bottomSheetControllerWillOpen(bottomSheetController: BottomSheetController)
    
    /**
     An optional delegation method that is fired after the
     BottomSheetController opened.
     - Parameter bottomSheetController: A BottomSheetController.
     */
    @objc
    optional func bottomSheetControllerDidOpen(bottomSheetController: BottomSheetController)
    
    /**
     An optional delegation method that is fired before the
     BottomSheetController closes.
     - Parameter bottomSheetController: A BottomSheetController.
     */
    @objc
    optional func bottomSheetControllerWillClose(bottomSheetController: BottomSheetController)
    
    /**
     An optional delegation method that is fired after the
     BottomSheetController closed.
     - Parameter bottomSheetController: A BottomSheetController.
     */
    @objc
    optional func bottomSheetControllerDidClose(bottomSheetController: BottomSheetController)
    
    /**
     An optional delegation method that is fired when the
     BottomSheetController pan gesture begins.
     - Parameter bottomSheetController: A BottomSheetController.
     - Parameter didBeginPanAt point: A CGPoint.
     */
    @objc
    optional func bottomSheetController(bottomSheetController: BottomSheetController, didBeginPanAt point: CGPoint)
    
    /**
     An optional delegation method that is fired when the
     BottomSheetController pan gesture changes position.
     - Parameter bottomSheetController: A BottomSheetController.
     - Parameter didChangePanAt point: A CGPoint.
     */
    @objc
    optional func bottomSheetController(bottomSheetController: BottomSheetController, didChangePanAt point: CGPoint)
    
    /**
     An optional delegation method that is fired when the
     BottomSheetController pan gesture ends.
     - Parameter bottomSheetController: A BottomSheetController.
     - Parameter didEndPanAt point: A CGPoint.
     */
    @objc
    optional func bottomSheetController(bottomSheetController: BottomSheetController, didEndPanAt point: CGPoint)
    
    /**
     An optional delegation method that is fired when the
     BottomSheetController tap gesture executes.
     - Parameter bottomSheetController: A BottomSheetController.
     - Parameter didTapAt point: A CGPoint.
     */
    @objc
    optional func bottomSheetController(bottomSheetController: BottomSheetController, didTapAt point: CGPoint)
}

@objc(BottomSheetController)
open class BottomSheetController: RootController {
    /**
     A CGFloat property that is used internally to track
     the original (x) position of the container view when panning.
     */
    fileprivate var originalY: CGFloat = 0
    
    /**
     A UIPanGestureRecognizer property internally used for the
     bottomView pan gesture.
     */
    internal fileprivate(set) var bottomPanGesture: UIPanGestureRecognizer?
    
    /**
     A UITapGestureRecognizer property internally used for the
     bottomView tap gesture.
     */
    internal fileprivate(set) var bottomTapGesture: UITapGestureRecognizer?
    
    /**
     A CGFloat property that accesses the bottomView threshold of
     the BottomSheetController. When the panning gesture has
     ended, if the position is beyond the threshold,
     the bottomView is opened, if it is below the threshold, the
     bottomView is closed.
     */
    @IBInspectable
    open var bottomThreshold: CGFloat = 64
    fileprivate var bottomViewThreshold: CGFloat = 0
    
    /**
     A BottomSheetControllerDelegate property used to bind
     the delegation object.
     */
    open weak var delegate: BottomSheetControllerDelegate?
    
    /**
     A CGFloat property that sets the animation duration of the
     bottomView when closing and opening. Defaults to 0.25.
     */
    @IBInspectable
    open var animationDuration: TimeInterval = 0.25
    
    /**
     A Boolean property that enables and disables the bottomView from
     opening and closing. Defaults to true.
     */
    @IBInspectable
    open var isEnabled: Bool {
        get {
            return isBottomViewEnabled
        }
        set(value) {
            if nil != bottomView {
                isBottomViewEnabled = value
            }
        }
    }
    
    /**
     A Boolean property that enables and disables the bottomView from
     opening and closing. Defaults to true.
     */
    @IBInspectable
    open var isBottomViewEnabled = false {
        didSet {
            isBottomPanGestureEnabled = isBottomViewEnabled
            isBottomTapGestureEnabled = isBottomViewEnabled
        }
    }
    
    /// Enables the left pan gesture.
    @IBInspectable
    open var isBottomPanGestureEnabled = false {
        didSet {
            if isBottomPanGestureEnabled {
                prepareBottomPanGesture()
            } else {
                removeBottomPanGesture()
            }
        }
    }
    
    /// Enables the left tap gesture.
    @IBInspectable
    open var isBottomTapGestureEnabled = false {
        didSet {
            if isBottomTapGestureEnabled {
                prepareBottomTapGesture()
            } else {
                removeBottomTapGesture()
            }
        }
    }
    
    /**
     A DepthPreset property that is used to set the depth of the
     bottomView when opened.
     */
    open var depthPreset = DepthPreset.depth1
    
    /**
     A UIView property that is used to hide and reveal the
     bottomViewController. It is very rare that this property will
     need to be accessed externally.
     */
    open fileprivate(set) var bottomView: UIView?
    
    /// Indicates whether the bottomView or rightView is opened.
    open var isOpened: Bool {
        return isBottomViewOpened
    }
    
    /// indicates if the bottomView is opened.
    open var isBottomViewOpened: Bool {
        guard let v = bottomView else {
            return false
        }
        return v.y != Screen.height
    }
    
    /**
     A UIViewController property that references the
     active left UIViewController.
     */
    open fileprivate(set) var bottomViewController: UIViewController?
    
    /**
     A CGFloat property to access the width that the bottomView
     opens up to.
     */
    @IBInspectable
    open fileprivate(set) var bottomViewHeight: CGFloat!
    
    /**
     An initializer that initializes the object with a NSCoder object.
     - Parameter aDecoder: A NSCoder instance.
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    /**
     An initializer that initializes the object with an Optional nib and bundle.
     - Parameter nibNameOrNil: An Optional String for the nib.
     - Parameter bundle: An Optional NSBundle where the nib is located.
     */
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        prepare()
    }
    
    /**
     An initializer for the BottomSheetController.
     - Parameter rootViewController: The main UIViewController.
     - Parameter bottomViewController: An Optional left UIViewController.
     */
    public init(rootViewController: UIViewController, bottomViewController: UIViewController? = nil) {
        super.init(rootViewController: rootViewController)
        self.bottomViewController = bottomViewController
        prepare()
    }
    
    /// Layout subviews.
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard let v = bottomView else {
            return
        }
        
        v.width = view.bounds.width
        v.height = bottomViewHeight
        bottomViewThreshold = view.bounds.height - bottomViewHeight / 2
        
        guard let vc = bottomViewController else {
            return
        }
        
        vc.view.width = v.bounds.width
        vc.view.height = bottomViewHeight
        vc.view.center = CGPoint(x: v.bounds.width / 2, y: bottomViewHeight / 2)
    }
    
    /**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
    open override func prepare() {
        super.prepare()
        prepareBottomView()
    }
    
    /**
     A method that is used to set the width of the bottomView when
     opened. This is the recommended method of setting the bottomView
     width.
     - Parameter width: A CGFloat value to set as the new width.
     - Parameter isHidden: A Boolean value of whether the bottomView
     should be isHidden after the width has been updated or not.
     - Parameter animated: A Boolean value that indicates to animate
     the bottomView width change.
     */
    open func setBottomViewHeight(height: CGFloat, isHidden: Bool, animated: Bool, duration: TimeInterval = 0.5) {
        guard let v = bottomView else {
            return
        }
        
        bottomViewHeight = height
        
        if animated {
            v.isShadowPathAutoSizing = false
            
            if isHidden {
                UIView.animate(withDuration: duration,
                    animations: { [weak self, v = v] in
                        guard let s = self else {
                            return
                        }
                        
                        v.bounds.size.height = height
                        v.position.y = -height / 2
                        s.rootViewController.view.alpha = 1
                }) { [weak self, v = v] _ in
                    guard let s = self else {
                        return
                    }
                    
                    v.isShadowPathAutoSizing = true
                    s.layoutSubviews()
                    s.hideView(container: v)
                }
            } else {
                UIView.animate(withDuration: duration,
                    animations: { [weak self, v = v] in
                        guard let s = self else {
                            return
                        }
                        
                        v.bounds.size.height = height
                        v.position.y = height / 2
                        s.rootViewController.view.alpha = 0.5
                }) { [weak self, v = v] _ in
                    guard let s = self else {
                        return
                    }
                    
                    v.isShadowPathAutoSizing = true
                    s.layoutSubviews()
                    s.showView(container: v)
                }
            }
        } else {
            v.bounds.size.height = height
            
            if isHidden {
                hideView(container: v)
                v.position.y = -v.bounds.height / 2
                rootViewController.view.alpha = 1
            } else {
                v.isShadowPathAutoSizing = false
                
                showView(container: v)
                v.position.y = height / 2
                rootViewController.view.alpha = 0.5
                v.isShadowPathAutoSizing = true
            }
            
            layoutSubviews()
        }
    }
    
    /**
     A method that toggles the bottomView opened if previously closed,
     or closed if previously opened.
     - Parameter velocity: A CGFloat value that sets the
     velocity of the user interaction when animating the
     bottomView. Defaults to 0.
     */
    open func toggleBottomView(velocity: CGFloat = 0) {
        isBottomViewOpened ? closeBottomView(velocity: velocity) : openBottomView(velocity: velocity)
    }
    
    /**
     A method that opens the bottomView.
     - Parameter velocity: A CGFloat value that sets the
     velocity of the user interaction when animating the
     bottomView. Defaults to 0.
     */
    open func openBottomView(velocity: CGFloat = 0) {
        guard isBottomViewEnabled else {
            return
        }
        
        guard let v = bottomView else {
            return
        }
        
        showView(container: v)
        
        isUserInteractionEnabled = false
        
        delegate?.bottomSheetController?(bottomSheetController: self, willOpen: .right)
        
        UIView.animate(withDuration: TimeInterval(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.y / velocity)))),
            animations: { [weak self, v = v] in
                guard let s = self else {
                    return
                }
                        
                v.position.y = s.view.bounds.height - v.bounds.height / 2
                s.rootViewController.view.alpha = 0.5
        }) { [weak self] _ in
            guard let s = self else {
                return
            }
            
            s.delegate?.bottomSheetController?(bottomSheetController: s, didOpen: .right)
        }
    }
    
    /**
     A method that closes the bottomView.
     - Parameter velocity: A CGFloat value that sets the
     velocity of the user interaction when animating the
     bottomView. Defaults to 0.
     */
    open func closeBottomView(velocity: CGFloat = 0) {
        guard isBottomViewEnabled else {
            return
        }
        
        guard let v = bottomView else {
            return
        }
        
        isUserInteractionEnabled = true
        
        delegate?.bottomSheetController?(bottomSheetController: self, willClose: .left)
        
        UIView.animate(withDuration: TimeInterval(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.y / velocity)))),
            animations: { [weak self, v = v] in
                guard let s = self else {
                    return
                }
                        
                v.position.y = s.view.bounds.height + v.bounds.height / 2
                s.rootViewController.view.alpha = 1
        }) { [weak self, v = v] _ in
            guard let s = self else {
                return
            }
            
            s.hideView(container: v)
            
            s.delegate?.bottomSheetController?(bottomSheetController: s, didClose: .left)
        }
    }
    
    /// A method that removes the passed in pan and bottomView tap gesture recognizers.
    fileprivate func removeBottomViewGestures() {
        removeBottomPanGesture()
        removeBottomTapGesture()
    }
    
    /// Removes the left pan gesture.
    fileprivate func removeBottomPanGesture() {
        guard let v = bottomPanGesture else {
            return
        }
        
        view.removeGestureRecognizer(v)
        bottomPanGesture = nil
    }
    
    /// Removes the left tap gesture.
    fileprivate func removeBottomTapGesture() {
        guard let v = bottomTapGesture else {
            return
        }
        
        view.removeGestureRecognizer(v)
        bottomTapGesture = nil
    }
    
    /**
     A method that determines whether the passed point is
     contained within the bounds of the bottomViewThreshold
     and height of the BottomSheetController view frame
     property.
     - Parameter point: A CGPoint to test against.
     - Returns: A Boolean of the result, true if yes, false
     otherwise.
     */
    fileprivate func isPointContainedWithinBottomThreshold(point: CGPoint) -> Bool {
        return point.y >= view.bounds.height - bottomThreshold
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
    fileprivate func isPointContainedWithinView(container: UIView, point: CGPoint) -> Bool {
        return container.bounds.contains(point)
    }
    
    /**
     A method that shows a view.
     - Parameter container: A container view.
     */
    fileprivate func showView(container: UIView) {
        container.depthPreset = depthPreset
        container.isHidden = false
    }
    
    /**
     A method that hides a view.
     - Parameter container: A container view.
     */
    fileprivate func hideView(container: UIView) {
        container.depthPreset = .none
        container.isHidden = true
    }
}

extension BottomSheetController {
    /// A method that prepares the bottomViewController.
    fileprivate func prepareBottomViewController() {
        guard let v = bottomView else {
            return
        }
        
        prepare(viewController: bottomViewController, withContainer: v)
    }
    
    /// A method that prepares the bottomView.
    fileprivate func prepareBottomView() {
        guard nil != bottomViewController else {
            return
        }
        
        isBottomViewEnabled = true
        
        bottomViewHeight = .phone == Device.userInterfaceIdiom ? 280 : 320
        bottomView = UIView()
        bottomView!.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: bottomViewHeight)
        bottomView!.backgroundColor = Color.green.base
        view.addSubview(bottomView!)
        
        bottomView!.isHidden = true
        bottomView!.position.y = view.bounds.height + bottomViewHeight / 2
        bottomView!.zPosition = 2000
        prepareBottomViewController()
    }
    
    /// Prepare the left pan gesture.
    fileprivate func prepareBottomPanGesture() {
        guard nil == bottomPanGesture else {
            return
        }
        
        bottomPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleBottomViewPanGesture(recognizer:)))
        bottomPanGesture!.delegate = self
        view.addGestureRecognizer(bottomPanGesture!)
    }
    
    /// Prepare the left tap gesture.
    fileprivate func prepareBottomTapGesture() {
        guard nil == bottomTapGesture else {
            return
        }
        
        bottomTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBottomViewTapGesture(recognizer:)))
        bottomTapGesture!.delegate = self
        bottomTapGesture!.cancelsTouchesInView = false
        view.addGestureRecognizer(bottomTapGesture!)
    }
}

extension BottomSheetController: UIGestureRecognizerDelegate {
    /**
     Detects the gesture recognizer being used.
     - Parameter gestureRecognizer: A UIGestureRecognizer to detect.
     - Parameter touch: The UITouch event.
     - Returns: A Boolean of whether to continue the gesture or not.
     */
    @objc
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == bottomPanGesture && (isBottomViewOpened || isPointContainedWithinBottomThreshold(point: touch.location(in: view))) {
            return true
        }
        
        if isBottomViewOpened && gestureRecognizer == bottomTapGesture {
            return true
        }
        
        return false
    }
    
    /**
     A method that is fired when the pan gesture is recognized
     for the bottomView.
     - Parameter recognizer: A UIPanGestureRecognizer that is
     passed to the handler when recognized.
     */
    @objc
    fileprivate func handleBottomViewPanGesture(recognizer: UIPanGestureRecognizer) {
        guard isBottomViewEnabled && (isBottomViewOpened || isPointContainedWithinBottomThreshold(point: recognizer.location(in: view))) else {
            return
        }
        
        guard let v = bottomView else {
            return
        }
        
        let point = recognizer.location(in: view)
        
        // Animate the panel.
        switch recognizer.state {
        case .began:
            originalY = v.position.y
            showView(container: v)
            
            delegate?.bottomSheetController?(bottomSheetController: self, didBeginPanAt: point)
        case .changed:
            let h = v.bounds.height
            let translationY = recognizer.translation(in: v).y
            
            v.position.y = originalY + translationY < view.bounds.height - (h / 2) ? view.bounds.height - (h / 2) : originalY + translationY
            
            let a = 1 - (view.bounds.height - v.position.y) / v.bounds.height
            rootViewController.view.alpha = 0.5 < a && v.position.y >= v.bounds.height / 2 ? a : 0.5
            
            delegate?.bottomSheetController?(bottomSheetController: self, didChangePanAt: point)
        case .ended, .cancelled, .failed:
            let p = recognizer.velocity(in: recognizer.view)
            let y = p.y >= 1000 || p.y <= -1000 ? p.y : 0
            
            delegate?.bottomSheetController?(bottomSheetController: self, didEndPanAt: point)
            
            if v.y >= bottomViewThreshold || y > 1000 {
                closeBottomView(velocity: y)
            } else {
                openBottomView(velocity: y)
            }
        case .possible:break
        }
    }
    
    /**
     A method that is fired when the tap gesture is recognized
     for the bottomView.
     - Parameter recognizer: A UITapGestureRecognizer that is
     passed to the handler when recognized.
     */
    @objc
    fileprivate func handleBottomViewTapGesture(recognizer: UITapGestureRecognizer) {
        guard isBottomViewOpened else {
            return
        }
        
        guard let v = bottomView else {
            return
        }
        
        delegate?.bottomSheetController?(bottomSheetController: self, didTapAt: recognizer.location(in: view), position: .left)
        
        guard isBottomViewEnabled && isBottomViewOpened && !isPointContainedWithinView(container: v, point: recognizer.location(in: v)) else {
            return
        }
        
        closeBottomView()
    }
}
