//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
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
	/**
		:name:	materialAnimationDidStart
	*/
	optional func materialAnimationDidStart(animation: CAAnimation)
	
	/**
		:name:	materialAnimationDidStop
	*/
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

public struct MaterialAnimation {
	/**
		:name:	animationDisabled
	*/
	public static func animationDisabled(animations: (() -> Void)) {
		animationWithDuration(0, animations: animations)
	}
	
	/**
		:name:	animationWithDuration
	*/
	public static func animationWithDuration(duration: CFTimeInterval, animations: (() -> Void), completion: (() -> Void)? = nil) {
		CATransaction.begin()
		CATransaction.setAnimationDuration(duration)
		CATransaction.setCompletionBlock(completion)
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
		return group
	}
}
