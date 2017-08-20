//
//  ThemeTests.swift
//  Material.Tests
//
//  Created by Orkhan Alikhanov on 8/20/17.
//  Copyright © 2017 CosmicMind, Inc. All rights reserved.
//

import XCTest
@testable import Material
        import Foundation

class ThemeTests: XCTestCase {
    func testExample() {
        let ViewTheme = Theme.for(View.self)
        ViewTheme.backgroundColor = .red
        
        XCTAssertEqual(View().backgroundColor, .red)
        XCTAssertEqual(FABMenuItem().backgroundColor, .red, "Should inherit background color from View")
        
        let FABMenuItemTheme = Theme.for(FABMenuItem.self)
        FABMenuItemTheme.backgroundColor = .green
        FABMenuItemTheme.titleLabel.textColor = .blue
        XCTAssertEqual(FABMenuItem().backgroundColor, .green)
        XCTAssertEqual(FABMenuItem().titleLabel.textColor, .blue)
    }
    
}
