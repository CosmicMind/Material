/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

public struct Application {
    /// An optional reference to the main UIWindow.
    public static var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    /// An optional reference to the top most view controller.
    public static var rootViewController: UIViewController? {
        return keyWindow?.rootViewController
    }
    
    /// A boolean indicating if the device is in Landscape mode.
    public static var isLandscape: Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }
    
    /// A boolean indicating if the device is in Portrait mode.
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
    
    /**
     A boolean that indicates based on iPhone rules if the
     status bar should be shown.
     */
    public static var shouldStatusBarBeHidden: Bool {
        return isLandscape && .phone == Device.userInterfaceIdiom
    }
    
    /// A reference to the user interface layout direction.
    public static var userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        return UIApplication.shared.userInterfaceLayoutDirection
    }
}
