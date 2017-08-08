/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Original Inspiration & Author
 * Copyright (c) 2016 Luke Zhao <me@lkzhao.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

@objc(MotionViewControllerDelegate)
public protocol MotionViewControllerDelegate {
    /**
     An optional delegation method that is executed motion will start the transition.
     - Parameter motion: A Motion instance.
     - Parameter willStartTransitionFrom viewController: A UIViewController.
     */
    @objc
    optional func motionWillStartTransition(motion: Motion)
    
    /**
     An optional delegation method that is executed motion did end the transition.
     - Parameter motion: A Motion instance.
     - Parameter willStartTransitionFrom viewController: A UIViewController.
     */
    @objc
    optional func motionDidEndTransition(motion: Motion)
    
    /**
     An optional delegation method that is executed motion did cancel the transition.
     - Parameter motion: A Motion instance.
     - Parameter willStartTransitionFrom viewController: A UIViewController.
     */
    @objc
    optional func motionDidCancelTransition(motion: Motion)
    
    /**
     An optional delegation method that is executed when the source
     view controller will start the transition.
     - Parameter motion: A Motion instance.
     - Parameter willStartTransitionFrom viewController: A UIViewController.
     */
    @objc
    optional func motion(motion: Motion, willStartTransitionFrom viewController: UIViewController)
    
    /**
     An optional delegation method that is executed when the source
     view controller did end the transition.
     - Parameter motion: A Motion instance.
     - Parameter willStartTransitionFrom viewController: A UIViewController.
     */
    @objc
    optional func motion(motion: Motion, didEndTransitionFrom viewController: UIViewController)
    
    /**
     An optional delegation method that is executed when the source
     view controller did cancel the transition.
     - Parameter motion: A Motion instance.
     - Parameter willStartTransitionFrom viewController: A UIViewController.
     */
    @objc
    optional func motion(motion: Motion, didCancelTransitionFrom viewController: UIViewController)
    
    /**
     An optional delegation method that is executed when the destination
     view controller will start the transition.
     - Parameter motion: A Motion instance.
     - Parameter willStartTransitionFrom viewController: A UIViewController.
     */
    @objc
    optional func motion(motion: Motion, willStartTransitionTo viewController: UIViewController)
    
    /**
     An optional delegation method that is executed when the destination
     view controller did end the transition.
     - Parameter motion: A Motion instance.
     - Parameter willStartTransitionFrom viewController: A UIViewController.
     */
    @objc
    optional func motion(motion: Motion, didEndTransitionTo viewController: UIViewController)
    
    /**
     An optional delegation method that is executed when the destination
     view controller did cancel the transition.
     - Parameter motion: A Motion instance.
     - Parameter willStartTransitionFrom viewController: A UIViewController.
     */
    @objc
    optional func motion(motion: Motion, didCancelTransitionTo viewController: UIViewController)
}

/**
 ### The singleton class/object for controlling interactive transitions.
 
 ```swift
 Motion.shared
 ```
 
 #### Use the following methods for controlling the interactive transition:
 
 ```swift
 func update(progress:Double)
 func end()
 func cancel()
 func apply(transitions: [MotionTransition], to view: UIView)
 ```
 */
public class Motion: MotionController {
    /// Shared singleton object for controlling the transition
    public static let shared = Motion()
    
    /// Source view controller.
    public internal(set) var fromViewController: UIViewController?
    
    /// Destination view controller.
    public internal(set) var toViewController: UIViewController?
    
    /// Whether or not we are presenting the destination view controller.
    public internal(set) var isPresenting = true
    
    /// Progress of the current transition, 0 if a transition is not happening.
    public override var elapsedTime: TimeInterval {
        didSet {
            guard isTransitioning else {
                return
            }
            
            transitionContext?.updateInteractiveTransition(CGFloat(elapsedTime))
        }
    }
    
    /// Indicates whether the transition is animating or not.
    public var isAnimating = false
    
    /**
     A UIViewControllerContextTransitioning object provided by UIKit, which
     might be nil when isTransitioning. This happens when calling motionReplaceViewController
     */
    internal weak var transitionContext: UIViewControllerContextTransitioning?
    
    /// A reference to a fullscreen snapshot.
    internal var fullScreenSnapshot: UIView!
    
    /// Default animation type.
    internal var defaultAnimation = MotionTransitionType.auto
    
    /// The color of the transitioning container.
    internal var containerBackgroundColor: UIColor?
    
    /**
     By default, Motion will always appear to be interactive to UIKit. This forces it to appear non-interactive.
     Used when doing a motionReplaceViewController within a UINavigationController, to fix a bug with
     UINavigationController.setViewControllers not able to handle interactive transitions.
     */
    internal var forceNonInteractive = false
    
    /// Inserts the toViews first.
    internal var insertToViewFirst = false
    
    /// Indicates whether a UINavigationController is transitioning.
    internal var isNavigationController = false
    
    /// Indicates whether a UITabBarController is transitioning.
    internal var isTabBarController = false
    
    /// Indicates whether a UINavigationController or UITabBarController is transitioning.
    internal var isContainerController: Bool {
        return isNavigationController || isTabBarController
    }
    
    /// Indicates whether the from view controller is full screen.
    internal var fromOverFullScreen: Bool {
        guard let v = fromViewController else {
            return false
        }
        
        return !isContainerController && (.overFullScreen == v.modalPresentationStyle || .overCurrentContext == v.modalPresentationStyle)
    }
    
    /// Indicates whether the to view controller is full screen.
    internal var toOverFullScreen: Bool {
        guard let v = toViewController else {
            return false
        }
        
        return !isContainerController && (.overFullScreen == v.modalPresentationStyle || .overCurrentContext == v.modalPresentationStyle)
    }
    
    /// A reference to the fromView, fromViewController.view.
    internal var fromView: UIView? {
        return fromViewController?.view
    }
    
    /// A reference to the toView, toViewController.view.
    internal var toView: UIView? {
        return toViewController?.view
    }
    
    /// An initializer.
    internal override init() {
        super.init()
    }
}

public extension Motion {
    /// Turn off built-in animations for the next transition.
    func disableDefaultAnimationForNextTransition() {
        defaultAnimation = .none
    }
    
    /**
     Set the default animation for the next transition. This may override the
     root-view's motionTransitions during the transition.
     - Parameter animation: A MotionTransitionType.
     */
    func setAnimationForNextTransition(_ animation: MotionTransitionType) {
        defaultAnimation = animation
    }
    
    /**
     Set the container background color for the next transition.
     - Parameter _ color: An optional UIColor.
     */
    func setContainerBackgroundColorForNextTransition(_ color: UIColor?) {
        containerBackgroundColor = color
    }
}

fileprivate extension Motion {
    /// Starts the transition animation.
    func start() {
        guard isTransitioning else {
            return
        }
        
        prepareViewControllers()
        prepareSnapshotView()
        prepareTransition()
        prepareContext()
        prepareToView()
        prepareViewHierarchy()
        processContext()
        prepareTransitionPairs()
        processForAnimation()
    }
}

internal extension Motion {
    override func animate() {
        guard let tv = toView else {
            return
        }
        
        context.unhide(view: tv)
        
        updateContainerBackgroundColor()
        updateInsertOrder()
        
        super.animate()
        
        fullScreenSnapshot?.removeFromSuperview()
    }
    
    override func complete(isFinished: Bool) {
        guard isTransitioning else {
            return
        }
        
        guard let c = container else {
            return
        }
        
        guard let tc = transitionContainer else {
            return
        }
        
        guard let fv = fromView else {
            return
        }
        
        guard let tv = toView else {
            return
        }
        
        context.clean()
        
        if isFinished && isPresenting && toOverFullScreen {
            // finished presenting a overFullScreen view controller.
            context.unhide(rootView: tv)
            context.removeSnapshots(rootView: tv)
            context.storeViewAlpha(rootView: fv)
            
            fromViewController!.motionStoredSnapshot = container
            fv.removeFromSuperview()
            fv.addSubview(c)
        } else if !isFinished && !isPresenting && fromOverFullScreen {
            // Cancelled dismissing a overFullScreen view controller.
            context.unhide(rootView: fv)
            context.removeSnapshots(rootView: fv)
            context.storeViewAlpha(rootView: tv)
            
            toViewController!.motionStoredSnapshot = container
            tv.removeFromSuperview()
            tv.addSubview(c)
        } else {
            context.unhideAll()
            context.removeAllSnapshots()
            c.removeFromSuperview()
        }
        
        // Move fromView & toView back from our container back to the one supplied by UIKit.
        if (toOverFullScreen && isFinished) || (fromOverFullScreen && !isFinished) {
            tc.addSubview(isFinished ? fv : tv)
        }
        
        tc.addSubview(isFinished ? tv : fv)
        
        if isPresenting != isFinished, !isContainerController {
            // Only happens when present a .overFullScreen view controller.
            // bug: http://openradar.appspot.com/radar?id=5320103646199808
            UIApplication.shared.keyWindow!.addSubview(isPresenting ? fv : tv)
        }
        
        // use temp variables to remember these values
        // because we have to reset everything before calling
        // any delegate or completion block
        let tContext = transitionContext
        let fvc = fromViewController
        let tvc = toViewController
        
        resetTransition()
        
        super.complete(isFinished: isFinished)
        
        if isFinished {
            processEndTransitionDelegation(transitionContext: tContext, fromViewController: fvc, toViewController: tvc)
        } else {
            processCancelTransitionDelegation(transitionContext: tContext, fromViewController: fvc, toViewController: tvc)
        }
        
        tContext?.completeTransition(isFinished)
    }
}

fileprivate extension Motion {
    /// Resets the transition values.
    func resetTransition() {
        transitionContext = nil
        fromViewController = nil
        toViewController = nil
        containerBackgroundColor = nil
        isNavigationController = false
        isTabBarController = false
        forceNonInteractive = false
        insertToViewFirst = false
        defaultAnimation = .auto
    }
}

fileprivate extension Motion {
    /// Prepares the from and to view controllers.
    func prepareViewControllers() {
        processStartTransitionDelegation(fromViewController: fromViewController, toViewController: toViewController)
    }
    
    /// Prepares the snapshot view, which hides any flashing that may occur.
    func prepareSnapshotView() {
        guard let v = transitionContainer else {
            return
        }
        
        fullScreenSnapshot = v.window?.snapshotView(afterScreenUpdates: true) ?? fromView?.snapshotView(afterScreenUpdates: true)
        (v.window ?? transitionContainer)?.addSubview(fullScreenSnapshot)
        
        if let v = fromViewController?.motionStoredSnapshot {
            v.removeFromSuperview()
            fromViewController?.motionStoredSnapshot = nil
        }
        
        if let v = toViewController?.motionStoredSnapshot {
            v.removeFromSuperview()
            toViewController?.motionStoredSnapshot = nil
        }
    }
    
    /// Prepares the MotionContext instance.
    func prepareContext() {
        guard let v = container else {
            return
        }
        
        guard let fv = fromView else {
            return
        }
        
        guard let tv = toView else {
            return
        }
        
        context.loadViewAlpha(rootView: tv)
        v.addSubview(tv)
        
        context.loadViewAlpha(rootView: fv)
        v.addSubview(fv)
    }
    
    /// Prepares the toView instance.
    func prepareToView() {
        guard let fv = fromView else {
            return
        }
        
        guard let tv = toView else {
            return
        }
        
        tv.frame = fv.frame
        tv.updateConstraints()
        tv.setNeedsLayout()
        tv.layoutIfNeeded()
    }
    
    /// Prepares the view hierarchy.
    func prepareViewHierarchy() {
        guard let fv = fromView else {
            return
        }
        
        guard let tv = toView else {
            return
        }
        
        context.set(fromViews: fv.flattenedViewHierarchy, toViews: tv.flattenedViewHierarchy)
    }
}

internal extension Motion {
    override func prepareTransition() {
        super.prepareTransition()
        insert(preprocessor: TransitionPreprocessor(motion: self), before: DurationPreprocessor.self)
    }
    
    override func prepareTransitionPairs() {
        super.prepareTransitionPairs()
        
        guard let tv = toView else {
            return
        }
        
        context.hide(view: tv)
    }
}

fileprivate extension Motion {
    /// Processes the animations.
    func processForAnimation() {
        #if os(tvOS)
            animate()
        #else
            if isNavigationController {
                // When animating within navigationController, we have to dispatch later into the main queue.
                // otherwise snapshots will be pure white. Possibly a bug with UIKit
                DispatchQueue.main.async { [weak self] in
                    self?.animate()
                }
            } else {
                animate()
            }
        #endif
    }
    
    /**
     Processes the start transition delegation methods.
     - Parameter fromViewController: An optional UIViewController.
     - Parameter toViewController: An optional UIViewController.
     */
    func processStartTransitionDelegation(fromViewController: UIViewController?, toViewController: UIViewController?) {
        guard let fvc = fromViewController else {
            return
        }
        
        guard let tvc = toViewController else {
            return
        }
        
        processForMotionDelegate(viewController: fvc) { [weak self] in
            guard let s = self else {
                return
            }
            
            $0.motion?(motion: s, willStartTransitionTo: tvc)
            $0.motionWillStartTransition?(motion: s)
        }
        
        processForMotionDelegate(viewController: tvc) { [weak self] in
            guard let s = self else {
                return
            }
            
            $0.motion?(motion: s, willStartTransitionFrom: fvc)
            $0.motionWillStartTransition?(motion: s)
        }
    }
    
    /**
     Processes the end transition delegation methods.
     - Parameter transitionContext: An optional UIViewControllerContextTransitioning.
     - Parameter fromViewController: An optional UIViewController.
     - Parameter toViewController: An optional UIViewController.
     */
    func processEndTransitionDelegation(transitionContext: UIViewControllerContextTransitioning?, fromViewController: UIViewController?, toViewController: UIViewController?) {
        guard let fvc = fromViewController else {
            return
        }
        
        guard let tvc = toViewController else {
            return
        }
        
        processForMotionDelegate(viewController: fvc) { [weak self] in
            guard let s = self else {
                return
            }
            
            $0.motion?(motion: s, didEndTransitionTo: tvc)
            $0.motionDidEndTransition?(motion: s)
        }
        
        processForMotionDelegate(viewController: tvc) { [weak self] in
            guard let s = self else {
                return
            }
            
            $0.motion?(motion: s, didEndTransitionFrom: fvc)
            $0.motionDidEndTransition?(motion: s)
        }
        
        transitionContext?.finishInteractiveTransition()
    }
    
    /**
     Processes the cancel transition delegation methods.
     - Parameter transitionContext: An optional UIViewControllerContextTransitioning.
     - Parameter fromViewController: An optional UIViewController.
     - Parameter toViewController: An optional UIViewController.
     */
    func processCancelTransitionDelegation(transitionContext: UIViewControllerContextTransitioning?, fromViewController: UIViewController?, toViewController: UIViewController?) {
        guard let fvc = fromViewController else {
            return
        }
        
        guard let tvc = toViewController else {
            return
        }
        
        processForMotionDelegate(viewController: fvc) { [weak self] in
            guard let s = self else {
                return
            }
            
            $0.motion?(motion: s, didCancelTransitionTo: tvc)
            $0.motionDidCancelTransition?(motion: s)
        }
        
        processForMotionDelegate(viewController: tvc) { [weak self] in
            guard let s = self else {
                return
            }
            
            $0.motion?(motion: s, didCancelTransitionFrom: fvc)
            $0.motionDidCancelTransition?(motion: s)
        }
        
        transitionContext?.finishInteractiveTransition()
    }
}

fileprivate extension Motion {
    /// Updates the container background color.
    func updateContainerBackgroundColor() {
        if let v = containerBackgroundColor {
            container?.backgroundColor = v
        } else if !toOverFullScreen && !fromOverFullScreen {
            container?.backgroundColor = toView?.backgroundColor
        }
    }
    
    /// Updates the insertToViewFirst boolean for animators.
    func updateInsertOrder() {
        if fromOverFullScreen {
            insertToViewFirst = true
        }
        
        for v in animators {
            (v as? MotionHasInsertOrder)?.insertToViewFirst = insertToViewFirst
        }
    }
}

internal extension Motion {
    /**
     A helper transition function.
     - Parameter from: A UIViewController.
     - Parameter to: A UIViewController.
     - Parameter in view: A UIView.
     - Parameter completion: An optional completion handler.
     */
    func transition(from: UIViewController, to: UIViewController, in view: UIView, completion: ((Bool) -> Void)? = nil) {
        guard !isTransitioning else {
            return
        }
        
        isPresenting = true
        transitionContainer = view
        fromViewController = from
        toViewController = to
        completionCallback = completion
        
        start()
    }
}

internal extension Motion {
    /**
     Helper for processing the MotionViewControllerDelegate.
     - Parameter viewController: A UIViewController of type `T`.
     - Parameter execute: A callback for execution during processing.
     */
    func processForMotionDelegate<T: UIViewController>(viewController: T, execute: (MotionViewControllerDelegate) -> Void) {
        if let delegate = viewController as? MotionViewControllerDelegate {
            execute(delegate)
        }
        
        if let v = viewController as? UINavigationController,
            let delegate = v.topViewController as? MotionViewControllerDelegate {
            execute(delegate)
        }
        
        if let v = viewController as? UITabBarController,
            let delegate = v.viewControllers?[v.selectedIndex] as? MotionViewControllerDelegate {
            execute(delegate)
        }
    }
}

extension Motion: UIViewControllerAnimatedTransitioning {
    /**
     The animation method that is used to coordinate the transition.
     - Parameter using transitionContext: A UIViewControllerContextTransitioning.
     */
    public func animateTransition(using context: UIViewControllerContextTransitioning) {
        guard !isTransitioning else {
            return
        }
        
        transitionContext = context
        fromViewController = fromViewController ?? context.viewController(forKey: .from)
        toViewController = toViewController ?? context.viewController(forKey: .to)
        transitionContainer = context.containerView
        
        start()
    }
    
    /**
     Returns the transition duration time interval.
     - Parameter using transitionContext: An optional UIViewControllerContextTransitioning.
     - Returns: A TimeInterval that is the total animation time including delays.
     */
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0 // Will be updated dynamically.
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        isAnimating = !transitionCompleted
    }
}

extension Motion: UIViewControllerTransitioningDelegate {
    /// A reference to the interactive transitioning instance.
    var interactiveTransitioning: UIViewControllerInteractiveTransitioning? {
        return forceNonInteractive ? nil : self
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        self.fromViewController = fromViewController ?? presenting
        self.toViewController = toViewController ?? presented
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        self.fromViewController = fromViewController ?? dismissed
        return self
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning
    }
}

extension Motion: UIViewControllerInteractiveTransitioning {
    public var wantsInteractiveStart: Bool {
        return true
    }
    public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        animateTransition(using: transitionContext)
    }
}

extension Motion: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = .push == operation
        self.fromViewController = fromViewController ?? fromVC
        self.toViewController = toViewController ?? toVC
        self.isNavigationController = true
        return self
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning
    }
}

extension Motion: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return !isAnimating
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isAnimating = true
        
        let fromVCIndex = tabBarController.childViewControllers.index(of: fromVC)!
        let toVCIndex = tabBarController.childViewControllers.index(of: toVC)!
        
        self.isPresenting = toVCIndex > fromVCIndex
        self.fromViewController = fromViewController ?? fromVC
        self.toViewController = toViewController ?? toVC
        self.isTabBarController = true
        
        return self
    }
}

public typealias MotionDelayCancelBlock = (Bool) -> Void

extension Motion {
    /**
     Executes a block of code after a time delay.
     - Parameter duration: An animation duration time.
     - Parameter animations: An animation block.
     - Parameter execute block: A completion block that is executed once
     the animations have completed.
     */
    @discardableResult
    public class func delay(_ time: TimeInterval, execute: @escaping () -> Void) -> MotionDelayCancelBlock? {
        var cancelable: MotionDelayCancelBlock?
        
        let delayed: MotionDelayCancelBlock = {
            if !$0 {
                DispatchQueue.main.async(execute: execute)
            }
            
            cancelable = nil
        }
        
        cancelable = delayed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            cancelable?(false)
        }
        
        return cancelable
    }
    
    /**
     Cancels the delayed MotionDelayCancelBlock.
     - Parameter delayed completion: An MotionDelayCancelBlock.
     */
    public class func cancel(delayed completion: MotionDelayCancelBlock) {
        completion(true)
    }
    
    /**
     Disables the default animations set on CALayers.
     - Parameter animations: A callback that wraps the animations to disable.
     */
    public class func disable(_ animations: (() -> Void)) {
        animate(duration: 0, animations: animations)
    }
    
    /**
     Runs an animation with a specified duration.
     - Parameter duration: An animation duration time.
     - Parameter animations: An animation block.
     - Parameter timingFunction: A CAMediaTimingFunction.
     - Parameter completion: A completion block that is executed once
     the animations have completed.
     */
    public class func animate(duration: CFTimeInterval, timingFunction: CAMediaTimingFunction = .easeInOut, animations: (() -> Void), completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock(completion)
        CATransaction.setAnimationTimingFunction(timingFunction)
        animations()
        CATransaction.commit()
    }
    
    /**
     Creates a CAAnimationGroup.
     - Parameter animations: An Array of CAAnimation objects.
     - Parameter timingFunction: A CAMediaTimingFunction.
     - Parameter duration: An animation duration time for the group.
     - Returns: A CAAnimationGroup.
     */
    public class func animate(group animations: [CAAnimation], timingFunction: CAMediaTimingFunction = .easeInOut, duration: CFTimeInterval = 0.5) -> CAAnimationGroup {
        let group = CAAnimationGroup()
        group.fillMode = MotionAnimationFillModeToValue(mode: .both)
        group.isRemovedOnCompletion = false
        group.animations = animations
        group.duration = duration
        group.timingFunction = timingFunction
        return group
    }
}
