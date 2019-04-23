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

@objc(InterimSpacePreset)
public enum InterimSpacePreset: Int {
  case none
  case interimSpace1
  case interimSpace2
  case interimSpace3
  case interimSpace4
  case interimSpace5
  case interimSpace6
  case interimSpace7
  case interimSpace8
  case interimSpace9
  case interimSpace10
  case interimSpace11
  case interimSpace12
  case interimSpace13
  case interimSpace14
  case interimSpace15
  case interimSpace16
  case interimSpace17
  case interimSpace18
}

public typealias InterimSpace = CGFloat

/// Converts the InterimSpacePreset enum to an InterimSpace value.
public func InterimSpacePresetToValue(preset: InterimSpacePreset) -> InterimSpace {
  switch preset {
  case .none:
    return 0
  case .interimSpace1:
    return 1
  case .interimSpace2:
    return 2
  case .interimSpace3:
    return 4
  case .interimSpace4:
    return 8
  case .interimSpace5:
    return 12
  case .interimSpace6:
    return 16
  case .interimSpace7:
    return 20
  case .interimSpace8:
    return 24
  case .interimSpace9:
    return 28
  case .interimSpace10:
    return 32
  case .interimSpace11:
    return 36
  case .interimSpace12:
    return 40
  case .interimSpace13:
    return 44
  case .interimSpace14:
    return 48
  case .interimSpace15:
    return 52
  case .interimSpace16:
    return 56
  case .interimSpace17:
    return 60
  case .interimSpace18:
    return 64
  }
}
