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
        return UIFont(name: "Roboto-Light", size: size)!
    }
    
    public static func mediumWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size)!
    }
    
    public static func regularWithSize(size: CGFloat) -> UIFont {
        var fonts = UIFont.fontNamesForFamilyName("Roboto")
        println(fonts)
        
        return UIFont(name: "Arial", size: size)!
    }
}
