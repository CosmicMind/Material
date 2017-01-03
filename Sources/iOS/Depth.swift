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

@objc(DepthPreset)
public enum DepthPreset: Int {
	case none
	case depth1
	case depth2
	case depth3
	case depth4
	case depth5
}

public struct Depth {
    /// Offset.
    public var offset: Offset
    
    /// Opacity.
    public var opacity: Float
    
    /// Radius.
    public var radius: CGFloat
    
    /// Preset.
    public var preset = DepthPreset.none {
        didSet {
            let depth = DepthPresetToValue(preset: preset)
            offset = depth.offset
            opacity = depth.opacity
            radius = depth.radius
        }
    }
    
    /**
     Initializer that takes in an offset, opacity, and radius.
     - Parameter offset: UIOffset.
     - Parameter opacity: Float.
     - Parameter radius: CGFloat.
     */
    public init(offset: Offset = .zero, opacity: Float = 0, radius: CGFloat = 0) {
        self.offset = offset
        self.opacity = opacity
        self.radius = radius
    }
    
    /**
     Initializer that takes in a DepthPreset.
     - Parameter preset: DepthPreset.
     */
    public init(preset: DepthPreset) {
        self.init()
        self.preset = preset
    }
    
    /**
     Static constructor for Depth with values of 0.
     - Returns: A Depth struct with values of 0.
     */
    static var zero: Depth {
        return Depth()
    }
}

/// Converts the DepthPreset enum to a Depth value.
public func DepthPresetToValue(preset: DepthPreset) -> Depth {
	switch preset {
	case .none:
		return .zero
	case .depth1:
        return Depth(offset: Offset(horizontal: 0, vertical: 0.5), opacity: 0.3, radius: 0.5)
	case .depth2:
        return Depth(offset: Offset(horizontal: 0, vertical: 1), opacity: 0.3, radius: 1)
	case .depth3:
        return Depth(offset: Offset(horizontal: 0, vertical: 2), opacity: 0.3, radius: 2)
	case .depth4:
        return Depth(offset: Offset(horizontal: 0, vertical: 4), opacity: 0.3, radius: 4)
	case .depth5:
        return Depth(offset: Offset(horizontal: 0, vertical: 8), opacity: 0.3, radius: 8)
	}
}
