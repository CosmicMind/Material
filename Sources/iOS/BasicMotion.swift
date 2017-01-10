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
}

public enum MotionAnimation {
    case background(color: UIColor)
    case corner(radius: CGFloat)
    case transform(transform: CATransform3D)
    case rotate(angle: CGFloat)
    case rotateX(angle: CGFloat)
    case rotateY(angle: CGFloat)
    case rotateZ(angle: CGFloat)
    case spin(rotations: CGFloat)
    case spinX(rotations: CGFloat)
    case spinY(rotations: CGFloat)
    case spinZ(rotations: CGFloat)
    case scale(by: CGFloat)
    case scaleX(by: CGFloat)
    case scaleY(by: CGFloat)
    case scaleZ(by: CGFloat)
    case move(by: CGPoint)
    case moveX(by: CGFloat)
    case moveY(by: CGFloat)
    case moveZ(by: CGFloat)
    case position(to: CGPoint)
    case shadow(path: CGPath)
    case fade(opacity: CGFloat)
}

extension CALayer {

    /**
     A method that accepts CAAnimation objects and executes them on the
     view's backing layer.
     - Parameter animation: A CAAnimation instance.
     */
    open func animate(animation: CAAnimation) {
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
    
    open func motion(animations: MotionAnimation...) {
        motion(animations: animations)
    }
    
    open func motion(animations: [MotionAnimation]) {
        motion(duration: 0.15, animations: animations)
    }
    
    open func motion(duration: TimeInterval, animations: MotionAnimation...) {
        motion(duration: duration, animations: animations)
    }
    
    open func motion(duration: TimeInterval, animations: [MotionAnimation]) {
        var a = [CABasicAnimation]()
        
        for v in animations {
            
            switch v {
            case let .background(color):
                a.append(Motion.background(color: color))
            case let .corner(radius):
                a.append(Motion.corner(radius: radius))
            case let .transform(transform):
                a.append(Motion.transform(transform: transform))
            case let .rotate(angle):
                a.append(Motion.rotate(angle: angle))
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
            case let .scale(by):
                a.append(Motion.scale(by: by))
            case let .scaleX(by):
                a.append(Motion.scaleX(by: by))
            case let .scaleY(by):
                a.append(Motion.scaleY(by: by))
            case let .scaleZ(by):
                a.append(Motion.scaleZ(by: by))
            case let .move(by):
                a.append(Motion.move(by: by))
            case let .moveX(by):
                a.append(Motion.moveX(by: by))
            case let .moveY(by):
                a.append(Motion.moveY(by: by))
            case let .moveZ(by):
                a.append(Motion.moveZ(by: by))
            case let .position(to):
                a.append(Motion.position(to: to))
            case let .shadow(path):
                a.append(Motion.shadow(path: path))
            case let .fade(opacity):
                let fade = Motion.fade(opacity: opacity)
                fade.fromValue = value(forKey: MotionAnimationKeyPath.opacity.rawValue) ?? NSNumber(floatLiteral: 1)
                a.append(fade)
            }
        }
        
        let g = Motion.animate(group: a, duration: duration)
        g.fillMode = AnimationFillModeToValue(mode: .forwards)
        g.isRemovedOnCompletion = false
        g.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
        
        animate(animation: g)
    }
    
    open func motion(delay: TimeInterval, animations: MotionAnimation...) {
        motion(delay: delay, animations: animations)
    }
    
    open func motion(delay: TimeInterval, animations: [MotionAnimation]) {
        Motion.delay(time: delay) { [weak self] in
            guard let s = self else {
                return
            }
            
            s.motion(animations: animations)
        }
    }
    
    open func motion(delay: TimeInterval, duration: TimeInterval, animations: MotionAnimation...) {
        motion(delay: delay, duration: duration, animations: animations)
    }
    
    open func motion(delay: TimeInterval, duration: TimeInterval, animations: [MotionAnimation]) {
        Motion.delay(time: delay) { [weak self] in
            guard let s = self else {
                return
            }
            
            s.motion(duration: duration, animations: animations)
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
    open func animate(animation: CAAnimation) {
        layer.animate(animation: animation)
    }
    
    open func motion(animations: MotionAnimation...) {
        layer.motion(animations: animations)
    }
    
    open func motion(animations: [MotionAnimation]) {
        layer.motion(animations: animations)
    }
    
    open func motion(duration: TimeInterval, animations: MotionAnimation...) {
        layer.motion(duration: duration, animations: animations)
    }
    
    open func motion(duration: TimeInterval, animations: [MotionAnimation]) {
        layer.motion(duration: duration, animations: animations)
    }
    
    open func motion(delay: TimeInterval, animations: MotionAnimation...) {
        layer.motion(delay: delay, animations: animations)
    }
    
    open func motion(delay: TimeInterval, animations: [MotionAnimation]) {
        layer.motion(delay: delay, animations: animations)
    }
    
    open func motion(delay: TimeInterval, duration: TimeInterval, animations: MotionAnimation...) {
        layer.motion(delay: delay, duration: duration, animations: animations)
    }
    
    open func motion(delay: TimeInterval, duration: TimeInterval, animations: [MotionAnimation]) {
        layer.motion(delay: delay, duration: duration, animations: animations)
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
    public static func spin(rotations: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotation)
        animation.toValue = (CGFloat(M_PI * 2) * rotations) as NSNumber
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotation.x key path.
     - Parameter rotations: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func spinX(rotations: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotationX)
        animation.toValue = (CGFloat(M_PI * 2) * rotations) as NSNumber
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotation.y key path.
     - Parameter rotations: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func spinY(rotations: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotationY)
        animation.toValue = (CGFloat(M_PI * 2) * rotations) as NSNumber
        return animation
    }
    
    /**
     Creates a CABasicAnimation for the transform.rotation.z key path.
     - Parameter rotations: An optional CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func spinZ(rotations: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: .rotationZ)
        animation.toValue = (CGFloat(M_PI * 2) * rotations) as NSNumber
        return animation
    }

    /**
     Creates a CABasicAnimation for the transform.scale key path.
     - Parameter by scale: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scale(by scale: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .scale)
		animation.toValue = scale as NSNumber
		return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.scale.x key path.
     - Parameter by scale: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scaleX(by scale: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .scaleX)
		animation.toValue = scale as NSNumber
		return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.scale.y key path.
     - Parameter by scale: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scaleY(by scale: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .scaleY)
		animation.toValue = scale as NSNumber
		return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.scale.z key path.
     - Parameter by scale: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func scaleZ(by scale: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .scaleZ)
		animation.toValue = scale as NSNumber
		return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.translation key path.
     - Parameter point: A CGPoint.
     - Returns: A CABasicAnimation.
     */
    public static func move(by point: CGPoint, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .translation)
		animation.toValue = NSValue(cgPoint: point)
	    return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.translation.x key path.
     - Parameter by translation: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func moveX(by translation: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .translationX)
		animation.toValue = translation as NSNumber
	    return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.translation.y key path.
     - Parameter by translation: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func moveY(by translation: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .translationY)
		animation.toValue = translation as NSNumber
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.translation.z key path.
     - Parameter by translation: A CGFloat.
     - Returns: A CABasicAnimation.
     */
    public static func moveZ(by translation: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .translationZ)
		animation.toValue = translation as NSNumber
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the position key path.
     - Parameter to point: A CGPoint.
     - Returns: A CABasicAnimation.
     */
    public static func position(to point: CGPoint, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .position)
		animation.toValue = NSValue(cgPoint: point)
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the shadowPath key path.
     - Parameter to path: A CGPath.
     - Returns: A CABasicAnimation.
     */
    public static func shadow(path: CGPath, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .shadowPath)
		animation.toValue = path
        return animation
	}
}
