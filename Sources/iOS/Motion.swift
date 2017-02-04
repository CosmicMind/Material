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

extension UIViewController: MotionDelegate, UIViewControllerTransitioningDelegate {
    /// MotionInstanceController Reference.
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
    
    open var isMotionEnabled: Bool {
        get {
            return motionInstanceController.isEnabled
        }
        set(value) {
            if value {
                modalPresentationStyle = .custom
                transitioningDelegate = self
                motionDelegate = self
            }
            
            motionInstanceController.isEnabled = value
        }
    }
    
    open weak var motionDelegate: MotionDelegate? {
        get {
            return motionInstanceController.delegate
        }
        set(value) {
            motionInstanceController.delegate = value
        }
    }
}

extension UIViewController {
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return isMotionEnabled ? Motion(isPresenting: true) : nil
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return isMotionEnabled ? Motion() : nil
    }
    
    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return isMotionEnabled ? MotionPresentationController(presentedViewController: presented, presenting: presenting) : nil
    }
}

extension UIView {
    /// MaterialTransitionItem Reference.
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
    
    open var motionIdentifier: String {
        get {
            return motionInstance.identifier
        }
        set(value) {
            motionInstance.identifier = value
        }
    }
    
    open var motionAnimations: [MotionAnimation] {
        get {
            return motionInstance.animations
        }
        set(value) {
            motionInstance.animations = value
        }
    }
    
    open func transitionSnapshot(afterUpdates: Bool, shouldHide: Bool = true) -> UIView {
        isHidden = false
        
        let oldCornerRadius = cornerRadius
        cornerRadius = 0
        
        var oldBackgroundColor: UIColor?
        
        if shouldHide {
            oldBackgroundColor = backgroundColor
            backgroundColor = .clear
        }
        
        let oldTransform = motionTransform
        motionTransform = CATransform3DIdentity
        
        let v = snapshotView(afterScreenUpdates: afterUpdates)!
        cornerRadius = oldCornerRadius
        
        if shouldHide {
            backgroundColor = oldBackgroundColor
        }
        
        motionTransform = oldTransform
        
        let contentView = v.subviews.first!
        contentView.cornerRadius = cornerRadius
        contentView.masksToBounds = true
        
        v.motionIdentifier = motionIdentifier
        v.position = motionPosition
        v.bounds = bounds
        v.cornerRadius = cornerRadius
        v.zPosition = zPosition
        v.opacity = opacity
        v.isOpaque = isOpaque
        v.anchorPoint = anchorPoint
        v.masksToBounds = masksToBounds
        v.borderColor = borderColor
        v.borderWidth = borderWidth
        v.shadowRadius = shadowRadius
        v.shadowOpacity = shadowOpacity
        v.shadowColor = shadowColor
        v.shadowOffset = shadowOffset
        v.contentMode = contentMode
        v.motionTransform = motionTransform
        v.backgroundColor = backgroundColor
        
        isHidden = shouldHide
        
        return v
    }
}

open class MotionPresentationController: UIPresentationController {
    open override func presentationTransitionWillBegin() {
        guard nil != containerView else {
            return
        }
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
            print("Animating")
        })
        
        print("presentationTransitionWillBegin")
    }
    
    open override func presentationTransitionDidEnd(_ completed: Bool) {
        print("presentationTransitionDidEnd")
    }
    
    open override func dismissalTransitionWillBegin() {
        guard nil != containerView else {
            return
        }
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
            print("Animating")
        })
        
        print("dismissalTransitionWillBegin")
    }
    
    open override func dismissalTransitionDidEnd(_ completed: Bool) {
        print("dismissalTransitionDidEnd")
    }
    
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
    optional func motionModifyDelay(motion: Motion) -> TimeInterval
    
    @objc
    optional func motionTransitionAnimation(motion: Motion)
}

open class Motion: NSObject {
    open var isPresenting: Bool
    
    open fileprivate(set) var transitionPairs = [(UIView, UIView)]()
    
    open var transitionSnapshot: UIView!
    
    open let transitionBackgroundView = UIView()
    
    open var toViewController: UIViewController!
    
    open var fromViewController: UIViewController!
    
    open var transitionContext: UIViewControllerContextTransitioning!
    
    open var delay: TimeInterval = 0
    open var duration: TimeInterval = 0.35
    
    open var containerView: UIView!
    open var transitionView = UIView()
    
    fileprivate var modifiedDelay: TimeInterval {
        return fromViewController?.motionDelegate?.motionModifyDelay?(motion: self) ?? 0
    }
    
    public override init() {
        isPresenting = false
        super.init()
    }
    
    public init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    open var toView: UIView {
        return toViewController.view
    }
    
    open var toSubviews: [UIView] {
        return Motion.subviews(of: toView)
    }
    
    open var fromView: UIView {
        return fromViewController.view
    }
    
    open var fromSubviews: [UIView] {
        return Motion.subviews(of: fromView)
    }
    
    open class func subviews(of view: UIView) -> [UIView] {
        var views: [UIView] = []
        Motion.subviews(of: view, views: &views)
        return views
    }
    
    open class func subviews(of view: UIView, views: inout [UIView]) {
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
}

extension Motion: UIViewControllerAnimatedTransitioning {
    @objc(animateTransition:)
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        prepareToViewController()
        prepareFromViewController()
        
        fromViewController.motionDelegate?.motion?(motion: self, willTransition: fromView, toView: toView)
        
        Motion.delay(modifiedDelay) { [weak self] in
            guard let s = self else {
                return
            }
            
            s.prepareContainerView()
            s.prepareTransitionSnapshot()
            s.prepareTransitionPairs()
            s.prepareTransitionView()
            s.prepareTransitionBackgroundView()
            s.prepareTransitionToView()
            s.prepareTransitionAnimation()
        }
    }
    
    @objc(transitionDuration:)
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return delay + duration
    }
}

extension Motion {
    fileprivate func prepareToViewController() {
        guard let v = transitionContext.viewController(forKey: .to) else {
            return
        }
        toViewController = v
    }
    
    fileprivate func prepareFromViewController() {
        guard let v = transitionContext.viewController(forKey: .from) else {
            return
        }
        fromViewController = v
    }
    
    fileprivate func prepareContainerView() {
        containerView = transitionContext.containerView
    }
    
    fileprivate func prepareTransitionSnapshot() {
        transitionSnapshot = fromView.transitionSnapshot(afterUpdates: true, shouldHide: false)
        transitionSnapshot.frame = containerView.bounds
        containerView.insertSubview(transitionSnapshot, aboveSubview: fromView)
    }
    
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
    
    fileprivate func prepareTransitionView() {
        transitionView.frame = containerView.bounds
        transitionView.isUserInteractionEnabled = false
        containerView.insertSubview(transitionView, belowSubview: transitionSnapshot)
    }
    
    fileprivate func prepareTransitionBackgroundView() {
        transitionBackgroundView.backgroundColor = isPresenting ? .clear : fromView.backgroundColor ?? .clear
        transitionBackgroundView.frame = transitionView.bounds
        transitionView.addSubview(transitionBackgroundView)
    }
    
    fileprivate func prepareTransitionToView() {
        toView.isHidden = isPresenting
        containerView.insertSubview(toView, belowSubview: transitionView)
        
        toView.updateConstraints()
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
    }
    
    fileprivate func prepareTransitionAnimation() {
        addTransitionAnimations()
        addBackgroundMotionAnimation()
        
        cleanupAnimation()
        removeTransitionSnapshot()
    }
}

extension Motion {
    fileprivate func addTransitionAnimations() {
        for (from, to) in transitionPairs {
            var snapshotAnimations = [CABasicAnimation]()
            var snapshotChildAnimations = [CABasicAnimation]()
            
            let sizeAnimation = Motion.size(to.bounds.size)
            let cornerRadiusAnimation = Motion.corner(radius: to.cornerRadius)
            
            snapshotAnimations.append(sizeAnimation)
            snapshotAnimations.append(cornerRadiusAnimation)
            snapshotAnimations.append(Motion.position(to: to.motionPosition))
            snapshotAnimations.append(Motion.transform(transform: to.motionTransform))
            snapshotAnimations.append(Motion.background(color: to.backgroundColor ?? .clear))
            
            snapshotChildAnimations.append(cornerRadiusAnimation)
            snapshotChildAnimations.append(sizeAnimation)
            snapshotChildAnimations.append(Motion.position(x: to.bounds.width / 2, y: to.bounds.height / 2))
            
            let d = transitionDuration(animations: to.motionAnimations)
            
            let snapshot = from.transitionSnapshot(afterUpdates: true)
            transitionView.addSubview(snapshot)
            
            Motion.delay(motionDelay(animations: to.motionAnimations)) { [weak self, weak to] in
                guard let s = self else {
                    return
                }
                
                guard let v = to else {
                    return
                }
                
                let tf = s.motionTimingFunction(animations: v.motionAnimations)
                
                let snapshotGroup = Motion.animate(group: snapshotAnimations, duration: d)
                snapshotGroup.fillMode = MotionAnimationFillModeToValue(mode: .forwards)
                snapshotGroup.isRemovedOnCompletion = false
                snapshotGroup.timingFunction = MotionAnimationTimingFunctionToValue(timingFunction: tf)
                
                let snapshotChildGroup = Motion.animate(group: snapshotChildAnimations, duration: d)
                snapshotChildGroup.fillMode = MotionAnimationFillModeToValue(mode: .forwards)
                snapshotChildGroup.isRemovedOnCompletion = false
                snapshotChildGroup.timingFunction = MotionAnimationTimingFunctionToValue(timingFunction: tf)
                
                snapshot.animate(snapshotGroup)
                snapshot.subviews.first!.animate(snapshotChildGroup)
            }
        }
        
        fromViewController.motionDelegate?.motionTransitionAnimation?(motion: self)
        toViewController.motionDelegate?.motionTransitionAnimation?(motion: self)
    }
    
    fileprivate func addBackgroundMotionAnimation() {
        transitionBackgroundView.motion(.backgroundColor(isPresenting ? toView.backgroundColor ?? .clear : .clear), .duration(transitionDuration(using: transitionContext)))
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
    internal class func animate(group animations: [CAAnimation], timingFunction: MotionAnimationTimingFunction = .easeInEaseOut, duration: CFTimeInterval = 0.5) -> CAAnimationGroup {
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
    fileprivate func motionDelay(animations: [MotionAnimation]) -> TimeInterval {
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
    
    fileprivate func transitionDuration(animations: [MotionAnimation]) -> TimeInterval {
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
    
    fileprivate func motionTimingFunction(animations: [MotionAnimation]) -> MotionAnimationTimingFunction {
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

extension Motion {
    fileprivate func cleanupAnimation() {
        Motion.delay(transitionDuration(using: transitionContext) + modifiedDelay) { [weak self] in
            guard let s = self else {
                return
            }
            
            s.showToSubviews()
            s.clearTransitionView()
            s.clearTransitionPairs()
            s.completeTransition()
        }
    }
    
    fileprivate func removeTransitionSnapshot() {
        Motion.delay(delay) { [weak self] in
            self?.transitionSnapshot.removeFromSuperview()
        }
    }
    
    fileprivate func showToSubviews() {
        toSubviews.forEach {
            $0.isHidden = false
        }
        toView.isHidden = false
    }
    
    fileprivate func clearTransitionPairs() {
        transitionPairs.removeAll()
    }
    
    fileprivate func clearTransitionView() {
        transitionView.removeFromSuperview()
        transitionView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    fileprivate func completeTransition() {
        toViewController.motionDelegate?.motion?(motion: self, didTransition: fromView, toView: toView)
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
}
