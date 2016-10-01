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
    /// Buttons for the TabBar.
    private lazy var buttons = [Button]()
    
    /// A reference to the TabBar.
    private var tabBar: TabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        prepareButtons()
        prepareTabBar()
    }
    
    private func prepareButtons() {
        let btn1 = FlatButton(title: "Library", titleColor: Color.blueGrey.base)
        btn1.pulseAnimation = .none
        buttons.append(btn1)
        
        let btn2 = FlatButton(title: "Photo", titleColor: Color.blueGrey.base)
        btn2.pulseAnimation = .none
        buttons.append(btn2)
        
        let btn3 = FlatButton(title: "Video", titleColor: Color.blueGrey.base)
        btn3.pulseAnimation = .none
        buttons.append(btn3)
    }
    
    private func prepareTabBar() {
        tabBar = TabBar()
        
        tabBar.dividerColor = Color.grey.lighten3
        tabBar.dividerAlignment = .top
        
        tabBar.lineColor = Color.blue.base
        tabBar.lineAlignment = .top
        
        tabBar.backgroundColor = Color.grey.lighten5
        tabBar.buttons = buttons
        
        view.layout(tabBar).horizontally().bottom()
    }
}

