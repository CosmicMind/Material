//
//  CheckButtonGroup.swift
//  Material
//
//  Created by Orkhan Alikhanov on 12/24/17.
//  Copyright © 2017 CosmicMind, Inc. All rights reserved.
//

/// Lays out provided check buttons within itself.
///
/// Unlike RadioButtonGroup, checking one check button that belongs to a check group *does not* unchecks any previously checked
/// check button within the same group. Intially, all of the check buttons are unchecked.
///
/// The buttons are laid out by `Grid` system, so that changing properites of grid instance
/// (e.g interimSpace) are reflected.
open class CheckButtonGroup: BaseButtonGroup<CheckButton> {
    
    /// Initializes CheckButtonGroup with an array of check buttons each having
    /// title equal to corresponding string in the `titles` parameter.
    ///
    /// - Parameter titles: An array of title strings
    public convenience init(titles: [String]) {
        let buttons = titles.map { CheckButton(title: $0) }
        self.init(buttons: buttons)
    }
    
    /// Returns all selected check buttons within the group
    /// or empty array if none is seleceted.
    open var selecetedButtons: [CheckButton] {
        return buttons.filter { $0.isSelected }
    }
    
    /// Returns indexes of all selected check buttons within the group
    /// or empty array if none is seleceted.
    open var selectedIndices: [Int] {
        return selecetedButtons.map { buttons.index(of: $0)! }
    }
    
    open override func didTap(button: CheckButton, at index: Int) {
        button.setSelected(!button.isSelected, animated: true)
    }
}

