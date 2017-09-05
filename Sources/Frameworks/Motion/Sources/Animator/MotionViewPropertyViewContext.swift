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

@available(iOS 10, tvOS 10, *)
internal class MotionViewPropertyViewContext: MotionAnimatorViewContext {
    /// A reference to the UIViewPropertyAnimator.
    fileprivate var viewPropertyAnimator: UIViewPropertyAnimator?
    
    override class func canAnimate(view: UIView, state: MotionTransitionState, isAppearing: Bool) -> Bool {
        return view is UIVisualEffectView && nil != state.opacity
    }

    override func resume(at elapsedTime: TimeInterval, isReversed: Bool) {
        viewPropertyAnimator?.finishAnimation(at: isReversed ? .start : .end)
    }

    override func seek(to elapsedTime: TimeInterval) {
        viewPropertyAnimator?.pauseAnimation()
        viewPropertyAnimator?.fractionComplete = CGFloat(elapsedTime / duration)
    }

    override func clean() {
        super.clean()
        viewPropertyAnimator?.stopAnimation(true)
        viewPropertyAnimator = nil
    }

    override func startAnimations(isAppearing: Bool) {
        guard let v = snapshot as? UIVisualEffectView else {
            return
        }
        
        let appearedEffect = v.effect
        let disappearedEffect = 0 == targetState.opacity ? nil : v.effect
        v.effect = isAppearing ? disappearedEffect : appearedEffect

        duration = targetState.duration!
        
        viewPropertyAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            v.effect = isAppearing ? appearedEffect : disappearedEffect
        }
        
        viewPropertyAnimator?.startAnimation()
    }
}
