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

@objc(DeviceModel)
public enum DeviceModel: Int {
  case iPodTouch5
  case iPodTouch6
  case iPhone4
  case iPhone4s
  case iPhone5
  case iPhone5c
  case iPhone5s
  case iPhone6
  case iPhone6Plus
  case iPhone6s
  case iPhone6sPlus
  case iPhone7
  case iPhone7Plus
  case iPhone8
  case iPhone8Plus
  case iPhoneX
  case iPhoneXS
  case iPhoneXSMax
  case iPhoneXR
  case iPhoneSE
  case iPad2
  case iPad3
  case iPad4
  case iPadAir
  case iPadAir2
  case iPadMini
  case iPadMini2
  case iPadMini3
  case iPadMini4
  case iPadPro
  case iPadProLarge
  case iPad5
  case iPadPro2
  case iPadProLarge2
  case iPad6
  case iPadPro3       //iPad Pro (11-inch)
  case iPadProLarge3  //iPad Pro (12.9-inch) (3rd generation)
  case appleTv
  case appleTv4k
  case homePod
  case simulator
  case unknown
}

public struct Device {
  /// Gets the Device identifier String.
  public static var identifier: String {
    var systemInfo = utsname()
    uname(&systemInfo)
    
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { (identifier, element) in
      guard let value = element.value as? Int8, value != 0 else {
        return identifier
      }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier
  }
  
  /// Gets the model name for the device.
  public static var model: DeviceModel {
    switch identifier {
    case "iPod5,1":                                     return .iPodTouch5
    case "iPod7,1":                                     return .iPodTouch6
    case "iPhone4,1":                                   return .iPhone4s
    case "iPhone5,1", "iPhone5,2":                      return .iPhone5
    case "iPhone5,3", "iPhone5,4":                      return .iPhone5c
    case "iPhone6,1", "iPhone6,2":                      return .iPhone5s
    case "iPhone7,2":                                   return .iPhone6
    case "iPhone7,1":                                   return .iPhone6Plus
    case "iPhone8,1":                                   return .iPhone6s
    case "iPhone8,2":                                   return .iPhone6sPlus
    case "iPhone8,3", "iPhone8,4":                      return .iPhoneSE
    case "iPhone9,1", "iPhone9,3":                      return .iPhone7
    case "iPhone9,2", "iPhone9,4":                      return .iPhone7Plus
    case "iPhone10,1", "iPhone10,4":                    return .iPhone8
    case "iPhone10,2", "iPhone10,5":                    return .iPhone8Plus
    case "iPhone10,3","iPhone10,6":                     return .iPhoneX
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":    return .iPad2
    case "iPad3,1", "iPad3,2", "iPad3,3":               return .iPad3
    case "iPad3,4", "iPad3,5", "iPad3,6":               return .iPad4
    case "iPad4,1", "iPad4,2", "iPad4,3":               return .iPadAir
    case "iPad5,3", "iPad5,4":                          return .iPadAir2
    case "iPad2,5", "iPad2,6", "iPad2,7":               return .iPadMini
    case "iPad4,4", "iPad4,5", "iPad4,6":               return .iPadMini2
    case "iPad4,7", "iPad4,8", "iPad4,9":               return .iPadMini3
    case "iPad5,1", "iPad5,2":                          return .iPadMini4
    case "iPad6,3", "iPad6,4":                          return .iPadPro
    case "iPad6,7", "iPad6,8":                          return .iPadProLarge
    case "iPad6,11", "iPad6,12":                        return .iPad5
    case "iPad7,3", "iPad7,4":                          return .iPadPro2
    case "iPad7,1", "iPad7,2":                          return .iPadProLarge2
    case "iPad7,5", "iPad7,6":                          return .iPad6
    case "i386", "x86_64":                              return .simulator
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":         return .iPhone4
    case "iPhone11,2":                                  return .iPhoneXS
    case "iPhone11,4", "iPhone11,6":                    return .iPhoneXSMax
    case "iPhone11,8":                                  return .iPhoneXR
    case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":   return .iPadPro3
    case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":   return .iPadProLarge3
    case "AppleTV5,3":                                  return .appleTv
    case "AppleTV6,2":                                  return .appleTv4k
    case "AudioAccessory1,1":                           return .homePod
    default:                                            return .unknown
    }
  }
  
  /// Retrieves the current device type.
  public static var userInterfaceIdiom: UIUserInterfaceIdiom {
    return UIDevice.current.userInterfaceIdiom
  }
}


public func ==(lhs: DeviceModel, rhs: DeviceModel) -> Bool {
  return lhs.rawValue == rhs.rawValue
}

public func !=(lhs: DeviceModel, rhs: DeviceModel) -> Bool {
  return lhs.rawValue != rhs.rawValue
}

