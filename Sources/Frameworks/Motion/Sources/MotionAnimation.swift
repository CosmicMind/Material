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

public class MotionAnimation {
    /// A reference to the callback that applies the MotionAnimationState.
    internal let apply: (inout MotionAnimationState) -> Void
    
    /**
     An initializer that accepts a given callback.
     - Parameter applyFunction: A given callback.
     */
    init(applyFunction: @escaping (inout MotionAnimationState) -> Void) {
        apply = applyFunction
    }
}

public extension MotionAnimation {
    /**
     Animates a view's current background color to the
     given color.
     - Parameter color: A UIColor.
     - Returns: A MotionAnimation.
     */
    static func background(color: UIColor) -> MotionAnimation {
        return MotionAnimation {
            $0.backgroundColor = color.cgColor
        }
    }
    
    /**
     Animates a view's current border color to the
     given color.
     - Parameter color: A UIColor.
     - Returns: A MotionAnimation.
     */
    static func border(color: UIColor) -> MotionAnimation {
        return MotionAnimation {
            $0.borderColor = color.cgColor
        }
    }
    
    /**
     Animates a view's current border width to the
     given width.
     - Parameter width: A CGFloat.
     - Returns: A MotionAnimation.
     */
    static func border(width: CGFloat) -> MotionAnimation {
        return MotionAnimation {
            $0.borderWidth = width
        }
    }
    
    /**
     Animates a view's current corner radius to the
     given radius.
     - Parameter radius: A CGFloat.
     - Returns: A MotionAnimation.
     */
    static func corner(radius: CGFloat) -> MotionAnimation {
        return MotionAnimation {
            $0.cornerRadius = radius
        }
    }
    
    /**
     Animates a view's current transform (perspective, scale, rotate)
     to the given one.
     - Parameter _ transform: A CATransform3D.
     - Returns: A MotionAnimation.
     */
    static func transform(_ transform: CATransform3D) -> MotionAnimation {
        return MotionAnimation {
            $0.transform = transform
        }
    }
    
    /**
     Animates a view's current rotation to the given x, y,
     and z values.
     - Parameter x: A CGFloat.
     - Parameter y: A CGFloat.
     - Parameter z: A CGFloat.
     - Returns: A MotionAnimation.
     */
    static func rotate(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) -> MotionAnimation {
        return MotionAnimation {
            var t = $0.transform ?? CATransform3DIdentity
            t = CATransform3DRotate(t, CGFloat(Double.pi) * x / 180, 1, 0, 0)
            t = CATransform3DRotate(t, CGFloat(Double.pi) * y / 180, 0, 1, 0)
            $0.transform = CATransform3DRotate(t, CGFloat(Double.pi) * z / 180, 0, 0, 1)
        }
    }
    
    /**
     Animates a view's current rotation to the given point.
     - Parameter _ point: A CGPoint.
     - Parameter z: A CGFloat.
     - Returns: A MotionAnimation.
     */
    static func rotate(_ point: CGPoint, z: CGFloat = 0) -> MotionAnimation {
        return .rotate(x: point.x, y: point.y, z: z)
    }
    
    /**
     Rotate 2d.
     - Parameter _ z: A CGFloat.
     - Returns: A MotionAnimation.
     */
    static func rotate(_ z: CGFloat) -> MotionAnimation {
        return .rotate(z: z)
    }
    
    /**
     Animates a view's current spin to the given x, y,
     and z values.
     - Parameter x: A CGFloat.
     - Parameter y: A CGFloat.
     - Parameter z: A CGFloat.
     - Returns: A MotionAnimation.
     */
    static func spin(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) -> MotionAnimation {
        return MotionAnimation {
            $0.spin = (x, y, z)
        }
    }
    
    /**
     Animates a view's current spin to the given point.
     - Parameter _ point: A CGPoint.
     - Parameter z: A CGFloat.
     - Returns: A MotionAnimation.
     */
    static func spin(_ point: CGPoint, z: CGFloat = 0) -> MotionAnimation {
        return .spin(x: point.x, y: point.y, z: z)
    }
    
    /**
     Spin 2d.
     - Parameter _ z: A CGFloat.
     - Returns: A MotionAnimation.
     */
    static func spin(_ z: CGFloat) -> MotionAnimation {
        return .spin(z: z)
    }
    
    /**
     Animates the view's current scale to the given x, y, and z scale values.
     - Parameter x: A CGFloat.
     - Parameter y: A CGFloat.
     - Parameter z: A CGFloat.
     - Returns: A MotionAnimation.
     */
    static func scale(x: CGFloat = 1, y: CGFloat = 1, z: CGFloat = 1) -> MotionAnimation {
        return MotionAnimation {
            $0.transform = CATransform3DScale($0.transform ?? CATransform3DIdentity, x, y, z)
        }
    }
    
    /**
     Animates the view's current x & y scale to the given scale value.
     - Parameter _ xy: A CGFloat.
     - Returns: A MotionAnimation.
     */
    static func scale(_ xy: CGFloat) -> MotionAnimation {
        return .scale(x: xy, y: xy)
    }
    
    /**
     Animates a view equal to the distance given by the x, y, and z values.
     - Parameter x: A CGFloat.
     - Parameter y: A CGFloat.
     - Parameter z: A CGFloat.
     - Returns: A MotionAnimation.
     */
    static func translate(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) -> MotionAnimation {
        return MotionAnimation {
            $0.transform = CATransform3DTranslate($0.transform ?? CATransform3DIdentity, x, y, z)
        }
    }
    
    /**
     Animates a view equal to the distance given by a point and z value.
     - Parameter _ point: A CGPoint.
     - Parameter z: A CGFloat.
     - Returns: A MotionAnimation.
     */
    static func translate(_ point: CGPoint, z: CGFloat = 0) -> MotionAnimation {
        return .translate(x: point.x, y: point.y, z: z)
    }
    
    /**
     Animates a view's current position to the given point.
     - Parameter _ point: A CGPoint.
     - Returns: A MotionAnimation.
     */
    static func position(_ point: CGPoint) -> MotionAnimation {
        return MotionAnimation {
            $0.position = point
        }
    }
    
    /// Fades the view in during an animation.
    static var fadeIn = MotionAnimation.fade(1)
    
    /// Fades the view out during an animation.
    static var fadeOut = MotionAnimation.fade(0)
    
    /**
     Animates a view's current opacity to the given one.
     - Parameter _ opacity: A Double.
     - Returns: A MotionAnimation.
     */
    static func fade(_ opacity: Double) -> MotionAnimation {
        return MotionAnimation {
            $0.opacity = opacity
        }
    }
    
    /**
     Animates a view's current zPosition to the given position.
     - Parameter _ position: An Int.
     - Returns: A MotionAnimation.
     */
    static func zPosition(_ position: CGFloat) -> MotionAnimation {
        return MotionAnimation {
            $0.zPosition = position
        }
    }
    
    /**
     Animates a view's current size to the given one.
     - Parameter _ size: A CGSize.
     - Returns: A MotionAnimation.
     */
    static func size(_ size: CGSize) -> MotionAnimation {
        return MotionAnimation {
            $0.size = size
        }
    }
    
    /**
     Animates a view's current shadow path to the given one.
     - Parameter path: A CGPath.
     - Returns: A MotionAnimation.
     */
    static func shadow(path: CGPath) -> MotionAnimation {
        return MotionAnimation {
            $0.shadowPath = path
        }
    }
    
    /**
     Animates a view's current shadow color to the given one.
     - Parameter color: A UIColor.
     - Returns: A MotionAnimation.
     */
    static func shadow(color: UIColor) -> MotionAnimation {
        return MotionAnimation {
            $0.shadowColor = color.cgColor
        }
    }
    
    /**
     Animates a view's current shadow offset to the given one.
     - Parameter offset: A CGSize.
     - Returns: A MotionAnimation.
     */
    static func shadow(offset: CGSize) -> MotionAnimation {
        return MotionAnimation {
            $0.shadowOffset = offset
        }
    }
    
    /**
     Animates a view's current shadow opacity to the given one.
     - Parameter opacity: A Float.
     - Returns: A MotionAnimation.
     */
    static func shadow(opacity: Float) -> MotionAnimation {
        return MotionAnimation {
            $0.shadowOpacity = opacity
        }
    }
    
    /**
     Animates a view's current shadow radius to the given one.
     - Parameter radius: A CGFloat.
     - Returns: A MotionAnimation.
     */
    static func shadow(radius: CGFloat) -> MotionAnimation {
        return MotionAnimation {
            $0.shadowRadius = radius
        }
    }
    
    /**
     Animates the views shadow offset, opacity, and radius. 
     - Parameter offset: A CGSize. 
     - Parameter opacity: A Float.
     - Parameter radius: A CGFloat.
     */
    static func depth(offset: CGSize, opacity: Float, radius: CGFloat) -> MotionAnimation {
        return MotionAnimation {
            $0.shadowOffset = offset
            $0.shadowOpacity = opacity
            $0.shadowRadius = radius
        }
    }
    
    /**
     Animates the views shadow offset, opacity, and radius.
     - Parameter _ depth: A tuple (CGSize, FLoat, CGFloat).
     */
    static func depth(_ depth: (CGSize, Float, CGFloat)) -> MotionAnimation {
        return .depth(offset: depth.0, opacity: depth.1, radius: depth.2)
    }
    
    /**
     Available in iOS 9+, animates a view using the spring API,
     given a stiffness and damping.
     - Parameter stiffness: A CGFlloat.
     - Parameter damping: A CGFloat.
     - Returns: A MotionAnimation.
     */
    @available(iOS 9, *)
    static func spring(stiffness: CGFloat, damping: CGFloat) -> MotionAnimation {
        return MotionAnimation {
            $0.spring = (stiffness, damping)
        }
    }
    
    /**
     The duration of the view's animation. If a duration of 0 is used,
     the value will be converted to 0.01, to give a close to zero value.
     - Parameter _ duration: A TimeInterval.
     - Returns: A MotionAnimation.
     */
    static func duration(_ duration: TimeInterval) -> MotionAnimation {
        return MotionAnimation {
            $0.duration = duration
        }
    }
    
    /**
     Delays the animation of a given view.
     - Parameter _ time: TimeInterval.
     - Returns: A MotionAnimation.
     */
    static func delay(_ time: TimeInterval) -> MotionAnimation {
        return MotionAnimation {
            $0.delay = time
        }
    }
    
    /**
     Sets the view's timing function for the animation.
     - Parameter _ timingFunction: A CAMediaTimingFunction.
     - Returns: A MotionAnimation.
     */
    static func timingFunction(_ timingFunction: CAMediaTimingFunction) -> MotionAnimation {
        return MotionAnimation {
            $0.timingFunction = timingFunction
        }
    }
    
    /**
     Creates a completion block handler that is executed once the animation
     is done.
     - Parameter _ execute: A callback to execute once completed.
     */
    static func completion(_ execute: @escaping () -> Void) -> MotionAnimation {
        return MotionAnimation {
            $0.completion = execute
        }
    }
}
