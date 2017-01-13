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

@objc(MotionTransition)
public enum MotionTransition: Int {
    case none
    case fade
}

open class MotionTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
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
        
        
        if operation == .push {
            transitionContext.containerView.addSubview(fromView)
            
            for v in fromView.subviews {
                if 0 < v.motionIdentifier.utf16.count {
                    v.motion(duration: 0.35, animations: v.motionAnimations)
                }
            }
            
            Motion.delay(time: transitionDuration(using: nil)) {
                transitionContext.containerView.addSubview(toView)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        
        if operation == .pop {
            transitionContext.containerView.addSubview(toView)
            
            for v in toView.subviews {
                if 0 < v.motionIdentifier.utf16.count {
                    v.motion(duration: 0.35, animations: [.scale(1), .backgroundColor(.white)])
                }
            }
            
            Motion.delay(time: transitionDuration(using: nil)) {
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
