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

fileprivate var MotionTransitionInstanceKey: UInt8 = 0
fileprivate var MotionTransitionInstanceControllerKey: UInt8 = 0

fileprivate struct MotionTransitionInstance {
    fileprivate var identifier: String
    fileprivate var animations: [MotionAnimation]
}

fileprivate struct MotionTransitionInstanceController {
    fileprivate var isEnabled: Bool
}

extension UIViewController: UIViewControllerTransitioningDelegate {
    /// MotionTransitionInstanceController Reference.
    fileprivate var motionTransition: MotionTransitionInstanceController {
        get {
            return AssociatedObject(base: self, key: &MotionTransitionInstanceControllerKey) {
                return MotionTransitionInstanceController(isEnabled: false)
            }
        }
        set(value) {
            AssociateObject(base: self, key: &MotionTransitionInstanceControllerKey, value: value)
        }
    }

    open var isMotionTransitionEnabled: Bool {
        get {
            return motionTransition.isEnabled
        }
        set(value) {
            if value {
                modalPresentationStyle = .custom
                transitioningDelegate = self
            }
            
            motionTransition.isEnabled = value
        }
    }
}

extension UIViewController {
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return isMotionTransitionEnabled ? MotionTransition(isPresenting: true) : nil
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return isMotionTransitionEnabled ? MotionTransition() : nil
    }
    
    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return isMotionTransitionEnabled ? MotionTransitionPresentationController(presentedViewController: presented, presenting: presenting) : nil
    }
}

extension UIViewController {
    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return isMotionTransitionEnabled ? MotionTransition(isPresenting: operation == .push) : nil
    }
}

extension UIViewController {
    open func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return isMotionTransitionEnabled ? MotionTransition() : nil
    }
}

extension UIView {
    /// The global position of a view.
    open var motionPosition: CGPoint {
        return superview?.convert(position, to: nil) ?? position
    }
    
    /// MaterialTransitionItem Reference.
    fileprivate var motionTransition: MotionTransitionInstance {
        get {
            return AssociatedObject(base: self, key: &MotionTransitionInstanceKey) {
                return MotionTransitionInstance(identifier: "", animations: [])
            }
        }
        set(value) {
            AssociateObject(base: self, key: &MotionTransitionInstanceKey, value: value)
        }
    }
    
    open var motionTransitionIdentifier: String {
        get {
            return motionTransition.identifier
        }
        set(value) {
            motionTransition.identifier = value
        }
    }
    
    open var motionTransitionAnimations: [MotionAnimation] {
        get {
            return motionTransition.animations
        }
        set(value) {
            motionTransition.animations = value
        }
    }
    
    open func motionTransitionSnapshot(afterUpdates: Bool) -> UIView {
        isHidden = false
        
        (self as? Pulseable)?.pulse.pulseLayer?.isHidden = true
        
        let oldCornerRadius = cornerRadius
        cornerRadius = 0
        
        let oldBackgroundColor = backgroundColor
        backgroundColor = .clear
        
        let oldTransform = transform
        transform = .identity
        
        let v = snapshotView(afterScreenUpdates: afterUpdates)!
        cornerRadius = oldCornerRadius
        backgroundColor = oldBackgroundColor
        transform = oldTransform
        
        let contentView = v.subviews.first!
        contentView.cornerRadius = cornerRadius
        contentView.masksToBounds = true
        
        v.motionTransitionIdentifier = motionTransitionIdentifier
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
        v.transform = transform
        v.backgroundColor = backgroundColor
        
        print(motionRotationAngle)
        
        isHidden = true
        (self as? Pulseable)?.pulse.pulseLayer?.isHidden = false
        
        return v
    }
}

open class MotionTransitionPresentationController: UIPresentationController {
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

open class MotionTransition: NSObject {
    open var isPresenting: Bool
    
    open var transitionSnapshot: UIView!
    
    open let transitionBackgroundView = UIView()
    
    open var toViewController: UIViewController!
    
    open var fromViewController: UIViewController!
    
    open var transitionContext: UIViewControllerContextTransitioning!
    
    open var delay: TimeInterval = 0
    open var duration: TimeInterval = 0
    
    open var containerView: UIView!
    open var transitionView = UIView()
    
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
        return subviews(of: toView)
    }
    
    open var fromView: UIView {
        return fromViewController.view
    }
    
    open var fromSubviews: [UIView] {
        return subviews(of: fromView)
    }
    
    open func subviews(of view: UIView) -> [UIView] {
        var views: [UIView] = []
        subviews(of: view, views: &views)
        return views
    }
    
    open func subviews(of view: UIView, views: inout [UIView]) {
        for v in view.subviews {
            if 0 < v.motionTransitionIdentifier.utf16.count {
                views.append(v)
            }
            subviews(of: v, views: &views)
        }
    }
}

extension MotionTransition: UIViewControllerAnimatedTransitioning {
    @objc(animateTransition:)
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        prepareToViewController()
        prepareFromViewController()
        prepareContainerView()
        prepareTransitionView()
        prepareTransitionBackgroundView()
        prepareTransitionSnapshot()
        prepareToView()
        prepareTransitionAnimation()
    }
    
    @objc(transitionDuration:)
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return delay + duration
    }
}

extension MotionTransition {
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
    
    fileprivate func prepareTransitionView() {
        transitionView.frame = containerView.bounds
        containerView.addSubview(transitionView)
    }
    
    fileprivate func prepareTransitionBackgroundView() {
        transitionBackgroundView.backgroundColor = fromView.backgroundColor
        transitionBackgroundView.frame = transitionView.bounds
        transitionView.addSubview(transitionBackgroundView)
    }
    
    fileprivate func prepareTransitionSnapshot() {
        transitionSnapshot = fromView.motionTransitionSnapshot(afterUpdates: true)
        transitionSnapshot.frame = containerView.bounds
        transitionView.addSubview(transitionSnapshot)
    }
    
    fileprivate func prepareToView() {
        if isPresenting {
            containerView.insertSubview(toView, belowSubview: transitionView)
        }
        
        toView.updateConstraints()
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        toView.isHidden = false
    }
    
    fileprivate func prepareTransitionAnimation() {
        for fv in fromSubviews {
            for tv in toSubviews {
                if tv.motionTransitionIdentifier == fv.motionTransitionIdentifier {
                    var t: TimeInterval = 0
                    var d: TimeInterval = 0
                    var tf = MotionAnimationTimingFunction.easeInEaseOut
                    
                    for ta in tv.motionTransitionAnimations {
                        switch ta {
                        case let .delay(time):
                            if time > delay {
                                delay = time
                            }
                            t = time
                        case let .duration(time):
                            if time > duration {
                                duration = time
                            }
                            d = time
                        default:break
                        }
                    }
                    
                    var snapshotAnimations = [CABasicAnimation]()
                    var snapshotChildAnimations = [CABasicAnimation]()
                    
                    let sizeAnimation = Motion.size(tv.bounds.size)
                    let cornerRadiusAnimation = Motion.corner(radius: tv.cornerRadius)
                    
                    snapshotAnimations.append(sizeAnimation)
                    snapshotAnimations.append(cornerRadiusAnimation)
                    snapshotAnimations.append(Motion.position(to: tv.motionPosition))
                    snapshotAnimations.append(Motion.rotation(angle: tv.motionRotationAngle))
                    snapshotAnimations.append(Motion.background(color: tv.backgroundColor ?? .clear))
                    
                    snapshotChildAnimations.append(cornerRadiusAnimation)
                    snapshotChildAnimations.append(sizeAnimation)
                    snapshotChildAnimations.append(Motion.position(x: tv.bounds.width / 2, y: tv.bounds.height / 2))
                    
                    let snapshot = fv.motionTransitionSnapshot(afterUpdates: true)
                    transitionView.insertSubview(snapshot, belowSubview: transitionSnapshot)
                    
                    Motion.delay(t) {
                        for ta in tv.motionTransitionAnimations {
                            switch ta {
                            case let .timingFunction(timingFunction):
                                tf = timingFunction
                            case let .shadow(path):
                                snapshotAnimations.append(Motion.shadow(path: path))
                            default:break
                            }
                        }
                        
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
            }
        }
        
        addBackgroundMotionAnimation()
        
        cleanupAnimation()
        cleanupFromView()
        cleanupTransitionSnapshot()
    }
}

extension MotionTransition {
    fileprivate func addBackgroundMotionAnimation() {
        transitionBackgroundView.motion(.backgroundColor(toView.backgroundColor ?? .clear), .duration(transitionDuration(using: transitionContext)))
    }
}

extension MotionTransition {
    fileprivate func cleanupAnimation() {
        Motion.delay(transitionDuration(using: transitionContext)) { [weak self] in
            guard let s = self else {
                return
            }
            
            s.hideToSubviews()
            s.clearTransitionView()
            s.completeTransition()
        }
    }
    
    fileprivate func cleanupFromView() {
        Motion.delay(delay) { [weak self] in
            self?.fromView.isHidden = true
        }
    }
    
    fileprivate func cleanupTransitionSnapshot() {
        Motion.delay(delay) { [weak self] in
            self?.transitionSnapshot.removeFromSuperview()
        }
    }
    
    fileprivate func hideToSubviews() {
        toSubviews.forEach {
            $0.isHidden = false
        }
    }
    
    fileprivate func clearTransitionView() {
        transitionView.removeFromSuperview()
        transitionView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    fileprivate func completeTransition() {
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
}
