//
//  CheckButton.swift
//  Material
//
//  Created by Orkhan Alikhanov on 12/22/18.
//  Copyright © 2017 CosmicMind. All rights reserved.
//

import UIKit

open class CheckButton: BaseIconLayerButton {
    class override var iconLayer: BaseIconLayer { return CheckBoxLayer() }
    
    /// Color of the checkmark (✓)
    open var checkmarkColor: UIColor {
        get {
            return (iconLayer as! CheckBoxLayer).checkmarkColor
        }
        set {
            (iconLayer as! CheckBoxLayer).checkmarkColor = newValue
        }
    }
    
    open override func prepare() {
        super.prepare()
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    @objc
    private func didTap() {
        guard !isAnimating else { return }
        setSelected(!isSelected, animated: true)
    }
}

internal class CheckBoxLayer: BaseIconLayer {
    var checkmarkColor: UIColor = .white {
        didSet {
            checkMarkLeftLayer.strokeColor = checkmarkColor.cgColor
            checkMarkRightLayer.strokeColor = checkmarkColor.cgColor
        }
    }
    let borderLayer = CALayer()
    let checkMarkLeftLayer = CAShapeLayer()
    let checkMarkRightLayer = CAShapeLayer()
    let checkMarkLayer = CALayer()
    
    override var selectedColor: UIColor {
        didSet {
            guard isSelected, isEnabled else { return }
            borderLayer.borderColor = selectedColor.cgColor
            borderLayer.backgroundColor = selectedColor.cgColor
        }
    }
    
    override var normalColor: UIColor {
        didSet {
            guard !isSelected, isEnabled else { return }
            borderLayer.borderColor = normalColor.cgColor
        }
    }
    
    override var disabledColor: UIColor {
        didSet {
            guard !isEnabled else { return }
            borderLayer.borderColor =  disabledColor.cgColor
            if isSelected { borderLayer.backgroundColor = disabledColor.cgColor }
        }
    }
        
    open override func prepare() {
        super.prepare()
        addSublayer(borderLayer)
        addSublayer(checkMarkLayer)
        checkMarkLayer.addSublayer(checkMarkLeftLayer)
        checkMarkLayer.addSublayer(checkMarkRightLayer)
        checkMarkLeftLayer.lineCap = kCALineCapSquare
        checkMarkRightLayer.lineCap = kCALineCapSquare
        checkMarkLeftLayer.strokeEnd = 0
        checkMarkRightLayer.strokeEnd = 0
        checkmarkColor = { checkmarkColor }() // calling didSet
    }
    
    override func prepareForFirstAnimation() {
        borderLayer.borderColor = (isEnabled ? (isSelected ? selectedColor : normalColor) : disabledColor).cgColor
        if isSelected {
            borderLayer.borderWidth = borderLayerNormalBorderWidth
        } else {
            borderLayer.backgroundColor = (isEnabled ? normalColor : disabledColor).cgColor
            checkMarkLeftLayer.strokeEnd = 1
            checkMarkRightLayer.strokeEnd = 1
        }
        checkMarkLayer.transform = .identity
    }
    
    override func firstAnimation() {
        borderLayer.transform = borderLayerScaleToShrink
        checkMarkLayer.transform = borderLayerScaleToShrink
        if isSelected {
            borderLayer.animate(#keyPath(CALayer.borderWidth), to: borderLayerFullBorderWidth)
        } else {
            checkMarkLeftLayer.animate(#keyPath(CAShapeLayer.strokeEnd), to: 0)
            checkMarkRightLayer.animate(#keyPath(CAShapeLayer.strokeEnd), to: 0)
            
            checkMarkLayer.transform = CATransform3DMakeTranslation(sideLength / 2 - checkMarkStartPoint.x, -(checkMarkStartPoint.y - sideLength / 2), 0)
        }
    }
    
    override func prepareForSecondAnimation() {
        borderLayer.backgroundColor = (isSelected ? (isEnabled ? selectedColor : disabledColor) : .clear).cgColor
        
        if isSelected {
            borderLayer.borderWidth = borderLayerNormalBorderWidth
            checkMarkLeftLayer.strokeEnd = 0.0001
            checkMarkRightLayer.strokeEnd = 0.0001
            
            checkMarkLayer.opacity = 0
            checkMarkLayer.animate(#keyPath(CALayer.opacity), to: 1, dur: Constants.totalDuration * 0.1)
        } else {
            borderLayer.borderWidth = borderLayerCenterDotBorderWidth
        }
    }
    
    override func secondAnimation() {
        borderLayer.transform = .identity
        checkMarkLayer.transform = .identity
        if isSelected {
            checkMarkLeftLayer.animate(#keyPath(CAShapeLayer.strokeEnd), to: 1)
            checkMarkRightLayer.animate(#keyPath(CAShapeLayer.strokeEnd), to: 1)
        } else {
            borderLayer.animate(#keyPath(CALayer.borderWidth), to: borderLayerNormalBorderWidth)
        }
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        guard !isAnimating else { return }
        
        let s = CGSize(width: sideLength, height: sideLength)
        borderLayer.frame.size = s
        checkMarkLayer.frame.size = s
        checkMarkLeftLayer.frame.size = s
        checkMarkRightLayer.frame.size = s
        
        checkMarkLeftLayer.path = checkMarkPathLeft.cgPath
        checkMarkRightLayer.path = checkMarkPathRigth.cgPath
        checkMarkLeftLayer.lineWidth = lineWidth
        checkMarkRightLayer.lineWidth = lineWidth
        
        borderLayer.borderWidth = borderLayerNormalBorderWidth
        borderLayer.cornerRadius = borderLayerCornerRadius
    }
}

private extension CheckBoxLayer {
    var borderLayerFullBorderWidth: CGFloat { return sideLength / 2 * 1.1 } //without multipling 1.1 a weird plus sign (+) appears sometimes.
    var borderLayerCenterDotBorderWidth: CGFloat { return sideLength / 2 * 0.87 }
    var borderLayerNormalBorderWidth: CGFloat { return sideLength * 0.1 }
    var borderLayerCornerRadius: CGFloat { return sideLength * 0.1 }
    var borderLayerScalePercentageToShrink: CGFloat { return 0.9 }
    var borderLayerScaleToShrink: CATransform3D {
        return CATransform3DMakeScale(borderLayerScalePercentageToShrink, borderLayerScalePercentageToShrink, 1)
    }
    
    
    var checkMarkStartPoint: CGPoint {
        return CGPoint(x: sideLength * 14 / 36, y: sideLength * 25 / 36)
    }
    
    var checkMarkRightEndPoint: CGPoint {
        return CGPoint(x: sideLength - (sideLength * 6 / 36), y: sideLength * 9 / 36)
    }
    
    var checkMarkLeftEndPoint: CGPoint {
        return CGPoint(x: sideLength * 6 / 36, y: sideLength * 18 / 36)
    }
    
    var checkMarkPathRigth: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: checkMarkStartPoint)
        path.addLine(to: checkMarkRightEndPoint)
        return path
    }
    
    var checkMarkPathLeft: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: checkMarkStartPoint)
        path.addLine(to: checkMarkLeftEndPoint)
        return path
    }
    
    var lineWidth: CGFloat { return sideLength * 0.1 }
}
