//
//  Base.swift
//  Material
//
//  Created by Orkhan Alikhanov on 8/29/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit

class Base: UIControl {
    let titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    let iconLayer = CALayer()
    var selectedColor = UIColor(red: 0.25, green: 0.32, blue: 0.71, alpha: 1.0)
    var normalColor = UIColor.gray
    
    func prepare() {
        layer.addSublayer(iconLayer)
        self.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        
        beforeFirstAnimation()
        firstAnimation()
        beforeSecondAnimation()
        secondAnimation()
    }

    @objc
    func didTap() {
        self.isSelected = !self.isSelected
        self.animate()
    }
    
    var sideLength: CGFloat { return frame.height }
    
    override var intrinsicContentSize: CGSize { return CGSize(width: 132, height: 132) }
    
    func beforeFirstAnimation() {}
    func firstAnimation() {}
    
    func beforeSecondAnimation() {}
    func secondAnimation() {}
    
    var isAnimating = false
    
    let totalDuration: TimeInterval = 0.5
    let delayFactor: TimeInterval = 0.33
    var duration: TimeInterval { return totalDuration / (1.0 + delayFactor + 1.0) }
    func animate() {
      beforeFirstAnimation()
      UIView.animate(withDuration: duration,
                     delay: 0.0,
                     options: [UIViewAnimationOptions.curveEaseInOut],
                     animations: {
                      self.isAnimating = true
                      self.firstAnimation()
      }) { _ in
        UIView.performWithoutAnimation {
          self.beforeSecondAnimation()
        }
        UIView.animate(withDuration: self.duration,
                       delay: self.duration * self.delayFactor,
                       options: [UIViewAnimationOptions.curveEaseInOut],
                       animations: {
                        self.secondAnimation()
        }, completion: {_ in self.isAnimating = false })
      }
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = CGSize(width: sideLength, height: sideLength)
        self.iconLayer.frame.size = size
   }
}
