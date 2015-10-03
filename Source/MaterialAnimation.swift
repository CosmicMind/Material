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

public struct MaterialAnimation {
	/**
		:name:	disableAnimation
	*/
	public static func disableAnimation(block: (() -> Void)) {
		CATransaction.begin()
		CATransaction.setAnimationDuration(0)
		block()
		CATransaction.commit()
	}
	
	/**
		:name:	groupAnimation
	*/
	public static func groupAnimation(view: UIView, animations: Array<CAAnimation>, duration: NSTimeInterval = 0.5) {
		groupAnimation(view.layer, animations: animations, duration: duration)
	}
	
	/**
		:name:	groupAnimation
	*/
	public static func groupAnimation(layer: CALayer, animations: Array<CAAnimation>, duration: NSTimeInterval = 0.5) {
		let group: CAAnimationGroup = CAAnimationGroup()
		group.animations = animations
		group.duration = duration
		layer.addAnimation(group, forKey: nil)
	}
	
	/**
		:name:	applyBasicAnimation
	*/
	internal static func applyBasicAnimation(animation: CABasicAnimation, toLayer layer: CALayer, completion: (() -> Void)? = nil) {
		groupAnimation(layer, animations: [animation], duration: animation.duration)
	}
	
	/**
		:name:	applyKeyframeAnimation
	*/
	internal static func applyKeyframeAnimation(animation: CAKeyframeAnimation, toLayer layer: CALayer) {
		// use presentation layer if available
		(nil == layer.presentationLayer() ? layer : layer.presentationLayer() as! CALayer).addAnimation(animation, forKey: animation.keyPath!)
	}
}
