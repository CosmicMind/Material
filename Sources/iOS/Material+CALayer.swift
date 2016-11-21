/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit

internal struct MaterialLayer {
    /// A reference to the CALayer.
    internal weak var layer: CALayer?
    
    /// A property that sets the height of the layer's frame.
    internal var heightPreset = HeightPreset.default {
        didSet {
            layer?.height = CGFloat(heightPreset.rawValue)
        }
    }
    
    /// A property that sets the cornerRadius of the backing layer.
    internal var cornerRadiusPreset = CornerRadiusPreset.none {
        didSet {
            layer?.cornerRadius = CornerRadiusPresetToValue(preset: cornerRadiusPreset)
        }
    }
    
    /// A preset property to set the borderWidth.
    internal var borderWidthPreset = BorderWidthPreset.none {
        didSet {
            layer?.borderWidth = BorderWidthPresetToValue(preset: borderWidthPreset)
        }
    }
    
    /// A preset property to set the shape.
    internal var shapePreset = ShapePreset.none {
        didSet {
            layer?.layoutShape()
        }
    }
    
    /// A preset value for Depth.
    internal var depthPreset: DepthPreset {
        get {
            return depth.preset
        }
        set(value) {
            depth.preset = value
        }
    }
    
    /// Grid reference.
    internal var depth = Depth.zero {
        didSet {
            guard let v = layer else {
                return
            }
            
            v.shadowOffset = depth.offset.asSize
            v.shadowOpacity = depth.opacity
            v.shadowRadius = depth.radius
            v.layoutShadowPath()
        }
    }
    
    /// Enables automatic shadowPath sizing.
    internal var isShadowPathAutoSizing = false
    
    /**
     Initializer that takes in a CALayer.
     - Parameter view: A CALayer reference.
     */
    internal init(layer: CALayer?) {
        self.layer = layer
    }
}

/// A memory reference to the MaterialLayer instance for CALayer extensions.
private var MaterialLayerKey: UInt8 = 0

/// Grid extension for UIView.
extension CALayer {
    /// MaterialLayer Reference.
    internal var materialLayer: MaterialLayer {
        get {
            return AssociatedObject(base: self, key: &MaterialLayerKey) {
                return MaterialLayer(layer: self)
            }
        }
        set(value) {
            AssociateObject(base: self, key: &MaterialLayerKey, value: value)
        }
    }
    
    /// A property that accesses the frame.origin.x property.
    @IBInspectable
    open var x: CGFloat {
        get {
            return frame.origin.x
        }
        set(value) {
            frame.origin.x = value
            
            layoutShadowPath()
        }
    }
    
    /// A property that accesses the frame.origin.y property.
    @IBInspectable
    open var y: CGFloat {
        get {
            return frame.origin.y
        }
        set(value) {
            frame.origin.y = value
            
            layoutShadowPath()
        }
    }
    
    /// A property that accesses the frame.size.width property.
    @IBInspectable
    open var width: CGFloat {
        get {
            return frame.size.width
        }
        set(value) {
            frame.size.width = value
            
            if .none != shapePreset {
                frame.size.height = value
                layoutShape()
            }
            
            layoutShadowPath()
        }
    }
    
    /// A property that accesses the frame.size.height property.
    @IBInspectable
    open var height: CGFloat {
        get {
            return frame.size.height
        }
        set(value) {
            frame.size.height = value
            
            if .none != shapePreset {
                frame.size.width = value
                layoutShape()
            }
            
            layoutShadowPath()
        }
    }
    
    /// HeightPreset value.
    open var heightPreset: HeightPreset {
        get {
            return materialLayer.heightPreset
        }
        set(value) {
            materialLayer.heightPreset = value
        }
    }
    
    /**
     A property that manages the overall shape for the object. If either the
     width or height property is set, the other will be automatically adjusted
     to maintain the shape of the object.
     */
    open var shapePreset: ShapePreset {
        get {
            return materialLayer.shapePreset
        }
        set(value) {
            materialLayer.shapePreset = value
        }
    }
    
    /// A preset value for Depth.
    open var depthPreset: DepthPreset {
        get {
            return depth.preset
        }
        set(value) {
            depth.preset = value
        }
    }
    
    /// Grid reference.
    open var depth: Depth {
        get {
            return materialLayer.depth
        }
        set(value) {
            materialLayer.depth = value
        }
    }
    
    /// Enables automatic shadowPath sizing.
    @IBInspectable
    open var isShadowPathAutoSizing: Bool {
        get {
            return materialLayer.isShadowPathAutoSizing
        }
        set(value) {
            materialLayer.isShadowPathAutoSizing = value
        }
    }
    
    /// A property that sets the cornerRadius of the backing layer.
    open var cornerRadiusPreset: CornerRadiusPreset {
        get {
            return materialLayer.cornerRadiusPreset
        }
        set(value) {
            materialLayer.cornerRadiusPreset = value
        }
    }
    
    /// A preset property to set the borderWidth.
    open var borderWidthPreset: BorderWidthPreset {
        get {
            return materialLayer.borderWidthPreset
        }
        set(value) {
            materialLayer.borderWidthPreset = value
        }
    }
    
    /**
     A method that accepts CAAnimation objects and executes them on the
     view's backing layer.
     - Parameter animation: A CAAnimation instance.
     */
    open func animate(animation: CAAnimation) {
        animation.delegate = self
        
        if let a = animation as? CABasicAnimation {
            a.fromValue = (nil == presentation() ? self : presentation()!).value(forKeyPath: a.keyPath!)
        }
        
        if let a = animation as? CAPropertyAnimation {
            add(a, forKey: a.keyPath!)
        } else if let a = animation as? CAAnimationGroup {
            add(a, forKey: nil)
        } else if let a = animation as? CATransition {
            add(a, forKey: kCATransition)
        }
    }
    
    /**
     A delegation method that is executed when the backing layer stops
     running an animation.
     - Parameter animation: The CAAnimation instance that stopped running.
     - Parameter flag: A boolean that indicates if the animation stopped
     because it was completed or interrupted. True if completed, false
     if interrupted.
     */
    open func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        guard let a = animation as? CAPropertyAnimation else {
            if let a = (animation as? CAAnimationGroup)?.animations {
                for x in a {
                    animationDidStop(x, finished: true)
                }
            }
            return
        }
        
        guard let b = a as? CABasicAnimation else {
            return
        }
        
        guard let v = b.toValue else {
            return
        }
        
        guard let k = b.keyPath else {
            return
        }
        
        setValue(v, forKeyPath: k)
        removeAnimation(forKey: k)
    }
    
    /// Manages the layout for the shape of the view instance.
    open func layoutShape() {
        guard 0 < width, 0 < height else {
            return
        }
        
        if .none != shapePreset {
            if width < height {
                frame.size.width = height
            } else if width > height {
                frame.size.height = width
            }
        }
        
        if .circle == shapePreset {
            cornerRadius = width / 2
        }
    }
    
    /// Sets the shadow path.
    open func layoutShadowPath() {
        guard isShadowPathAutoSizing else {
            return
        }
       
        if .none == depthPreset {
            shadowPath = nil
        } else if nil == shadowPath {
            shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            let a = Motion.shadowPath(to: UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath)
            a.fromValue = shadowPath
            animate(animation: a)
        }
    }
}

@available(iOS 10, *)
extension CALayer: CAAnimationDelegate {
    
}
