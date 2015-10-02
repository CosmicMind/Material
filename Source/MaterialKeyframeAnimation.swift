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
		:name:	path
	*/
	public static func pathAnimation(bezierPath: UIBezierPath, mode: MaterialAnimationRotationMode = .Auto) -> CAKeyframeAnimation {
		let animation: CAKeyframeAnimation = CAKeyframeAnimation()
		animation.keyPath = "position"
		animation.path = bezierPath.CGPath
		animation.rotationMode = MaterialAnimationRotationModeToValue(mode)
		return animation
	}
	
	/**
		:name: path
	*/
	public static func path(view: UIView, bezierPath: UIBezierPath, mode: MaterialAnimationRotationMode = .Auto, duration: CFTimeInterval = 1) {
		path(view.layer, bezierPath: bezierPath, mode: mode, duration: duration)
	}
	
	/**
		:name: path
	*/
	public static func path(layer: CALayer, bezierPath: UIBezierPath, mode: MaterialAnimationRotationMode = .Auto, duration: CFTimeInterval = 1) {
		let animation: CAKeyframeAnimation = pathAnimation(bezierPath, mode: mode)
		animation.duration = duration
		applyKeyframeAnimation(animation, toLayer: layer)
	}
}