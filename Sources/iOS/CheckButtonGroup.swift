//
//  CheckButtonGroup.swift
//  Material
//
//  Created by Orkhan Alikhanov on 12/24/17.
//  Copyright © 2017 CosmicMind, Inc. All rights reserved.
//

open class CheckButtonGroup: BaseButtonGroup<CheckButton> {
    public convenience init(titles: [String]) {
        let buttons = titles.map { CheckButton(title: $0) }
        self.init(buttons: buttons)
    }
    
    open var selecetedButtons: [CheckButton] {
        return buttons.filter { $0.isSelected }
    }
    
    open var selectedIndices: [Int] {
        return selecetedButtons.map { buttons.index(of: $0)! }
    }
    
    open override func didTap(button: CheckButton, at index: Int) {
        button.setSelected(!button.isSelected, animated: true)
    }
}

