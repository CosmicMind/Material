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

class ViewController: UIViewController {
    private var card: Card!
    
    /// Conent area.
    private var contentView: UILabel!
    
    /// Bottom Bar views.
    private var bottomBar: Bar!
    private var dateFormatter: DateFormatter!
    private var dateLabel: UILabel!
    private var favoriteButton: IconButton!
    
    /// Toolbar views.
    private var toolbar: Toolbar!
    private var moreButton: IconButton!
    private var authorView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        prepareDateFormatter()
        prepareDateLabel()
        prepareFavoriteButton()
        prepareMoreButton()
        prepareAuthorView()
        prepareToolbar()
        prepareContentView()
        prepareBottomBar()
        prepareImageCard()
    }
    
    private func prepareDateFormatter() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    private func prepareDateLabel() {
        dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.blueGrey.base
        dateLabel.text = dateFormatter.string(from: Date.distantFuture)
    }
    
    private func prepareFavoriteButton() {
        favoriteButton = IconButton(image: Icon.favorite, tintColor: Color.red.base)
    }
    
    private func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreVertical, tintColor: Color.blueGrey.base)
    }
    
    private func prepareAuthorView() {
        authorView = UIImageView()
        authorView.image = UIImage(named: "CosmicMind")?.resize(toWidth: 24)
        authorView.contentMode = .scaleAspectFit
    }
    
    private func prepareToolbar() {
        toolbar = Toolbar(leftViews: [authorView], rightViews: [moreButton])
        
        toolbar.title = "CosmicMind"
        toolbar.titleLabel.textAlignment = .left
        
        toolbar.detail = "Build Beautiful Software"
        toolbar.detailLabel.textAlignment = .left
        toolbar.detailLabel.textColor = Color.blueGrey.base
    }
    
    private func prepareContentView() {
        contentView = UILabel()
        contentView.numberOfLines = 0
        contentView.text = "Material is an animation and graphics framework that is used to create beautiful applications."
        contentView.font = RobotoFont.regular(with: 14)
    }
    
    private func prepareBottomBar() {
        bottomBar = Bar()
        
        bottomBar.leftViews = [dateLabel]
        bottomBar.rightViews = [favoriteButton]
    }
    
    private func prepareImageCard() {
        card = Card()
        
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .wideRectangle2
        
        card.contentView = contentView
        card.contentViewEdgeInsetsPreset = .wideRectangle3
        
        card.bottomBar = bottomBar
        card.bottomBarEdgeInsetsPreset = .wideRectangle2
        
        view.layout(card).horizontally(left: 20, right: 20).center()
    }
}

