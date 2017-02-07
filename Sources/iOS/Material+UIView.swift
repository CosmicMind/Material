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

/// Grid extension for UIView.
extension UIView {
    /// A property that accesses the backing layer's masksToBounds.
    @IBInspectable
    open var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set(value) {
            layer.masksToBounds = value
        }
    }
    
    /// A property that accesses the backing layer's opacity.
    @IBInspectable
    open var opacity: Float {
        get {
            return layer.opacity
        }
        set(value) {
            layer.opacity = value
        }
    }
    
    /// A property that accesses the backing layer's anchorPoint.
    @IBInspectable
    open var anchorPoint: CGPoint {
        get {
            return layer.anchorPoint
        }
        set(value) {
            layer.anchorPoint = value
        }
    }
    
    /// A property that accesses the frame.origin.x property.
    @IBInspectable
    open var x: CGFloat {
        get {
            return layer.x
        }
        set(value) {
            layer.x = value
        }
    }
    
    /// A property that accesses the frame.origin.y property.
    @IBInspectable
    open var y: CGFloat {
        get {
            return layer.y
        }
        set(value) {
            layer.y = value
        }
    }
    
    /// A property that accesses the frame.size.width property.
    @IBInspectable
    open var width: CGFloat {
        get {
            return layer.width
        }
        set(value) {
            layer.width = value
        }
    }
    
    /// A property that accesses the frame.size.height property.
    @IBInspectable
    open var height: CGFloat {
        get {
            return layer.height
        }
        set(value) {
            layer.height = value
        }
    }
    
    /// HeightPreset value.
    open var heightPreset: HeightPreset {
        get {
            return layer.heightPreset
        }
        set(value) {
            layer.heightPreset = value
        }
    }
    
    /**
     A property that manages the overall shape for the object. If either the
     width or height property is set, the other will be automatically adjusted
     to maintain the shape of the object.
     */
    open var shapePreset: ShapePreset {
        get {
            return layer.shapePreset
        }
        set(value) {
            layer.shapePreset = value
        }
    }
    
    /// A preset value for Depth.
    open var depthPreset: DepthPreset {
        get {
            return layer.depthPreset
        }
        set(value) {
            layer.depthPreset = value
        }
    }
    
    /// Depth reference.
    open var depth: Depth {
        get {
            return layer.depth
        }
        set(value) {
            layer.depth = value
        }
    }
    
    /// A property that accesses the backing layer's shadow
    @IBInspectable
    open var shadowColor: UIColor? {
        get {
            guard let v = layer.shadowColor else {
                return nil
            }
            
            return UIColor(cgColor: v)
        }
        set(value) {
            layer.shadowColor = value?.cgColor
        }
    }
    
    /// A property that accesses the backing layer's shadowOffset.
    @IBInspectable
    open var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set(value) {
            layer.shadowOffset = value
        }
    }
    
    /// A property that accesses the backing layer's shadowOpacity.
    @IBInspectable
    open var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set(value) {
            layer.shadowOpacity = value
        }
    }
    
    /// A property that accesses the backing layer's shadowRadius.
    @IBInspectable
    open var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set(value) {
            layer.shadowRadius = value
        }
    }
    
    /// A property that accesses the backing layer's shadowPath.
    @IBInspectable
    open var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set(value) {
            layer.shadowPath = value
        }
    }
    
    /// Enables automatic shadowPath sizing.
    @IBInspectable
    open var isShadowPathAutoSizing: Bool {
        get {
            return layer.isShadowPathAutoSizing
        }
        set(value) {
            layer.isShadowPathAutoSizing = value
        }
    }
    
    /// A property that sets the cornerRadius of the backing layer.
    open var cornerRadiusPreset: CornerRadiusPreset {
        get {
            return layer.cornerRadiusPreset
        }
        set(value) {
            layer.cornerRadiusPreset = value
        }
    }
    
    /// A property that accesses the layer.cornerRadius.
    @IBInspectable
    open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set(value) {
            layer.cornerRadius = value
        }
    }
    
    /// A preset property to set the borderWidth.
    open var borderWidthPreset: BorderWidthPreset {
        get {
            return layer.borderWidthPreset
        }
        set(value) {
            layer.borderWidthPreset = value
        }
    }
    
    /// A property that accesses the layer.borderWith.
    @IBInspectable
    open var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set(value) {
            layer.borderWidth = value
        }
    }
    
    /// A property that accesses the layer.borderColor property.
    @IBInspectable
    open var borderColor: UIColor? {
        get {
            guard let v = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: v)
        }
        set(value) {
            layer.borderColor = value?.cgColor
        }
    }
    
    /// A property that accesses the layer.position property.
    @IBInspectable
    open var position: CGPoint {
        get {
            return layer.position
        }
        set(value) {
            layer.position = value
        }
    }
    
    /// A property that accesses the layer.zPosition property.
    @IBInspectable
    open var zPosition: CGFloat {
        get {
            return layer.zPosition
        }
        set(value) {
            layer.zPosition = value
        }
    }
    
    /**
     A method that accepts CAAnimation objects and executes them on the
     view's backing layer.
     - Parameter animation: A CAAnimation instance.
     */
    open func animate(animation: CAAnimation) {
        layer.animate(animation: animation)
    }
    
    /// Manages the layout for the shape of the view instance.
    open func layoutShape() {
        layer.layoutShape()
    }
    
    /// Sets the shadow path.
    open func layoutShadowPath() {
        layer.layoutShadowPath()
    }
}
