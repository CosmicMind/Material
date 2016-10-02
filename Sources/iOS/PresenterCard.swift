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

open class PresenterCard: Card {
    /// A preset wrapper around presenterViewEdgeInsets.
    open var presenterViewEdgeInsetsPreset = EdgeInsetsPreset.none {
        didSet {
            presenterViewEdgeInsets = EdgeInsetsPresetToValue(preset: presenterViewEdgeInsetsPreset)
        }
    }
    
    /// A reference to presenterViewEdgeInsets.
    @IBInspectable
    open var presenterViewEdgeInsets = EdgeInsets.zero {
        didSet {
            layoutSubviews()
        }
    }
    
    /// A reference to the presenterView.
    @IBInspectable
    open var presenterView: UIView? {
        didSet {
            layoutSubviews()
        }
    }
    
    open override func reload() {
        // Clear constraints so new ones do not conflict.
        container.removeConstraints(constraints)
        for v in container.subviews {
            v.removeFromSuperview()
        }
        
        var format = "V:|"
        var views = [String: Any]()
        var metrics = [String: Any]()
        
        if let v = toolbar {
            metrics["toolbarTop"] = toolbarEdgeInsets.top
            metrics["toolbarBottom"] = toolbarEdgeInsets.bottom
            
            format += "-(toolbarTop)-[toolbar]-(toolbarBottom)"
            views["toolbar"] = v
            container.layout(v).horizontally(left: toolbarEdgeInsets.left, right: toolbarEdgeInsets.right).height(v.height)
            v.grid.reload()
            v.divider.reload()
        }
        
        if let v = presenterView {
            metrics["presenterViewBottom"] = presenterViewEdgeInsets.bottom
            
            if nil != toolbar {
                metrics["toolbarBottom"] = (metrics["toolbarBottom"] as! CGFloat) + presenterViewEdgeInsets.top
                format += "-[presenterView]-(presenterViewBottom)"
            } else {
                metrics["presenterViewTop"] = presenterViewEdgeInsets.top
                format += "-(presenterViewTop)-[presenterView]-(presenterViewBottom)"
            }
            
            views["presenterView"] = v
            container.layout(v).horizontally(left: presenterViewEdgeInsets.left, right: presenterViewEdgeInsets.right)
            v.grid.reload()
            v.divider.reload()
        }
        
        if let v = contentView {
            metrics["contentViewBottom"] = contentViewEdgeInsets.bottom
            
            if nil != presenterView {
                metrics["presenterViewBottom"] = (metrics["presenterViewBottom"] as! CGFloat) + contentViewEdgeInsets.top
                format += "-[contentView]-(contentViewBottom)"
            } else if nil != toolbar {
                metrics["toolbarBottom"] = (metrics["toolbarBottom"] as! CGFloat) + contentViewEdgeInsets.top
                format += "-[contentView]-(contentViewBottom)"
            } else {
                metrics["contentViewTop"] = contentViewEdgeInsets.top
                format += "-(contentViewTop)-[contentView]-(contentViewBottom)"
            }
            
            views["contentView"] = v
            container.layout(v).horizontally(left: contentViewEdgeInsets.left, right: contentViewEdgeInsets.right)
            v.grid.reload()
            v.divider.reload()
        }
        
        if let v = bottomBar {
            metrics["bottomBarBottom"] = bottomBarEdgeInsets.bottom
            
            if nil != contentView {
                metrics["contentViewBottom"] = (metrics["contentViewBottom"] as! CGFloat) + bottomBarEdgeInsets.top
                format += "-[bottomBar]-(bottomBarBottom)"
            } else if nil != presenterView {
                metrics["presenterViewBottom"] = (metrics["presenterViewBottom"] as! CGFloat) + bottomBarEdgeInsets.top
                format += "-[bottomBar]-(bottomBarBottom)"
            } else if nil != toolbar {
                metrics["toolbarBottom"] = (metrics["toolbarBottom"] as! CGFloat) + bottomBarEdgeInsets.top
                format += "-[bottomBar]-(bottomBarBottom)"
            } else {
                metrics["bottomBarTop"] = bottomBarEdgeInsets.top
                format += "-(bottomBarTop)-[bottomBar]-(bottomBarBottom)"
            }
            
            views["bottomBar"] = v
            container.layout(v).horizontally(left: bottomBarEdgeInsets.left, right: bottomBarEdgeInsets.right).height(v.height)
            v.grid.reload()
            v.divider.reload()
        }
        
        guard 0 < views.count else {
            return
        }
        
        container.addConstraints(Layout.constraint(format: "\(format)-|", options: [], metrics: metrics, views: views))
    }
}
