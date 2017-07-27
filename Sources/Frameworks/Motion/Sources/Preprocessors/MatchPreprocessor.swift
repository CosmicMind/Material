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

class MatchPreprocessor: MotionPreprocessor {
    /// A reference to a MotionContext.
    weak var context: MotionContext!
    
    /**
     Processes the transitionary views.
     - Parameter fromViews: An Array of UIViews.
     - Parameter toViews: An Array of UIViews.
     */
    func process(fromViews: [UIView], toViews: [UIView]) {
        for tv in toViews {
            guard let i = tv.motionIdentifier, let fv = context.sourceView(for: i) else { continue }
            
            var tvState = context[tv] ?? MotionTransitionState()
            var fvState = context[fv] ?? MotionTransitionState()
            
            if let v = tvState.beginStateIfMatched {
                tvState.append(.beginWith(transitions: v))
            }
            
            if let v = fvState.beginStateIfMatched {
                fvState.append(.beginWith(transitions: v))
            }
            
            tvState.motionIdentifier = i
            tvState.opacity = 0
            
            fvState.motionIdentifier = i
            fvState.arc = tvState.arc
            fvState.duration = tvState.duration
            fvState.timingFunction = tvState.timingFunction
            fvState.delay = tvState.delay
            fvState.spring = tvState.spring
            
            let forceNonFade = tvState.nonFade || fvState.nonFade
            let isNonOpaque = !fv.isOpaque || fv.alpha < 1 || !tv.isOpaque || tv.alpha < 1
            
            if !forceNonFade && isNonOpaque {
                // Cross fade if from/toViews are not opaque.
                fvState.opacity = 0
                
            } else {
                // No cross fade in this case, fromView is always displayed during the transition.
                fvState.opacity = nil
                
                /**
                 We dont want two shadows showing up. Therefore we disable toView's
                 shadow when fromView is able to display its shadow.
                 */
                if !fv.layer.masksToBounds && fvState.displayShadow {
                    tvState.displayShadow = false
                }
            }
            
            context[tv] = tvState
            context[fv] = fvState
        }
    }
}
