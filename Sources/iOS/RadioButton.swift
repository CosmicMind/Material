//
//  RadioButton.swift
//  Material
//
//  Created by Orkhan Alikhanov on 8/27/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit

class RadioButton: Base {
    let centerDot = CALayer()
    let outerCircle = CALayer()
    
    override func prepare() {
        super.prepare()
        iconLayer.addSublayer(centerDot)
        iconLayer.addSublayer(outerCircle)
    }
    
    let percentageOfOuterCircleSizeToShrinkTo: CGFloat = 0.9
    let percentageOfOuterCircleWidthToStart: CGFloat = 1
    var outerCircleScaleToShrink: CATransform3D {
        let s = percentageOfOuterCircleSizeToShrinkTo
        return CATransform3DMakeScale(s, s, 1)
    }
    var centerDotScaleForMeeting: CATransform3D {
        let s = ((outerCircleDiameter - 2 * percentageOfOuterCircleWidthToStart * outerCircleBorderWidth) * percentageOfOuterCircleSizeToShrinkTo) / centerDotDiameter
        return CATransform3DMakeScale(s, s, 1)
    }
    
    var outerCircleFullBorderWidth: CGFloat {
        return (self.outerCircleDiameter / 2.0) * 1.1 //without multipling 1.1 a weird plus sign (+) appears sometimes.
    }
    
    var centerDotDiameter: CGFloat {
        return outerCircleDiameter / 2.0
    }
    
    var outerCircleDiameter: CGFloat {
        return sideLength// * (56.0 / 135.0)
    }
    
    var outerCircleBorderWidth: CGFloat {
        return outerCircleDiameter * 0.11
    }
    
    override func beforeFirstAnimation() {
        outerCircle.borderColor = (isSelected ? selectedColor : normalColor).cgColor
        if !isSelected {
            centerDot.backgroundColor = normalColor.cgColor
        }
    }
    
    override func firstAnimation() {
        outerCircle.transform = outerCircleScaleToShrink
        let to = isSelected ? outerCircleDiameter / 2.0 : outerCircleBorderWidth * percentageOfOuterCircleWidthToStart
        self.outerCircle.animate(#keyPath(CALayer.borderWidth),
                                 from: outerCircleBorderWidth,
                                 to: to,
                                 timingFunction: .easeIn)
        if !isSelected {
            self.centerDot.transform = centerDotScaleForMeeting
        }
    }
    
    override func beforeSecondAnimation() {
        self.centerDot.transform = isSelected ?  centerDotScaleForMeeting : .identity
        self.centerDot.backgroundColor = (isSelected ? selectedColor : .clear).cgColor

        if !isSelected {
            self.outerCircle.borderWidth = outerCircleFullBorderWidth
        }
    }
    
    override func secondAnimation() {
        outerCircle.transform = .identity
        let from = isSelected ? outerCircleBorderWidth * percentageOfOuterCircleWidthToStart : outerCircleFullBorderWidth
        outerCircle.animate(#keyPath(CALayer.borderWidth),
                                 from: from,
                                 to: outerCircleBorderWidth,
                                 timingFunction: .easeIn)
        if isSelected {
            centerDot.transform = .identity
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !isAnimating else { return }
        
        centerDot.frame = CGRect(x: centerDotDiameter / 2.0, y: centerDotDiameter / 2.0, width: centerDotDiameter, height: centerDotDiameter)
        outerCircle.frame.size = CGSize(width: outerCircleDiameter, height: outerCircleDiameter)
        centerDot.cornerRadius = centerDot.bounds.width / 2
        outerCircle.cornerRadius = outerCircleDiameter / 2
        outerCircle.borderWidth = outerCircleBorderWidth
    }
}
