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
    case shadowPath
    case opacity
    case zPosition
    case width = "bounds.size.width"
    case height = "bounds.size.height"
}

public enum MotionAnimation {
    case delay(TimeInterval)
    case timingFunction(MotionAnimationTimingFunction)
    case duration(TimeInterval)
    case custom(CABasicAnimation)
    case backgroundColor(UIColor)
    case corners(CGFloat)
    case transform(CATransform3D)
    case rotate(CGFloat)
    case rotateX(CGFloat)
    case rotateY(CGFloat)
    case rotateZ(CGFloat)
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
    case position(x: CGFloat, y: CGFloat)
    case shadow(path: CGPath)
    case fade(CGFloat)
    case zPosition(Int)
    case width(CGFloat)
    case height(CGFloat)
}

extension CALayer {

    /**
     A method that accepts CAAnimation objects and executes them on the
     view's backing layer.
     - Parameter animation: A CAAnimation instance.
     */
    open func animate(_ animations: CAAnimation...) {
        animate(animations)
    }
    
    /**
     A method that accepts CAAnimation objects and executes them on the
     view's backing layer.
     - Parameter animation: A CAAnimation instance.
     */
    open func animate(_ animations: [CAAnimation]) {
        for animation in animations {
            animation.delegate = self
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

    /**
     A delegation method that is executed when the backing layer stops
     running an animation.
     - Parameter animation: The CAAnimation instance that stopped running.
     - Parameter flag: A boolean that indicates if the animation stopped
     because it was completed or interrupted. True if completed, false
     if interrupted.
     */
    open func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        guard let a = animation as? CAPropertyAnimation else {
            if let a = (animation as? CAAnimationGroup)?.animations {
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
    
    open func motion(_ animations: MotionAnimation...) {
        motion(animations)
    }
    
    open func motion(_ animations: [MotionAnimation]) {
        motion(delay: 0, duration: 0.25, timingFunction: .easeInEaseOut, animations: animations)
    }
    
    fileprivate func motion(delay: TimeInterval, duration: TimeInterval, timingFunction: MotionAnimationTimingFunction, animations: [MotionAnimation]) {
        var t = delay
        var w: CGFloat = 0
        var h: CGFloat = 0
        
        for v in animations {
            switch v {
            case let .delay(time):
                t = time
            case let .width(width):
                w = width
            case let .height(height):
                h = height
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
                case let .corners(radius):
                    a.append(Motion.corner(radius: radius))
                case let .transform(transform):
                    a.append(Motion.transform(transform: transform))
                case let .rotate(angle):
                    let rotate = Motion.rotate(angle: angle)
                    let radians = CGFloat(atan2f(Float(s.affineTransform().b), Float(s.affineTransform().a)))
                    rotate.fromValue = radians * 180 / CGFloat(M_PI)
                    a.append(rotate)
                case let .rotateX(angle):
                    a.append(Motion.rotateX(angle: angle))
                case let .rotateY(angle):
                    a.append(Motion.rotateY(angle: angle))
                case let .rotateZ(angle):
                    a.append(Motion.rotateZ(angle: angle))
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
                case let .x(x):
                    a.append(Motion.position(to: CGPoint(x: x + w / 2, y: s.position.y)))
                case let .y(y):
                    a.append(Motion.position(to: CGPoint(x: s.position.x, y: y + h / 2)))
                case let .position(x, y):
                    a.append(Motion.position(to: CGPoint(x: x, y: y)))
                case let .shadow(path):
                    a.append(Motion.shadow(path: path))
                case let .fade(opacity):
                    let fade = Motion.fade(opacity: opacity)
                    fade.fromValue = s.value(forKey: MotionAnimationKeyPath.opacity.rawValue) ?? NSNumber(floatLiteral: 1)
                    a.append(fade)
                case let .zPosition(index):
                    let zPosition = Motion.zPosition(index: index)
                    zPosition.fromValue = s.value(forKey: MotionAnimationKeyPath.zPosition.rawValue) ?? NSNumber(integerLiteral: 0)
                    a.append(zPosition)
                case let .width(w):
                    a.append(Motion.width(w))
                case let .height(h):
                    a.append(Motion.height(h))
                default:break
                }
            }
        
            let g = Motion.animate(group: a, duration: d)
            g.fillMode = MotionAnimationFillModeToValue(mode: .forwards)
            g.isRemovedOnCompletion = false
            g.timingFunction = MotionAnimationTimingFunctionToValue(timingFunction: tf)
            
            s.animate(g)
        }
    }
}

@available(iOS 10, *)
extension CALayer: CAAnimationDelegate {}

extension UIView {
    /**
     A method that accepts CAAnimation objects and executes them on the
     view's backing layer.
     - Parameter animation: A CAAnimation instance.
     */
    open func animate(_ animations: CAAnimation...) {
        layer.animate(animations)
    }
    
    open func animate(_ animations: [CAAnimation]) {
        layer.animate(animations)
    }
    
    open func motion(_ animations: MotionAnimation...) {
        layer.motion(animations)
    }
    
    open func motion(_ animations: [MotionAnimation]) {
        layer.motion(animations)
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
    public static func rotate(angle: CGFloat) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .rotation)
        animation.toValue = (CGFloat(M_PI) * angle / 180) as NSNumber
		return animation
	}
    
    /**
     Creates a CABasicAnimation for the transform.rotation.x key path.
     - Parameter angle: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func rotateX(angle: CGFloat) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .rotationX)
		animation.toValue = (CGFloat(M_PI) * angle / 180) as NSNumber
		return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.rotation.y key path.
     - Parameter angle: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func rotateY(angle: CGFloat) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .rotationY)
        animation.toValue = (CGFloat(M_PI) * angle / 180) as NSNumber
		return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.rotation.z key path.
     - Parameter angle: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func rotateZ(angle: CGFloat) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .rotationZ)
        animation.toValue = (CGFloat(M_PI) * angle / 180) as NSNumber
		return animation
	}
    
    /**
     Creates a CABasicAnimation for the transform.rotation key path.
     - Parameter rotations: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func spin(rotations: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotation)
        animation.toValue = (CGFloat(M_PI * 2) * rotations) as NSNumber
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotation.x key path.
     - Parameter rotations: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func spinX(rotations: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotationX)
        animation.toValue = (CGFloat(M_PI * 2) * rotations) as NSNumber
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotation.y key path.
     - Parameter rotations: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func spinY(rotations: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotationY)
        animation.toValue = (CGFloat(M_PI * 2) * rotations) as NSNumber
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotation.z key path.
     - Parameter rotations: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func spinZ(rotations: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotationZ)
        animation.toValue = (CGFloat(M_PI * 2) * rotations) as NSNumber
        return animation
    }

    /**
     Creates a CABasicAnimation for the transform.scale key path.
     - Parameter to scale: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scale(to scale: CGFloat) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .scale)
		animation.toValue = scale as NSNumber
		return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.scale.x key path.
     - Parameter to scale: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scaleX(to scale: CGFloat) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .scaleX)
		animation.toValue = scale as NSNumber
		return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.scale.y key path.
     - Parameter to scale: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scaleY(to scale: CGFloat) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .scaleY)
		animation.toValue = scale as NSNumber
		return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.scale.z key path.
     - Parameter to scale: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scaleZ(to scale: CGFloat) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .scaleZ)
		animation.toValue = scale as NSNumber
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
		animation.toValue = translation as NSNumber
	    return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.translation.y key path.
     - Parameter to translation: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func translateY(to translation: CGFloat) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .translationY)
		animation.toValue = translation as NSNumber
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.translation.z key path.
     - Parameter to translation: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func translateZ(to translation: CGFloat) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .translationZ)
		animation.toValue = translation as NSNumber
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
     Creates a CABasicAnimation for the opacity key path.
     - Parameter opacity: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func fade(opacity: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .opacity)
        animation.toValue = NSNumber(floatLiteral: Double(opacity))
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
}
