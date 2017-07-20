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

internal class MotionCoreAnimationViewContext: MotionAnimatorViewContext {
    /// The transition states.
    fileprivate var transitionStates = [String: (Any?, Any?)]()
    
    /// A reference to the animation timing function.
    fileprivate var timingFunction = CAMediaTimingFunction.standard

    /// Layer which holds the content.
    fileprivate var contentLayer: CALayer? {
        return snapshot.layer.sublayers?.get(0)
    }
    
    /// Layer which holds the overlay.
    fileprivate var overlayLayer: CALayer?

    override func clean() {
        super.clean()
        overlayLayer = nil
    }
    
    override class func canAnimate(view: UIView, state: MotionTransitionState, isAppearing: Bool) -> Bool {
        return  nil != state.position           ||
                nil != state.size               ||
                nil != state.transform          ||
                nil != state.cornerRadius       ||
                nil != state.opacity            ||
                nil != state.overlay            ||
                nil != state.backgroundColor    ||
                nil != state.borderColor        ||
                nil != state.borderWidth        ||
                nil != state.shadowOpacity      ||
                nil != state.shadowRadius       ||
                nil != state.shadowOffset       ||
                nil != state.shadowColor        ||
                nil != state.shadowPath         ||
                nil != state.contentsRect       ||
                       state.forceAnimate
    }
    
    override func apply(state: MotionTransitionState) {
        let ts = viewState(targetState: state)
        
        for (key, targetValue) in ts {
            if nil == transitionStates[key] {
                let current = currentValue(for: key)
                transitionStates[key] = (current, current)
            }
            
            animate(key: key, beginTime: 0, fromValue: targetValue, toValue: targetValue)
        }
    }

    override func resume(at elapsedTime: TimeInterval, isReversed: Bool) {
        for (key, (fromValue, toValue)) in transitionStates {
            transitionStates[key] = (currentValue(for: key), !isReversed ? toValue : fromValue)
        }

        targetState.duration = isReversed ? elapsedTime - targetState.delay : duration - elapsedTime
        animate(delay: max(0, targetState.delay - elapsedTime))
    }

    override func seek(to elapsedTime: TimeInterval) {
        seek(layer: snapshot.layer, elapsedTime: elapsedTime)
        
        if let v = contentLayer {
            seek(layer: v, elapsedTime: elapsedTime)
        }
    
        if let v = overlayLayer {
            seek(layer: v, elapsedTime: elapsedTime)
        }
    }

    override func startAnimations(isAppearing: Bool) {
        if let beginState = targetState.beginState?.state {
            let appeared = viewState(targetState: beginState)
            for (k, v) in appeared {
                snapshot.layer.setValue(v, forKeyPath: k)
            }
            
            if let (k, v) = beginState.overlay {
                let overlay = getOverlayLayer()
                overlay.backgroundColor = k
                overlay.opacity = Float(v)
            }
        }

        let disappeared = viewState(targetState: targetState)
        for (k, v) in disappeared {
            let isAppearingState = currentValue(for: k)
            let toValue = isAppearing ? isAppearingState : v
            let fromValue = !isAppearing ? isAppearingState : v
            
            transitionStates[k] = (fromValue, toValue)
        }

        animate(delay: targetState.delay)
    }
}

extension MotionCoreAnimationViewContext {
    /**
     Lazy loads the overlay layer.
     - Returns: A CALayer.
     */
    fileprivate func getOverlayLayer() -> CALayer {
        if nil == overlayLayer {
            overlayLayer = CALayer()
            overlayLayer!.frame = snapshot.bounds
            overlayLayer!.opacity = 0
            snapshot.layer.addSublayer(overlayLayer!)
        }
        
        return overlayLayer!
    }
    
    /**
     Retrieves the overlay key for a given key.
     - Parameter for key: A String.
     - Returns: An optional String.
     */
    fileprivate func overlayKey(for key: String) -> String? {
        guard key.hasPrefix("overlay.") else {
            return nil
        }
        
        var k = key
        k.removeSubrange(k.startIndex..<k.index(key.startIndex, offsetBy: 8))
        return k
    }
    
    /**
     Retrieves the current value for a given key.
     - Parameter for key: A String.
     - Returns: An optional Any value.
     */
    fileprivate func currentValue(for key: String) -> Any? {
        if let key = overlayKey(for: key) {
            return overlayLayer?.value(forKeyPath: key)
        }
        
        if false != snapshot.layer.animationKeys()?.isEmpty {
            return snapshot.layer.value(forKeyPath:key)
        }
        
        return (snapshot.layer.presentation() ?? snapshot.layer).value(forKeyPath: key)
    }
    
    /**
     Retrieves the animation for a given key.
     - Parameter key: String.
     - Parameter beginTime: A TimeInterval.
     - Parameter fromValue: An optional Any value.
     - Parameter toValue: An optional Any value.
     - Parameter ignoreArc: A Boolean value to ignore an arc position.
     */
    fileprivate func getAnimation(key: String, beginTime: TimeInterval, fromValue: Any?, toValue: Any?, ignoreArc: Bool = false) -> CAPropertyAnimation {
        let key = overlayKey(for: key) ?? key
        let anim: CAPropertyAnimation
        
        if !ignoreArc, "position" == key, let arcIntensity = targetState.arc,
            let fromPos = (fromValue as? NSValue)?.cgPointValue,
            let toPos = (toValue as? NSValue)?.cgPointValue,
            abs(fromPos.x - toPos.x) >= 1, abs(fromPos.y - toPos.y) >= 1 {
            
            let a = CAKeyframeAnimation(keyPath: key)
            let path = CGMutablePath()
            let maxControl = fromPos.y > toPos.y ? CGPoint(x: toPos.x, y: fromPos.y) : CGPoint(x: fromPos.x, y: toPos.y)
            let minControl = (toPos - fromPos) / 2 + fromPos
            
            path.move(to: fromPos)
            path.addQuadCurve(to: toPos, control: minControl + (maxControl - minControl) * arcIntensity)
            
            a.values = [fromValue!, toValue!]
            a.path = path
            a.duration = duration
            a.timingFunctions = [timingFunction]
            
            anim = a
        } else if #available(iOS 9.0, *), "cornerRadius" != key, let (stiffness, damping) = targetState.spring {
            let a = CASpringAnimation(keyPath: key)
            a.stiffness = stiffness
            a.damping = damping
            a.duration = a.settlingDuration * 0.9
            a.fromValue = fromValue
            a.toValue = toValue
            
            anim = a
        } else {
            let a = CABasicAnimation(keyPath: key)
            a.duration = duration
            a.fromValue = fromValue
            a.toValue = toValue
            a.timingFunction = timingFunction
            
            anim = a
        }
        
        anim.fillMode = kCAFillModeBoth
        anim.isRemovedOnCompletion = false
        anim.beginTime = beginTime
        
        return anim
    }
    
    /**
     Retrieves the duration of an animation, including the
     duration of the animation and the initial delay.
     - Parameter key: A String.
     - Parameter beginTime: A TimeInterval.
     - Parameter fromValue: A optional Any value.
     - Parameter toValue: A optional Any value.
     - Returns: A TimeInterval.
     */
    @discardableResult
    fileprivate func animate(key: String, beginTime: TimeInterval, fromValue: Any?, toValue: Any?) -> TimeInterval {
        let anim = getAnimation(key: key, beginTime:beginTime, fromValue: fromValue, toValue: toValue)
        
        if let overlayKey = overlayKey(for: key) {
            getOverlayLayer().add(anim, forKey: overlayKey)
            
        } else {
            snapshot.layer.add(anim, forKey: key)
            
            switch key {
            case "cornerRadius", "contentsRect", "contentsScale":
                contentLayer?.add(anim, forKey: key)
                overlayLayer?.add(anim, forKey: key)
                
            case "bounds.size":
                guard let fs = (fromValue as? NSValue)?.cgSizeValue else {
                    return 0
                }
                
                guard let ts = (toValue as? NSValue)?.cgSizeValue else {
                    return 0
                }
                
                // for the snapshotView(UIReplicantView): there is a
                // subview(UIReplicantContentView) that is hosting the real snapshot image.
                // because we are using CAAnimations and not UIView animations,
                // The snapshotView will not layout during animations.
                // we have to add two more animations to manually layout the content view.
                let fpn = NSValue(cgPoint: fs.center)
                let tpn = NSValue(cgPoint: ts.center)
                
                let a = getAnimation(key: "position", beginTime: 0, fromValue: fpn, toValue: tpn, ignoreArc: true)
                a.beginTime = anim.beginTime
                a.timingFunction = anim.timingFunction
                a.duration = anim.duration
                
                contentLayer?.add(a, forKey: "position")
                contentLayer?.add(anim, forKey: key)
                
                overlayLayer?.add(a, forKey: "position")
                overlayLayer?.add(anim, forKey: key)
                
            default: break
            }
        }
        
        return anim.duration + anim.beginTime - beginTime
    }
    
    /**
     Animates the contentLayer and overlayLayer with a given delay.
     - Parameter delay: A TimeInterval.
     */
    fileprivate func animate(delay: TimeInterval) {
        if let v = targetState.timingFunction {
            timingFunction = v
        }
        
        if let v = targetState.duration {
            duration = v
        }
        
        let beginTime = currentTime + delay
        
        var finalDuration: TimeInterval = duration
        
        for (key, (fromValue, toValue)) in transitionStates {
            let neededTime = animate(key: key, beginTime: beginTime, fromValue: fromValue, toValue: toValue)
            finalDuration = max(finalDuration, neededTime + delay)
        }
        
        duration = finalDuration
    }
    
    /**
     Constructs a map of key paths to animation state values.
     - Parameter targetState state: A MotionTransitionState.
     - Returns: A map of key paths to animation values.
     */
    fileprivate func viewState(targetState ts: MotionTransitionState) -> [String: Any?] {
        var ts = ts
        var values = [String: Any?]()
        
        if let size = ts.size {
            if ts.useScaleBasedSizeChange ?? targetState.useScaleBasedSizeChange ?? false {
                let currentSize = snapshot.bounds.size
                ts.append(.scale(x: size.width / currentSize.width, y: size.height / currentSize.height))
                
            } else {
                values["bounds.size"] = NSValue(cgSize:size)
            }
        }
        
        if let position = ts.position {
            values["position"] = NSValue(cgPoint:position)
        }
        
        if let opacity = ts.opacity, !(snapshot is UIVisualEffectView) {
            values["opacity"] = NSNumber(value: opacity)
        }
        
        if let cornerRadius = ts.cornerRadius {
            values["cornerRadius"] = NSNumber(value: cornerRadius.native)
        }
        
        if let backgroundColor = ts.backgroundColor {
            values["backgroundColor"] = backgroundColor
        }
        
        if let zPosition = ts.zPosition {
            values["zPosition"] = NSNumber(value: zPosition.native)
        }
        
        if let borderWidth = ts.borderWidth {
            values["borderWidth"] = NSNumber(value: borderWidth.native)
        }
        
        if let borderColor = ts.borderColor {
            values["borderColor"] = borderColor
        }
        
        if let masksToBounds = ts.masksToBounds {
            values["masksToBounds"] = masksToBounds
        }
        
        if ts.displayShadow {
            if let shadowColor = ts.shadowColor {
                values["shadowColor"] = shadowColor
            }
            
            if let shadowRadius = ts.shadowRadius {
                values["shadowRadius"] = NSNumber(value: shadowRadius.native)
            }
            
            if let shadowOpacity = ts.shadowOpacity {
                values["shadowOpacity"] = NSNumber(value: shadowOpacity)
            }
            
            if let shadowPath = ts.shadowPath {
                values["shadowPath"] = shadowPath
            }
            
            if let shadowOffset = ts.shadowOffset {
                values["shadowOffset"] = NSValue(cgSize: shadowOffset)
            }
        }
        
        if let contentsRect = ts.contentsRect {
            values["contentsRect"] = NSValue(cgRect: contentsRect)
        }
        
        if let contentsScale = ts.contentsScale {
            values["contentsScale"] = NSNumber(value: contentsScale.native)
        }
        
        if let transform = ts.transform {
            values["transform"] = NSValue(caTransform3D: transform)
        }
        
        if let (color, opacity) = ts.overlay {
            values["overlay.backgroundColor"] = color
            values["overlay.opacity"] = NSNumber(value: opacity.native)
        }
        
        return values
    }
    
    /**
     Moves a layer's animation to a given elapsed time.
     - Parameter layer: A CALayer.
     - Parameter elapsedTime: A TimeInterval.
     */
    fileprivate func seek(layer: CALayer, elapsedTime: TimeInterval) {
        let timeOffset = elapsedTime - targetState.delay
        for (key, anim) in layer.animations {
            anim.speed = 0
            anim.timeOffset = max(0, min(anim.duration - 0.01, timeOffset))
            layer.removeAnimation(forKey: key)
            layer.add(anim, forKey: key)
        }
    }
}
