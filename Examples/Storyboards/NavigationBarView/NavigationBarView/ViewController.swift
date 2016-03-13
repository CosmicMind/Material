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
    
    @IBOutlet weak var navigationBarView: NavigationBarView!
	
	@IBOutlet weak var navigationBarViewHeightConstraint: NSLayoutConstraint?
	
	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		// If landscape.
		if UIInterfaceOrientationIsLandscape(toInterfaceOrientation) {
			/**
			The height of the NavigationBarView is dependant on the device being used.
			If the device is an iPad, the height should stay the same as in Portrait 
			view, otherwise it should strink to the Landscape height for iPhone.
			*/
			navigationBarViewHeightConstraint?.constant = .iPad == MaterialDevice.type ? navigationBarView!.heightForPortraitOrientation :  navigationBarView!.heightForLandscapeOrientation
		} else {
			navigationBarViewHeightConstraint?.constant = navigationBarView!.heightForPortraitOrientation
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		prepareView()
		prepareNavigationBarView()
    }
	
	/// General preparation statements.
    private func prepareView() {
		view.backgroundColor = MaterialColor.white
    }
	
	/// Prepare the navigationBarView.
    func prepareNavigationBarView() {
		// Stylize.
        navigationBarView.backgroundColor = MaterialColor.indigo.darken1
		
        // To lighten the status bar add the "View controller-based status bar appearance = NO"
        // to your info.plist file and set the following property.
        navigationBarView.statusBarStyle = .LightContent
        
        // Title label.
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Material"
        titleLabel.textAlignment = .Left
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = RobotoFont.regular
        navigationBarView.titleLabel = titleLabel
		
        // Detail label.
        let detailLabel: UILabel = UILabel()
        detailLabel.text = "Build Beautiful Software"
        detailLabel.textAlignment = .Left
        detailLabel.textColor = MaterialColor.white
        detailLabel.font = RobotoFont.regular
        navigationBarView.detailLabel = detailLabel
		
        // Menu button.
        let img1: UIImage? = UIImage(named: "ic_menu_white")
        let btn1: FlatButton = FlatButton()
        btn1.pulseScale = false
        btn1.setImage(img1, forState: .Normal)
        btn1.setImage(img1, forState: .Highlighted)
        
        // Star button.
        let img2: UIImage? = UIImage(named: "ic_star_white")
        let btn2: FlatButton = FlatButton()
        btn2.pulseScale = false
        btn2.setImage(img2, forState: .Normal)
        btn2.setImage(img2, forState: .Highlighted)
        
        // Search button.
        let img3: UIImage? = UIImage(named: "ic_search_white")
        let btn3: FlatButton = FlatButton()
        btn3.pulseScale = false
        btn3.setImage(img3, forState: .Normal)
        btn3.setImage(img3, forState: .Highlighted)
        
        // Add buttons to left side.
        navigationBarView.leftControls = [btn1]
        
        // Add buttons to right side.
        navigationBarView.rightControls = [btn2, btn3]
    }
}

