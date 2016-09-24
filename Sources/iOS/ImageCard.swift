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

@objc(ToolbarAlignment)
public enum ToolbarAlignment: Int {
    case top
    case bottom
}

open class ImageCard: Card {
    /// A reference to the imageView.
    @IBInspectable
    open var imageView: UIImageView? {
        didSet {
            layoutSubviews()
        }
    }
    
    /// An ImageCardToolbarAlignment value.
    open var toolbarAlignment = ToolbarAlignment.bottom {
        didSet {
            layoutSubviews()
        }
    }
    
    open override func layout() {
        guard let iv = imageView else {
            super.layout()
            return
        }
        
        var format = "V:|"
        var views = [String: Any]()
        
        format += "[imageView]"
        views["imageView"] = iv
        layout(iv).horizontally()
        
        if let v = toolbar {
            iv.layout(v).horizontally().height(v.height)
            if .top == toolbarAlignment {
                iv.layout(v).top()
            } else {
                iv.layout(v).bottom()
            }
        }
        
        if let v = contentView {
            format += "-(top)-[contentView]-(bottom)-"
            views["contentView"] = v
            layout(v).horizontally(left: contentEdgeInsets.left, right: contentEdgeInsets.right)
        }
        
        if let v = bottomBar {
            format += "[bottomBar]"
            views["bottomBar"] = v
            layout(v).horizontally().height(v.height)
        }
        
        guard 0 < views.count else {
            return
        }
        
        var metrics = [String: Any]()
        metrics["top"] = contentEdgeInsets.top
        metrics["bottom"] = contentEdgeInsets.bottom
        
        addConstraints(Layout.constraint(format: "\(format)|", options: [], metrics: metrics, views: views))
    }
}
