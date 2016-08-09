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

public typealias AnimationTransitionType = String
public typealias AnimationTransitionSubTypeType = String

@objc(AnimationTransition)
public enum AnimationTransition: Int {
	case Fade
	case MoveIn
	case Push
	case Reveal
}

@objc(AnimationTransitionSubType)
public enum AnimationTransitionSubType: Int {
	case Right
	case Left
	case Top
	case Bottom
}

/**
	:name:	AnimationTransitionToValue
*/
public func AnimationTransitionToValue(transition: AnimationTransition) -> AnimationTransitionType {
	switch transition {
	case .Fade:
		return kCATransitionFade
	case .MoveIn:
		return kCATransitionMoveIn
	case .Push:
		return kCATransitionPush
	case .Reveal:
		return kCATransitionReveal
	}
}

/**
	:name:	AnimationTransitionSubTypeToValue
*/
public func AnimationTransitionSubTypeToValue(direction: AnimationTransitionSubType) -> AnimationTransitionSubTypeType {
	switch direction {
	case .Right:
		return kCATransitionFromRight
	case .Left:
		return kCATransitionFromLeft
	case .Top:
		return kCATransitionFromBottom
	case .Bottom:
		return kCATransitionFromTop
	}
}

extension Animation {
	/**
	:name: transition
	*/
	public static func transition(type: AnimationTransition, direction: AnimationTransitionSubType? = nil, duration: CFTimeInterval? = nil) -> CATransition {
		let animation: CATransition = CATransition()
		animation.type = AnimationTransitionToValue(transition: type)
		if let d = direction {
			animation.subtype = AnimationTransitionSubTypeToValue(direction: d)
		}
		if let v: CFTimeInterval = duration {
			animation.duration = v
		}
		return animation
	}
}
