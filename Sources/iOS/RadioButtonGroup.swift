//
//  RadioButtonGroup.swift
//  Material
//
//  Created by Orkhan Alikhanov on 12/24/17.
//  Copyright © 2017 CosmicMind, Inc. All rights reserved.
//

open class RadioButtonGroup: BaseButtonGroup<RadioButton> {
    public convenience init(titles: [String]) {
        let buttons = titles.map { RadioButton(title: $0) }
        self.init(buttons: buttons)
    }
    
    open var selectedButton: RadioButton? {
        return buttons.first { $0.isSelected }
    }
    
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
