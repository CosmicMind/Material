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

@objc(AnimationRotationMode)
public enum AnimationRotationMode: Int {
	case `default`
	case auto
	case autoReverse
}

/**
 Converts an AnimationRotationMode to a corresponding CAAnimationRotate key.
 - Parameter mode: An AnimationRotationMode.
 - Returns: An optional CAAnimationRotate key String.
 */
public func AnimationRotationModeToValue(mode: AnimationRotationMode) -> String? {
	switch mode {
    case .default:
        return nil
    case .auto:
		return kCAAnimationRotateAuto
	case .autoReverse:
		return kCAAnimationRotateAutoReverse
	}
}

extension Motion {
	/**
     Creates a CAKeyframeAnimation.
     - Parameter bezierPath: A UIBezierPath.
     - Parameter mode: An AnimationRotationMode.
     - Parameter duration: An animation duration time.
     - Returns: A CAKeyframeAnimation.
     */
	public static func path(bezierPath: UIBezierPath, mode: AnimationRotationMode = .auto, duration: CFTimeInterval? = nil) -> CAKeyframeAnimation {
		let animation = CAKeyframeAnimation()
		animation.keyPath = AnimationKeyPath.position.rawValue
		animation.path = bezierPath.cgPath
        animation.rotationMode = AnimationRotationModeToValue(mode: mode)
		if let v = duration {
			animation.duration = v
		}
		return animation
	}
}
