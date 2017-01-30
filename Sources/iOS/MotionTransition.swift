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
    fileprivate var delegate: MotionTransition
}

extension UIViewController {
    /// MotionTransitionInstanceController Reference.
    fileprivate var motionTransition: MotionTransitionInstanceController {
        get {
            return AssociatedObject(base: self, key: &MotionTransitionInstanceControllerKey) {
                return MotionTransitionInstanceController(delegate: MotionTransition())
            }
        }
        set(value) {
            AssociateObject(base: self, key: &MotionTransitionInstanceControllerKey, value: value)
        }
    }
    
    open var transitionDelegate: MotionTransition {
        return motionTransition.delegate
    }
}

open class MotionTransitionViewController: UIViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)
        prepare()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        prepare()
    }
    
    /**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
    open func prepare() {
        modalPresentationStyle = .custom
        transitioningDelegate = transitionDelegate
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
    
    open func snapshot(afterUpdates: Bool) -> UIView {
        isHidden = false
        
        (self as? Pulseable)?.pulse.pulseLayer?.isHidden = true
        
        let oldCornerRadius = cornerRadius
        cornerRadius = 0
        
        let v = snapshotView(afterScreenUpdates: afterUpdates)!
        cornerRadius = oldCornerRadius
        
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
        v.backgroundColor = backgroundColor
        v.borderColor = borderColor
        v.borderWidth = borderWidth
        v.shadowRadius = shadowRadius
        v.shadowOpacity = shadowOpacity
        v.shadowColor = shadowColor
        v.shadowOffset = shadowOffset
        v.contentMode = contentMode
        v.layer.transform = layer.transform
        
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
//            print("Animating")
        })
        
//        print("presentationTransitionWillBegin")
    }

    open override func presentationTransitionDidEnd(_ completed: Bool) {
//        print("presentationTransitionDidEnd")
    }
    
    open override func dismissalTransitionWillBegin() {
        guard nil != containerView else {
            return
        }
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
//            print("Animating")
        })
        
//        print("dismissalTransitionWillBegin")
    }
    
    open override func dismissalTransitionDidEnd(_ completed: Bool) {
//        print("dismissalTransitionDidEnd")
    }
    
    open override var frameOfPresentedViewInContainerView: CGRect {
        return containerView?.bounds ?? .zero
    }
}

open class MotionTransition: NSObject {
    open var isPresenting = false
    
    open var toViewController: UIViewController!
    
    open var fromViewController: UIViewController!
    
    open var transitionContext: UIViewControllerContextTransitioning!
    
    open var delay: TimeInterval = 0
    open var duration: TimeInterval = 0
    
    open var containerView: UIView!
    open var transitionView = UIView()
    
    open var toView: UIView {
        return toViewController.view
    }
    
    open var toSubviews: [UIView] {
        var views: [UIView] = []
        subviews(of: toView, views: &views)
        return views
    }
    
    open var fromView: UIView {
        return fromViewController.view
    }
    
    open var fromSubviews: [UIView] {
        var views: [UIView] = []
        subviews(of: fromView, views: &views)
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

extension MotionTransition: UIViewControllerTransitioningDelegate {
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MotionTransitionPresentedAnimator()
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MotionTransitionDismissedAnimator()
    }
    
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil // MotionTransitionInteractiveAnimator()
    }
    
    open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil // MotionTransitionInteractiveAnimator()
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return MotionTransitionPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension MotionTransition: UINavigationControllerDelegate {
    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = operation == .push
        return self
    }
    
    open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return MotionTransitionInteractiveAnimator()
    }
}

extension MotionTransition: UITabBarControllerDelegate {
    open func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        self.fromViewController = fromViewController ?? fromVC
        self.toViewController = toViewController ?? toVC
        //        self.inContainerController = true
        return self
    }
    
    open func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return MotionTransitionInteractiveAnimator()
    }
}

extension MotionTransition: UIViewControllerAnimatedTransitioning {
    @objc(animateTransition:)
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let tVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        guard let fVC = transitionContext.viewController(forKey: .from) else {
            return
        }

        self.transitionContext = transitionContext
        
        containerView = transitionContext.containerView
        containerView.addSubview(transitionView)
        transitionView.frame = containerView.bounds
        
        toViewController = tVC
        fromViewController = fVC
    }
    
    @objc(transitionDuration:)
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return delay + duration
    }
}

open class MotionTransitionPresentedAnimator: MotionTransition {
    open let backgroundView = UIView()
    
    @objc(animateTransition:)
    open override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)
        
        transitionView.isHidden = true
        
        backgroundView.backgroundColor = fromView.backgroundColor
        backgroundView.frame = transitionView.bounds
        transitionView.addSubview(backgroundView)
        
        containerView.insertSubview(toView, belowSubview: transitionView)
        toView.updateConstraints()
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        
        for tv in toSubviews {
            for fv in fromSubviews {
                if tv.motionTransitionIdentifier == fv.motionTransitionIdentifier {
                    var t: TimeInterval = 0
                    var d: TimeInterval = 0
                    var snapshotAnimations = [CABasicAnimation]()
                    var snapshotChildAnimations = [CABasicAnimation]()
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
                    
                    snapshotAnimations.append(Motion.position(to: tv.motionPosition))
                    
                    let sizeAnimation = Motion.size(tv.bounds.size)
                    snapshotAnimations.append(sizeAnimation)
                    snapshotChildAnimations.append(sizeAnimation)
                    
                    snapshotChildAnimations.append(Motion.position(x: tv.bounds.width / 2, y: tv.bounds.height / 2))
                    
                    snapshotAnimations.append(Motion.rotate(angle: tv.motionRotationAngle))
                    
                    let cornerRadiusAnimation = Motion.corner(radius: tv.cornerRadius)
                    snapshotAnimations.append(cornerRadiusAnimation)
                    snapshotChildAnimations.append(cornerRadiusAnimation)
                    
                    let snapshot = fv.snapshot(afterUpdates: true)
                    transitionView.addSubview(snapshot)
                    
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
        
        let d = transitionDuration(using: transitionContext)
        
        if let v = toView.backgroundColor {
            backgroundView.motion(.backgroundColor(v), .duration(d))
        }
        
        Motion.delay(d) { [weak self] in
            defer {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
            guard let s = self else {
                return
            }
            
            s.transitionView.removeFromSuperview()
            for v in s.transitionView.subviews {
                v.removeFromSuperview()
            }
        }
        
        transitionView.isHidden = false
    }
}

open class MotionTransitionDismissedAnimator: MotionTransition {
    @objc(animateTransition:)
    open override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)
        
        transitionView.isHidden = true
        
        let bgView = UIView()
        bgView.backgroundColor = fromView.backgroundColor
        bgView.frame = transitionView.bounds
        transitionView.addSubview(bgView)
        
        toView.updateConstraints()
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        
        for tv in toSubviews {
            for fv in fromSubviews {
                if tv.motionTransitionIdentifier == fv.motionTransitionIdentifier {
                    var t: TimeInterval = 0
                    var d: TimeInterval = 0
                    var snapshotAnimations = [CABasicAnimation]()
                    var snapshotChildAnimations = [CABasicAnimation]()
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
                    
                    snapshotAnimations.append(Motion.position(to: tv.motionPosition))
                    
                    let sizeAnimation = Motion.size(tv.bounds.size)
                    snapshotAnimations.append(sizeAnimation)
                    snapshotChildAnimations.append(sizeAnimation)
                    
                    snapshotChildAnimations.append(Motion.position(x: tv.bounds.width / 2, y: tv.bounds.height / 2))
                    
                    snapshotAnimations.append(Motion.rotate(angle: tv.motionRotationAngle))
                    
                    let cornerRadiusAnimation = Motion.corner(radius: tv.cornerRadius)
                    snapshotAnimations.append(cornerRadiusAnimation)
                    snapshotChildAnimations.append(cornerRadiusAnimation)
                    
                    let snapshot = fv.snapshot(afterUpdates: true)
                    transitionView.addSubview(snapshot)
                    
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
        
        fromView.isHidden = true
        
        let d = transitionDuration(using: transitionContext)
        
        if nil != bgView.backgroundColor {
            bgView.motion(.backgroundColor(.clear), .duration(d))
        }
        
        Motion.delay(d) { [weak self] in
            defer {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
            guard let s = self else {
                return
            }
            
            for v in s.toSubviews {
                v.isHidden = false
            }
            
            s.transitionView.removeFromSuperview()
            for v in s.transitionView.subviews {
                v.removeFromSuperview()
            }
        }
        
        transitionView.isHidden = false
    }
}

open class MotionTransitionInteractiveAnimator: MotionTransitionInteractiveDelegate {
    open override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        
    }
}

open class MotionTransitionInteractiveDelegate: UIPercentDrivenInteractiveTransition {
    open var isPresenting = false
    open var transitionContext: UIViewControllerContextTransitioning!
    
    open var containerView: UIView!
    
    open var toView: UIView!
    open var toViewController: UIViewController!
    open var toViewStartFrame: CGRect!
    open var toViewFinalFrame: CGRect!
    
    open var fromView: UIView!
    open var fromViewController: UIViewController!
    open var fromViewFinalFrame: CGRect!
    
    open var panGesture: UIPanGestureRecognizer!
    
    @objc(startInteractiveTransition:)
    open override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        
        guard let tView = transitionContext.view(forKey: .to) else {
            return
        }
        
        guard let tVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        guard let fView = transitionContext.view(forKey: .from) else {
            return
        }
        
        guard let fVC = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        self.transitionContext = transitionContext
        
        containerView = transitionContext.containerView
        
        toView = tView
        toViewController = tVC
        
        fromView = fView
        fromViewController = fVC
        
        toViewStartFrame = transitionContext.initialFrame(for: toViewController)
        toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        fromViewFinalFrame = transitionContext.finalFrame(for: fromViewController)
        
        preparePanGesture()
    }
    
    open func animationEnded(_ transitionCompleted: Bool) {
        //        print("MotionTransitionAnimator", #function)
    }
}

extension MotionTransitionInteractiveDelegate {
    fileprivate func preparePanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(recognizer:)))
        panGesture.maximumNumberOfTouches = 1
        containerView.addGestureRecognizer(panGesture)
    }
}

extension MotionTransitionInteractiveDelegate {
    @objc
    fileprivate func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            panGesture.setTranslation(.zero, in: containerView)
        case .changed:
            let translation = panGesture.translation(in: containerView)
            
            /**
             Compute how far the gesture recognizer tranveled on the
             vertical axis.
             */
            let percentageComplete = fabs(translation.y / containerView.bounds.height)
            update(percentageComplete)
            
        case .ended:
            finish()
            containerView.removeGestureRecognizer(panGesture)
        default:break
        }
    }
}
