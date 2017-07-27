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

class DurationPreprocessor: MotionPreprocessor {
    /// A reference to a MotionContext.
    weak var context: MotionContext!
    
    /**
     Processes the transitionary views.
     - Parameter fromViews: An Array of UIViews.
     - Parameter toViews: An Array of UIViews.
     */
    func process(fromViews: [UIView], toViews: [UIView]) {
        var maxDuration: TimeInterval = 0
        maxDuration = applyOptimizedDurationIfNoDuration(views:fromViews)
        maxDuration = max(maxDuration, applyOptimizedDurationIfNoDuration(views:toViews))
        setDurationForInfiniteDuration(views: fromViews, duration: maxDuration)
        setDurationForInfiniteDuration(views: toViews, duration: maxDuration)
    }

    /**
     Retrieves the optimized duration for a given UIView.
     - Parameter for view: A UIView.
     - Returns: A TimeInterval.
     */
    func optimizedDuration(for view: UIView) -> TimeInterval {
        let v = context[view]!
        
        return view.optimizedDuration(fromPosition: context.container.convert(view.layer.position, from: view.superview),
                                        toPosition: v.position,
                                              size: v.size,
                                         transform: v.transform)
    }

    /**
     Applies the optimized duration for an Array of UIViews.
     - Parameter views: An Array of UIViews.
     - Returns: A TimeInterval.
    */
    func applyOptimizedDurationIfNoDuration(views: [UIView]) -> TimeInterval {
        var d: TimeInterval = 0
        
        for v in views where nil != context[v] {
            if nil == context[v]?.duration {
                context[v]!.duration = optimizedDuration(for: v)
            }
            
            d = .infinity == context[v]!.duration! ?
                    max(d, optimizedDuration(for: v)) :
                    max(d, context[v]!.duration!)
        }
        
        return d
    }

    /**
     Sets the duration if the duration of a transition is set to `.infinity`.
     - Parameter views: An Array of UIViews.
     - Parameter duration: A TimeInterval.
     */
    func setDurationForInfiniteDuration(views: [UIView], duration: TimeInterval) {
        for v in views where .infinity == context[v]?.duration {
            context[v]!.duration = duration
        }
    }
}
