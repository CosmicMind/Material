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

fileprivate var MotionTransitionItemKey: UInt8 = 0
fileprivate var MotionTransitionItemControllerKey: UInt8 = 0

fileprivate struct MotionTransitionItem {
    fileprivate var identifier: String
    fileprivate var animations: [MotionAnimation]
}

fileprivate struct MotionTransitionItemController {
    fileprivate var delegate: MotionTransitionDelegate
}

extension UIViewController {
//    override func transition(from fromViewController: UIViewController, to toViewController: UIViewController, duration: TimeInterval, options: UIViewAnimationOptions = [], animations: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
//        
//    }
    
    /// MaterialLayer Reference.
    fileprivate var motionTransition: MotionTransitionItemController {
        get {
            return AssociatedObject(base: self, key: &MotionTransitionItemControllerKey) {
                return MotionTransitionItemController(delegate: MotionTransitionDelegate())
            }
        }
        set(value) {
            AssociateObject(base: self, key: &MotionTransitionItemControllerKey, value: value)
        }
    }
    
    open var transitionDelegate: MotionTransitionDelegate {
        return motionTransition.delegate
    }
}

extension UIView {
    /// MaterialLayer Reference.
    fileprivate var motionTransition: MotionTransitionItem {
        get {
            return AssociatedObject(base: self, key: &MotionTransitionItemKey) {
                return MotionTransitionItem(identifier: "", animations: [])
            }
        }
        set(value) {
            AssociateObject(base: self, key: &MotionTransitionItemKey, value: value)
        }
    }
    
    open var transitionIdentifier: String {
        get {
            return motionTransition.identifier
        }
        set(value) {
            motionTransition.identifier = value
        }
    }
    
    open var transitionAnimations: [MotionAnimation] {
        get {
            return motionTransition.animations
        }
        set(value) {
            motionTransition.animations = value
        }
    }
}

open class MotionTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
}
open class MotionTransitionInteractiveAnimator: NSObject, UIViewControllerInteractiveTransitioning {
    public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
    }
}

open class MotionTransitionDelegate: NSObject {
    open var isPresenting = false
    
    open var containerView: UIView!
    
    open var toView: UIView!
    open var toViewController: UIViewController!
    open var toViewStartFrame: CGRect!
    open var toViewFinalFrame: CGRect!
    
    open var fromView: UIView!
    open var fromViewController: UIViewController!
    open var fromViewFinalFrame: CGRect!
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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
        
        let containerView = transitionContext.containerView
        
        toView = tView
        toViewController = tVC
        
        fromView = fView
        fromViewController = fVC
        
        toViewStartFrame = transitionContext.initialFrame(for: toViewController)
        toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        fromViewFinalFrame = transitionContext.finalFrame(for: fromViewController)
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
}

extension MotionTransitionDelegate: UIViewControllerTransitioningDelegate {
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MotionTransitionAnimator()
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MotionTransitionAnimator()
    }
    
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return MotionTransitionInteractiveAnimator()
    }
    
    open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return MotionTransitionInteractiveAnimator()
    }
}

extension MotionTransitionDelegate: UINavigationControllerDelegate {
    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = operation == .push
        return MotionTransitionAnimator()
    }
    
        open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
            return MotionTransitionInteractiveAnimator()
        }
}

extension MotionTransitionDelegate: UITabBarControllerDelegate {
    //    open func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    //        return MotionTransitionAnimator()
    //    }
    
    open func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        self.fromViewController = fromViewController ?? fromVC
        self.toViewController = toViewController ?? toVC
        //        self.inContainerController = true
        return MotionTransitionAnimator()
    }
}

open class FadeMotionTransition: NSObject, UIViewControllerAnimatedTransitioning {
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        
        toView.alpha = 0
        
        transitionContext.containerView.addSubview(fromView)
        transitionContext.containerView.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: { _ in
                        toView.alpha = 1
                        fromView.alpha = 0
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    open func animationEnded(_ transitionCompleted: Bool) {
        print("FadeMotionTransition ANIMATION ENDED")
    }
}

open class SlideMotionTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var operation: UINavigationControllerOperation
    
    init(operation: UINavigationControllerOperation) {
        self.operation = operation
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        
        var duration = transitionDuration(using: nil)
        
        if operation == .push {
            transitionContext.containerView.addSubview(toView)
            
            for v in toView.subviews {
                if 0 < v.transitionIdentifier.utf16.count {
                    for a in v.transitionAnimations {
                        switch a {
                        case let .duration(dur):
                            if dur > duration {
                                duration = dur
                            }
                        default:break
                        }
                    }
                    v.motion(v.transitionAnimations)
                }
            }
            
            Motion.delay(duration) {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        
        if operation == .pop {
            transitionContext.containerView.addSubview(fromView)
            
            for v in fromView.subviews {
                if 0 < v.transitionIdentifier.utf16.count {
                    for a in v.transitionAnimations {
                        switch a {
                        case let .duration(dur):
                            if dur > duration {
                                duration = dur
                            }
                        default:break
                        }
                    }
                    v.motion(v.transitionAnimations)
                }
            }
            
            Motion.delay(duration) {
                transitionContext.containerView.addSubview(toView)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    open func animationEnded(_ transitionCompleted: Bool) {
        print("SlideMotionTransition ANIMATION ENDED")
    }
}

//open class MotionTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
//    var presenting = false
//    
//    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView
//        
//        guard let fromVC = transitionContext.viewController(forKey: .from) else {
//            return
//        }
//        
//        guard let toVC = transitionContext.viewController(forKey: .to) else {
//            return
//        }
//        
//        guard let fromView = transitionContext.view(forKey: .from) else {
//            return
//        }
//        
//        guard let toView = transitionContext.view(forKey: .to) else {
//            return
//        }
//        
//        let containerFrame = containerView.frame
//        var toViewStartFrame = transitionContext.initialFrame(for: toVC)
//        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)
//        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC)
//        
//        // Set up the animation parameters.
//        if (presenting) {
//            // Modify the frame of the presented view so that it starts
//            // offscreen at the lower-right corner of the container.
//            toViewStartFrame.origin.x = containerFrame.size.width;
//            toViewStartFrame.origin.y = containerFrame.size.height;
//        }
//        else {
//            // Modify the frame of the dismissed view so it ends in
//            // the lower-right corner of the container view.
//            fromViewFinalFrame = CGRect(x: containerFrame.size.width,
//                                        y: containerFrame.size.height,
//                                        width: toView.frame.size.width,
//                                        height: toView.frame.size.height);
//        }
//        
//        // Always add the "to" view to the container.
//        // And it doesn't hurt to set its start frame.
//        containerView.addSubview(toView)
//        toView.frame = toViewStartFrame;
//        
//        UIView.animate(withDuration: transitionDuration(using: nil), animations: { [weak self] in
//            guard let s = self else {
//                return
//            }
//            
//            if s.presenting {
//                toView.frame = toViewFinalFrame
//            } else {
//                fromView.frame = fromViewFinalFrame
//            }
//            
//        }, completion: { [weak self] _ in
//            guard let s = self else {
//                return
//            }
//            
//            let success = !transitionContext.transitionWasCancelled
//            if (s.presenting && !success) || (!s.presenting && success) {
//                toView.removeFromSuperview()
//            }
//            
//            transitionContext.completeTransition(success)
//        })
//    }
//
//    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 0.25
//    }
//}


//@objc(TransitionMotion)
//public enum TransitionMotion: Int {
//	case fade
//	case moveIn
//	case push
//	case reveal
//}
//
//@objc(TransitionMotionDirection)
//public enum TransitionMotionDirection: Int {
//	case `default`
//    case right
//	case left
//	case top
//	case bottom
//}
//
///**
// Converts an TransitionMotion to a corresponding CATransition key.
// - Parameter transition: An TransitionMotion.
// - Returns: A CATransition key String.
// */
//public func TransitionMotionToValue(transition type: TransitionMotion) -> String {
//	switch type {
//	case .fade:
//		return kCATransitionFade
//	case .moveIn:
//		return kCATransitionMoveIn
//	case .push:
//		return kCATransitionPush
//	case .reveal:
//		return kCATransitionReveal
//	}
//}
//
///**
// Converts an TransitionMotionDirection to a corresponding CATransition direction key.
// - Parameter direction: An TransitionMotionDirection.
// - Returns: An optional CATransition direction key String.
// */
//public func TransitionMotionDirectionToValue(direction: TransitionMotionDirection) -> String? {
//	switch direction {
//    case .default:
//        return nil
//    case .right:
//		return kCATransitionFromRight
//	case .left:
//		return kCATransitionFromLeft
//	case .top:
//		return kCATransitionFromBottom
//	case .bottom:
//		return kCATransitionFromTop
//	}
//}
//
//extension Motion {
//	/**
//     Creates a CATransition animation.
//     - Parameter type: An TransitionMotion.
//     - Parameter direction: An optional TransitionMotionDirection.
//     - Parameter duration: An optional duration time.
//     - Returns: A CATransition.
//     */
//	public static func transition(type: TransitionMotion, direction: TransitionMotionDirection = .default, duration: CFTimeInterval? = nil) -> CATransition {
//		let animation = CATransition()
//		animation.type = TransitionMotionToValue(transition: type)
//        animation.subtype = TransitionMotionDirectionToValue(direction: direction)
//		
//        if let v = duration {
//			animation.duration = v
//		}
//		
//        return animation
//	}
//}
