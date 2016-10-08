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

class RootViewController: UIViewController {
    /// NavigationBar buttons.
    private var menuButton: IconButton!
    private var starButton: IconButton!
    private var searchButton: IconButton!
    
    /// Trigger to go to the next view controller.
    private var nextButton: FlatButton!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        prepareMenuButton()
        prepareStarButton()
        prepareSearchButton()
        prepareNavigationItem()
        prepareNextButton()
    }
    
    internal func handleNextButton() {
        navigationController?.pushViewController(NextViewController(), animated: true)
    }
    
    private func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu, tintColor: Color.white)
        menuButton.pulseColor = Color.white
    }
    
    private func prepareStarButton() {
        starButton = IconButton(image: Icon.cm.star, tintColor: Color.white)
        starButton.pulseColor = Color.white
    }
    
    private func prepareSearchButton() {
        searchButton = IconButton(image: Icon.cm.search, tintColor: Color.white)
        searchButton.pulseColor = Color.white
    }
    
    private func prepareNavigationItem() {
        navigationItem.title = "Material"
        navigationItem.titleLabel.textColor = Color.white
        
        navigationItem.detail = "Build Beautiful Software"
        navigationItem.detailLabel.textColor = Color.lightBlue.lighten5
        
        navigationItem.leftViews = [menuButton]
        navigationItem.rightViews = [starButton, searchButton]
    }
    
    private func prepareNextButton() {
        nextButton = FlatButton()
        nextButton.pulseAnimation = .none
        nextButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        view.layout(nextButton).edges()
    }
}

