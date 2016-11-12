/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

internal struct MotionPulse<T: UIView> where T: Pulsable {
	/**
     Triggers the expanding animation.
     - Parameter _ view: A Reference to the view to add the 
     animations too.
     - Parameter point: A point to pulse from.
     */
    internal static func expandAnimation(view: inout T, visualLayer: CAShapeLayer, point: CGPoint) {
        guard .none != view.pulse.animation else {
            return
        }
        
        let w = view.width
        let h = view.height
        
        let n = .center == view.pulse.animation ? w < h ? w : h : w < h ? h : w
        
        let bLayer = CAShapeLayer()
        let pLayer = CAShapeLayer()
        
        bLayer.addSublayer(pLayer)
        view.pulse.layers.append(bLayer)
        visualLayer.addSublayer(bLayer)
        bLayer.zPosition = 0
        pLayer.zPosition = 0
        
        visualLayer.masksToBounds = !(.centerRadialBeyondBounds == view.pulse.animation || .radialBeyondBounds == view.pulse.animation)
        
        Motion.disable(animations: {
            bLayer.frame = visualLayer.bounds
            pLayer.bounds = CGRect(x: 0, y: 0, width: n, height: n)
            
            switch view.pulse.animation {
            case .center, .centerWithBacking, .centerRadialBeyondBounds:
                pLayer.position = CGPoint(x: w / 2, y: h / 2)
            default:
                pLayer.position = point
            }
            
            pLayer.cornerRadius = n / 2
            pLayer.backgroundColor = view.pulse.color.withAlphaComponent(view.pulse.opacity).cgColor
            pLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(scaleX: 0, y: 0))
        })
        
        bLayer.setValue(false, forKey: "animated")
        
        let duration: CFTimeInterval = .center == view.pulse.animation ? 0.16125 : 0.325
        
        switch view.pulse.animation {
        case .centerWithBacking, .backing, .pointWithBacking:
            bLayer.add(Motion.backgroundColor(color: view.pulse.color.withAlphaComponent(view.pulse.opacity / 2), duration: duration), forKey: nil)
        default:break
        }
        
        switch view.pulse.animation {
        case .center, .centerWithBacking, .centerRadialBeyondBounds, .radialBeyondBounds, .point, .pointWithBacking:
            pLayer.add(Motion.scale(by: 1, duration: duration), forKey: nil)
        default:break
        }
        
        Motion.delay(time: duration) {
            bLayer.setValue(true, forKey: "animated")
        }
	}
	
	/**
     Triggers the contracting animation.
     - Parameter _ view: A Reference to the view to add the
     animations too.
     - Parameter pulse: A Pulse instance.
     */
    internal static func contractAnimation(view: inout T) {
        var view = view
        guard let bLayer = view.pulse.layers.last else {
            return
        }
        
        guard let animated = bLayer.value(forKey: "animated") as? Bool else {
            return
        }
        
        Motion.delay(time: animated ? 0 : 0.15) {
            guard let pLayer = bLayer.sublayers?.first as? CAShapeLayer else {
                return
            }
            
            let duration = 0.325
            
            switch view.pulse.animation {
            case .centerWithBacking, .backing, .pointWithBacking:
                bLayer.add(Motion.backgroundColor(color: view.pulse.color.withAlphaComponent(0), duration: duration), forKey: nil)
            default:break
            }
            
            switch view.pulse.animation {
            case .center, .centerWithBacking, .centerRadialBeyondBounds, .radialBeyondBounds, .point, .pointWithBacking:
                pLayer.add(Motion.animate(group: [
                    Motion.scale(by: .center == view.pulse.animation ? 1 : 1.325),
                    Motion.backgroundColor(color: view.pulse.color.withAlphaComponent(0))
                ], duration: duration), forKey: nil)
            default:break
            }
            
            Motion.delay(time: duration) {
                pLayer.removeFromSuperlayer()
                bLayer.removeFromSuperlayer()
            }
        }
	}
}
