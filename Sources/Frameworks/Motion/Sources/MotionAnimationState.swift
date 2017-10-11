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

public struct MotionAnimationState {
    /// A reference to the position.
    public var position: CGPoint?
    
    /// A reference to the size.
    public var size: CGSize?
    
    /// A reference to the transform.
    public var transform: CATransform3D?
    
    /// A reference to the spin tuple.
    public var spin: (x: CGFloat, y: CGFloat, z: CGFloat)?
    
    /// A reference to the opacity.
    public var opacity: Double?
    
    /// A reference to the cornerRadius.
    public var cornerRadius: CGFloat?
    
    /// A reference to the backgroundColor.
    public var backgroundColor: CGColor?
    
    /// A reference to the zPosition.
    public var zPosition: CGFloat?
    
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
    
    /// A reference to the spring animation settings.
    public var spring: (CGFloat, CGFloat)?
    
    /// A time delay on starting the animation.
    public var delay: TimeInterval = 0
    
    /// The duration of the animation.
    public var duration: TimeInterval = 0.35
    
    /// The timing function value of the animation.
    public var timingFunction = CAMediaTimingFunction.easeInOut
    
    /// Custom target states.
    public var custom: [String: Any]?
    
    /// Completion block.
    public var completion: (() -> Void)?
    
    /**
     An initializer that accepts an Array of MotionAnimations.
     - Parameter animations: An Array of MotionAnimations.
     */
    init(animations: [MotionAnimation]) {
        append(contentsOf: animations)
    }
}

extension MotionAnimationState {
    /**
     Adds a MotionAnimation to the current state.
     - Parameter _ element: A MotionAnimation.
     */
    public mutating func append(_ element: MotionAnimation) {
        element.apply(&self)
    }
    
    /**
     Adds an Array of MotionAnimations to the current state.
     - Parameter contentsOf elements: An Array of MotionAnimations.
     */
    public mutating func append(contentsOf elements: [MotionAnimation]) {
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

extension MotionAnimationState: ExpressibleByArrayLiteral {
    /**
     An initializer implementing the ExpressibleByArrayLiteral protocol.
     - Parameter arrayLiteral elements: A list of MotionAnimations.
     */
    public init(arrayLiteral elements: MotionAnimation...) {
        append(contentsOf: elements)
    }
}
