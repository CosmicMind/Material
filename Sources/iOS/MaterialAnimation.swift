/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
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
*	*	Neither the name of Material nor the names of its
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
	/// Delay helper method.
	public static func delay(time: NSTimeInterval, completion: ()-> Void) ->  MaterialAnimationDelayCancelBlock? {
		
		func dispatch_later(completion: ()-> Void) {
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), completion)
		}
		
		var cancelable: MaterialAnimationDelayCancelBlock?
		
		let delayed: MaterialAnimationDelayCancelBlock = { (cancel: Bool) in
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
	public static func animateWithDuration(duration: CFTimeInterval, animations: (() -> Void), completion: (() -> Void)? = nil) {
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
	public static func animateWithDelay(delay d: CFTimeInterval, duration: CFTimeInterval, animations: (() -> Void), completion: (() -> Void)? = nil) {
		delay(d) {
			animateWithDuration(duration, animations: animations, completion: completion)
		}
	}
}
