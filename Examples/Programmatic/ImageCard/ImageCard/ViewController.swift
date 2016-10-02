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
    private var card: ImageCard!
    
    /// Conent area.
    private var imageView: UIImageView!
    private var contentView: UILabel!
    
    /// Bottom Bar views.
    private var bottomBar: Bar!
    private var favoriteButton: FlatButton!
    private var shareButton: FlatButton!
    private var starButton: FlatButton!
    
    /// Toolbar views.
    private var toolbar: Toolbar!
    private var moreButton: IconButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        prepareImageView()
        prepareFavoriteButton()
        prepareShareButton()
        prepareStarButton()
        prepareMoreButton()
        prepareToolbar()
        prepareContentView()
        prepareBottomBar()
        prepareImageCard()
    }
    
    private func prepareImageView() {
        imageView = UIImageView()
        imageView.image = UIImage(named: "frontier.jpg")?.resize(toWidth: view.width)
        imageView.contentMode = .scaleAspectFill
    }
    
    private func prepareFavoriteButton() {
        favoriteButton = FlatButton(image: Icon.favorite, tintColor: Color.blueGrey.base)
    }
    
    private func prepareShareButton() {
        shareButton = FlatButton(image: Icon.cm.share, tintColor: Color.blueGrey.base)
    }
    
    private func prepareStarButton() {
        starButton = FlatButton(image: Icon.cm.star, tintColor: Color.blueGrey.base)
    }
    
    private func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreHorizontal, tintColor: Color.white)
    }
    
    private func prepareToolbar() {
        toolbar = Toolbar()
        toolbar.backgroundColor = nil
        
        toolbar.title = "CosmicMind"
        toolbar.titleLabel.textColor = Color.white
        
        toolbar.detail = "Build Beautiful Software"
        toolbar.detailLabel.textColor = Color.white
    }
    
    private func prepareContentView() {
        contentView = UILabel()
        contentView.numberOfLines = 0
        contentView.text = "Material is an animation and graphics framework that is used to create beautiful applications."
        contentView.font = RobotoFont.regular(with: 14)
    }
    
    private func prepareBottomBar() {
        bottomBar = Bar(centerViews: [favoriteButton, shareButton, starButton])
    }
    
    private func prepareImageCard() {
        card = ImageCard()
        
        card.imageView = imageView
        
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .square3
        
        card.contentView = contentView
        card.contentViewEdgeInsetsPreset = .square3
        
        card.bottomBar = bottomBar
        
        view.layout(card).horizontally(left: 20, right: 20).center()
    }
}

