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

internal class MotionTransitionStateWrapper {
    /// A reference to a MotionTransitionState.
    internal var state: MotionTransitionState
    
    /**
     An initializer that accepts a given MotionTransitionState.
     - Parameter state: A MotionTransitionState.
     */
    internal init(state: MotionTransitionState) {
        self.state = state
    }
}

public struct MotionTransitionState {
    /// The initial state that the transition will start at.
    internal var beginState: MotionTransitionStateWrapper?
    
    /// The start state if there is a match in the desition view controller.
    public var beginStateIfMatched: [MotionTransition]?

    /// A reference to the position.
    public var position: CGPoint?
    
    /// A reference to the size.
    public var size: CGSize?
    
    /// A reference to the transform.
    public var transform: CATransform3D?
    
    /// A reference to the opacity.
    public var opacity: Double?
    
    /// A reference to the cornerRadius.
    public var cornerRadius: CGFloat?
    
    /// A reference to the backgroundColor.
    public var backgroundColor: CGColor?
    
    /// A reference to the zPosition.
    public var zPosition: CGFloat?

    /// A reference to the contentsRect.
    public var contentsRect: CGRect?
    
    /// A reference to the contentsScale.
    public var contentsScale: CGFloat?

    /// A reference to the borderWidth.
    public var borderWidth: CGFloat?
    
    /// A reference to the borderColor.
    public var borderColor: CGColor?

    /// A reference to the shadowColor.
    public var shadowColor: CGColor?
    
    /// A reference to the shadowOpacity.
    public var shadowOpacity: Float?
    
    /// A reference to the shadowOffset.
    public var shadowOffset: CGSize?
    
    /// A reference to the shadowRadius.
    public var shadowRadius: CGFloat?
    
    /// A reference to the shadowPath.
    public var shadowPath: CGPath?
    
    /// A boolean for the masksToBounds state.
    public var masksToBounds: Bool?
    
    /// A boolean indicating whether to display a shadow or not.
    public var displayShadow = true

    /// A reference to the overlay settings.
    public var overlay: (color: CGColor, opacity: CGFloat)?

    /// A reference to the spring animation settings.
    public var spring: (CGFloat, CGFloat)?
    
    /// A time delay on starting the animation.
    public var delay: TimeInterval = 0
    
    /// The duration of the animation.
    public var duration: TimeInterval?
    
    /// The timing function value of the animation.
    public var timingFunction: CAMediaTimingFunction?

    /// The arc curve value.
    public var arc: CGFloat?
    
    /// The identifier value to match source and destination views.
    public var motionIdentifier: String?
    
    /// The cascading animation settings.
    public var cascade: (TimeInterval, CascadeDirection, Bool)?

    /** 
     A boolean indicating whether to ignore the subview transition
     animations or not.
     */
    public var ignoreSubviewTransitions: Bool?
    
    /// The coordinate space to transition views within.
    public var coordinateSpace: MotionCoordinateSpace?
    
    /// Change the size of a view based on a scale factor.
    public var useScaleBasedSizeChange: Bool?
    
    /// The type of snapshot to use.
    public var snapshotType: MotionSnapshotType?

    /// Do not fade the view when transitioning.
    public var nonFade = false
    
    /// Force an animation.
    public var forceAnimate = false
    
    /// Custom target states.
    public var custom: [String: Any]?

    /**
     An initializer that accepts an Array of MotionTransitions.
     - Parameter transitions: An Array of MotionTransitions.
     */
    init(transitions: [MotionTransition]) {
        append(contentsOf: transitions)
    }
}

extension MotionTransitionState {
    /**
     Adds a MotionTransition to the current state.
     - Parameter _ element: A MotionTransition.
     */
    public mutating func append(_ element: MotionTransition) {
        element.apply(&self)
    }
    
    /**
     Adds an Array of MotionTransitions to the current state.
     - Parameter contentsOf elements: An Array of MotionTransitions.
     */
    public mutating func append(contentsOf elements: [MotionTransition]) {
        for v in elements {
            v.apply(&self)
        }
    }
    
    /**
     A subscript that returns a custom value for a specified key.
     - Parameter key: A String.
     - Returns: An optional Any value.
     */
    public subscript(key: String) -> Any? {
        get {
            return custom?[key]
        }
        set(value) {
            if nil == custom {
                custom = [:]
            }
            
            custom![key] = value
        }
    }
}

extension MotionTransitionState: ExpressibleByArrayLiteral {
    /**
     An initializer implementing the ExpressibleByArrayLiteral protocol.
     - Parameter arrayLiteral elements: A list of MotionTransitions.
     */
    public init(arrayLiteral elements: MotionTransition...) {
        append(contentsOf: elements)
    }
}
