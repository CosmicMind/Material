/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
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

@objc(DividerAlignment)
public enum DividerAlignment: Int {
    case top
    case left
    case bottom
    case right
}

open class Divider {
    /// A reference to the UIView.
    internal weak var view: UIView?
    
    /// A reference to the divider UIView.
    internal var line: UIView?
    
    /// A reference to the height.
    public var height: CGFloat
    
    /// Divider color.
    open var color: UIColor? {
        get {
            return line?.backgroundColor
        }
        set(value) {
            guard let v = value else {
                line?.removeFromSuperview()
                line = nil
                return
            }
            if nil == line {
                line = UIView()
                line?.zPosition = 5000
                view?.addSubview(line!)
                reload()
            }
            line?.backgroundColor = v
        }
    }
    
    /// A reference to the dividerAlignment.
    open var alignment = DividerAlignment.bottom {
        didSet {
            reload()
        }
    }
    
    /**
     Initializer that takes in a UIView.
     - Parameter view: A UIView reference.
     */
    internal init(view: UIView?, height: CGFloat = 1) {
        self.view = view
        self.height = height
    }
    
    /// Lays out the divider.
    internal func reload() {
        guard let l = line, let v = view else {
            return
        }
        
        switch alignment {
        case .top:
            l.frame = CGRect(x: 0, y: 0, width: v.width, height: height)
        case .bottom:
            l.frame = CGRect(x: 0, y: v.height - height, width: v.width, height: height)
        case .left:
            l.frame = CGRect(x: 0, y: 0, width: height, height: v.height)
        case .right:
            l.frame = CGRect(x: v.width - height, y: 0, width: height, height: v.height)
        }
    }
}
