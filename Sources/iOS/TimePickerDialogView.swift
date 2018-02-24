//
//  TimePickerDialogView.swift
//  Material
//
//  Created by Orkhan Alikhanov on 1/23/18.
//  Copyright © 2018 CosmicMind, Inc. All rights reserved.
//

import UIKit

open class TimePickerDialogView: DialogView {
    
    open let headerPickerContainer = HeaderPickerContainer()
    
    open override func prepare() {
        super.prepare()
        addSubview(headerPickerContainer)
    }
    
    open override func contentViewSizeThatFits(width: CGFloat) -> CGSize {
        headerPickerContainer.isLandscape = maxSize.width > maxSize.height
        headerPickerContainer.extraH = buttonAreaSizeThatFits(width: width).height
        return headerPickerContainer.intrinsicContentSize
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        headerPickerContainer.frame = contentView.bounds
    }
}
