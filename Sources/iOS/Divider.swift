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
    internal var divider: UIView?
    
    /// Divider color.
    open var color: UIColor? {
        get {
            return divider?.backgroundColor
        }
        set(value) {
            guard let v = value else {
                divider?.removeFromSuperview()
                divider = nil
                return
            }
            if nil == divider {
                divider = UIView()
                divider?.zPosition = 5000
                view?.addSubview(divider!)
                reload()
            }
            divider?.backgroundColor = v
        }
    }
    
    /// A reference to the dividerAlignment.
    internal var alignment = DividerAlignment.top {
        didSet {
            reload()
        }
    }
    
    /**
     Initializer that takes in a UIView.
     - Parameter view: A UIView reference.
     */
    internal init(view: UIView?) {
        self.view = view
    }
    
    /// Lays out the divider.
    internal func reload() {
        guard let v = view else {
            return
        }
        
        guard let d = divider else {
            return
        }
        
        switch alignment {
        case .top:
            d.frame = CGRect(x: 0, y: 0, width: v.width, height: 1)
        case .bottom:
            d.frame = CGRect(x: 0, y: v.height - 1, width: v.width, height: 1)
        case .left:
            d.frame = CGRect(x: 0, y: 0, width: 1, height: v.height)
        case .right:
            d.frame = CGRect(x: v.width - 1, y: 0, width: 1, height: v.height)
        }
    }
}
