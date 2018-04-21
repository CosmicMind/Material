/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

@objc(EdgeInsetsPreset)
public enum EdgeInsetsPreset: Int {
  case none
  
  // square
  case square1
  case square2
  case square3
  case square4
  case square5
  case square6
  case square7
  case square8
  case square9
  case square10
  case square11
  case square12
  case square13
  case square14
  case square15
  
  // rectangle
  case wideRectangle1
  case wideRectangle2
  case wideRectangle3
  case wideRectangle4
  case wideRectangle5
  case wideRectangle6
  case wideRectangle7
  case wideRectangle8
  case wideRectangle9
  
  // flipped rectangle
  case tallRectangle1
  case tallRectangle2
  case tallRectangle3
  case tallRectangle4
  case tallRectangle5
  case tallRectangle6
  case tallRectangle7
  case tallRectangle8
  case tallRectangle9
  
  /// horizontally
  case horizontally1
  case horizontally2
  case horizontally3
  case horizontally4
  case horizontally5
  
  /// vertically
  case vertically1
  case vertically2
  case vertically3
  case vertically4
  case vertically5
}

public typealias EdgeInsets = UIEdgeInsets

/// Converts the EdgeInsetsPreset to a Inset value.
public func EdgeInsetsPresetToValue(preset: EdgeInsetsPreset) -> EdgeInsets {
  switch preset {
  case .none:
    return .zero
    
  // square
  case .square1:
    return EdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
  case .square2:
    return EdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
  case .square3:
    return EdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
  case .square4:
    return EdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
  case .square5:
    return EdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
  case .square6:
    return EdgeInsets(top: 28, left: 28, bottom: 28, right: 28)
  case .square7:
    return EdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
  case .square8:
    return EdgeInsets(top: 36, left: 36, bottom: 36, right: 36)
  case .square9:
    return EdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
  case .square10:
    return EdgeInsets(top: 44, left: 44, bottom: 44, right: 44)
  case .square11:
    return EdgeInsets(top: 48, left: 48, bottom: 48, right: 48)
  case .square12:
    return EdgeInsets(top: 52, left: 52, bottom: 52, right: 52)
  case .square13:
    return EdgeInsets(top: 56, left: 56, bottom: 56, right: 56)
  case .square14:
    return EdgeInsets(top: 60, left: 60, bottom: 60, right: 60)
  case .square15:
    return EdgeInsets(top: 64, left: 64, bottom: 64, right: 64)
    
  // rectangle
  case .wideRectangle1:
    return EdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
  case .wideRectangle2:
    return EdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
  case .wideRectangle3:
    return EdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
  case .wideRectangle4:
    return EdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
  case .wideRectangle5:
    return EdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
  case .wideRectangle6:
    return EdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
  case .wideRectangle7:
    return EdgeInsets(top: 24, left: 48, bottom: 24, right: 48)
  case .wideRectangle8:
    return EdgeInsets(top: 28, left: 56, bottom: 28, right: 56)
  case .wideRectangle9:
    return EdgeInsets(top: 32, left: 64, bottom: 32, right: 64)
    
  // flipped rectangle
  case .tallRectangle1:
    return EdgeInsets(top: 4, left: 2, bottom: 4, right: 2)
  case .tallRectangle2:
    return EdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
  case .tallRectangle3:
    return EdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
  case .tallRectangle4:
    return EdgeInsets(top: 24, left: 12, bottom: 24, right: 12)
  case .tallRectangle5:
    return EdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
  case .tallRectangle6:
    return EdgeInsets(top: 40, left: 20, bottom: 40, right: 20)
  case .tallRectangle7:
    return EdgeInsets(top: 48, left: 24, bottom: 48, right: 24)
  case .tallRectangle8:
    return EdgeInsets(top: 56, left: 28, bottom: 56, right: 28)
  case .tallRectangle9:
    return EdgeInsets(top: 64, left: 32, bottom: 64, right: 32)
    
  /// horizontally
  case .horizontally1:
    return EdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
  case .horizontally2:
    return EdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
  case .horizontally3:
    return EdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
  case .horizontally4:
    return EdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
  case .horizontally5:
    return EdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    
  /// vertically
  case .vertically1:
    return EdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
  case .vertically2:
    return EdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
  case .vertically3:
    return EdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
  case .vertically4:
    return EdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
  case .vertically5:
    return EdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
  }
}
