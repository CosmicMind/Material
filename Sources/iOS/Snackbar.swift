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

@objc(SnackbarStatus)
public enum SnackbarStatus: Int {
    case visible
    case notVisible
}

open class Snackbar: BarView {
    /// A convenience property to set the titleLabel text.
    public var text: String? {
        get {
            return textLabel?.text
        }
        set(value) {
            textLabel?.text = value
            layoutSubviews()
        }
    }
    
    /// Text label.
    public private(set) var textLabel: UILabel!
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 49)
    }
    
    /// The status of the snackbar.
    open internal(set) var status = SnackbarStatus.notVisible
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if willRenderView {
            if nil != text && "" != text {
                if nil == textLabel.superview {
                    contentView.addSubview(textLabel)
                }
                textLabel.frame = contentView.bounds
            } else {
                textLabel.removeFromSuperview()
            }
            
            contentView.grid.reload()
        }
    }
    
    /**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepareView method
     to initialize property values and other setup operations.
     The super.prepareView method should always be called immediately
     when subclassing.
     */
    open override func prepareView() {
        super.prepareView()
        backgroundColor = Color.grey.darken3
        grid.contentEdgeInsets = EdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        grid.interimSpace = 24
        prepareTextLabel()
    }
    
    /// Prepares the textLabel.
    private func prepareTextLabel() {
        textLabel = UILabel()
        textLabel.contentScaleFactor = Device.scale
        textLabel.font = RobotoFont.medium(with: 14)
        textLabel.textAlignment = .left
        textLabel.textColor = Color.white
    }
}
