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

open class MenuItem: View {
    /// A reference to the titleLabel.
    open let titleLabel = UILabel()
    
    /// A reference to the button.
    open let button = FabButton()
    
    /**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
    open override func prepare() {
        super.prepare()
        backgroundColor = nil
        
        prepareButton()
        prepareTitleLabel()
    }
    
    /// A reference to the titleLabel text.
    open var title: String? {
        get {
            return titleLabel.text
        }
        set(value) {
            titleLabel.text = value
            hideTitleLabel()
        }
    }
    
    /// Shows the titleLabel.
    open func showTitleLabel() {
        let interimSpace = InterimSpacePresetToValue(preset: .interimSpace6)
        
        titleLabel.sizeToFit()
        titleLabel.width += 1.5 * interimSpace
        titleLabel.height += interimSpace / 2
        titleLabel.y = (height - titleLabel.height) / 2
        titleLabel.x = -titleLabel.width - interimSpace
        titleLabel.alpha = 0
        titleLabel.isHidden = false
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let s = self else {
                return
            }
            
            s.titleLabel.alpha = 1
        })
    }
    
    /// Hides the titleLabel.
    open func hideTitleLabel() {
        titleLabel.isHidden = true
    }
    
    /// Prepares the button.
    private func prepareButton() {
        layout(button).edges()
    }
    
    /// Prepares the titleLabel.
    private func prepareTitleLabel() {
        titleLabel.font = RobotoFont.regular(with: 14)
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .white
        titleLabel.depthPreset = button.depthPreset
        titleLabel.cornerRadiusPreset = .cornerRadius1
        addSubview(titleLabel)
    }
}
