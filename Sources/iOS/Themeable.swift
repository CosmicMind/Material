//
//  Themeable.swift
//  Material
//
//  Created by Orkhan Alikhanov on 8/20/17.
//  Copyright © 2017 CosmicMind, Inc. All rights reserved.
//

import UIKit

public protocol Themeable {
    static var themeables: [String] { get }
    func applyTheming()
}


extension Themeable where Self: UIView {
    public func applyTheming() { Theme.applyTheme(to: self) }
}

