/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

public struct Device {
	/// Gets the model name for the device.
	public static var model: String {
		var systemInfo = utsname()
		uname(&systemInfo)
		
		let machineMirror = Mirror(reflecting: systemInfo.machine)
		let identifier = machineMirror.children.reduce("") { (identifier, element) in
			guard let value = element.value as? Int8, value != 0 else {
				return identifier
			}
			return identifier + String(UnicodeScalar(UInt8(value)))
		}
		
		switch identifier {
		case "iPod5,1":										return "iPod Touch 5"
		case "iPod7,1":										return "iPod Touch 6"
		case "iPhone3,1", "iPhone3,2", "iPhone3,3":			return "iPhone 4"
		case "iPhone4,1":									return "iPhone 4s"
		case "iPhone5,1", "iPhone5,2":						return "iPhone 5"
		case "iPhone5,3", "iPhone5,4":						return "iPhone 5c"
		case "iPhone6,1", "iPhone6,2":						return "iPhone 5s"
		case "iPhone7,2":									return "iPhone 6"
		case "iPhone7,1":									return "iPhone 6 Plus"
		case "iPhone8,1":									return "iPhone 6s"
		case "iPhone8,2":									return "iPhone 6s Plus"
		case "iPhone8,4":									return "iPhone SE"
		case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":	return "iPad 2"
		case "iPad3,1", "iPad3,2", "iPad3,3":				return "iPad 3"
		case "iPad3,4", "iPad3,5", "iPad3,6":				return "iPad 4"
		case "iPad4,1", "iPad4,2", "iPad4,3":				return "iPad Air"
		case "iPad5,3", "iPad5,4":							return "iPad Air 2"
		case "iPad2,5", "iPad2,6", "iPad2,7":				return "iPad Mini"
		case "iPad4,4", "iPad4,5", "iPad4,6":				return "iPad Mini 2"
		case "iPad4,7", "iPad4,8", "iPad4,9":				return "iPad Mini 3"
		case "iPad5,1", "iPad5,2":							return "iPad Mini 4"
		case "iPad6,3", "iPad6,4":							return "iPad Pro 9.7-inch"
		case "iPad6,7", "iPad6,8":							return "iPad Pro 12.9-inch"
		case "AppleTV5,3":									return "Apple TV"
		case "i386", "x86_64":								return "Simulator"
		default:											return identifier
		}
	}
    
    /// Retrieves the current device type.
	public static var userInterfaceIdiom: UIUserInterfaceIdiom {
		return UIDevice.current.userInterfaceIdiom
	}
	
	/// A Boolean indicating if the device is in Landscape mode.
	public static var isLandscape: Bool {
		return UIApplication.shared.statusBarOrientation.isLandscape
	}
	
	/// A Boolean indicating if the device is in Portrait mode.
	public static var isPortrait: Bool {
		return !isLandscape
	}
	
	/// The current UIInterfaceOrientation value.
	public static var orientation: UIInterfaceOrientation {
		return UIApplication.shared.statusBarOrientation
	}
	
	/// Retrieves the device status bar style.
	public static var statusBarStyle: UIStatusBarStyle {
		get {
            return UIApplication.shared.statusBarStyle
		}
		set(value) {
			UIApplication.shared.statusBarStyle = value
		}
	}
	
	/// Retrieves the device status bar hidden state.
	public static var isStatusBarHidden: Bool {
		get {
            return UIApplication.shared.isStatusBarHidden
		}
		set(value) {
			UIApplication.shared.isStatusBarHidden = value
		}
	}
	
	/// Retrieves the device bounds.
	public static var bounds: CGRect {
		return UIScreen.main.bounds
	}
	
	/// Retrieves the device width.
	public static var width: CGFloat {
		return bounds.width
	}
	
	/// Retrieves the device height.
	public static var height: CGFloat {
		return bounds.height
	}
	
	/// Retrieves the device scale.
	public static var scale: CGFloat {
		return UIScreen.main.scale
	}
}
