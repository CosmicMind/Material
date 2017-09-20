//
//  Helper.swift
//  Material
//
//  Created by Orkhan Alikhanov on 8/29/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit

internal extension CATransaction {
    enum TimingFunction {
        case `default`
        case linear
        case easeIn
        case easeOut
        case easeInOut
        
        var name: String {
            switch self {
            case .default:
                return kCAMediaTimingFunctionDefault
            case .linear:
                return kCAMediaTimingFunctionLinear
            case .easeIn:
                return kCAMediaTimingFunctionEaseIn
            case .easeOut:
                return kCAMediaTimingFunctionEaseOut
            case .easeInOut:
                return kCAMediaTimingFunctionEaseInEaseOut
            }
        }
        
        var media: CAMediaTimingFunction {
            return CAMediaTimingFunction(name: name)
        }
    }
    
    static func performWithoutAnimation(_ actionsWithoutAnimation: @escaping () -> Void) {
        perform {
            setDisableActions(true)
            actionsWithoutAnimation()
        }
    }
    
    static func animate(withDuration duration: TimeInterval,
                        delay: TimeInterval,
                        timingFunction: TimingFunction, animations: @escaping () -> Void, completion: (()->Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            animate(withDuration: duration, timingFunction: timingFunction, animations: animations, completion: completion)
        }
    }
    
    static func animate(withDuration duration: TimeInterval, timingFunction: TimingFunction, animations: @escaping () -> Void, completion: (()->Void)? = nil) {
        perform(with: completion) {
            setAnimationDuration(duration)
            setAnimationTimingFunction(timingFunction.media)
            animations()
        }
    }
    
    static func perform(with completion: (()->Void)? = nil, _ code: @escaping () -> Void) {
        begin()
        setCompletionBlock(completion)
        code()
        commit()
    }
}

internal extension CALayer {
    func animate(_ keyPath: String, from: Any?, to: Any?, timingFunction: CATransaction.TimingFunction = .default, dur: TimeInterval = 0  ) {
        self.setValue(to, forKeyPath: keyPath)
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.timingFunction = timingFunction.media
        animation.fromValue = from
        animation.toValue = to
        animation.fillMode = kCAFillModeForwards
        animation.duration = dur
        self.add(animation, forKey: nil)
    }
}

internal extension CATransform3D {
    static var identity: CATransform3D {
        return CATransform3DIdentity
    }
}
