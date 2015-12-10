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

public typealias MaterialAnimationTransitionType = String
public typealias MaterialAnimationTransitionSubTypeType = String

public enum MaterialAnimationTransition {
	case Fade
	case MoveIn
	case Push
	case Reveal
}

public enum MaterialAnimationTransitionSubType {
	case Right
	case Left
	case Top
	case Bottom
}

/**
	:name:	MaterialAnimationTransitionToValue
*/
public func MaterialAnimationTransitionToValue(transition: MaterialAnimationTransition) -> MaterialAnimationTransitionType {
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
	:name:	MaterialAnimationTransitionSubTypeToValue
*/
public func MaterialAnimationTransitionSubTypeToValue(direction: MaterialAnimationTransitionSubType) -> MaterialAnimationTransitionSubTypeType {
	switch direction {
	case .Right:
		return kCATransitionFromRight
	case .Left:
		return kCATransitionFromLeft
	case .Top:
		return kCATransitionFromTop
	case .Bottom:
		return kCATransitionFromBottom
	}
}

public extension MaterialAnimation {
	/**
	:name: transition
	*/
	public static func transition(type: MaterialAnimationTransition, direction: MaterialAnimationTransitionSubType? = nil, duration: CFTimeInterval? = nil) -> CATransition {
		let animation: CATransition = CATransition()
		animation.type = MaterialAnimationTransitionToValue(type)
		if let d = direction {
			animation.subtype = MaterialAnimationTransitionSubTypeToValue(d)
		}
		if let d = duration {
			animation.duration = d
		}
		return animation
	}
}