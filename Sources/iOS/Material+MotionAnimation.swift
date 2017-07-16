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

public enum MotionAnimationKeyPath: String {
    case backgroundColor
    case barTintColor
    case cornerRadius
    case transform
    case rotation  = "transform.rotation"
    case rotationX = "transform.rotation.x"
    case rotationY = "transform.rotation.y"
    case rotationZ = "transform.rotation.z"
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
    case shadowOffset
    case shadowOpacity
    case shadowRadius
}

public enum MotionAnimation {
    case delay(TimeInterval)
    case timingFunction(MotionAnimationTimingFunction)
    case duration(TimeInterval)
    case custom(CABasicAnimation)
    case backgroundColor(UIColor)
    case barTintColor(UIColor)
    case cornerRadius(CGFloat)
    case transform(CATransform3D)
    case rotationAngle(CGFloat)
    case rotationAngleX(CGFloat)
    case rotationAngleY(CGFloat)
    case rotationAngleZ(CGFloat)
    case spin(CGFloat)
    case spinX(CGFloat)
    case spinY(CGFloat)
    case spinZ(CGFloat)
    case scale(CGFloat)
    case scaleX(CGFloat)
    case scaleY(CGFloat)
    case scaleZ(CGFloat)
    case translate(x: CGFloat, y: CGFloat)
    case translateX(CGFloat)
    case translateY(CGFloat)
    case translateZ(CGFloat)
    case x(CGFloat)
    case y(CGFloat)
    case point(x: CGFloat, y: CGFloat)
    case position(x: CGFloat, y: CGFloat)
    case fade(Double)
    case zPosition(Int)
    case width(CGFloat)
    case height(CGFloat)
    case size(width: CGFloat, height: CGFloat)
    case shadowPath(CGPath)
    case shadowOffset(CGSize)
    case shadowOpacity(Float)
    case shadowRadius(CGFloat)
    case depth(shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat)
}

@available(iOS 10, *)
extension CALayer: CAAnimationDelegate {}

extension CALayer {
    
    /**
     A function that accepts CAAnimation objects and executes them on the
     view's backing layer.
     - Parameter animation: A CAAnimation instance.
     */
    open func animate(_ animations: CAAnimation...) {
        animate(animations)
    }
    
    /**
     A function that accepts CAAnimation objects and executes them on the
     view's backing layer.
     - Parameter animation: A CAAnimation instance.
     */
    open func animate(_ animations: [CAAnimation]) {
        for animation in animations {
            if nil == animation.delegate {
                animation.delegate = self
            }
            
            if let a = animation as? CABasicAnimation {
                a.fromValue = (presentation() ?? self).value(forKeyPath: a.keyPath!)
            }
            
            if let a = animation as? CAPropertyAnimation {
                add(a, forKey: a.keyPath!)
            } else if let a = animation as? CAAnimationGroup {
                add(a, forKey: nil)
            } else if let a = animation as? CATransition {
                add(a, forKey: kCATransition)
            }
        }
    }
    
    open func animationDidStart(_ anim: CAAnimation) {}
    
    /**
     A delegation function that is executed when the backing layer stops
     running an animation.
     - Parameter animation: The CAAnimation instance that stopped running.
     - Parameter flag: A boolean that indicates if the animation stopped
     because it was completed or interrupted. True if completed, false
     if interrupted.
     */
    open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let a = anim as? CAPropertyAnimation else {
            if let a = (anim as? CAAnimationGroup)?.animations {
                for x in a {
                    animationDidStop(x, finished: true)
                }
            }
            return
        }
        
        guard let b = a as? CABasicAnimation else {
            return
        }
        
        guard let v = b.toValue else {
            return
        }
        
        guard let k = b.keyPath else {
            return
        }
        
        setValue(v, forKeyPath: k)
        removeAnimation(forKey: k)
    }
    
    /**
     A function that accepts a list of MotionAnimation values and executes them.
     - Parameter animations: A list of MotionAnimation values.
     */
    open func motion(_ animations: MotionAnimation...) {
        motion(animations)
    }
    
    /**
     A function that accepts an Array of MotionAnimation values and executes them.
     - Parameter animations: An Array of MotionAnimation values.
     - Parameter completion: An optional completion block.
     */
    open func motion(_ animations: [MotionAnimation], completion: (() -> Void)? = nil) {
        motion(delay: 0, duration: 0.35, timingFunction: .easeInEaseOut, animations: animations, completion: completion)
    }
    
    /**
     A function that executes an Array of MotionAnimation values.
     - Parameter delay: The animation delay TimeInterval.
     - Parameter duration: The animation duration TimeInterval.
     - Parameter timingFunction: The animation MotionAnimationTimingFunction.
     - Parameter animations: An Array of MotionAnimations.
     - Parameter completion: An optional completion block.
     */
    fileprivate func motion(delay: TimeInterval, duration: TimeInterval, timingFunction: MotionAnimationTimingFunction, animations: [MotionAnimation], completion: (() -> Void)? = nil) {
        var t = delay
        
        for v in animations {
            switch v {
            case let .delay(time):
                t = time
            default:break
            }
        }
        
        Motion.delay(t) { [weak self] in
            guard let s = self else {
                return
            }
            
            var a = [CABasicAnimation]()
            var tf = timingFunction
            var d = duration
            
            var w: CGFloat = s.bounds.width
            var h: CGFloat = s.bounds.height
            
            for v in animations {
                switch v {
                case let .width(width):
                    w = width
                case let .height(height):
                    h = height
                case let .size(width, height):
                    w = width
                    h = height
                default:break
                }
            }
            
            var px: CGFloat = s.position.x
            var py: CGFloat = s.position.y
            
            for v in animations {
                switch v {
                case let .x(x):
                    px = x + w / 2
                case let .y(y):
                    py = y + h / 2
                case let .point(x, y):
                    px = x + w / 2
                    py = y + h / 2
                default:break
                }
            }
            
            for v in animations {
                switch v {
                case let .timingFunction(timingFunction):
                    tf = timingFunction
                case let .duration(duration):
                    d = duration
                case let .custom(animation):
                    a.append(animation)
                case let .backgroundColor(color):
                    a.append(Motion.background(color: color))
                case let .barTintColor(color):
                    a.append(Motion.barTint(color: color))
                case let .cornerRadius(radius):
                    a.append(Motion.corner(radius: radius))
                case let .transform(transform):
                    a.append(Motion.transform(transform: transform))
                case let .rotationAngle(angle):
                    let rotate = Motion.rotation(angle: angle)
                    a.append(rotate)
                case let .rotationAngleX(angle):
                    a.append(Motion.rotationX(angle: angle))
                case let .rotationAngleY(angle):
                    a.append(Motion.rotationY(angle: angle))
                case let .rotationAngleZ(angle):
                    a.append(Motion.rotationZ(angle: angle))
                case let .spin(rotations):
                    a.append(Motion.spin(rotations: rotations))
                case let .spinX(rotations):
                    a.append(Motion.spinX(rotations: rotations))
                case let .spinY(rotations):
                    a.append(Motion.spinY(rotations: rotations))
                case let .spinZ(rotations):
                    a.append(Motion.spinZ(rotations: rotations))
                case let .scale(to):
                    a.append(Motion.scale(to: to))
                case let .scaleX(to):
                    a.append(Motion.scaleX(to: to))
                case let .scaleY(to):
                    a.append(Motion.scaleY(to: to))
                case let .scaleZ(to):
                    a.append(Motion.scaleZ(to: to))
                case let .translate(x, y):
                    a.append(Motion.translate(to: CGPoint(x: x, y: y)))
                case let .translateX(to):
                    a.append(Motion.translateX(to: to))
                case let .translateY(to):
                    a.append(Motion.translateY(to: to))
                case let .translateZ(to):
                    a.append(Motion.translateZ(to: to))
                case .x(_), .y(_), .point(_, _):
                    let position = Motion.position(to: CGPoint(x: px, y: py))
                    a.append(position)
                case let .position(x, y):
                    a.append(Motion.position(to: CGPoint(x: x, y: y)))
                case let .fade(opacity):
                    let fade = Motion.fade(opacity: opacity)
                    fade.fromValue = s.value(forKey: MotionAnimationKeyPath.opacity.rawValue) ?? NSNumber(floatLiteral: 1)
                    a.append(fade)
                case let .zPosition(index):
                    let zPosition = Motion.zPosition(index: index)
                    zPosition.fromValue = s.value(forKey: MotionAnimationKeyPath.zPosition.rawValue) ?? NSNumber(integerLiteral: 0)
                    a.append(zPosition)
                case .width(_), .height(_), .size(_, _):
                    a.append(Motion.size(CGSize(width: w, height: h)))
                case let .shadowPath(path):
                    let shadowPath = Motion.shadow(path: path)
                    shadowPath.fromValue = s.shadowPath
                    a.append(shadowPath)
                case let .shadowOffset(offset):
                    let shadowOffset = Motion.shadow(offset: offset)
                    shadowOffset.fromValue = s.shadowOffset
                    a.append(shadowOffset)
                case let .shadowOpacity(opacity):
                    let shadowOpacity = Motion.shadow(opacity: opacity)
                    shadowOpacity.fromValue = s.shadowOpacity
                    a.append(shadowOpacity)
                case let .shadowRadius(radius):
                    let shadowRadius = Motion.shadow(radius: radius)
                    shadowRadius.fromValue = s.shadowRadius
                    a.append(shadowRadius)
                case let .depth(offset, opacity, radius):
                    if let path = s.shadowPath {
                        let shadowPath = Motion.shadow(path: path)
                        shadowPath.fromValue = s.shadowPath
                        a.append(shadowPath)
                    }
                    
                    let shadowOffset = Motion.shadow(offset: offset)
                    shadowOffset.fromValue = s.shadowOffset
                    a.append(shadowOffset)
                    
                    let shadowOpacity = Motion.shadow(opacity: opacity)
                    shadowOpacity.fromValue = s.shadowOpacity
                    a.append(shadowOpacity)
                    
                    let shadowRadius = Motion.shadow(radius: radius)
                    shadowRadius.fromValue = s.shadowRadius
                    a.append(shadowRadius)
                default:break
                }
            }
            
            let g = Motion.animate(group: a, duration: d)
            g.fillMode = MotionAnimationFillModeToValue(mode: .forwards)
            g.isRemovedOnCompletion = false
            g.timingFunction = MotionAnimationTimingFunctionToValue(timingFunction: tf)
            
            s.animate(g)
            
            guard let execute = completion else {
                return
            }
            
            Motion.delay(d, execute: execute)
        }
    }
}

extension UIView {
    /// Computes the rotation of the view.
    open var motionRotationAngle: CGFloat {
        get {
            return CGFloat(atan2f(Float(transform.b), Float(transform.a))) * 180 / CGFloat(Double.pi)
        }
        set(value) {
            transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * value / 180)
        }
    }
    
    /// The global position of a view.
    open var motionPosition: CGPoint {
        return superview?.convert(layer.position, to: nil) ?? layer.position
    }
    
    /// The layer.transform of a view.
    open var motionTransform: CATransform3D {
        get {
            return layer.transform
        }
        set(value) {
            layer.transform = value
        }
    }
    
    /// Computes the scale X axis value of the view.
    open var motionScaleX: CGFloat {
        return transform.a
    }
    
    /// Computes the scale Y axis value of the view.
    open var motionScaleY: CGFloat {
        return transform.b
    }
    
    /**
     A function that accepts CAAnimation objects and executes them on the
     view's backing layer.
     - Parameter animations: A list of CAAnimations.
     */
    open func animate(_ animations: CAAnimation...) {
        layer.animate(animations)
    }
    
    /**
     A function that accepts an Array of CAAnimation objects and executes
     them on the view's backing layer.
     - Parameter animations: An Array of CAAnimations.
     */
    open func animate(_ animations: [CAAnimation]) {
        layer.animate(animations)
    }
    
    /**
     A function that accepts a list of MotionAnimation values and executes
     them on the view's backing layer.
     - Parameter animations: A list of MotionAnimation values.
     */
    open func motion(_ animations: MotionAnimation...) {
        layer.motion(animations)
    }
    
    /**
     A function that accepts an Array of MotionAnimation values and executes
     them on the view's backing layer.
     - Parameter animations: An Array of MotionAnimation values.
     - Parameter completion: An optional completion block.
     */
    open func motion(_ animations: [MotionAnimation], completion: (() -> Void)? = nil) {
        layer.motion(animations, completion: completion)
    }
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

extension Motion {
    /**
     Creates a CABasicAnimation for the backgroundColor key path.
     - Parameter color: A UIColor.
     - Returns: A CABasicAnimation.
     */
    public static func background(color: UIColor) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .backgroundColor)
        animation.toValue = color.cgColor
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the barTintColor key path.
     - Parameter color: A UIColor.
     - Returns: A CABasicAnimation.
     */
    public static func barTint(color: UIColor) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .barTintColor)
        animation.toValue = color.cgColor
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the cornerRadius key path.
     - Parameter radius: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func corner(radius: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .cornerRadius)
        animation.toValue = radius
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform key path.
     - Parameter transform: A CATransform3D object.
     - Returns: A CABasicAnimation.
     */
    public static func transform(transform: CATransform3D) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .transform)
        animation.toValue = NSValue(caTransform3D: transform)
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotation key path.
     - Parameter angle: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func rotation(angle: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotation)
        animation.toValue = NSNumber(value: Double(CGFloat(Double.pi) * angle / 180))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotation.x key path.
     - Parameter angle: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func rotationX(angle: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotationX)
        animation.toValue = NSNumber(value: Double(CGFloat(Double.pi) * angle / 180))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotation.y key path.
     - Parameter angle: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func rotationY(angle: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotationY)
        animation.toValue = NSNumber(value: Double(CGFloat(Double.pi) * angle / 180))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotation.z key path.
     - Parameter angle: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func rotationZ(angle: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotationZ)
        animation.toValue = NSNumber(value: Double(CGFloat(Double.pi) * angle / 180))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotation key path.
     - Parameter rotations: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func spin(rotations: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotation)
        animation.toValue = NSNumber(value: Double(CGFloat(Double.pi) * 2 * rotations))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotation.x key path.
     - Parameter rotations: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func spinX(rotations: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotationX)
        animation.toValue = NSNumber(value: Double(CGFloat(Double.pi) * 2 * rotations))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotation.y key path.
     - Parameter rotations: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func spinY(rotations: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotationY)
        animation.toValue = NSNumber(value: Double(CGFloat(Double.pi) * 2 * rotations))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotation.z key path.
     - Parameter rotations: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func spinZ(rotations: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotationZ)
        animation.toValue = NSNumber(value: Double(CGFloat(Double.pi) * 2 * rotations))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.scale key path.
     - Parameter to scale: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scale(to scale: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .scale)
        animation.toValue = NSNumber(value: Double(scale))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.scale.x key path.
     - Parameter to scale: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scaleX(to scale: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .scaleX)
        animation.toValue = NSNumber(value: Double(scale))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.scale.y key path.
     - Parameter to scale: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scaleY(to scale: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .scaleY)
        animation.toValue = NSNumber(value: Double(scale))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.scale.z key path.
     - Parameter to scale: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scaleZ(to scale: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .scaleZ)
        animation.toValue = NSNumber(value: Double(scale))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.translation key path.
     - Parameter point: A CGPoint.
     - Returns: A CABasicAnimation.
     */
    public static func translate(to point: CGPoint) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .translation)
        animation.toValue = NSValue(cgPoint: point)
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.translation.x key path.
     - Parameter to translation: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func translateX(to translation: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .translationX)
        animation.toValue = NSNumber(value: Double(translation))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.translation.y key path.
     - Parameter to translation: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func translateY(to translation: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .translationY)
        animation.toValue = NSNumber(value: Double(translation))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.translation.z key path.
     - Parameter to translation: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func translateZ(to translation: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .translationZ)
        animation.toValue = NSNumber(value: Double(translation))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the position key path.
     - Parameter x: A CGFloat.
     - Parameter y: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func position(x: CGFloat, y: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .position)
        animation.toValue = NSValue(cgPoint: CGPoint(x: x, y: y))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the position key path.
     - Parameter to point: A CGPoint.
     - Returns: A CABasicAnimation.
     */
    public static func position(to point: CGPoint) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .position)
        animation.toValue = NSValue(cgPoint: point)
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the opacity key path.
     - Parameter opacity: A Double.
     - Returns: A CABasicAnimation.
     */
    public static func fade(opacity: Double) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .opacity)
        animation.toValue = NSNumber(floatLiteral: opacity)
        return animation
    }
    
    /**
     Creates a CABasicaAnimation for the zPosition key path.
     - Parameter index: An Int.
     - Returns: A CABasicAnimation.
     */
    public static func zPosition(index: Int) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .zPosition)
        animation.toValue = NSNumber(integerLiteral: index)
        return animation
    }
    
    /**
     Creates a CABasicaAnimation for the width key path.
     - Parameter width: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func width(_ width: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .width)
        animation.toValue = NSNumber(floatLiteral: Double(width))
        return animation
    }
    
    /**
     Creates a CABasicaAnimation for the height key path.
     - Parameter height: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func height(_ height: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .height)
        animation.toValue = NSNumber(floatLiteral: Double(height))
        return animation
    }
    
    /**
     Creates a CABasicaAnimation for the height key path.
     - Parameter size: A CGSize.
     - Returns: A CABasicAnimation.
     */
    public static func size(_ size: CGSize) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .size)
        animation.toValue = NSValue(cgSize: size)
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the shadowPath key path.
     - Parameter path: A CGPath.
     - Returns: A CABasicAnimation.
     */
    public static func shadow(path: CGPath) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .shadowPath)
        animation.toValue = path
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the shadowOffset key path.
     - Parameter offset: CGSize.
     - Returns: A CABasicAnimation.
     */
    public static func shadow(offset: CGSize) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .shadowOffset)
        animation.toValue = NSValue(cgSize: offset)
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the shadowOpacity key path.
     - Parameter opacity: Float.
     - Returns: A CABasicAnimation.
     */
    public static func shadow(opacity: Float) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .shadowOpacity)
        animation.toValue = NSNumber(floatLiteral: Double(opacity))
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the shadowRadius key path.
     - Parameter radius: CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func shadow(radius: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .shadowRadius)
        animation.toValue = NSNumber(floatLiteral: Double(radius))
        return animation
    }
}
