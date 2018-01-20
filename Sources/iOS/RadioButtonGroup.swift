//
//  RadioButtonGroup.swift
//  Material
//
//  Created by Orkhan Alikhanov on 12/24/17.
//  Copyright © 2017 CosmicMind, Inc. All rights reserved.
//


/// Lays out provided radio buttons within itself.
///
/// Checking one radio button that belongs to a radio group unchecks any previously checked
/// radio button within the same group. Intially, all of the radio buttons are unchecked.
///
/// The buttons are laid out by `Grid` system, so that changing properites of grid instance
/// (e.g interimSpace) are reflected.
open class RadioButtonGroup: BaseButtonGroup<RadioButton> {
    
    /// Initializes RadioButtonGroup with an array of radio buttons each having
    /// title equal to corresponding string in the `titles` parameter.
    ///
    /// - Parameter titles: An array of title strings.
    public convenience init(titles: [String]) {
        let buttons = titles.map { RadioButton(title: $0) }
        self.init(buttons: buttons)
    }
    
    /// Returns selected radio button within the group.
    /// If none is selected (e.g in initial state), nil is returned.
    open var selectedButton: RadioButton? {
        return buttons.first { $0.isSelected }
    }
    
    /// Returns index of selected radio button within the group.
    /// If none is selected (e.g in initial state), -1 is returned.
    open var selectedIndex: Int {
        guard let b = selectedButton else { return -1 }
        return buttons.index(of: b)!
    }
    
    open override func didTap(button: RadioButton, at index: Int) {
        let isAnimating = buttons.reduce(false) { $0 || $1.isAnimating }
        guard !isAnimating else { return }
        
        buttons.forEach { $0.setSelected($0 == button, animated: true) }
    }
}
