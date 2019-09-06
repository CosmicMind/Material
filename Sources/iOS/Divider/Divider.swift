/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Motion

@objc(DividerAlignment)
public enum DividerAlignment: Int {
  case top
  case left
  case bottom
  case right
}

public class Divider: UIView {
    
    fileprivate static func from(view: UIView) -> Divider? {
        guard let divider = view.subviews.first(where: { $0 is Divider }) as? Divider else {
            return nil
        }
        
        return divider
    }
    
    fileprivate static func orCreate(view: UIView) -> Divider {
        if let divider = Divider.from(view: view) {
            return divider
        }
        
        let divider = Divider()
        view.addSubview(divider)
        
        divider.update(thickness: 1)
        
        return divider
    }
    
    private(set) var thickness: CGFloat = 1
    public func update(thickness: CGFloat) {
        guard let superview = self.superview else {
            return
        }
        
        let c = contentEdgeInsets
        
        self.removeFromSuperview()
        superview.addSubview(self)
        self.layer.zPosition = 5000
        
        self.thickness = thickness
        
        switch self.dividerAlignment {
        case .bottom, .top:
            superview.layout(self)
                .leading(c.left, { _, _ in .equal })
                .trailing(c.right, {_, _ in .equal })
                .height(thickness)
            
            if case .bottom = self.dividerAlignment {
                superview.layout(self).bottom(c.bottom, { _, _ in .equal })
            } else {
                superview.layout(self).top(c.top, { _, _ in .equal })
            }
            
        case .left, .right:
            superview.layout(self)
                .bottom(c.bottom, { _, _ in .equal })
                .top(c.top, {_, _ in .equal })
                .width(thickness)
            
            if case .left = self.dividerAlignment {
                superview.layout(self).leading(c.left, { _, _ in .equal })
            } else {
                superview.layout(self).trailing(c.right, { _, _ in .equal })
            }
        }
    }
    
    public var alignment: DividerAlignment = .bottom {
        didSet {
            self.update(thickness: self.thickness)
        }
    }
    
    /// A preset wrapper around contentEdgeInsets.
    public var contentEdgeInsetsPreset = EdgeInsetsPreset.none {
        didSet {
            contentEdgeInsets = EdgeInsetsPresetToValue(preset: contentEdgeInsetsPreset)
        }
    }
    
    /// A reference to EdgeInsets.
    public var contentEdgeInsets = EdgeInsets.zero {
        didSet {
            self.update(thickness: self.thickness)
        }
    }
    
    /// Lays out the divider.
    public func reloadLayout() {
        self.update(thickness: self.thickness)
    }
}

public extension UIView {
    
    /// A preset wrapper around divider.contentEdgeInsets.
    open var dividerContentEdgeInsetsPreset: EdgeInsetsPreset {
        get {
            return Divider.from(view: self)?.contentEdgeInsetsPreset ?? .none
        }
        set(value) {
            Divider.orCreate(view: self).contentEdgeInsetsPreset = value
        }
    }
    
    /// A reference to divider.contentEdgeInsets.
    open var dividerContentEdgeInsets: EdgeInsets {
        get {
            return Divider.from(view: self)?.contentEdgeInsets ?? .zero
        }
        set(value) {
            Divider.orCreate(view: self).contentEdgeInsets = value
        }
    }
    
    /// Divider animation.
    @IBInspectable
    open var dividerAlignment: DividerAlignment {
        get {
            return Divider.from(view: self)?.alignment ?? .bottom
        }
        
        set {
            Divider.orCreate(view: self).alignment = newValue
        }
    }
    
    /// Divider color.
    @IBInspectable
    open var dividerColor: UIColor? {
        get {
            return Divider.from(view: self)?.backgroundColor
        }
        
        set {
            Divider.orCreate(view: self).backgroundColor = newValue
        }
    }
    
    /// Divider visibility.
    @IBInspectable
    open var isDividerHidden: Bool {
        get {
            return Divider.from(view: self) == nil
        }
        
        set {
            if newValue {
                Divider.from(view: self)?.isHidden = true
                return
            }
            
            Divider.orCreate(view: self).isHidden = false
        }
    }
    
    /// Divider thickness.
    @IBInspectable
    open var dividerThickness: CGFloat {
        get {
            return Divider.from(view: self)?.thickness ?? 0.0
        }
        
        set {
            guard newValue > 0 else {
                Divider.from(view: self)?.isHidden = true
                return
            }
            
            Divider.orCreate(view: self).update(thickness: newValue)
        }
    }
    
    /// Sets the divider frame.
    public func layoutDivider() {
        Divider.orCreate(view: self).reloadLayout()
    }
    
}
