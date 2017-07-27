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

class IgnoreSubviewTransitionsPreprocessor: MotionPreprocessor {
    /// A reference to a MotionContext.
    weak var context: MotionContext!
    
    /**
     Processes the transitionary views.
     - Parameter fromViews: An Array of UIViews.
     - Parameter toViews: An Array of UIViews.
     */
    func process(fromViews: [UIView], toViews: [UIView]) {
        process(views:fromViews)
        process(views:toViews)
    }

    /**
     Process an Array of views for the cascade animation.
     - Parameter views: An Array of UIViews.
     */
    func process(views: [UIView]) {
        for v in views {
            guard let recursive = context[v]?.ignoreSubviewTransitions else {
                continue
            }
            
            let parentView = v is UITableView ? v.subviews.get(0) ?? v : v

            guard recursive else {
                for subview in parentView.subviews {
                    context[subview] = nil
                }
                
                continue
            }
            
            cleanSubviewTransitions(for: parentView)
        }
    }
}

extension IgnoreSubviewTransitionsPreprocessor {
    /**
     Clears the transition for a given view's subviews.
     - Parameter for view: A UIView.
     */
    fileprivate func cleanSubviewTransitions(for view: UIView) {
        for v in view.subviews {
            context[v] = nil
            cleanSubviewTransitions(for: v)
        }
    }
}
