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
    /// Card reference.
    private lazy var card: Card = Card()
    
    /// Conent area.
    private var contentView: UILabel!
    
    /// Bottom Bar views.
    private var bottomBar: Bar!
    private var favoriteButton: FlatButton!
    private var shareButton: FlatButton!
    private var starButton: FlatButton!
    
    /// Toolbar views.
    private var toolbar: Toolbar!
    private var moreButton: IconButton!
    private var authorView: View!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        prepareFavoriteButton()
        prepareShareButton()
        prepareStarButton()
        prepareMoreButton()
        prepareAuthorView()
        prepareToolbar()
        prepareContentView()
        prepareBottomBar()
        prepareImageCard()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    private func prepareFavoriteButton() {
        favoriteButton = FlatButton(image: Icon.favorite, tintColor: Color.grey.base)
        favoriteButton.grid.columns = 4
    }
    
    private func prepareShareButton() {
        shareButton = FlatButton(image: Icon.cm.share, tintColor: Color.grey.base)
        shareButton.grid.columns = 4
    }
    
    private func prepareStarButton() {
        starButton = FlatButton(image: Icon.cm.star, tintColor: Color.grey.base)
        starButton.grid.columns = 4
    }
    
    private func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreVertical, tintColor: Color.grey.base)
    }
    
    private func prepareAuthorView() {
        authorView = View()
        authorView.width = 24
        authorView.image = UIImage(named: "CosmicMind")
        authorView.backgroundColor = nil
        authorView.contentsGravityPreset = .ResizeAspect
    }
    
    private func prepareToolbar() {
        toolbar = Toolbar()
        toolbar.backgroundColor = nil
        
        toolbar.title = "CosmicMind"
        toolbar.titleLabel.textAlignment = .left
        
        toolbar.detail = "Build Beautiful Software"
        toolbar.detailLabel.textAlignment = .left
        
        toolbar.contentEdgeInsetsPreset = .square2
        
        toolbar.leftViews.append(authorView)
        toolbar.rightViews.append(moreButton)
    }
    
    private func prepareContentView() {
        contentView = UILabel()
        contentView.numberOfLines = 0
        contentView.text = "It’s been a while, have you read any new books lately?"
        contentView.font = RobotoFont.regular(with: 14)
    }
    
    private func prepareBottomBar() {
        bottomBar = Bar()
        bottomBar.backgroundColor = Color.grey.lighten4
        bottomBar.contentEdgeInsetsPreset = .square1
        bottomBar.cornerRadiusPreset = .cornerRadius1
        
        bottomBar.divider.color = Color.grey.lighten3
        bottomBar.divider.alignment = .top
        
        bottomBar.contentView.grid.views = [favoriteButton, shareButton, starButton]
    }
    
    private func prepareImageCard() {
        card.toolbar = toolbar
        card.contentView = contentView
        card.bottomBar = bottomBar
        card.cornerRadiusPreset = .cornerRadius1
        card.contentEdgeInsetsPreset = .square3
        
        view.layout(card).horizontally(left: 20, right: 20).center()
    }
}

