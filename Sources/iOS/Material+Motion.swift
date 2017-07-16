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

@objc(MotionAnimationFillMode)
public enum MotionAnimationFillMode: Int {
    case forwards
    case backwards
    case both
    case removed
}

/**
 Converts the MotionAnimationFillMode enum value to a corresponding String.
 - Parameter mode: An MotionAnimationFillMode enum value.
 */
public func MotionAnimationFillModeToValue(mode: MotionAnimationFillMode) -> String {
    switch mode {
    case .forwards:
        return kCAFillModeForwards
    case .backwards:
        return kCAFillModeBackwards
    case .both:
        return kCAFillModeBoth
    case .removed:
        return kCAFillModeRemoved
    }
}

@objc(MotionAnimationTimingFunction)
public enum MotionAnimationTimingFunction: Int {
    case `default`
    case linear
    case easeIn
    case easeOut
    case easeInEaseOut
}

/**
 Converts the MotionAnimationTimingFunction enum value to a corresponding CAMediaTimingFunction.
 - Parameter function: An MotionAnimationTimingFunction enum value.
 - Returns: A CAMediaTimingFunction.
 */
public func MotionAnimationTimingFunctionToValue(timingFunction: MotionAnimationTimingFunction) -> CAMediaTimingFunction {
    switch timingFunction {
    case .default:
        return CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
    case .linear:
        return CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    case .easeIn:
        return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    case .easeOut:
        return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    case .easeInEaseOut:
        return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    }
}

public typealias MotionDelayCancelBlock = (Bool) -> Void

fileprivate var MotionInstanceKey: UInt8 = 0
fileprivate var MotionInstanceControllerKey: UInt8 = 0

fileprivate struct MotionInstance {
    fileprivate var identifier: String
    fileprivate var animations: [MotionAnimation]
}

fileprivate struct MotionInstanceController {
    fileprivate var isEnabled: Bool
    fileprivate weak var delegate: MotionDelegate?
}

extension UIViewController: MotionDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate {
    /// MotionInstanceController reference.
    fileprivate var motionInstanceController: MotionInstanceController {
        get {
            return AssociatedObject(base: self, key: &MotionInstanceControllerKey) {
                return MotionInstanceController(isEnabled: false, delegate: nil)
            }
        }
        set(value) {
            AssociateObject(base: self, key: &MotionInstanceControllerKey, value: value)
        }
    }
    
    /// A boolean that indicates whether motion is enabled.
    open var isMotionEnabled: Bool {
        get {
            return motionInstanceController.isEnabled
        }
        set(value) {
            if value {
                modalPresentationStyle = .custom
                transitioningDelegate = self
                motionDelegate = self
                (self as? UINavigationController)?.delegate = self
                (self as? UITabBarController)?.delegate = self
            }
            
            motionInstanceController.isEnabled = value
        }
    }
    
    /// A reference to the MotionDelegate.
    open weak var motionDelegate: MotionDelegate? {
        get {
            return motionInstanceController.delegate
        }
        set(value) {
            motionInstanceController.delegate = value
        }
    }
    
    /**
     Determines whether to use a Motion instance for transitions.
     - Parameter _ navigationController: A UINavigationController.
     - Parameter animationControllerFor operation: A UINavigationControllerOperation.
     - Parameter from fromVC: A UIViewController that is being transitioned from.
     - Parameter to toVC: A UIViewController that is being transitioned to.
     - Returns: An optional UIViewControllerAnimatedTransitioning.
     */
    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return fromVC.isMotionEnabled ? Motion(isPresenting: operation == .push, isContainer: true) : nil
    }
    
    /**
     Determines whether to use a Motion instance for transitions.
     - Parameter _ tabBarController: A UITabBarController.
     - Parameter animationControllerForTransitionFrom fromVC: A UIViewController that is being transitioned from.
     - Parameter to toVC: A UIViewController that is being transitioned to.
     - Returns: An optional UIViewControllerAnimatedTransitioning.
     */
    open func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return fromVC.isMotionEnabled ? Motion(isPresenting: true, isContainer: true) : nil
    }
}

extension UIViewController {
    /**
     Determines whether to use a Motion instance for transitions.
     - Parameter forPresented presented: A UIViewController.
     - Parameter presenting: A UIViewController.
     - Parameter source: A UIViewController.
     - Returns: An optional UIViewControllerAnimatedTransitioning.
     */
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return isMotionEnabled ? PresentingMotion(isPresenting: true, isContainer: false) : nil
    }
    
    /**
     Determines whether to use a Motion instance for transitions.
     - Parameter forDismissed dismissed: A UIViewController.
     - Returns: An optional UIViewControllerAnimatedTransitioning.
     */
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return isMotionEnabled ? DismissingMotion(isPresenting: true, isContainer: false) : nil
    }
    
    /**
     Determines whether to use a MotionPresentationController for transitions.
     - Parameter forPresented presented: A UIViewController.
     - Parameter presenting: A UIViewController.
     - Parameter source: A UIViewController.
     - Returns: An optional UIPresentationController.
     */
    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return isMotionEnabled ? MotionPresentationController(presentedViewController: presented, presenting: presenting) : nil
    }
}

extension UIView {
    /// MotionInstance reference.
    fileprivate var motionInstance: MotionInstance {
        get {
            return AssociatedObject(base: self, key: &MotionInstanceKey) {
                return MotionInstance(identifier: "", animations: [])
            }
        }
        set(value) {
            AssociateObject(base: self, key: &MotionInstanceKey, value: value)
        }
    }
    
    /// An identifier value used to connect views across UIViewControllers.
    open var motionIdentifier: String {
        get {
            return motionInstance.identifier
        }
        set(value) {
            motionInstance.identifier = value
        }
    }
    
    /// The animations to run while in transition.
    open var motionAnimations: [MotionAnimation] {
        get {
            return motionInstance.animations
        }
        set(value) {
            motionInstance.animations = value
        }
    }
}

extension UIView {
    /**
     Snapshots the view instance for animations during transitions.
     - Parameter afterUpdates: A boolean indicating whether to snapshot the view
     after a render update, or as is.
     - Parameter shouldHide: A boolean indicating whether the view should be hidden
     after the snapshot is taken.
     - Returns: A UIView instance that is a snapshot of the given UIView.
     */
    open func transitionSnapshot(afterUpdates: Bool, shouldHide: Bool = true) -> UIView {
        isHidden = false
        
        // Material specific.
        (self as? PulseableLayer)?.pulseLayer?.isHidden = true
        
        let oldCornerRadius = layer.cornerRadius
        layer.cornerRadius = 0
        
        var oldBackgroundColor: UIColor?
        
        if shouldHide {
            oldBackgroundColor = backgroundColor
            backgroundColor = .clear
        }
        
        let oldTransform = motionTransform
        motionTransform = CATransform3DIdentity
        
        let v = snapshotView(afterScreenUpdates: afterUpdates)!
        layer.cornerRadius = oldCornerRadius
        
        if shouldHide {
            backgroundColor = oldBackgroundColor
        }
        
        motionTransform = oldTransform
        
        let contentView = v.subviews.first!
        contentView.layer.cornerRadius = layer.cornerRadius
        contentView.layer.masksToBounds = true
        
        v.motionIdentifier = motionIdentifier
        v.layer.position = motionPosition
        v.bounds = bounds
        v.layer.cornerRadius = layer.cornerRadius
        v.layer.zPosition = layer.zPosition
        v.layer.opacity = layer.opacity
        v.isOpaque = isOpaque
        v.layer.anchorPoint = layer.anchorPoint
        v.layer.masksToBounds = layer.masksToBounds
        v.layer.borderColor = layer.borderColor
        v.layer.borderWidth = layer.borderWidth
        v.layer.shadowRadius = layer.shadowRadius
        v.layer.shadowOpacity = layer.shadowOpacity
        v.layer.shadowColor = layer.shadowColor
        v.layer.shadowOffset = layer.shadowOffset
        v.contentMode = contentMode
        v.motionTransform = motionTransform
        v.backgroundColor = backgroundColor
        
        // Material specific.
        (self as? PulseableLayer)?.pulseLayer?.isHidden = false
        
        isHidden = shouldHide
        
        return v
    }
}

open class MotionPresentationController: UIPresentationController {
    open override func presentationTransitionWillBegin() {
        guard nil != containerView else {
            return
        }
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in })
    }
    
    open override func presentationTransitionDidEnd(_ completed: Bool) {}
    
    open override func dismissalTransitionWillBegin() {
        guard nil != containerView else {
            return
        }
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in })
    }
    
    open override func dismissalTransitionDidEnd(_ completed: Bool) {}
    
    open override var frameOfPresentedViewInContainerView: CGRect {
        return containerView?.bounds ?? .zero
    }
}

@objc(MotionDelegate)
public protocol MotionDelegate {
    @objc
    optional func motion(motion: Motion, willTransition fromView: UIView, toView: UIView)
    
    @objc
    optional func motion(motion: Motion, didTransition fromView: UIView, toView: UIView)
    
    @objc
    optional func motionDelayTransitionByTimeInterval(motion: Motion) -> TimeInterval
    
    @objc
    optional func motionWillBeginPresentation(presentationController: UIPresentationController)
    
    @objc
    optional func motionAnimateAlongsideTransition(presentationController: UIPresentationController)
}

open class MotionAnimator: NSObject {
    /// A boolean indicating whether Motion is presenting a view controller.
    open fileprivate(set) var isPresenting: Bool
    
    /// A boolean indicating whether the view controller is a container.
    open fileprivate(set) var isContainer: Bool
    
    /**
     An Array of UIView pairs with common motionIdentifiers in
     the from and to view controllers.
     */
    open fileprivate(set) var transitionPairs = [(UIView, UIView)]()
    
    /// A reference to the transition snapshot.
    open var transitionSnapshot: UIView!
    
    /// A reference to the transition background view.
    open let transitionBackgroundView = UIView()
    
    /// A reference to the view controller that is being transitioned to.
    open var toViewController: UIViewController {
        return transitionContext.viewController(forKey: .to)!
    }
    
    /// A reference to the view controller that is being transitioned from.
    open var fromViewController: UIViewController {
        return transitionContext.viewController(forKey: .from)!
    }
    
    /// The transition context for the current transition.
    open var transitionContext: UIViewControllerContextTransitioning!
    
    /// The transition delay time.
    open var delay: TimeInterval = 0
    
    /// The transition duration time.
    open var duration: TimeInterval = 0.35
    
    /// The transition container view.
    open var containerView: UIView!
    
    /// The view that is used to animate the transitions between view controllers.
    open var transitionView = UIView()
    
    /// The view that is being transitioned to.
    open var toView: UIView {
        return toViewController.view
    }
    
    /// The subviews of the view being transitioned to.
    open var toSubviews: [UIView] {
        return Motion.subviews(of: toView)
    }
    
    /// The view that is being transitioned from.
    open var fromView: UIView {
        return fromViewController.view
    }
    
    /// The subviews of the view being transitioned from.
    open var fromSubviews: [UIView] {
        return Motion.subviews(of: fromView)
    }
    
    /// The default initializer.
    public override init() {
        isPresenting = false
        isContainer = false
        super.init()
    }
    
    /**
     An initializer to modify the presenting and container state.
     - Parameter isPresenting: A boolean value indicating if the
     Motion instance is presenting the view controller.
     - Parameter isContainer: A boolean value indicating if the
     Motion instance is a container view controller.
     */
    public init(isPresenting: Bool, isContainer: Bool) {
        self.isPresenting = isPresenting
        self.isContainer = isContainer
        super.init()
    }
    
    /// Returns an Array of subviews for a given subview.
    fileprivate class func subviews(of view: UIView) -> [UIView] {
        var views: [UIView] = []
        Motion.subviews(of: view, views: &views)
        return views
    }
    
    /// Populates an Array of views that are subviews of a given view.
    fileprivate class func subviews(of view: UIView, views: inout [UIView]) {
        for v in view.subviews {
            if 0 < v.motionIdentifier.utf16.count {
                views.append(v)
            }
            subviews(of: v, views: &views)
        }
    }
    
    /**
     Executes a block of code after a time delay.
     - Parameter duration: An animation duration time.
     - Parameter animations: An animation block.
     - Parameter execute block: A completion block that is executed once
     the animations have completed.
     */
    @discardableResult
    open class func delay(_ time: TimeInterval, execute block: @escaping () -> Void) -> MotionDelayCancelBlock? {
        func asyncAfter(completion: @escaping () -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: completion)
        }
        
        var cancelable: MotionDelayCancelBlock?
        
        let delayed: MotionDelayCancelBlock = {
            if !$0 {
                DispatchQueue.main.async(execute: block)
            }
            cancelable = nil
        }
        
        cancelable = delayed
        
        asyncAfter {
            cancelable?(false)
        }
        
        return cancelable
    }
    
    /**
     Cancels the delayed MotionDelayCancelBlock.
     - Parameter delayed completion: An MotionDelayCancelBlock.
     */
    open class func cancel(delayed completion: MotionDelayCancelBlock) {
        completion(true)
    }
    
    /**
     Disables the default animations set on CALayers.
     - Parameter animations: A callback that wraps the animations to disable.
     */
    open class func disable(_ animations: (() -> Void)) {
        animate(duration: 0, animations: animations)
    }
    
    /**
     Runs an animation with a specified duration.
     - Parameter duration: An animation duration time.
     - Parameter animations: An animation block.
     - Parameter timingFunction: An MotionAnimationTimingFunction value.
     - Parameter completion: A completion block that is executed once
     the animations have completed.
     */
    open class func animate(duration: CFTimeInterval, timingFunction: MotionAnimationTimingFunction = .easeInEaseOut, animations: (() -> Void), completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock(completion)
        CATransaction.setAnimationTimingFunction(MotionAnimationTimingFunctionToValue(timingFunction: timingFunction))
        animations()
        CATransaction.commit()
    }
}

extension MotionAnimator: UIViewControllerAnimatedTransitioning {
    /**
     The animation method that is used to coordinate the transition.
     - Parameter using transitionContext: A UIViewControllerContextTransitioning.
     */
    @objc(animateTransition:)
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
    }
    
    /**
     Returns the transition duration time interval.
     - Parameter using transitionContext: An optional UIViewControllerContextTransitioning.
     - Returns: A TimeInterval that is the total animation time including delays.
     */
    @objc(transitionDuration:)
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return delay + duration
    }
}

extension MotionAnimator {
    /// Adds the available transition animations.
    fileprivate func addTransitionAnimations() {
        for (from, to) in transitionPairs {
            var snapshotAnimations = [CABasicAnimation]()
            var snapshotChildAnimations = [CABasicAnimation]()
            
            let sizeAnimation = Motion.size(to.bounds.size)
            let cornerRadiusAnimation = Motion.corner(radius: to.layer.cornerRadius)
            
            snapshotAnimations.append(sizeAnimation)
            snapshotAnimations.append(cornerRadiusAnimation)
            snapshotAnimations.append(Motion.position(to: to.motionPosition))
            snapshotAnimations.append(Motion.transform(transform: to.motionTransform))
            snapshotAnimations.append(Motion.background(color: to.backgroundColor ?? .clear))
            
            if let path = to.layer.shadowPath {
                let shadowPath = Motion.shadow(path: path)
                shadowPath.fromValue = fromView.layer.shadowPath
                snapshotAnimations.append(shadowPath)
            }
            
            let shadowOffset = Motion.shadow(offset: to.layer.shadowOffset)
            shadowOffset.fromValue = fromView.layer.shadowOffset
            snapshotAnimations.append(shadowOffset)
            
            let shadowOpacity = Motion.shadow(opacity: to.layer.shadowOpacity)
            shadowOpacity.fromValue = fromView.layer.shadowOpacity
            snapshotAnimations.append(shadowOpacity)
            
            let shadowRadius = Motion.shadow(radius: to.layer.shadowRadius)
            shadowRadius.fromValue = fromView.layer.shadowRadius
            snapshotAnimations.append(shadowRadius)
            
            snapshotChildAnimations.append(cornerRadiusAnimation)
            snapshotChildAnimations.append(sizeAnimation)
            snapshotChildAnimations.append(Motion.position(x: to.bounds.width / 2, y: to.bounds.height / 2))
            
            let d = calculateAnimationTransitionDuration(animations: to.motionAnimations)
            
            let snapshot = from.transitionSnapshot(afterUpdates: true)
            transitionView.addSubview(snapshot)
            
            Motion.delay(calculateAnimationDelayTimeInterval(animations: to.motionAnimations)) { [weak self, weak to] in
                guard let s = self else {
                    return
                }
                
                guard let v = to else {
                    return
                }
                
                let tf = s.calculateAnimationTimingFunction(animations: v.motionAnimations)
                
                let snapshotGroup = Motion.animate(group: snapshotAnimations, duration: d)
                snapshotGroup.fillMode = MotionAnimationFillModeToValue(mode: .forwards)
                snapshotGroup.isRemovedOnCompletion = false
                snapshotGroup.timingFunction = MotionAnimationTimingFunctionToValue(timingFunction: tf)
                
                let snapshotChildGroup = Motion.animate(group: snapshotChildAnimations, duration: d)
                snapshotChildGroup.fillMode = MotionAnimationFillModeToValue(mode: .forwards)
                snapshotChildGroup.isRemovedOnCompletion = false
                snapshotChildGroup.timingFunction = MotionAnimationTimingFunctionToValue(timingFunction: tf)
                
                snapshot.animate(snapshotGroup)
                snapshot.subviews.first?.animate(snapshotChildGroup)
            }
        }
    }
    
    /// Adds the background animation.
    fileprivate func addBackgroundAnimation() {
        transitionBackgroundView.motion(.backgroundColor(isPresenting ? toView.backgroundColor ?? .clear : .clear), .duration(transitionDuration(using: transitionContext)))
    }
}

extension MotionAnimator {
    /**
     Calculates the animation delay time based on the given Array of MotionAnimations.
     - Parameter animations: An Array of MotionAnimations.
     - Returns: A TimeInterval.
     */
    fileprivate func calculateAnimationDelayTimeInterval(animations: [MotionAnimation]) -> TimeInterval {
        var t: TimeInterval = 0
        for a in animations {
            switch a {
            case let .delay(time):
                if time > delay {
                    delay = time
                }
                t = time
            default:break
            }
        }
        return t
    }
    
    /**
     Calculates the animation transition duration based on the given Array of MotionAnimations.
     - Parameter animations: An Array of MotionAnimations.
     - Returns: A TimeInterval.
     */
    fileprivate func calculateAnimationTransitionDuration(animations: [MotionAnimation]) -> TimeInterval {
        var t: TimeInterval = 0.35
        for a in animations {
            switch a {
            case let .duration(time):
                if time > duration {
                    duration = time
                }
                t = time
            default:break
            }
        }
        return t
    }
    
    /**
     Calculates the animation timing function based on the given Array of MotionAnimations.
     - Parameter animations: An Array of MotionAnimations.
     - Returns: A MotionAnimationTimingFunction.
     */
    fileprivate func calculateAnimationTimingFunction(animations: [MotionAnimation]) -> MotionAnimationTimingFunction {
        var t = MotionAnimationTimingFunction.easeInEaseOut
        for a in animations {
            switch a {
            case let .timingFunction(timingFunction):
                t = timingFunction
            default:break
            }
        }
        return t
    }
}

open class Motion: MotionAnimator {
    /// A time value to delay the transition animation by.
    fileprivate var delayTransitionByTimeInterval: TimeInterval {
        return fromViewController.motionDelegate?.motionDelayTransitionByTimeInterval?(motion: self) ?? 0
    }
    
    /**
     The animation method that is used to coordinate the transition.
     - Parameter using transitionContext: A UIViewControllerContextTransitioning.
     */
    @objc(animateTransition:)
    open override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)
        fromViewController.motionDelegate?.motion?(motion: self, willTransition: fromView, toView: toView)
        
        Motion.delay(delayTransitionByTimeInterval) { [weak self] in
            guard let s = self else {
                return
            }
            
            s.prepareContainerView()
            s.prepareTransitionSnapshot()
            s.prepareTransitionPairs()
            s.prepareTransitionView()
            s.prepareTransitionBackgroundView()
            s.prepareToView()
            s.prepareTransitionAnimation()
        }
    }
    
    /// Prepares the toView.
    fileprivate func prepareToView() {
        toView.isHidden = isPresenting
        containerView.insertSubview(toView, belowSubview: transitionView)
        
        toView.frame = fromView.frame
        toView.updateConstraints()
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
    }
}

extension Motion {
    /// Prepares the containerView.
    fileprivate func prepareContainerView() {
        containerView = transitionContext.containerView
    }
    
    /// Prepares the transitionSnapshot.
    fileprivate func prepareTransitionSnapshot() {
        transitionSnapshot = fromView.transitionSnapshot(afterUpdates: true, shouldHide: false)
        transitionSnapshot.frame = fromView.frame
        containerView.addSubview(transitionSnapshot)
    }
    
    /// Prepares the transitionPairs.
    fileprivate func prepareTransitionPairs() {
        for from in fromSubviews {
            for to in toSubviews {
                guard to.motionIdentifier == from.motionIdentifier else {
                    continue
                }
                transitionPairs.append((from, to))
            }
        }
    }
    
    /// Prepares the transitionView.
    fileprivate func prepareTransitionView() {
        transitionView.frame = toView.bounds
        transitionView.isUserInteractionEnabled = false
        containerView.insertSubview(transitionView, belowSubview: transitionSnapshot)
    }
    
    /// Prepares the transitionBackgroundView.
    fileprivate func prepareTransitionBackgroundView() {
        transitionBackgroundView.backgroundColor = isPresenting ? .clear : fromView.backgroundColor ?? .clear
        transitionBackgroundView.frame = transitionView.bounds
        transitionView.addSubview(transitionBackgroundView)
    }
    
    /// Prepares the transition animation.
    fileprivate func prepareTransitionAnimation() {
        addTransitionAnimations()
        addBackgroundAnimation()
        cleanUpAnimation()
        removeTransitionSnapshot()
    }
}

extension Motion {
    /**
     Creates a CAAnimationGroup.
     - Parameter animations: An Array of CAAnimation objects.
     - Parameter timingFunction: An MotionAnimationTimingFunction value.
     - Parameter duration: An animation duration time for the group.
     - Returns: A CAAnimationGroup.
     */
    open class func animate(group animations: [CAAnimation], timingFunction: MotionAnimationTimingFunction = .easeInEaseOut, duration: CFTimeInterval = 0.5) -> CAAnimationGroup {
        let group = CAAnimationGroup()
        group.fillMode = MotionAnimationFillModeToValue(mode: .forwards)
        group.isRemovedOnCompletion = false
        group.animations = animations
        group.duration = duration
        group.timingFunction = MotionAnimationTimingFunctionToValue(timingFunction: timingFunction)
        return group
    }
}

extension Motion {
    /// Cleans up the animation transition.
    fileprivate func cleanUpAnimation() {
        Motion.delay(transitionDuration(using: transitionContext) + delayTransitionByTimeInterval) { [weak self] in
            guard let s = self else {
                return
            }
            
            s.showToSubviews()
            s.removeTransitionView()
            s.clearTransitionPairs()
            s.completeTransition()
        }
    }
    
    /// Removes the transitionSnapshot from its superview.
    fileprivate func removeTransitionSnapshot() {
        Motion.delay(delay) { [weak self] in
            self?.transitionSnapshot.removeFromSuperview()
        }
    }
    
    /// Shows the toView and its subviews.
    fileprivate func showToSubviews() {
        toSubviews.forEach {
            $0.isHidden = false
        }
        toView.isHidden = false
    }
    
    /// Clears the transitionPairs Array.
    fileprivate func clearTransitionPairs() {
        transitionPairs.removeAll()
    }
    
    /// Removes the transitionView.
    fileprivate func removeTransitionView() {
        transitionView.removeFromSuperview()
    }
    
    /// Calls the completionTransition method.
    fileprivate func completeTransition() {
        toViewController.motionDelegate?.motion?(motion: self, didTransition: fromView, toView: toView)
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
}

open class PresentingMotion: Motion {}

open class DismissingMotion: Motion {
    /// Prepares the toView.
    fileprivate override func prepareToView() {
        toView.isHidden = true
        toView.frame = fromView.frame
        toView.updateConstraints()
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
    }

}
