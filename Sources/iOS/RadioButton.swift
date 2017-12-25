//
//  RadioButton.swift
//  Material
//
//  Created by Orkhan Alikhanov on 12/22/18.
//  Copyright © 2017 CosmicMind. All rights reserved.
//

import UIKit

open class RadioButton: BaseIconLayerButton {
    class override var iconLayer: BaseIconLayer { return RadioBoxLayer() }
    
    open override func prepare() {
        super.prepare()
        
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    @objc
    private func didTap() {
        setSelected(true, animated: true)
    }
}

internal class RadioBoxLayer: BaseIconLayer {
    private let centerDot = CALayer()
    private let outerCircle = CALayer()
    
    override var selectedColor: UIColor {
        didSet {
            guard isSelected, isEnabled else { return }
            outerCircle.borderColor = selectedColor.cgColor
            centerDot.backgroundColor = selectedColor.cgColor
        }
    }
    
    override var normalColor: UIColor {
        didSet {
            guard !isSelected, isEnabled else { return }
            outerCircle.borderColor = normalColor.cgColor
        }
    }
    
    override var disabledColor: UIColor {
        didSet {
            guard !isEnabled else { return }
            outerCircle.borderColor = disabledColor.cgColor
            if isSelected { centerDot.backgroundColor = disabledColor.cgColor }
        }
    }
        
    override func prepare() {
        super.prepare()
        addSublayer(centerDot)
        addSublayer(outerCircle)
    }
    
    override func prepareForFirstAnimation() {
        outerCircle.borderColor = (isEnabled ? (isSelected ? selectedColor : normalColor) : disabledColor).cgColor
        if !isSelected {
            centerDot.backgroundColor = (isEnabled ? normalColor : disabledColor).cgColor
        }
        outerCircle.borderWidth = outerCircleBorderWidth
    }
    
    override func firstAnimation() {
        outerCircle.transform = outerCircleScaleToShrink
        let to = isSelected ? sideLength / 2.0 : outerCircleBorderWidth * percentageOfOuterCircleWidthToStart
        outerCircle.animate(#keyPath(CALayer.borderWidth), to: to)
        if !isSelected {
            centerDot.transform = centerDotScaleForMeeting
        }
    }
    
    override func prepareForSecondAnimation() {
        centerDot.transform = isSelected ? centerDotScaleForMeeting : .identity
        centerDot.backgroundColor = (isSelected ? (isEnabled ? selectedColor : disabledColor) : .clear).cgColor
        outerCircle.borderWidth = isSelected ? outerCircleBorderWidth * percentageOfOuterCircleWidthToStart : outerCircleFullBorderWidth
    }
    
    override func secondAnimation() {
        outerCircle.transform = .identity
        outerCircle.animate(#keyPath(CALayer.borderWidth), to: outerCircleBorderWidth)
        if isSelected {
            centerDot.transform = .identity
        }
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        guard !isAnimating else { return }
        
        centerDot.frame = CGRect(x: centerDotDiameter / 2.0, y: centerDotDiameter / 2.0, width: centerDotDiameter, height: centerDotDiameter)
        outerCircle.frame.size = CGSize(width: sideLength, height: sideLength)
        centerDot.cornerRadius = centerDot.bounds.width / 2
        outerCircle.cornerRadius = sideLength / 2
        outerCircle.borderWidth = outerCircleBorderWidth
    }
}

private extension RadioBoxLayer {
    var percentageOfOuterCircleSizeToShrinkTo: CGFloat { return 0.9 }
    var percentageOfOuterCircleWidthToStart: CGFloat { return 1 }
    
    var outerCircleScaleToShrink: CATransform3D {
        let s = percentageOfOuterCircleSizeToShrinkTo
        return CATransform3DMakeScale(s, s, 1)
    }
    var centerDotScaleForMeeting: CATransform3D {
        let s = ((sideLength - 2 * percentageOfOuterCircleWidthToStart * outerCircleBorderWidth) * percentageOfOuterCircleSizeToShrinkTo) / centerDotDiameter
        return CATransform3DMakeScale(s, s, 1)
    }
    
    var outerCircleFullBorderWidth: CGFloat {
        return (self.sideLength / 2.0) * 1.1 //without multipling 1.1 a weird plus sign (+) appears sometimes.
    }
    
    var centerDotDiameter: CGFloat { return sideLength / 2.0 }
    var outerCircleBorderWidth: CGFloat { return sideLength * 0.11 }
}
