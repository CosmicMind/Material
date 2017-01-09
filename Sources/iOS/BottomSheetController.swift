/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

@objc(BottomSheetFABButtonPosition)
public enum BottomSheetFABButtonPosition: Int {
    case left
    case right
    case center
}

@objc(BottomSheetStyle)
public enum BottomSheetStyle: Int {
    case modal
    case persistent
}

open class BottomSheet: View {
    /// Handler for when the fabButton is set.
    fileprivate var fabButtonWasSet: ((FABButton?) -> Void)?
    
    /// A reference to a FABButton.
    open var fabButton: FABButton? {
        didSet {
            fabButtonWasSet?(fabButton)
            fabButton?.zPosition = 6000
            layoutSubviews()
        }
    }

    /// A reference to the BottomSheetFABButtonPosition.
    open var fabButtonPostion = BottomSheetFABButtonPosition.right
    
    /// A reference to the fabButtonEdgeInsetsPreset.
    open var fabButtonEdgeInsetsPreset = EdgeInsetsPreset.none {
        didSet {
            fabButtonEdgeInsets = EdgeInsetsPresetToValue(preset: fabButtonEdgeInsetsPreset)
        }
    }
        
    /// A reference to the fabButtonEdgeInsets.
    open var fabButtonEdgeInsets = EdgeInsets.zero {
        didSet {
            layoutSubviews()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if let v = fabButton {
            if nil == v.superview {
                v.removeFromSuperview()
                addSubview(v)
            }
            
            var point = center
            point.y = fabButtonEdgeInsets.top - fabButtonEdgeInsets.bottom
            
            switch fabButtonPostion {
            case .left:
                point.x = v.bounds.width / 2 + fabButtonEdgeInsets.left
            case .right:
                point.x = bounds.width - v.bounds.width / 2 - fabButtonEdgeInsets.right
            case .center:break
            }
            
            v.center = point
        }
    }
    
    open override func prepare() {
        super.prepare()
        fabButtonEdgeInsetsPreset = .horizontally5
    }
}

extension BottomSheet {
    /**
     Handles the hit test for the fabButton.
     - Parameter _ point: A CGPoint.
     - Parameter with event: An optional UIEvent.
     - Returns: An optional UIView.
     */
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let v = fabButton else {
            return super.hitTest(point, with: event)
        }
        
        let p = v.convert(point, from: self)
        if v.bounds.contains(p) {
            return v.hitTest(p, with: event)
        }
        
        return super.hitTest(point, with: event)
    }
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
     - Parameter bottomViewController: A BottomSheetController.
     */
    @objc
    optional func bottomViewControllerWillOpen(bottomViewController: BottomSheetController)
    
    /**
     An optional delegation method that is fired after the
     BottomSheetController opened.
     - Parameter bottomViewController: A BottomSheetController.
     */
    @objc
    optional func bottomViewControllerDidOpen(bottomViewController: BottomSheetController)
    
    /**
     An optional delegation method that is fired before the
     BottomSheetController closes.
     - Parameter bottomViewController: A BottomSheetController.
     */
    @objc
    optional func bottomViewControllerWillClose(bottomViewController: BottomSheetController)
    
    /**
     An optional delegation method that is fired after the
     BottomSheetController closed.
     - Parameter bottomViewController: A BottomSheetController.
     */
    @objc
    optional func bottomViewControllerDidClose(bottomViewController: BottomSheetController)
    
    /**
     An optional delegation method that is fired when the
     BottomSheetController pan gesture begins.
     - Parameter bottomViewController: A BottomSheetController.
     - Parameter didBeginPanAt point: A CGPoint.
     */
    @objc
    optional func bottomViewController(bottomViewController: BottomSheetController, didBeginPanAt point: CGPoint)
    
    /**
     An optional delegation method that is fired when the
     BottomSheetController pan gesture changes position.
     - Parameter bottomViewController: A BottomSheetController.
     - Parameter didChangePanAt point: A CGPoint.
     */
    @objc
    optional func bottomViewController(bottomViewController: BottomSheetController, didChangePanAt point: CGPoint)
    
    /**
     An optional delegation method that is fired when the
     BottomSheetController pan gesture ends.
     - Parameter bottomViewController: A BottomSheetController.
     - Parameter didEndPanAt point: A CGPoint.
     */
    @objc
    optional func bottomViewController(bottomViewController: BottomSheetController, didEndPanAt point: CGPoint)
    
    /**
     An optional delegation method that is fired when the
     BottomSheetController tap gesture executes.
     - Parameter bottomViewController: A BottomSheetController.
     - Parameter didTapAt point: A CGPoint.
     */
    @objc
    optional func bottomViewController(bottomViewController: BottomSheetController, didTapAt point: CGPoint)
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
     bottomSheet pan gesture.
     */
    internal fileprivate(set) var bottomPanGesture: UIPanGestureRecognizer?
    
    /**
     A UITapGestureRecognizer property internally used for the
     bottomSheet tap gesture.
     */
    internal fileprivate(set) var bottomTapGesture: UITapGestureRecognizer?
    
    /**
     A CGFloat property that accesses the bottomSheet threshold of
     the BottomSheetController. When the panning gesture has
     ended, if the position is beyond the threshold,
     the bottomSheet is opened, if it is below the threshold, the
     bottomSheet is closed.
     */
    @IBInspectable
    open var bottomThreshold: CGFloat = 64
    fileprivate var bottomSheetThreshold: CGFloat = 0
    
    /// A preset for bottomSheetClosedThreshold.
    open var bottomSheetClosedThresholdPreset = HeightPreset.none {
        didSet {
            bottomSheetClosedThreshold = CGFloat(bottomSheetClosedThresholdPreset.rawValue)
        }
    }
    
    /// The height the BottomSheet should leave open when a FABButton exists.
    open var bottomSheetClosedThreshold: CGFloat = 0 {
        didSet {
            layoutSubviews()
        }
    }
    
    /**
     A BottomSheetControllerDelegate property used to bind
     the delegation object.
     */
    open weak var delegate: BottomSheetControllerDelegate?
    
    /**
     A CGFloat property that sets the animation duration of the
     bottomSheet when closing and opening. Defaults to 0.25.
     */
    @IBInspectable
    open var animationDuration: TimeInterval = 0.25
    
    /**
     A Boolean property that enables and disables the bottomSheet from
     opening and closing. Defaults to true.
     */
    @IBInspectable
    open var isEnabled: Bool {
        get {
            return isBottomSheetEnabled
        }
        set(value) {
            isBottomSheetEnabled = value
        }
    }
    
    /**
     A Boolean property that enables and disables the bottomSheet from
     opening and closing. Defaults to true.
     */
    @IBInspectable
    open var isBottomSheetEnabled = false {
        didSet {
            isBottomPanGestureEnabled = isBottomSheetEnabled
            isBottomTapGestureEnabled = isBottomSheetEnabled
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
     bottomSheet when opened.
     */
    open var depthPreset = DepthPreset.depth1
    
    /**
     A UIView property that is used to hide and reveal the
     bottomViewController. It is very rare that this property will
     need to be accessed externally.
     */
    open let bottomSheet = BottomSheet()
    
    /// Indicates whether the bottomSheet or rightView is opened.
    open var isOpened: Bool {
        return isBottomSheetOpened
    }
    
    /// indicates if the bottomSheet is opened.
    open var isBottomSheetOpened: Bool {
        return bottomSheet.y != Screen.height
    }
    
    /**
     A UIViewController property that references the
     active left UIViewController.
     */
    open fileprivate(set) var bottomViewController: UIViewController?
    
    /**
     A CGFloat property to access the width that the bottomSheet
     opens up to.
     */
    @IBInspectable
    open fileprivate(set) var bottomSheetHeight: CGFloat = 0
    
    /// Determines the layout style for the bottomSheet.
    open var bottomSheetStyle = BottomSheetStyle.modal {
        didSet {
            switch bottomSheetStyle {
            case .modal:
                depthPreset = .depth1
                isBottomPanGestureEnabled = true
                isBottomTapGestureEnabled = true
            case .persistent:
                depthPreset = .none
                isBottomPanGestureEnabled = false
                isBottomTapGestureEnabled = false
            }
        }
    }
    
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
        bottomSheet.width = view.bounds.width
        bottomSheet.height = bottomSheetHeight
        
        bottomSheetThreshold = view.bounds.height - bottomSheetHeight / 2
        
        if .persistent == bottomSheetStyle {
            rootViewController.view.height = view.bounds.height - bottomSheetHeight
        }
        
        guard let vc = bottomViewController else {
            return
        }
        
        vc.view.width = bottomSheet.bounds.width
        vc.view.height = bottomSheetHeight
        vc.view.center = CGPoint(x: bottomSheet.bounds.width / 2, y: bottomSheetHeight / 2)
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
        prepareBottomSheet()
        bottomSheetClosedThresholdPreset = .large
        bottomSheet.fabButtonWasSet = handleFABButtonWasSet
    }
    
    /**
     A method that is used to set the width of the bottomSheet when
     opened. This is the recommended method of setting the bottomSheet
     width.
     - Parameter width: A CGFloat value to set as the new width.
     - Parameter isHidden: A Boolean value of whether the bottomSheet
     should be isHidden after the width has been updated or not.
     - Parameter animated: A Boolean value that indicates to animate
     the bottomSheet width change.
     */
    open func setBottomSheetHeight(height: CGFloat, isHidden: Bool, animated: Bool, duration: TimeInterval = 0.5) {
        bottomSheetHeight = height
        
        if animated {
            bottomSheet.isShadowPathAutoSizing = false
            
            if isHidden {
                UIView.animate(withDuration: duration,
                    animations: { [weak self, v = bottomSheet] in
                        guard let s = self else {
                            return
                        }
                        
                        v.bounds.size.height = height
                        v.position.y = s.view.bounds.height - height / 2
//                        s.rootViewController.view.alpha = 1
                }) { [weak self, v = bottomSheet] _ in
                    guard let s = self else {
                        return
                    }
                    
                    v.isShadowPathAutoSizing = true
                    s.layoutSubviews()
                    s.hideView(container: v)
                }
            } else {
                UIView.animate(withDuration: duration,
                    animations: { [weak self, v = bottomSheet, h = bottomSheetHeight] in
                        guard let s = self else {
                            return
                        }
                        
                        v.bounds.size.height = h
                        v.position.y = s.view.bounds.height - h / 2
//                        s.rootViewController.view.alpha = 0.5
                }) { [weak self, v = bottomSheet] _ in
                    guard let s = self else {
                        return
                    }
                    
                    v.isShadowPathAutoSizing = true
//                    s.layoutSubviews()
                    s.showView(container: v)
                }
            }
        } else {
            bottomSheet.bounds.size.height = bottomSheetHeight
            
            if isHidden {
                hideView(container: bottomSheet)
                bottomSheet.position.y = view.bounds.height - bottomSheetHeight / 2
                rootViewController.view.alpha = 1
            } else {
                bottomSheet.isShadowPathAutoSizing = false
                
                showView(container: bottomSheet)
                bottomSheet.position.y = height / 2
                rootViewController.view.alpha = 0.5
                bottomSheet.isShadowPathAutoSizing = true
            }
            
            layoutSubviews()
        }
    }
    
    /**
     A method that toggles the bottomSheet opened if previously closed,
     or closed if previously opened.
     - Parameter velocity: A CGFloat value that sets the
     velocity of the user interaction when animating the
     bottomSheet. Defaults to 0.
     */
    open func toggleBottomSheet(velocity: CGFloat = 0) {
        isBottomSheetOpened ? closeBottomSheet(velocity: velocity) : openBottomSheet(velocity: velocity)
    }
    
    /**
     A method that opens the bottomSheet.
     - Parameter velocity: A CGFloat value that sets the
     velocity of the user interaction when animating the
     bottomSheet. Defaults to 0.
     */
    open func openBottomSheet(velocity: CGFloat = 0) {
        guard isBottomSheetEnabled else {
            return
        }
        
        showView(container: bottomSheet)
        
        isUserInteractionEnabled = false
        
        delegate?.bottomViewControllerWillOpen?(bottomViewController: self)
        
        UIView.animate(withDuration: TimeInterval(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(bottomSheet.y / velocity)))),
            animations: { [weak self, v = bottomSheet] in
                guard let s = self else {
                    return
                }
                
                v.position.y = s.view.bounds.height - s.bottomSheetHeight / 2
                
                if .modal == s.bottomSheetStyle {
                    s.rootViewController.view.alpha = 0.5
                }
        }) { [weak self] _ in
            guard let s = self else {
                return
            }
            
            s.delegate?.bottomViewControllerDidOpen?(bottomViewController: s)
        }
    }
    
    /**
     A method that closes the bottomSheet.
     - Parameter velocity: A CGFloat value that sets the
     velocity of the user interaction when animating the
     bottomSheet. Defaults to 0.
     */
    open func closeBottomSheet(velocity: CGFloat = 0) {
        guard isBottomSheetEnabled else {
            return
        }
        
        isUserInteractionEnabled = true
        
        delegate?.bottomViewControllerWillClose?(bottomViewController: self)
        
        UIView.animate(withDuration: TimeInterval(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(bottomSheet.y / velocity)))),
            animations: { [weak self, v = bottomSheet] in
                guard let s = self else {
                    return
                }
                
                v.position.y = s.view.bounds.height + s.bottomSheetHeight / 2 - (nil == s.bottomSheet.fabButton ? 0 : s.bottomSheetClosedThreshold)
                
                if .modal == s.bottomSheetStyle {
                    s.rootViewController.view.alpha = 1
                }
        }) { [weak self, v = bottomSheet] _ in
            guard let s = self else {
                return
            }
            
            if nil == s.bottomSheet.fabButton {
                s.hideView(container: v)
            }
            
            s.delegate?.bottomViewControllerDidClose?(bottomViewController: s)
        }
    }
    
    /// A method that removes the passed in pan and bottomSheet tap gesture recognizers.
    fileprivate func removeBottomSheetGestures() {
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
     contained within the bounds of the bottomSheetThreshold
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
        let result = container.bounds.contains(point)
        
        guard false == result, let v = bottomSheet.fabButton else {
            return result
        }
        
        return v.bounds.contains(v.convert(point, from: container))
    }
    
    /**
     A method that shows a view.
     - Parameter container: A container view.
     */
    fileprivate func showView(container: UIView) {
        container.isHidden = false
        container.depthPreset = depthPreset
    }
    
    /**
     A method that hides a view.
     - Parameter container: A container view.
     */
    fileprivate func hideView(container: UIView) {
        container.isHidden = true
        container.depthPreset = .none
    }
}

extension BottomSheetController {
    /// A method that prepares the bottomViewController.
    fileprivate func prepareBottomSheetController() {
        prepare(viewController: bottomViewController, withContainer: bottomSheet)
    }
    
    /// A method that prepares the bottomSheet.
    fileprivate func prepareBottomSheet() {
        bottomSheetHeight = .phone == Device.userInterfaceIdiom ? 280 : 320
        
        bottomSheet.isHidden = true
        bottomSheet.width = view.bounds.width
        bottomSheet.height = bottomSheetHeight
        bottomSheet.position.y = view.bounds.height + bottomSheetHeight / 2
        bottomSheet.zPosition = 2000
        view.addSubview(bottomSheet)
        
        guard nil != bottomViewController else {
            return
        }
        
        isBottomSheetEnabled = true
        prepareBottomSheetController()
    }
    
    /// Prepare the left pan gesture.
    fileprivate func prepareBottomPanGesture() {
        guard nil == bottomPanGesture else {
            return
        }
        
        bottomPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleBottomSheetPanGesture(recognizer:)))
        bottomPanGesture!.delegate = self
        view.addGestureRecognizer(bottomPanGesture!)
    }
    
    /// Prepare the left tap gesture.
    fileprivate func prepareBottomTapGesture() {
        guard nil == bottomTapGesture else {
            return
        }
        
        bottomTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBottomSheetTapGesture(recognizer:)))
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
        if gestureRecognizer == bottomPanGesture && (isBottomSheetOpened || isPointContainedWithinBottomThreshold(point: touch.location(in: view))) {
            return true
        }
        
        if isBottomSheetOpened && gestureRecognizer == bottomTapGesture {
            return true
        }
        
        return false
    }
    
    /**
     A method that is fired when the pan gesture is recognized
     for the bottomSheet.
     - Parameter recognizer: A UIPanGestureRecognizer that is
     passed to the handler when recognized.
     */
    @objc
    fileprivate func handleBottomSheetPanGesture(recognizer: UIPanGestureRecognizer) {
        guard isBottomSheetEnabled && (isBottomSheetOpened || isPointContainedWithinBottomThreshold(point: recognizer.location(in: view))) else {
            return
        }
        
        // Animate the panel.
        switch recognizer.state {
        case .began:
            originalY = bottomSheet.position.y
            showView(container: bottomSheet)
            
            delegate?.bottomViewController?(bottomViewController: self, didBeginPanAt: recognizer.location(in: view))
        case .changed:
            let y = originalY + recognizer.translation(in: bottomSheet).y
            let h = view.bounds.height
            let b = bottomSheetHeight / 2
            let p = h - b
            let q = h + b - bottomSheetClosedThreshold
            
            bottomSheet.position.y = y < p ? p : y > q && nil != bottomSheet.fabButton ? q : y
            
            let a = 1 - (h - y) / bottomSheetHeight
            rootViewController.view.alpha = 0.5 < a && y >= b ? a : 0.5
            
            delegate?.bottomViewController?(bottomViewController: self, didChangePanAt: recognizer.location(in: view))
        case .ended, .cancelled, .failed:
            let p = recognizer.velocity(in: recognizer.view)
            let v = p.y >= 500 || p.y <= -500 ? p.y : 0
            
            delegate?.bottomViewController?(bottomViewController: self, didEndPanAt: recognizer.location(in: view))
            
            if bottomSheet.y >= bottomSheetThreshold || v > 500 {
                closeBottomSheet(velocity: v)
            } else {
                openBottomSheet(velocity: v)
            }
        case .possible:break
        }
    }
    
    /**
     A method that is fired when the tap gesture is recognized
     for the bottomSheet.
     - Parameter recognizer: A UITapGestureRecognizer that is
     passed to the handler when recognized.
     */
    @objc
    fileprivate func handleBottomSheetTapGesture(recognizer: UITapGestureRecognizer) {
        guard isBottomSheetOpened else {
            return
        }
        
        delegate?.bottomViewController?(bottomViewController: self, didTapAt: recognizer.location(in: view))
        
        guard isBottomSheetEnabled && isBottomSheetOpened && !isPointContainedWithinView(container: bottomSheet, point: recognizer.location(in: bottomSheet)) else {
            return
        }
        
        closeBottomSheet()
    }
}

extension BottomSheetController {
    /**
     A handler that is executed when the bottomSheet.fabButton
     has been set.
     - Parameter fabButton: An optional FABButton.
     */
    fileprivate func handleFABButtonWasSet(fabButton: FABButton?) {
        guard nil == fabButton else {
            if !isOpened  {
                showView(container: bottomSheet)
                closeBottomSheet()
            }
            return
        }
        
        if !isOpened {
            closeBottomSheet()
        }
    }
}
