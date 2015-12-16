//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io> and other CosmicMind contributors
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

@objc(MaterialAnimationDelegate)
public protocol MaterialAnimationDelegate : MaterialDelegate {
	optional func materialAnimationDidStart(animation: CAAnimation)
	optional func materialAnimationDidStop(animation: CAAnimation, finished flag: Bool)
}

public typealias MaterialAnimationFillModeType = String

public enum MaterialAnimationFillMode {
	case Forwards
	case Backwards
	case Both
	case Removed
}

/**
	:name:	MaterialAnimationFillModeToValue
*/
public func MaterialAnimationFillModeToValue(mode: MaterialAnimationFillMode) -> MaterialAnimationFillModeType {
	switch mode {
	case .Forwards:
		return kCAFillModeForwards
	case .Backwards:
		return kCAFillModeBackwards
	case .Both:
		return kCAFillModeBoth
	case .Removed:
		return kCAFillModeRemoved
	}
}

public typealias MaterialAnimationDelayCancelBlock = (cancel : Bool) -> Void

public struct MaterialAnimation {
	/**
	:name:	delay
	*/
	public static func delay(time: NSTimeInterval, completion: ()-> Void) ->  MaterialAnimationDelayCancelBlock? {
		
		func dispatch_later(completion: ()-> Void) {
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), completion)
		}
		
		var cancelable: MaterialAnimationDelayCancelBlock?
		
		let delayed: MaterialAnimationDelayCancelBlock = { cancel in
			if !cancel {
				dispatch_async(dispatch_get_main_queue(), completion)
			}
			cancelable = nil
		}
		
		cancelable = delayed
		
		dispatch_later {
			cancelable?(cancel: false)
		}
		
		return cancelable;
	}
	
	/**
	:name:	delayCancel
	*/
	public static func delayCancel(completion: MaterialAnimationDelayCancelBlock?) {
		completion?(cancel: true)
	}

	
	/**
	:name:	animationDisabled
	*/
	public static func animationDisabled(animations: (() -> Void)) {
		animateWithDuration(0, animations: animations)
	}
	
	/**
	:name:	animateWithDuration
	*/
	public static func animateWithDuration(duration: CFTimeInterval, animations: (() -> Void), options: UIViewAnimationOptions? = nil, completion: (() -> Void)? = nil) {
		CATransaction.begin()
		CATransaction.setAnimationDuration(duration)
		CATransaction.setCompletionBlock(completion)
		CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
		animations()
		CATransaction.commit()
	}
	
	/**
	:name:	animationGroup
	*/
	public static func animationGroup(animations: Array<CAAnimation>, duration: CFTimeInterval = 0.5) -> CAAnimationGroup {
		let group: CAAnimationGroup = CAAnimationGroup()
		group.fillMode = MaterialAnimationFillModeToValue(.Forwards)
		group.removedOnCompletion = false
		group.animations = animations
		group.duration = duration
		group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		return group
	}
	
	/**
	:name:	animateWithDelay
	*/
	public static func animateWithDelay(delay d: CFTimeInterval, duration: CFTimeInterval, animations: (() -> Void), options: UIViewAnimationOptions? = nil, completion: (() -> Void)? = nil) {
		delay(d) {
			animateWithDuration(duration, animations: animations, options: options, completion: completion)
		}
	}
}
