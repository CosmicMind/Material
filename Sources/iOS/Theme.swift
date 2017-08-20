//
//  Theme.swift
//  Material
//
//  Created by Orkhan Alikhanov on 8/20/17.
//  Copyright © 2017 CosmicMind, Inc. All rights reserved.
//

import UIKit

open class Theme {
    fileprivate static let shared = Theme()
    fileprivate var themes: [String: [String: UIView]] = [:]
    
    fileprivate func `for`<T: UIView, C: UIView>(_ type: T.Type, in container: C.Type = UIView.self as! C.Type) -> T {
        let typeKey = NSStringFromClass(T.self)
        let containerKey = NSStringFromClass(C.self)
        if let themeView = themes[typeKey]?[containerKey] as? T {
            return themeView
        }
        
        if themes[typeKey] == nil {
            themes[typeKey] = [:]
        }
        
        let themeView = T()
        themes[typeKey]![containerKey] = themeView
        return themeView
    }
    
    fileprivate func applyTheme(to view: UIView) {
        func classHierarchy(of anyclass: AnyClass) -> [String] {
            var hierarchy: [String] = []
            var anyclass: AnyClass = anyclass
            while anyclass !== UIView.self {
                hierarchy.append(NSStringFromClass(anyclass))
                anyclass = class_getSuperclass(anyclass)!
            }
            return hierarchy
        }
        
        let hierarchy = classHierarchy(of: type(of: view))
        let containerKey = NSStringFromClass(UIView.self)         ///Currently only UIView.self
        var allKeyPaths: [String] = []
        hierarchy.reversed().forEach { typeKey in
            if let themeView = themes[typeKey]?[containerKey] {
                if let keyPaths = (NSClassFromString(typeKey) as? Themeable.Type)?.themeables {
                    allKeyPaths.append(contentsOf: keyPaths)
                    allKeyPaths.forEach { path in
                        if let value = themeView.value(forKeyPath: path) {
                            view.setValue(value, forKeyPath: path)
                        }
                    }
                }
            }
        }
    }
}


extension Theme {
    
    /// Returns a view of `type` in order to use as theming base
    ///
    /// - Parameters:
    ///   - type: Type of view to theme
    ///   - container: When contained in. Defaults to `UIView.self`. Note: currently not supported
    /// - Returns: View to theme
    open static func `for`<T: UIView, C: UIView>(_ type: T.Type, in container: C.Type = UIView.self as! C.Type) -> T {
        return shared.for(type, in: UIView.self)
    }
    
    /// Applies theme to view
    ///
    /// - Parameter view: view to apply theme to
    open static func applyTheme(to view: UIView) {
        return shared.applyTheme(to: view)
    }
}
