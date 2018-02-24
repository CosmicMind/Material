//
//  HeaderPickerContainer.swift
//  Material
//
//  Created by Orkhan Alikhanov on 2/8/18.
//  Copyright © 2018 CosmicMind, Inc. All rights reserved.
//

import UIKit

open class HeaderPickerContainer: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    private let headerContainer = UIView()
    open var header = TimePickerHeaderView()
    open var timePicker = TimePickerView()
    
    
    open func prepare() {
        headerContainer.addSubview(header)
        addSubview(headerContainer)
        addSubview(timePicker)
        
        headerContainer.backgroundColor = Color.blue.base
        
        timePicker.addTarget(self, action: #selector(timePickerTimeUpdated), for: .valueChanged)
        header.addTarget(self, action: #selector(headerShowingMinutesUpdated), for: .valueChanged)
        timePickerTimeUpdated()
    }
    
    @objc
    private func timePickerTimeUpdated() {
        header.time = timePicker.time
        header.isShowingMinutes = timePicker.isShowingMinutes
        layoutSubviews()
    }
    
    @objc
    private func headerShowingMinutesUpdated() {
        timePicker.setShowingMinutes(header.isShowingMinutes, animated: true)
    }
    
    open override var intrinsicContentSize: CGSize {
        let s = Constants.picker.size
        let i = Constants.picker.insets
        let headH = isLandscape ? 0 : Constants.header.height
        let sideW = isLandscape ? Constants.header.width : 0
        
        return CGSize(width: sideW + s.width + i.left + i.right,
                      height: headH + s.height + i.top + i.bottom)
    }
    
    var isLandscape = false {
        didSet {
            header.isLandscape = isLandscape
        }
    }
    var extraH: CGFloat = 0
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let s = Constants.picker.size
        let i = Constants.picker.insets
        let headH = isLandscape ? 0 : Constants.header.height
        let sideW = isLandscape ? Constants.header.width : 0
        
        headerContainer.frame = bounds
        if isLandscape {
            headerContainer.frame.size.width = sideW
            headerContainer.frame.size.height += extraH
        } else {
            headerContainer.frame.size.height = headH
        }
        
        
        timePicker.frame = CGRect(x: sideW + i.left,
                                  y: headH + i.top,
                                  width: s.width,
                                  height: s.height)
        
        header.frame.size = header.intrinsicContentSize
        header.layoutSubviews()
        let y = isLandscape ? center.y : headH / 2
        let x = isLandscape ? sideW / 2 : center.x
        header.colonCenter = CGPoint(x: x, y: y)
    }
    
    private struct Constants {
        struct picker {
            static let size = CGSize(width: 200, height: 200)
            static let insets = UIEdgeInsets(top: 24, left: 20, bottom: 0, right: 20)
        }
        
        struct header {
            static let height: CGFloat = 70
            static let width: CGFloat = 150
        }
    }
    
}
