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

public enum AnimationKeyPath: String {
    case backgroundColor
    case scale  = "transform.scale"
    case position
    case shadowPath
}

extension CABasicAnimation {
    /**
     A convenience initializer that takes a given AnimationKeyPath.
     - Parameter keyPath: An AnimationKeyPath.
     */
    public convenience init(keyPath: AnimationKeyPath) {
        self.init(keyPath: keyPath.rawValue)
    }
}

extension Animation {
	/**
     Creates a CABasicAnimation for the backgroundColor key path.
     - Parameter color: A UIColor.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
	public static func backgroundColor(color: UIColor, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .backgroundColor)
		animation.toValue = color.cgColor
		animation.fillMode = AnimationFillModeToValue(mode: .forwards)
		animation.isRemovedOnCompletion = false
		animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the transform.scale key path.
     - Parameter by scale: A CGFloat.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func scale(by scale: CGFloat, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .scale)
		animation.toValue = scale as NSNumber
		animation.fillMode = AnimationFillModeToValue(mode: .forwards)
		animation.isRemovedOnCompletion = false
		animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		if let v = duration {
			animation.duration = v
		}
		return animation
	}
	
    /**
     Creates a CABasicAnimation for the position key path.
     - Parameter to point: A CGPoint.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func position(to point: CGPoint, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .position)
		animation.toValue = NSValue(cgPoint: point)
        animation.fillMode = AnimationFillModeToValue(mode: .forwards)
        animation.isRemovedOnCompletion = false
        animation.timingFunction = AnimationTimingFunctionToValue(function: .easeInEaseOut)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}
	
    /**
     Creates a CABasicAnimation for the shadowPath key path.
     - Parameter to path: A CGPath.
     - Parameter duration: An animation time duration.
     - Returns: A CABasicAnimation.
     */
    public static func shadowPath(to path: CGPath, duration: CFTimeInterval? = nil) -> CABasicAnimation {
		let animation = CABasicAnimation(keyPath: .shadowPath)
		animation.toValue = path
        animation.fillMode = AnimationFillModeToValue(mode: .forwards)
        animation.isRemovedOnCompletion = false
        animation.timingFunction = AnimationTimingFunctionToValue(function: .linear)
		
        if let v = duration {
			animation.duration = v
		}
		
        return animation
	}
}
