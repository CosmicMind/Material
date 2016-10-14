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
    /// View.
    internal var imageCard: ImageCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        // Prepare view.
        prepareImageCard()
    }
}

/// ImageCard.
extension ViewController {
    internal func prepareImageCard() {
        imageCard = ImageCard()
        view.layout(imageCard).horizontally(left: 20, right: 20).center()
        
        prepareToolbar()
        prepareImageView()
        prepareContentView()
        prepareBottomBar()
    }
    
    private func prepareToolbar() {
        imageCard.toolbar = Toolbar()
        imageCard.toolbar?.backgroundColor = .clear
        imageCard.toolbarEdgeInsetsPreset = .square3
        
        // Use the property subscript to access the model data.
        imageCard.toolbar?.title = "Graph"
        imageCard.toolbar?.titleLabel.textColor = .white
        
        imageCard.toolbar?.detail = "Build Data-Driven Software"
        imageCard.toolbar?.detailLabel.textColor = .white
    }
    
    private func prepareImageView() {
        imageCard.imageView = UIImageView()
        imageCard.imageView?.image = UIImage(named: "frontier.jpg")?.resize(toWidth: view.width)
    }
    
    private func prepareContentView() {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Graph is a semantic database that is used to create data-driven applications."
        label.font = RobotoFont.regular(with: 14)
        
        imageCard.contentView = label
        imageCard.contentViewEdgeInsetsPreset = .square3
    }
    
    private func prepareBottomBar() {
        let shareButton = IconButton(image: Icon.cm.share, tintColor: Color.blueGrey.base)
        let favoriteButton = IconButton(image: Icon.favorite, tintColor: Color.red.base)
        
        let label = UILabel()
        label.text = "CosmicMind"
        label.textAlignment = .center
        label.textColor = Color.blueGrey.base
        label.font = RobotoFont.regular(with: 12)
        
        imageCard.bottomBar = Bar()
        imageCard.bottomBarEdgeInsetsPreset = .wideRectangle2
        imageCard.bottomBarEdgeInsets.top = 0
        imageCard.bottomBar?.contentViewAlignment = .center
        
        imageCard.bottomBar?.leftViews = [favoriteButton]
        imageCard.bottomBar?.centerViews = [label]
        imageCard.bottomBar?.rightViews = [shareButton]
    }
}

