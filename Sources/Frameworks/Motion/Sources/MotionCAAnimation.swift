/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
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

public enum MotionAnimationKeyPath: String {
    case backgroundColor
    case borderColor
    case borderWidth
    case cornerRadius
    case transform
    case rotate  = "transform.rotation"
    case rotateX = "transform.rotation.x"
    case rotateY = "transform.rotation.y"
    case rotateZ = "transform.rotation.z"
    case scale  = "transform.scale"
    case scaleX = "transform.scale.x"
    case scaleY = "transform.scale.y"
    case scaleZ = "transform.scale.z"
    case translation  = "transform.translation"
    case translationX = "transform.translation.x"
    case translationY = "transform.translation.y"
    case translationZ = "transform.translation.z"
    case position
    case opacity
    case zPosition
    case width = "bounds.size.width"
    case height = "bounds.size.height"
    case size = "bounds.size"
    case shadowPath
    case shadowColor
    case shadowOffset
    case shadowOpacity
    case shadowRadius
}

extension CABasicAnimation {
    /**
     A convenience initializer that takes a given MotionAnimationKeyPath.
     - Parameter keyPath: An MotionAnimationKeyPath.
     */
    public convenience init(keyPath: MotionAnimationKeyPath) {
        self.init(keyPath: keyPath.rawValue)
    }
}

public struct MotionCAAnimation {}

fileprivate extension MotionCAAnimation {
    /**
     Creates a CABasicAnimation.
     - Parameter keyPath: A MotionAnimationKeyPath.
     - Parameter toValue: An Any value that is the end state of the animation.
     */
    static func createAnimation(keyPath: MotionAnimationKeyPath, toValue: Any) -> CABasicAnimation {
        let a = CABasicAnimation(keyPath: keyPath)
        a.toValue = toValue
        return a
    }
}

@available(iOS 9.0, *)
internal extension MotionCAAnimation {
    /**
     Converts a CABasicAnimation to a CASpringAnimation.
     - Parameter animation: A CABasicAnimation.
     - Parameter stiffness: A CGFloat.
     - Parameter damping: A CGFloat.
     */
    static func convert(animation: CABasicAnimation, stiffness: CGFloat, damping: CGFloat) -> CASpringAnimation {
        let a = CASpringAnimation(keyPath: animation.keyPath)
        a.fromValue = animation.fromValue
        a.toValue = animation.toValue
        a.stiffness = stiffness
        a.damping = damping
        return a
    }
}

public extension MotionCAAnimation {
    /**
     Creates a CABasicAnimation for the backgroundColor key path.
     - Parameter color: A UIColor.
     - Returns: A CABasicAnimation.
     */
    static func background(color: UIColor) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .backgroundColor, toValue: color.cgColor)
    }
    
    /**
     Creates a CABasicAnimation for the borderColor key path.
     - Parameter color: A UIColor.
     - Returns: A CABasicAnimation.
     */
    static func border(color: UIColor) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .borderColor, toValue: color.cgColor)
    }
    
    /**
     Creates a CABasicAnimation for the borderWidth key path.
     - Parameter width: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    static func border(width: CGFloat) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .borderWidth, toValue: NSNumber(floatLiteral: Double(width)))
    }
    
    /**
     Creates a CABasicAnimation for the cornerRadius key path.
     - Parameter radius: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    static func corner(radius: CGFloat) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .cornerRadius, toValue: NSNumber(floatLiteral: Double(radius)))
    }
    
    /**
     Creates a CABasicAnimation for the transform key path.
     - Parameter _ t: A CATransform3D object.
     - Returns: A CABasicAnimation.
     */
    static func transform(_ t: CATransform3D) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .transform, toValue: NSValue(caTransform3D: t))
    }
    
    /**
     Creates a CABasicAnimation for the transform.scale key path.
     - Parameter xyz: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scale(_ xyz: CGFloat) -> CABasicAnimation {
        let a = CABasicAnimation(keyPath: .scale)
        a.toValue = NSNumber(value: Double(xyz))
        return a
    }
    
    /**
     Creates a CABasicAnimation for the transform.scale.x key path.
     - Parameter x: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scale(x: CGFloat) -> CABasicAnimation {
        let a = CABasicAnimation(keyPath: .scaleX)
        a.toValue = NSNumber(value: Double(x))
        return a
    }
    
    /**
     Creates a CABasicAnimation for the transform.scale.y key path.
     - Parameter y: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scale(y: CGFloat) -> CABasicAnimation {
        let a = CABasicAnimation(keyPath: .scaleY)
        a.toValue = NSNumber(value: Double(y))
        return a
    }
    
    /**
     Creates a CABasicAnimation for the transform.scale.z key path.
     - Parameter z: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scale(z: CGFloat) -> CABasicAnimation {
        let a = CABasicAnimation(keyPath: .scaleZ)
        a.toValue = NSNumber(value: Double(z))
        return a
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotate.x key path.
     - Parameter x: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    static func spin(x: CGFloat) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .rotateX, toValue: NSNumber(value: Double(CGFloat(Double.pi) * 2 * x)))
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotate.y key path.
     - Parameter y: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    static func spin(y: CGFloat) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .rotateY, toValue: NSNumber(value: Double(CGFloat(Double.pi) * 2 * y)))
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotate.z key path.
     - Parameter z: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    static func spin(z: CGFloat) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .rotateZ, toValue: NSNumber(value: Double(CGFloat(Double.pi) * 2 * z)))
    }
    
    /**
     Creates a CABasicAnimation for the position key path.
     - Parameter _ point: A CGPoint.
     - Returns: A CABasicAnimation.
     */
    static func position(_ point: CGPoint) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .position, toValue: NSValue(cgPoint: point))
    }
    
    /**
     Creates a CABasicAnimation for the opacity key path.
     - Parameter _ opacity: A Double.
     - Returns: A CABasicAnimation.
     */
    static func fade(_ opacity: Double) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .opacity, toValue: NSNumber(floatLiteral: opacity))
    }
    
    /**
     Creates a CABasicaAnimation for the zPosition key path.
     - Parameter _ position: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    static func zPosition(_ position: CGFloat) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .zPosition, toValue: NSNumber(value: Double(position)))
    }
    
    /**
     Creates a CABasicaAnimation for the width key path.
     - Parameter width: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    static func width(_ width: CGFloat) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .width, toValue: NSNumber(floatLiteral: Double(width)))
    }
    
    /**
     Creates a CABasicaAnimation for the height key path.
     - Parameter height: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    static func height(_ height: CGFloat) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .height, toValue: NSNumber(floatLiteral: Double(height)))
    }
    
    /**
     Creates a CABasicaAnimation for the height key path.
     - Parameter size: A CGSize.
     - Returns: A CABasicAnimation.
     */
    static func size(_ size: CGSize) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .size, toValue: NSValue(cgSize: size))
    }
    
    /**
     Creates a CABasicAnimation for the shadowPath key path.
     - Parameter path: A CGPath.
     - Returns: A CABasicAnimation.
     */
    static func shadow(path: CGPath) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .shadowPath, toValue: path)
    }
    
    /**
     Creates a CABasicAnimation for the shadowColor key path.
     - Parameter color: A UIColor.
     - Returns: A CABasicAnimation.
     */
    static func shadow(color: UIColor) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .shadowColor, toValue: color.cgColor)
    }
    
    /**
     Creates a CABasicAnimation for the shadowOffset key path.
     - Parameter offset: A CGSize.
     - Returns: A CABasicAnimation.
     */
    static func shadow(offset: CGSize) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .shadowOffset, toValue: NSValue(cgSize: offset))
    }
    
    /**
     Creates a CABasicAnimation for the shadowOpacity key path.
     - Parameter opacity: A Float.
     - Returns: A CABasicAnimation.
     */
    static func shadow(opacity: Float) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .shadowOpacity, toValue: NSNumber(floatLiteral: Double(opacity)))
    }
    
    /**
     Creates a CABasicAnimation for the shadowRadius key path.
     - Parameter radius: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    static func shadow(radius: CGFloat) -> CABasicAnimation {
        return MotionCAAnimation.createAnimation(keyPath: .shadowRadius, toValue: NSNumber(floatLiteral: Double(radius)))
    }
}
