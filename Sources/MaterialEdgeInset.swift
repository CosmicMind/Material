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
*	*	Neither the name of Material nor the names of its
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

public enum MaterialEdgeInset {
	case None
	
	// square
	case Square1
	case Square2
	case Square3
	case Square4
	case Square5
	case Square6
	case Square7
	case Square8
	case Square9
	
	// rectangle
	case WideRectangle1
	case WideRectangle2
	case WideRectangle3
	case WideRectangle4
	case WideRectangle5
	case WideRectangle6
	case WideRectangle7
	case WideRectangle8
	case WideRectangle9
	
	// flipped rectangle
	case TallRectangle1
	case TallRectangle2
	case TallRectangle3
	case TallRectangle4
	case TallRectangle5
	case TallRectangle6
	case TallRectangle7
	case TallRectangle8
	case TallRectangle9
}

/// Converts the MaterialEdgeInset to a UIEdgeInsets value.
public func MaterialEdgeInsetToValue(inset: MaterialEdgeInset) -> UIEdgeInsets {
	switch inset {
	case .None:
		return UIEdgeInsetsZero
	
	// square
	case .Square1:
		return UIEdgeInsetsMake(4, 4, 4, 4)
	case .Square2:
		return UIEdgeInsetsMake(8, 8, 8, 8)
	case .Square3:
		return UIEdgeInsetsMake(16, 16, 16, 16)
	case .Square4:
		return UIEdgeInsetsMake(24, 24, 24, 24)
	case .Square5:
		return UIEdgeInsetsMake(32, 32, 32, 32)
	case .Square6:
		return UIEdgeInsetsMake(40, 40, 40, 40)
	case .Square7:
		return UIEdgeInsetsMake(48, 48, 48, 48)
	case .Square8:
		return UIEdgeInsetsMake(56, 56, 56, 56)
	case .Square9:
		return UIEdgeInsetsMake(64, 64, 64, 64)
	
	// rectangle
	case .WideRectangle1:
		return UIEdgeInsetsMake(2, 4, 2, 4)
	case .WideRectangle2:
		return UIEdgeInsetsMake(4, 8, 4, 8)
	case .WideRectangle3:
		return UIEdgeInsetsMake(8, 16, 8, 16)
	case .WideRectangle4:
		return UIEdgeInsetsMake(12, 24, 12, 24)
	case .WideRectangle5:
		return UIEdgeInsetsMake(16, 32, 16, 32)
	case .WideRectangle6:
		return UIEdgeInsetsMake(20, 40, 20, 40)
	case .WideRectangle7:
		return UIEdgeInsetsMake(24, 48, 24, 48)
	case .WideRectangle8:
		return UIEdgeInsetsMake(28, 56, 28, 56)
	case .WideRectangle9:
		return UIEdgeInsetsMake(32, 64, 32, 64)
		
	// flipped rectangle
	case .TallRectangle1:
		return UIEdgeInsetsMake(4, 2, 4, 2)
	case .TallRectangle2:
		return UIEdgeInsetsMake(8, 4, 8, 4)
	case .TallRectangle3:
		return UIEdgeInsetsMake(16, 8, 16, 8)
	case .TallRectangle4:
		return UIEdgeInsetsMake(24, 12, 24, 12)
	case .TallRectangle5:
		return UIEdgeInsetsMake(32, 16, 32, 16)
	case .TallRectangle6:
		return UIEdgeInsetsMake(40, 20, 40, 20)
	case .TallRectangle7:
		return UIEdgeInsetsMake(48, 24, 48, 24)
	case .TallRectangle8:
		return UIEdgeInsetsMake(56, 28, 56, 28)
	case .TallRectangle9:
		return UIEdgeInsetsMake(64, 32, 64, 32)
	}
}
