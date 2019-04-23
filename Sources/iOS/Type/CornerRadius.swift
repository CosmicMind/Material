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

@objc(CornerRadiusPreset)
public enum CornerRadiusPreset: Int {
  case none
  case cornerRadius1
  case cornerRadius2
  case cornerRadius3
  case cornerRadius4
  case cornerRadius5
  case cornerRadius6
  case cornerRadius7
  case cornerRadius8
  case cornerRadius9
}

/// Converts the CornerRadiusPreset enum to a CGFloat value.
public func CornerRadiusPresetToValue(preset: CornerRadiusPreset) -> CGFloat {
  switch preset {
  case .none:
    return 0
  case .cornerRadius1:
    return 2
  case .cornerRadius2:
    return 4
  case .cornerRadius3:
    return 8
  case .cornerRadius4:
    return 12
  case .cornerRadius5:
    return 16
  case .cornerRadius6:
    return 20
  case .cornerRadius7:
    return 24
  case .cornerRadius8:
    return 28
  case .cornerRadius9:
    return 32
  }
}
