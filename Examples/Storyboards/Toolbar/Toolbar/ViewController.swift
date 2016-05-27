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
*	*	Neither the name of Material nor the names of its
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
    
    @IBOutlet weak var toolbar: Toolbar!
	
	@IBOutlet weak var toolbarHeightConstraint: NSLayoutConstraint?
	
	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		adjustToOrientation(toInterfaceOrientation)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		prepareView()
		prepareToolbar()
		adjustToOrientation(MaterialDevice.orientation)
    }
	
	/// Adjusts the Toolbar height to the correct height based on the orientation value.
	private func adjustToOrientation(interfaceOrientation: UIInterfaceOrientation) {
		toolbar.grid.layoutInset.top = .iPad == MaterialDevice.type || UIInterfaceOrientationIsPortrait(interfaceOrientation) ? 20 : 0
		toolbarHeightConstraint?.constant = toolbar.intrinsicContentSize().height + toolbar.grid.layoutInset.top
	}
	
	/// General preparation statements.
    private func prepareView() {
		MaterialDevice.statusBarStyle = .LightContent
		view.backgroundColor = MaterialColor.white
    }
	
	/// Prepare the toolbar.
    func prepareToolbar() {
		// Stylize.
        toolbar.backgroundColor = MaterialColor.indigo.darken1
		
        // Title label.
        toolbar.title = "Material"
        toolbar.titleLabel.textColor = MaterialColor.white
		
        // Detail label.
        toolbar.detail = "Build Beautiful Software"
		toolbar.detailLabel.textColor = MaterialColor.white
		
        // Menu button.
        let img1: UIImage? = MaterialIcon.cm.menu
        let btn1: IconButton = IconButton()
        btn1.pulseColor = MaterialColor.white
		btn1.tintColor = MaterialColor.white
		btn1.setImage(img1, forState: .Normal)
        btn1.setImage(img1, forState: .Highlighted)
        
        // Star button.
        let img2: UIImage? = MaterialIcon.cm.star
        let btn2: IconButton = IconButton()
        btn2.pulseColor = MaterialColor.white
		btn2.tintColor = MaterialColor.white
        btn2.setImage(img2, forState: .Normal)
        btn2.setImage(img2, forState: .Highlighted)
        
        // Search button.
        let img3: UIImage? = MaterialIcon.cm.search
        let btn3: IconButton = IconButton()
        btn3.pulseColor = MaterialColor.white
		btn3.tintColor = MaterialColor.white
		btn3.setImage(img3, forState: .Normal)
        btn3.setImage(img3, forState: .Highlighted)
        
        // Add buttons to left side.
        toolbar.leftControls = [btn1]
        
        // Add buttons to right side.
        toolbar.rightControls = [btn2, btn3]
    }
}

