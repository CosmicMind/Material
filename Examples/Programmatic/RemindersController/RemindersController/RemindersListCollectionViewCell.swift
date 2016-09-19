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
import Material

class RemindersListCollectionViewCell: CollectionViewCell {
    /// A reference to the titleLabel.
    public private(set) lazy var titleLabel: UILabel = UILabel()
    
    /// A reference to the countLabel.
    public private(set) lazy var countLabel: UILabel = UILabel()
    
    open override func prepare() {
        super.prepare()
        
        prepareTitleLabel()
        prepareCountLabel()
        prepareDivider()
    }
    
    /// Prepares the titleLabel.
    private func prepareTitleLabel() {
        titleLabel.font = RobotoFont.regular(with: 22)
        layout(titleLabel).edges(top: 24, left: 24, bottom: 24, right: 24)
    }
    
    /// Prepares the countLabel.
    private func prepareCountLabel() {
        countLabel.font = RobotoFont.regular(with: 22)
        countLabel.textAlignment = .right
        layout(countLabel).edges(top: 24, left: 24, bottom: 24, right: 24)
    }
    
    /// Prepares the divider.
    private func prepareDivider() {
        divider.color = Color.grey.lighten3
    }
}
