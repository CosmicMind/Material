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

@objc(TransitionMotion)
public enum TransitionMotion: Int {
	case fade
	case moveIn
	case push
	case reveal
}

@objc(TransitionMotionDirection)
public enum TransitionMotionDirection: Int {
	case `default`
    case right
	case left
	case top
	case bottom
}

/**
 Converts an TransitionMotion to a corresponding CATransition key.
 - Parameter transition: An TransitionMotion.
 - Returns: A CATransition key String.
 */
public func TransitionMotionToValue(transition type: TransitionMotion) -> String {
	switch type {
	case .fade:
		return kCATransitionFade
	case .moveIn:
		return kCATransitionMoveIn
	case .push:
		return kCATransitionPush
	case .reveal:
		return kCATransitionReveal
	}
}

/**
 Converts an TransitionMotionDirection to a corresponding CATransition direction key.
 - Parameter direction: An TransitionMotionDirection.
 - Returns: An optional CATransition direction key String.
 */
public func TransitionMotionDirectionToValue(direction: TransitionMotionDirection) -> String? {
	switch direction {
    case .default:
        return nil
    case .right:
		return kCATransitionFromRight
	case .left:
		return kCATransitionFromLeft
	case .top:
		return kCATransitionFromBottom
	case .bottom:
		return kCATransitionFromTop
	}
}

extension Motion {
	/**
     Creates a CATransition animation.
     - Parameter type: An TransitionMotion.
     - Parameter direction: An optional TransitionMotionDirection.
     - Parameter duration: An optional duration time.
     - Returns: A CATransition.
     */
	public static func transition(type: TransitionMotion, direction: TransitionMotionDirection = .default, duration: CFTimeInterval? = nil) -> CATransition {
		let animation = CATransition()
		animation.type = TransitionMotionToValue(transition: type)
        animation.subtype = TransitionMotionDirectionToValue(direction: direction)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}
}
