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

@objc(AnimationFillMode)
public enum AnimationFillMode: Int {
	case forwards
	case backwards
	case both
	case removed
}

/**
 Converts the AnimationFillMode enum value to a corresponding String.
 - Parameter mode: An AnimationFillMode enum value.
 */
public func AnimationFillModeToValue(mode: AnimationFillMode) -> String {
	switch mode {
	case .forwards:
		return kCAFillModeForwards
	case .backwards:
		return kCAFillModeBackwards
	case .both:
		return kCAFillModeBoth
	case .removed:
		return kCAFillModeRemoved
	}
}

@objc(AnimationTimingFunction)
public enum AnimationTimingFunction: Int {
    case `default`
    case linear
    case easeIn
    case easeOut
    case easeInEaseOut
}

/**
 Converts the AnimationTimingFunction enum value to a corresponding CAMediaTimingFunction.
 - Parameter function: An AnimationTimingFunction enum value.
 - Returns: A CAMediaTimingFunction.
 */
public func AnimationTimingFunctionToValue(function: AnimationTimingFunction) -> CAMediaTimingFunction {
    switch function {
    case .default:
        return CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
    case .linear:
        return CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    case .easeIn:
        return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    case .easeOut:
        return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    case .easeInEaseOut:
        return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    }
}

public typealias MotionDelayCancelBlock = (Bool) -> Void

public struct Motion {
	/**
     Executes a block of code after a time delay.
     - Parameter duration: An animation duration time.
     - Parameter animations: An animation block.
     - Parameter execute block: A completion block that is executed once
     the animations have completed.
     */
    @discardableResult
    public static func delay(time: TimeInterval, execute block: @escaping () -> Void) -> MotionDelayCancelBlock? {
		
		func asyncAfter(completion: @escaping () -> Void) {
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: completion)
        }
		
		var cancelable: MotionDelayCancelBlock?
		
		let delayed: MotionDelayCancelBlock = {
			if !$0 {
				DispatchQueue.main.async(execute: block)
			}
            
			cancelable = nil
		}
		
		cancelable = delayed
		
		asyncAfter {
			cancelable?(false)
		}
		
		return cancelable;
	}
	
	/**
     Cancels the delayed MotionDelayCancelBlock.
     - Parameter delayed completion: An MotionDelayCancelBlock.
     */
	public static func cancel(delayed completion: MotionDelayCancelBlock) {
		completion(true)
	}

	/**
     Disables the default animations set on CALayers. 
     - Parameter animations: A callback that wraps the animations to disable.
     */
	public static func disable(animations: (() -> Void)) {
		animate(duration: 0, animations: animations)
	}
	
	/**
     Runs an animation with a specified duration.
     - Parameter duration: An animation duration time.
     - Parameter animations: An animation block.
     - Parameter timingFunction: An AnimationTimingFunction value.
     - Parameter completion: A completion block that is executed once
     the animations have completed.
     */
	public static func animate(duration: CFTimeInterval, timingFunction: AnimationTimingFunction = .easeInEaseOut, animations: (() -> Void), completion: (() -> Void)? = nil) {
		CATransaction.begin()
		CATransaction.setAnimationDuration(duration)
		CATransaction.setCompletionBlock(completion)
		CATransaction.setAnimationTimingFunction(AnimationTimingFunctionToValue(function: .easeInEaseOut))
		animations()
		CATransaction.commit()
	}
	
	/**
     Creates a CAAnimationGroup.
     - Parameter animations: An Array of CAAnimation objects.
     - Parameter timingFunction: An AnimationTimingFunction value.
     - Parameter duration: An animation duration time for the group.
     - Returns: A CAAnimationGroup.
     */
    public static func animate(group animations: [CAAnimation], timingFunction: AnimationTimingFunction = .easeInEaseOut, duration: CFTimeInterval = 0.5) -> CAAnimationGroup {
		let group = CAAnimationGroup()
		group.fillMode = AnimationFillModeToValue(mode: .forwards)
		group.isRemovedOnCompletion = false
		group.animations = animations
		group.duration = duration
		group.timingFunction = AnimationTimingFunctionToValue(function: timingFunction)
		return group
	}
	
	/**
     Executes an animation block with a given delay and duration.
     - Parameter delay time: A CFTimeInterval.
     - Parameter duration: An animation duration time.
     - Parameter animations: An animation block.
     - Parameter completion: A completion block that is executed once
     the animations have completed.
     */
	public static func animate(delay time: CFTimeInterval, duration: CFTimeInterval, animations: @escaping (() -> Void), completion: (() -> Void)? = nil) {
        delay(time: time) {
            animate(duration: duration, animations: animations, completion: completion)
		}
	}
}

