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

@objc(PulseAnimation)
public enum PulseAnimation: Int {
    case none
    case center
    case centerWithBacking
    case centerRadialBeyondBounds
    case radialBeyondBounds
    case backing
    case point
    case pointWithBacking
}

public protocol Pulseable {
    /// A reference to the PulseAnimation.
    var pulseAnimation: PulseAnimation { get set }
    
    /// A UIColor.
    var pulseColor: UIColor { get set }
    
    /// The opcaity value for the pulse animation.
    var pulseOpacity: CGFloat { get set }
}

internal protocol PulseableLayer {
    /// A reference to the pulse layer.
    var pulseLayer: CALayer? { get }
}

public struct Pulse {
    /// A UIView that is Pulseable.
    fileprivate weak var pulseView: UIView?
    
    /// The layer the pulse layers are added to.
    internal weak var pulseLayer: CALayer?
    
    /// Pulse layers.
    fileprivate var layers = [CAShapeLayer]()
    
    /// A reference to the PulseAnimation.
    public var animation = PulseAnimation.pointWithBacking
    
    /// A UIColor.
    public var color = Color.grey.base
    
    /// The opcaity value for the pulse animation.
    public var opacity: CGFloat = 0.18

    /**
     An initializer that takes a given view and pulse layer.
     - Parameter pulseView: An optional UIView.
     - Parameter pulseLayer: An optional CALayer.
     */
    public init(pulseView: UIView?, pulseLayer: CALayer?) {
        self.pulseView = pulseView
        self.pulseLayer = pulseLayer
    }
    
    /**
     Triggers the expanding animation.
     - Parameter point: A point to pulse from.
     */
    public mutating func expand(point: CGPoint) {
        guard let view = pulseView else {
            return
        }
        
        guard let layer = pulseLayer else {
            return
        }
        
        guard .none != animation else {
            return
        }
        
        let bLayer = CAShapeLayer()
        let pLayer = CAShapeLayer()
        
        bLayer.addSublayer(pLayer)
        layer.addSublayer(bLayer)
        bLayer.zPosition = 0
        pLayer.zPosition = 0
        
        layers.insert(bLayer, at: 0)
        
        layer.masksToBounds = !(.centerRadialBeyondBounds == animation || .radialBeyondBounds == animation)
 
        let w = view.bounds.width
        let h = view.bounds.height
        
        Motion.disable({ [
            n = .center == animation ? w < h ? w : h : w < h ? h : w,
            bounds = layer.bounds,
            animation = animation,
            color = color,
            opacity = opacity
            ] in
            
            bLayer.frame = bounds
            pLayer.frame = CGRect(x: 0, y: 0, width: n, height: n)
            
            switch animation {
            case .center, .centerWithBacking, .centerRadialBeyondBounds:
                pLayer.position = CGPoint(x: w / 2, y: h / 2)
            default:
                pLayer.position = point
            }
            
            pLayer.cornerRadius = n / 2
            pLayer.backgroundColor = color.withAlphaComponent(opacity).cgColor
            pLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(scaleX: 0, y: 0))
        })
        
        bLayer.setValue(false, forKey: "animated")
        
        let t: TimeInterval = .center == animation ? 0.16125 : 0.325
        
        switch animation {
        case .centerWithBacking, .backing, .pointWithBacking:
            bLayer.animate(.background(color: color.withAlphaComponent(opacity / 2)), .duration(t))
        default:break
        }
        
        switch animation {
        case .center, .centerWithBacking, .centerRadialBeyondBounds, .radialBeyondBounds, .point, .pointWithBacking:
            pLayer.animate(.scale(1), .duration(t))
        default:break
        }
        
        Motion.delay(t) {
            bLayer.setValue(true, forKey: "animated")
        }
	}
	
	/// Triggers the contracting animation.
    public mutating func contract() {
        guard let bLayer = layers.popLast() else {
            return
        }
        
        guard let animated = bLayer.value(forKey: "animated") as? Bool else {
            return
        }
        
        Motion.delay(animated ? 0 : 0.15) { [animation = animation, color = color] in
            guard let pLayer = bLayer.sublayers?.first as? CAShapeLayer else {
                return
            }
            
            let t: TimeInterval = 0.325
            
            switch animation {
            case .centerWithBacking, .backing, .pointWithBacking:
                bLayer.animate(.background(color: color.withAlphaComponent(0)), .duration(t))
            default:break
            }
            
            switch animation {
            case .center, .centerWithBacking, .centerRadialBeyondBounds, .radialBeyondBounds, .point, .pointWithBacking:
                pLayer.animate(.background(color: color.withAlphaComponent(0)))
            default:break
            }
            
            Motion.delay(t) {
                pLayer.removeFromSuperlayer()
                bLayer.removeFromSuperlayer()
            }
        }
	}
}
