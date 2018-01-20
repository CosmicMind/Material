//
//  BaseIconLayerButton.swift
//  Material
//
//  Created by Orkhan Alikhanov on 12/22/18.
//  Copyright © 2017 CosmicMind. All rights reserved.
//

import UIKit
import Motion

/// Implements common logic for CheckButton and RadioButton
open class BaseIconLayerButton: Button {
    class var iconLayer: BaseIconLayer { fatalError("Has to be implemented by subclasses") }
    lazy var iconLayer: BaseIconLayer = type(of: self).iconLayer
    
    /// A Boolean value indicating whether the button is in the selected state
    ///
    /// Use `setSelected(_:, animated:)` if the state change needs to be animated
    open override var isSelected: Bool {
        didSet {
            iconLayer.setSelected(isSelected, animated: false)
        }
    }
    
    /// A Boolean value indicating whether the control is enabled.
    open override var isEnabled: Bool {
        didSet {
            iconLayer.isEnabled = isEnabled
        }
    }
    
    
    /// Sets the color of the icon to use for the specified state.
    ///
    /// - Parameters:
    ///   - color: The color of the icon to use for the specified state.
    ///   - state: The state that uses the specified color. Supports only (.normal, .selected, .disabled)
    open func setIconColor(_ color: UIColor, for state: UIControlState) {
        switch state {
        case .normal:
            iconLayer.normalColor = color
        case .selected:
            iconLayer.selectedColor = color
        case .disabled:
            iconLayer.disabledColor = color
        default:
            fatalError("unsupported state")
        }
    }
    
    /// Returns the icon color used for a state.
    ///
    /// - Parameter state: The state that uses the icon color. Supports only (.normal, .selected, .disabled)
    /// - Returns: The color of the title for the specified state.
    open func iconColor(for state: UIControlState) -> UIColor {
        switch state {
        case .normal:
            return iconLayer.normalColor
        case .selected:
            return iconLayer.selectedColor
        case .disabled:
            return iconLayer.disabledColor
        default:
            fatalError("unsupported state")
        }
    }
    
    /// A Boolean value indicating whether the button is being animated
    open var isAnimating: Bool { return iconLayer.isAnimating }
    
    
    /// Sets the `selected` state of the button, optionally animating the transition.
    ///
    /// - Parameters:
    ///   - isSelected: A Boolean value indicating new `selected` state
    ///   - animated: true if the state change should be animated, otherwise false.
    open func setSelected(_ isSelected: Bool, animated: Bool) {
        guard !isAnimating else { return }
        iconLayer.setSelected(isSelected, animated: animated)
        self.isSelected = isSelected
    }
    
    open override func prepare() {
        super.prepare()
        layer.addSublayer(iconLayer)

        // we push the title to the right to make room for iconLayer
        // `contentEdgeInsets` is used to let default implementation of
        // `intrinsicContentSize` consider our titleSpacing
        let titleSpacing = (margin + iconSize + margin) / 2
        titleEdgeInsets = UIEdgeInsets(top: 0, left: titleSpacing, bottom: 0, right: -titleSpacing)
        contentEdgeInsets = UIEdgeInsets(top: margin, left: titleSpacing, bottom: margin, right: titleSpacing)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // pulse.animation set to .none so that when we call `super.touchesBegan`
        // pulse will not expand as there is a `guard` against .none case
        pulse.animation = .none
        super.touchesBegan(touches, with: event)
        pulse.animation = .point
        
        // expand pulse from the center of iconLayer/visualLayer (`point` is relative to self.view/self.layer)
        pulse.expand(point: iconLayer.frame.center)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // positioning iconLayer
        iconLayer.frame.size = CGSize(width: iconSize, height: iconSize)
        iconLayer.frame.origin.y = bounds.height / 2 - iconSize / 2
        iconLayer.frame.origin.x = margin
        
        
        // visualLayer is the layer where pulse layer is expanding.
        // So we position it at the center of iconLayer, and make it
        // small circle, so that the expansion of pulse layer is clipped off
        let s = margin + iconSize + margin // considering margin as well
        visualLayer.bounds.size = CGSize(width: s, height: s)
        visualLayer.frame.center = iconLayer.frame.center
        visualLayer.cornerRadius = s / 2
    }
    
    private let margin: CGFloat = 5
    private let iconSize: CGFloat = 16
}

// MARK: - BaseIconLayer

internal class BaseIconLayer: CALayer {
    var selectedColor = Color.blue.base
    var normalColor = Color.lightGray
    var disabledColor = Color.gray
    
    
    func prepareForFirstAnimation() {}
    func firstAnimation() {}
    
    func prepareForSecondAnimation() {}
    func secondAnimation() {}
    
    private(set) var isAnimating = false
    private(set) var isSelected = false
    var isEnabled = true {
        didSet {
            selectedColor = { selectedColor }()
            normalColor = { normalColor }()
            disabledColor = { disabledColor }()
        }
    }
    
    override init() {
        super.init()
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    func prepare() {
        normalColor = { normalColor }() // calling didSet
        selectedColor = { selectedColor }() // calling didSet
    }
    
    func setSelected(_ isSelected: Bool, animated: Bool) {
        guard self.isSelected != isSelected, !isAnimating else { return }
        self.isSelected = isSelected
        
        if animated {
            animate()
        } else {
            Motion.disable {
                prepareForFirstAnimation()
                firstAnimation()
                prepareForSecondAnimation()
                secondAnimation()
            }
        }
    }
    
    private func animate() {
        guard !isAnimating else { return }
        
        prepareForFirstAnimation()
        Motion.animate(duration: Constants.partialDuration, timingFunction: .easeInOut, animations: {
            self.isAnimating = true
            self.firstAnimation()
        }, completion: {
            Motion.disable {
                self.prepareForSecondAnimation()
            }
            Motion.delay(Constants.partialDuration * Constants.delayFactor) {
                Motion.animate(duration: Constants.partialDuration, timingFunction: .easeInOut, animations: {
                    self.secondAnimation()
                }, completion: { self.isAnimating = false })
            }
        })
    }
    
    var sideLength: CGFloat { return frame.height }
    
    struct Constants {
        static let totalDuration = 0.5
        static let delayFactor = 0.33
        static let partialDuration = totalDuration / (1.0 + delayFactor + 1.0)
    }
}

// MARK: - Helper extension

private extension CGRect {
    var center: CGPoint {
        get {
            return CGPoint(x: minX + width / 2 , y: minY + height / 2)
        }
        set {
            origin = CGPoint(x: newValue.x - width / 2, y: newValue.y - height / 2)
        }
    }
}


internal extension CALayer {
    /// Animates the propery of CALayer from current value to the specified value
    /// and does not reset to the initial value after the animation finishes
    ///
    /// - Parameters:
    ///   - keyPath: Keypath to the animatable property of the layer
    ///   - to: Final value of the property
    ///   - dur: Duration of the animation in seconds. Defaults to 0, which results in taking the duration from enclosing CATransaction, or .25 seconds
    func animate(_ keyPath: String, to: CGFloat, dur: TimeInterval = 0) {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.timingFunction = .easeIn
        animation.fromValue = self.value(forKeyPath: keyPath) // from current value
        animation.duration = dur
        
        setValue(to, forKeyPath: keyPath)
        self.add(animation, forKey: nil)
    }
}

internal extension CATransform3D {
    static var identity: CATransform3D {
        return CATransform3DIdentity
    }
}

