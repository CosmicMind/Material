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
    private var card: PresenterCard!
    
    /// Conent area.
    private var presenterView: UIImageView!
    private var contentView: UILabel!
    
    /// Bottom Bar views.
    private var bottomBar: Bar!
    private var dateFormatter: DateFormatter!
    private var dateLabel: UILabel!
    private var favoriteButton: IconButton!
    private var shareButton: IconButton!
    
    /// Toolbar views.
    private var toolbar: Toolbar!
    private var moreButton: IconButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        preparePresenterView()
        prepareDateFormatter()
        prepareDateLabel()
        prepareFavoriteButton()
        prepareShareButton()
        prepareMoreButton()
        prepareToolbar()
        prepareContentView()
        prepareBottomBar()
        prepareImageCard()
    }
    
    private func preparePresenterView() {
        presenterView = UIImageView()
        presenterView.image = UIImage(named: "dreamer.jpg")?.resize(toWidth: view.width)
        presenterView.clipsToBounds = true
        presenterView.contentMode = .scaleAspectFill
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
        dateLabel.textAlignment = .center
        dateLabel.text = dateFormatter.string(from: Date.distantFuture)
    }
    
    private func prepareFavoriteButton() {
        favoriteButton = IconButton(image: Icon.favorite, tintColor: Color.red.base)
        favoriteButton.grid.columns = 4
    }
    
    private func prepareShareButton() {
        shareButton = IconButton(image: Icon.cm.share, tintColor: Color.blueGrey.base)
        shareButton.grid.columns = 4
    }
    
    private func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreHorizontal, tintColor: Color.blueGrey.base)
    }
    
    private func prepareToolbar() {
        toolbar = Toolbar()
        toolbar.backgroundColor = nil
        
        toolbar.title = "Material"
        toolbar.titleLabel.textAlignment = .left
        
        toolbar.detail = "Build Beautiful Software"
        toolbar.detailLabel.textAlignment = .left
        toolbar.detailLabel.textColor = Color.blueGrey.base
        
        toolbar.rightViews = [moreButton]
    }
    
    private func prepareContentView() {
        contentView = UILabel()
        contentView.numberOfLines = 0
        contentView.text = "Material is an animation and graphics framework that is the foundation for creating beautiful applications."
        contentView.font = RobotoFont.regular(with: 14)
    }
    
    private func prepareBottomBar() {
        bottomBar = Bar()
        bottomBar.backgroundColor = nil
        
        bottomBar.leftViews = [favoriteButton]
        bottomBar.rightViews = [shareButton]
        bottomBar.contentView.grid.views = [dateLabel]
    }
    
    private func prepareImageCard() {
        card = PresenterCard()
        card.cornerRadiusPreset = .cornerRadius1
        
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .square2
        
        card.presenterView = presenterView
        
        card.contentView = contentView
        card.contentViewEdgeInsetsPreset = .square3
        
        card.bottomBar = bottomBar
        card.bottomBarEdgeInsetsPreset = .square1
        
        view.layout(card).horizontally(left: 20, right: 20).center()
    }
}

