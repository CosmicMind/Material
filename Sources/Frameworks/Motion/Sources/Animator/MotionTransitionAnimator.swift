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

internal class MotionTransitionAnimator<T: MotionAnimatorViewContext>: MotionAnimator, MotionHasInsertOrder {
    /// A reference to a MotionContext.
    weak public var context: MotionContext!
  
    /// An index of views to their corresponding animator context.
    var viewToContexts = [UIView: T]()

    var insertToViewFirst = false
}

extension MotionTransitionAnimator {
    /**
     Animates a given view.
     - Parameter view: A UIView.
     - Parameter isAppearing: A boolean that determines whether the
     view is appearing.
     */
    fileprivate func animate(view: UIView, isAppearing: Bool) {
        let s = context.snapshotView(for: view)
        let v = T(animator: self, snapshot: s, targetState: context[view]!)
        
        viewToContexts[view] = v
        
        v.startAnimations(isAppearing: isAppearing)
    }
}

extension MotionTransitionAnimator {
    /// Cleans the contexts.
    func clean() {
        for v in viewToContexts.values {
            v.clean()
        }
        
        viewToContexts.removeAll()
        insertToViewFirst = false
    }
    
    /**
     A function that determines if a view can be animated.
     - Parameter view: A UIView.
     - Parameter isAppearing: A boolean that determines whether the
     view is appearing.
     */
    func canAnimate(view: UIView, isAppearing: Bool) -> Bool {
        guard let state = context[view] else {
            return false
        }
        
        return T.canAnimate(view: view, state: state, isAppearing: isAppearing)
    }
    
    /**
     Animates the fromViews to the toViews.
     - Parameter fromViews: An Array of UIViews.
     - Parameter toViews: An Array of UIViews.
     - Returns: A TimeInterval.
     */
    func animate(fromViews: [UIView], toViews: [UIView]) -> TimeInterval {
        var duration: TimeInterval = 0
        
        if insertToViewFirst {
            for v in toViews {
                animate(view: v, isAppearing: true)
            }
            
            for v in fromViews {
                animate(view: v, isAppearing: false)
            }
            
        } else {
            for v in fromViews {
                animate(view: v, isAppearing: false)
            }
            
            for v in toViews {
                animate(view: v, isAppearing: true)
            }
        }
        
        for v in viewToContexts.values {
            duration = max(duration, v.duration)
        }
        
        return duration
    }
    
    /**
     Moves the view's animation to the given elapsed time.
     - Parameter to elapsedTime: A TimeInterval.
     */
    func seek(to elapsedTime: TimeInterval) {
        for v in viewToContexts.values {
            v.seek(to: elapsedTime)
        }
    }
    
    /**
     Resumes the animation with a given elapsed time and
     optional reversed boolean.
     - Parameter at elapsedTime: A TimeInterval.
     - Parameter isReversed: A boolean to reverse the animation
     or not.
     */
    func resume(at elapsedTime: TimeInterval, isReversed: Bool) -> TimeInterval {
        var duration: TimeInterval = 0
        
        for (_, v) in viewToContexts {
            v.resume(at: elapsedTime, isReversed: isReversed)
            duration = max(duration, v.duration)
        }
        
        return duration
    }
    
    /**
     Applies the given state to the given view.
     - Parameter state: A MotionTransitionState.
     - Parameter to view: A UIView.
     */
    func apply(state: MotionTransitionState, to view: UIView) {
        guard let v = viewToContexts[view] else {
            return
        }
        
        v.apply(state: state)
    }
}
