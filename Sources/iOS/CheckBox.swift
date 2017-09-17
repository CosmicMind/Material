//
//  CheckBox.swift
//  Material
//
//  Created by Orkhan Alikhanov on 8/29/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit

class CheckBox: Base {
    let borderLayer = CALayer()
    var borderLayerFullBorderWidth: CGFloat { return sideLength / 2 * 1.1 } //without multipling 1.1 a weird plus sign (+) appears sometimes.
    var borderLayerCenterDotBorderWidth: CGFloat { return sideLength / 2 * 0.87 }
    var borderLayerNormalBorderWidth: CGFloat { return sideLength * 0.1 }
    var borderLayerCornerRadius: CGFloat { return sideLength * 0.1 }
    var borderLayerScalePercentageToShrink: CGFloat = 0.9
    var borderLayerScaleToShrink: CATransform3D {
        return CATransform3DMakeScale(borderLayerScalePercentageToShrink, borderLayerScalePercentageToShrink, 1)
    }
    
    var checkMarkLeftLayer = CAShapeLayer()
    var checkMarkRightLayer = CAShapeLayer()
    var checkMarkLayer = CALayer()
    
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
    
    var lineWidth: CGFloat {
        return sideLength * 0.1
    }
    
    var checkmarkColor: UIColor = .white
    
    override func prepare() {
        super.prepare()
        iconLayer.addSublayer(borderLayer)
        iconLayer.addSublayer(checkMarkLayer)
        checkMarkLayer.addSublayer(checkMarkLeftLayer)
        checkMarkLayer.addSublayer(checkMarkRightLayer)
        checkMarkLeftLayer.lineCap = kCALineCapSquare
        checkMarkRightLayer.lineCap = kCALineCapSquare
    }
    
    override func beforeFirstAnimation() {
        borderLayer.borderColor = (isSelected ? selectedColor : normalColor).cgColor
        if !isSelected {
            borderLayer.backgroundColor = normalColor.cgColor
        }
        checkMarkLayer.transform = .identity
    }
    
    override func firstAnimation() {
        borderLayer.transform = borderLayerScaleToShrink
        checkMarkLayer.transform = borderLayerScaleToShrink
        if isSelected {
            borderLayer.animate(#keyPath(CALayer.borderWidth),
                                from: borderLayerNormalBorderWidth,
                                to: borderLayerFullBorderWidth,
                                timingFunction: .easeIn)
        } else {
            checkMarkLeftLayer.animate(#keyPath(CAShapeLayer.strokeEnd),
                                       from: 1,
                                       to: 0,
                                       timingFunction: .easeIn)
            
            checkMarkRightLayer.animate(#keyPath(CAShapeLayer.strokeEnd),
                                        from: 1,
                                        to: 0,
                                        timingFunction: .easeIn)
            
            
            checkMarkLayer.transform = CATransform3DMakeTranslation(sideLength / 2 - checkMarkStartPoint.x, -(checkMarkStartPoint.y - sideLength / 2), 0)
        }
    }
    
    override func beforeSecondAnimation() {
        borderLayer.backgroundColor = (isSelected ? selectedColor : .clear).cgColor
        
        if isSelected {
            borderLayer.borderWidth = borderLayerNormalBorderWidth
            checkMarkLeftLayer.strokeEnd = 0.0001
            checkMarkRightLayer.strokeEnd = 0.0001
            checkMarkLayer.animate(#keyPath(CALayer.opacity),
                                   from: 0,
                                   to: 1,
                                   timingFunction: .easeIn,
                                   dur: totalDuration * 0.1)
            
            checkMarkLeftLayer.strokeColor = checkmarkColor.cgColor
            checkMarkRightLayer.strokeColor = checkmarkColor.cgColor
            checkMarkLeftLayer.path = checkMarkPathLeft.cgPath
            checkMarkRightLayer.path = checkMarkPathRigth.cgPath
            checkMarkLeftLayer.lineWidth = lineWidth
            checkMarkRightLayer.lineWidth = lineWidth
        } else {
            borderLayer.borderWidth = borderLayerCenterDotBorderWidth
        }
    }
    
    override func secondAnimation() {
        borderLayer.transform = .identity
        checkMarkLayer.transform = .identity
        if isSelected {
            checkMarkLeftLayer.animate(#keyPath(CAShapeLayer.strokeEnd),
                                       from: 0,
                                       to: 1,
                                       timingFunction: .easeIn)
            
            checkMarkRightLayer.animate(#keyPath(CAShapeLayer.strokeEnd),
                                        from: 0,
                                        to: 1,
                                        timingFunction: .easeIn)
        } else {
            borderLayer.animate(#keyPath(CALayer.borderWidth),
                                from: borderLayerCenterDotBorderWidth,
                                to: borderLayerNormalBorderWidth,
                                timingFunction: .easeIn)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !isAnimating else { return }
        
        borderLayer.frame.size = CGSize(width: sideLength, height: sideLength)
        checkMarkLayer.frame.size = borderLayer.frame.size
        checkMarkLeftLayer.frame.size = borderLayer.frame.size
        checkMarkRightLayer.frame.size = borderLayer.frame.size
        
        borderLayer.borderWidth = borderLayerNormalBorderWidth
        borderLayer.cornerRadius = borderLayerCornerRadius
    }
}
