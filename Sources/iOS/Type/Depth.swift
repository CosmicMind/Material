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

public enum DepthPreset {
  case none
  case depth1
  case depth2
  case depth3
  case depth4
  case depth5
  indirect case above(DepthPreset)
  indirect case below(DepthPreset)
  indirect case left(DepthPreset)
  indirect case right(DepthPreset)
  
  /// Returns raw depth value without considering direction.
  public var rawValue: DepthPreset {
    switch self {
    case .above(let v):
      return v.rawValue
    case .below(let v):
      return v.rawValue
    case .left(let v):
      return v.rawValue
    case .right(let v):
      return v.rawValue
    default:
      return self
    }
  }
}

public struct Depth {
  /// Offset.
  public var offset: Offset
  
  /// Opacity.
  public var opacity: Float
  
  /// Radius.
  public var radius: CGFloat
  
  /// A tuple of raw values.
  public var rawValue: (CGSize, Float, CGFloat) {
    return (offset.asSize, opacity, radius)
  }
  
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
   - Parameter offset: A UIOffset.
   - Parameter opacity: A Float.
   - Parameter radius: A CGFloat.
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
  case .above(let preset):
    var v = DepthPresetToValue(preset: preset)
    if preset.isRoot {
      v.offset.vertical *= -1
    } else {
      let value = DepthPresetToValue(preset: preset.rawValue)
      v.offset.vertical -= value.offset.vertical
    }
    return v
  case .below(let preset):
    var v = DepthPresetToValue(preset: preset)
    if preset.isRoot {
      return v
    } else {
      let value = DepthPresetToValue(preset: preset.rawValue)
      v.offset.vertical += value.offset.vertical
    }
    return v
  case .left(let preset):
    var v = DepthPresetToValue(preset: preset)
    if preset.isRoot {
      v.offset.horizontal = -v.offset.vertical
      v.offset.vertical = 0
    } else {
      let value = DepthPresetToValue(preset: preset.rawValue)
      v.offset.horizontal -= value.offset.vertical
    }
    return v
  case .right(let preset):
    var v = DepthPresetToValue(preset: preset)
    if preset.isRoot {
      v.offset.horizontal = v.offset.vertical
      v.offset.vertical = 0
    } else {
      let value = DepthPresetToValue(preset: preset.rawValue)
      v.offset.horizontal += value.offset.vertical
    }
    return v
  }
}

fileprivate extension DepthPreset {
  /// Checks if the preset is the root value (has no direction).
  var isRoot: Bool {
    switch self {
    case .above(_):
      return false
    case .below(_):
      return false
    case .left(_):
      return false
    case .right(_):
      return false
    default:
      return true
    }
  }
}
