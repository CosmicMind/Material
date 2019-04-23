/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
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
import Motion

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
    
    Motion.disable { [
      n = .center == animation ? min(w, h) : max(w, h),
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
    }
    
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
