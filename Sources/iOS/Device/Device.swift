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

@objc(DeviceModel)
public enum DeviceModel: Int {
  case iPodTouch5
  case iPodTouch6
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

