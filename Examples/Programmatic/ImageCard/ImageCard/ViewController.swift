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
    private var imageView: UIImageView!
    private var toolbar: Toolbar!
    private var contentView: UILabel!
    private var bottomBar: Bar!
    private var favoriteButton: IconButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        prepareImageView()
        prepareToolbar()
        prepareContentView()
        prepareFavoriteButton()
        prepareBottomBar()
        prepareImageCard()
    }
    
    private func prepareImageView() {
        imageView = UIImageView()
        imageView.image = UIImage(named: "CosmicMind")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
    }
    
    private func prepareToolbar() {
        toolbar = Toolbar()
        
        toolbar.title = "Title"
        toolbar.titleLabel.textAlignment = .left
        
        toolbar.detail = "Detail Description"
        toolbar.detailLabel.textAlignment = .left
        
        toolbar.backgroundColor = nil
    }
    
    private func prepareContentView() {
        contentView = UILabel()
        contentView.numberOfLines = 0
        contentView.text = "It’s been a while, have you read any new books lately?"
        contentView.font = RobotoFont.regular(with: 14)
    }
    
    private func prepareFavoriteButton() {
        favoriteButton = IconButton(image: Icon.favorite, tintColor: Color.blue.base)
        favoriteButton.pulseColor = Color.blue.base
    }
    
    private func prepareBottomBar() {
        bottomBar = Bar()
        bottomBar.backgroundColor = nil
        bottomBar.leftViews = [favoriteButton]
    }
    
    private func prepareImageCard() {
        let card = ImageCard()
        card.imageView = imageView
        card.toolbar = toolbar
        card.contentView = contentView
        card.bottomBar = bottomBar
        
        view.layout(card).top(100).left(20).right(20)
    }
}

