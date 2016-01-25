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

public enum MaterialEdgeInsetPreset {
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

/**
	:name:	MaterialEdgeInsetPresetToValue
*/
public func MaterialEdgeInsetPresetToValue(inset: MaterialEdgeInsetPreset) -> UIEdgeInsets {
	switch inset {
	case .None:
		return UIEdgeInsetsZero
	
	// square
	case .Square1:
		return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
	case .Square2:
		return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
	case .Square3:
		return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
	case .Square4:
		return UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
	case .Square5:
		return UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
	case .Square6:
		return UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
	case .Square7:
		return UIEdgeInsets(top: 48, left: 48, bottom: 48, right: 48)
	case .Square8:
		return UIEdgeInsets(top: 56, left: 56, bottom: 56, right: 56)
	case .Square9:
		return UIEdgeInsets(top: 64, left: 64, bottom: 64, right: 64)
	
	// rectangle
	case .WideRectangle1:
		return UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
	case .WideRectangle2:
		return UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
	case .WideRectangle3:
		return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
	case .WideRectangle4:
		return UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
	case .WideRectangle5:
		return UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
	case .WideRectangle6:
		return UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
	case .WideRectangle7:
		return UIEdgeInsets(top: 24, left: 48, bottom: 24, right: 48)
	case .WideRectangle8:
		return UIEdgeInsets(top: 28, left: 56, bottom: 28, right: 56)
	case .WideRectangle9:
		return UIEdgeInsets(top: 32, left: 64, bottom: 32, right: 64)
		
	// flipped rectangle
	case .TallRectangle1:
		return UIEdgeInsets(top: 4, left: 2, bottom: 4, right: 2)
	case .TallRectangle2:
		return UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
	case .TallRectangle3:
		return UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
	case .TallRectangle4:
		return UIEdgeInsets(top: 24, left: 12, bottom: 24, right: 12)
	case .TallRectangle5:
		return UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
	case .TallRectangle6:
		return UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20)
	case .TallRectangle7:
		return UIEdgeInsets(top: 48, left: 24, bottom: 48, right: 24)
	case .TallRectangle8:
		return UIEdgeInsets(top: 56, left: 28, bottom: 56, right: 28)
	case .TallRectangle9:
		return UIEdgeInsets(top: 64, left: 32, bottom: 64, right: 32)
	}
}
