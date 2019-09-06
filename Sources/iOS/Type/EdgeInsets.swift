/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
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
    return EdgeInsets(square: 4)
  case .square2:
    return EdgeInsets(square: 8)
  case .square3:
    return EdgeInsets(square: 16)
  case .square4:
    return EdgeInsets(square: 20)
  case .square5:
    return EdgeInsets(square: 24)
  case .square6:
    return EdgeInsets(square: 28)
  case .square7:
    return EdgeInsets(square: 32)
  case .square8:
    return EdgeInsets(square: 36)
  case .square9:
    return EdgeInsets(square: 40)
  case .square10:
    return EdgeInsets(square: 44)
  case .square11:
    return EdgeInsets(square: 48)
  case .square12:
    return EdgeInsets(square: 52)
  case .square13:
    return EdgeInsets(square: 56)
  case .square14:
    return EdgeInsets(square: 60)
  case .square15:
    return EdgeInsets(square: 64)
    
  // rectangle
  case .wideRectangle1:
    return EdgeInsets(vertical: 2, horizontal: 4)
  case .wideRectangle2:
    return EdgeInsets(vertical: 4, horizontal: 8)
  case .wideRectangle3:
    return EdgeInsets(vertical: 8, horizontal: 16)
  case .wideRectangle4:
    return EdgeInsets(vertical: 12, horizontal: 24)
  case .wideRectangle5:
    return EdgeInsets(vertical: 16, horizontal: 32)
  case .wideRectangle6:
    return EdgeInsets(vertical: 20, horizontal: 40)
  case .wideRectangle7:
    return EdgeInsets(vertical: 24, horizontal: 48)
  case .wideRectangle8:
    return EdgeInsets(vertical: 28, horizontal: 56)
  case .wideRectangle9:
    return EdgeInsets(vertical: 32, horizontal: 64)
    
  // flipped rectangle
  case .tallRectangle1:
    return EdgeInsets(vertical: 4, horizontal: 2)
  case .tallRectangle2:
    return EdgeInsets(vertical: 8, horizontal: 4)
  case .tallRectangle3:
    return EdgeInsets(vertical: 16, horizontal: 8)
  case .tallRectangle4:
    return EdgeInsets(vertical: 24, horizontal: 12)
  case .tallRectangle5:
    return EdgeInsets(vertical: 32, horizontal: 16)
  case .tallRectangle6:
    return EdgeInsets(vertical: 40, horizontal: 20)
  case .tallRectangle7:
    return EdgeInsets(vertical: 48, horizontal: 24)
  case .tallRectangle8:
    return EdgeInsets(vertical: 56, horizontal: 28)
  case .tallRectangle9:
    return EdgeInsets(vertical: 64, horizontal: 32)
    
  /// horizontally
  case .horizontally1:
    return EdgeInsets(horizontal: 2)
  case .horizontally2:
    return EdgeInsets(horizontal: 4)
  case .horizontally3:
    return EdgeInsets(horizontal: 8)
  case .horizontally4:
    return EdgeInsets(horizontal: 16)
  case .horizontally5:
    return EdgeInsets(horizontal: 24)
    
  /// vertically
  case .vertically1:
    return EdgeInsets(vertical: 2)
  case .vertically2:
    return EdgeInsets(vertical: 4)
  case .vertically3:
    return EdgeInsets(vertical: 8)
  case .vertically4:
    return EdgeInsets(vertical: 16)
  case .vertically5:
    return EdgeInsets(vertical: 24)
  }
}

public extension EdgeInsets {
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    init(vertical: CGFloat) {
        self.init(top: vertical, left: 0, bottom: vertical, right: 0)
    }

    init(horizontal: CGFloat) {
        self.init(top: 0, left: horizontal, bottom: 0, right: horizontal)
    }
    
    init(square: CGFloat) {
        self.init(top: square, left: square, bottom: square, right: square)
    }
}
