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

@available(iOS 10, *)
extension CALayer: CAAnimationDelegate {}

internal extension CALayer {
    /// Retrieves all currently running animations for the layer.
    var animations: [(String, CAAnimation)] {
        guard let keys = animationKeys() else {
            return []
        }
        
        return keys.map {
            return ($0, self.animation(forKey: $0)!.copy() as! CAAnimation)
        }
    }
    
    /**
     Concats transforms and returns the result.
     - Parameters layer: A CALayer.
     - Returns: A CATransform3D.
     */
    func flatTransformTo(layer: CALayer) -> CATransform3D {
        var l = layer
        var t = l.transform
        
        while let sl = l.superlayer, self != sl {
            t = CATransform3DConcat(sl.transform, t)
            l = sl
        }
        
        return t
    }
}

public extension CALayer {
    /**
     A function that accepts CAAnimation objects and executes them on the
     view's backing layer.
     - Parameter animation: A CAAnimation instance.
     */
    func animate(_ animations: CAAnimation...) {
        animate(animations)
    }
    
    /**
     A function that accepts CAAnimation objects and executes them on the
     view's backing layer.
     - Parameter animation: A CAAnimation instance.
     */
    func animate(_ animations: [CAAnimation]) {
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
    
    /**
     Executed when an animation has started. 
     - Parameter _ anim: A CAAnimation.
     */
    func animationDidStart(_ anim: CAAnimation) {}
    
    /**
     A delegation function that is executed when the backing layer stops
     running an animation.
     - Parameter animation: The CAAnimation instance that stopped running.
     - Parameter flag: A boolean that indicates if the animation stopped
     because it was completed or interrupted. True if completed, false
     if interrupted.
     */
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
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
    func animate(_ animations: MotionAnimation...) {
        animate(animations)
    }
    
    /**
     A function that accepts an Array of MotionAnimation values and executes them.
     - Parameter animations: An Array of MotionAnimation values.
     - Parameter completion: An optional completion block.
     */
    func animate(_ animations: [MotionAnimation], completion: (() -> Void)? = nil) {
        startAnimations(animations, completion: completion)
    }
}

fileprivate extension CALayer {
    /**
     A function that executes an Array of MotionAnimation values.
     - Parameter _ animations: An Array of MotionAnimations.
     - Parameter completion: An optional completion block.
     */
    func startAnimations(_ animations: [MotionAnimation], completion: (() -> Void)? = nil) {
        let ts = MotionAnimationState(animations: animations)
        
        Motion.delay(ts.delay) { [weak self,
            ts = ts,
            completion = completion] in
            
            guard let s = self else {
                return
            }

            var anims = [CABasicAnimation]()
            var duration = 0 == ts.duration ? 0.01 : ts.duration
            
            if let v = ts.backgroundColor {
                let a = MotionCAAnimation.background(color: UIColor(cgColor: v))
                a.fromValue = s.backgroundColor
                anims.append(a)
            }
            
            if let v = ts.borderColor {
                let a = MotionCAAnimation.border(color: UIColor(cgColor: v))
                a.fromValue = s.borderColor
                anims.append(a)
            }
            
            if let v = ts.borderWidth {
                let a = MotionCAAnimation.border(width: v)
                a.fromValue = NSNumber(floatLiteral: Double(s.borderWidth))
                anims.append(a)
            }
            
            if let v = ts.cornerRadius {
                let a = MotionCAAnimation.corner(radius: v)
                a.fromValue = NSNumber(floatLiteral: Double(s.cornerRadius))
                anims.append(a)
            }
            
            if let v = ts.transform {
                let a = MotionCAAnimation.transform(v)
                a.fromValue = NSValue(caTransform3D: s.transform)
                anims.append(a)
            }
            
            if let v = ts.spin {
                var a = MotionCAAnimation.spin(x: v.x)
                a.fromValue = NSNumber(floatLiteral: 0)
                anims.append(a)
                
                a = MotionCAAnimation.spin(y: v.y)
                a.fromValue = NSNumber(floatLiteral: 0)
                anims.append(a)
                
                a = MotionCAAnimation.spin(z: v.z)
                a.fromValue = NSNumber(floatLiteral: 0)
                anims.append(a)
            }
            
            if let v = ts.position {
                let a = MotionCAAnimation.position(v)
                a.fromValue = NSValue(cgPoint: s.position)
                anims.append(a)
            }
            
            if let v = ts.opacity {
                let a = MotionCAAnimation.fade(v)
                a.fromValue = s.value(forKeyPath: MotionAnimationKeyPath.opacity.rawValue) ?? NSNumber(floatLiteral: 1)
                anims.append(a)
            }
            
            if let v = ts.zPosition {
                let a = MotionCAAnimation.zPosition(v)
                a.fromValue = s.value(forKeyPath: MotionAnimationKeyPath.zPosition.rawValue) ?? NSNumber(floatLiteral: 0)
                anims.append(a)
            }
            
            if let v = ts.size {
                let a = MotionCAAnimation.size(v)
                a.fromValue = NSValue(cgSize: s.bounds.size)
                anims.append(a)
            }

            if let v = ts.shadowPath {
                let a = MotionCAAnimation.shadow(path: v)
                a.fromValue = s.shadowPath
                anims.append(a)
            }
            
            if let v = ts.shadowColor {
                let a = MotionCAAnimation.shadow(color: UIColor(cgColor: v))
                a.fromValue = s.shadowColor
                anims.append(a)
            }
            
            if let v = ts.shadowOffset {
                let a = MotionCAAnimation.shadow(offset: v)
                a.fromValue = NSValue(cgSize: s.shadowOffset)
                anims.append(a)
            }

            if let v = ts.shadowOpacity {
                let a = MotionCAAnimation.shadow(opacity: v)
                a.fromValue = NSNumber(floatLiteral: Double(s.shadowOpacity))
                anims.append(a)
            }
            
            if let v = ts.shadowRadius {
                let a = MotionCAAnimation.shadow(radius: v)
                a.fromValue = NSNumber(floatLiteral: Double(s.shadowRadius))
                anims.append(a)
            }
            
            if #available(iOS 9.0, *), let (stiffness, damping) = ts.spring {
                for i in 0..<anims.count where nil != anims[i].keyPath {
                    let v = anims[i]
                    
                    guard "cornerRadius" != v.keyPath else {
                        continue
                    }
                    
                    let a = MotionCAAnimation.convert(animation: v, stiffness: stiffness, damping: damping)
                    anims[i] = a
                    
                    if a.settlingDuration > duration {
                        duration = a.settlingDuration
                    }
                }
            }

            let g = Motion.animate(group: anims, duration: duration)
            g.fillMode = MotionAnimationFillModeToValue(mode: .both)
            g.isRemovedOnCompletion = false
            g.timingFunction = ts.timingFunction
            
            s.animate(g)
            
            if let v = ts.completion {
                Motion.delay(duration, execute: v)
            }
            
            if let v = completion {
                Motion.delay(duration, execute: v)
            }
        }
    }
}
