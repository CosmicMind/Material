//
//  Roboto.swift
//  MaterialKit
//
//  Created by Adam Dahan on 2015-08-22.
//  Copyright (c) 2015 GraphKit Inc. All rights reserved.
//

import UIKit

public struct Roboto {

    public static func lightWithSize(size: CGFloat) -> UIFont {
        if let light = UIFont(name: "Roboto-Light", size: size) {
            return light
        }
		return UIFont.systemFontOfSize(size)
    }
    
    public static func mediumWithSize(size: CGFloat) -> UIFont {
        if let light = UIFont(name: "Roboto-Medium", size: size) {
            return light
        }
		return UIFont.systemFontOfSize(size)
    }
    
    public static func regularWithSize(size: CGFloat) -> UIFont {
        if let light = UIFont(name: "Roboto-Regular", size: size) {
            return light
        }
		return UIFont.systemFontOfSize(size)
    }
}
