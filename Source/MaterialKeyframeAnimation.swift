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

public typealias MaterialAnimationRotationModeType = String

public enum MaterialAnimationRotationMode {
	case None
	case Auto
	case AutoReverse
}

/**
	:name:	MaterialAnimationRotationModeToValue
*/
public func MaterialAnimationRotationModeToValue(mode: MaterialAnimationRotationMode) -> MaterialAnimationRotationModeType? {
	switch mode {
	case .None:
		return nil
	case .Auto:
		return kCAAnimationRotateAuto
	case .AutoReverse:
		return kCAAnimationRotateAutoReverse
	}
}

public extension MaterialAnimation {
	/**
		:name: position
	*/
	public static func position(
		view: UIView,
		path: UIBezierPath,
		mode: MaterialAnimationRotationMode = .Auto,
		duration: CFTimeInterval = 1,
		completion: (() -> Void)? = nil) {
			position(view.layer, path: path, mode: mode, duration: duration, completion: completion)
	}
	
	/**
		:name: position
	*/
	public static func position(
		layer: CALayer,
		path: UIBezierPath,
		mode: MaterialAnimationRotationMode = .Auto,
		duration: CFTimeInterval = 1,
		completion: (() -> Void)? = nil) {
			
		let animation: CAKeyframeAnimation = CAKeyframeAnimation()
		animation.keyPath = "position"
		animation.duration = duration
		animation.path = path.CGPath
		animation.rotationMode = MaterialAnimationRotationModeToValue(mode)
		applyKeyframeAnimation(animation, toLayer: layer)
	}
}