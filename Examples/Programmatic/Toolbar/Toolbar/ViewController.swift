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

/*
A Toolbar is a fully featured Toolbar that supports orientation 
changes, background images, title and detail labels, both left and right UIControl
sets, and status bar settings. Below is an example of its usage.
*/

import UIKit
import Material

class ViewController: UIViewController {
	/// Reference for containerView.
	private var containerView: UIView!
	
	/// Reference for Toolbar.
	private var toolbar: Toolbar!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareContainerView()
		prepareToolbar()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the containerView.
	private func prepareContainerView() {
		containerView = UIView()
		view.layout(containerView).edges(top: 100, left: 20, right: 20)
	}
	
	/// Prepares the toolbar
	private func prepareToolbar() {
		toolbar = Toolbar()
		containerView.addSubview(toolbar)
		
		// Title label.
		toolbar.title = "Material"
		toolbar.titleLabel.textColor = MaterialColor.white
		
		// Detail label.
		toolbar.detail = "Build Beautiful Software"
		toolbar.detailLabel.textColor = MaterialColor.white

		var image: UIImage? = MaterialIcon.cm.menu

		// Menu button.
		let menuButton: IconButton = IconButton()
		menuButton.pulseColor = MaterialColor.white
		menuButton.tintColor = MaterialColor.white
		menuButton.setImage(image, forState: .Normal)
		menuButton.setImage(image, forState: .Highlighted)

		// Switch control.
		let switchControl: MaterialSwitch = MaterialSwitch(state: .Off, style: .LightContent, size: .Small)

		// Search button.
		image = MaterialIcon.cm.search
		let searchButton: IconButton = IconButton()
		searchButton.pulseColor = MaterialColor.white
		searchButton.tintColor = MaterialColor.white
		searchButton.setImage(image, forState: .Normal)
		searchButton.setImage(image, forState: .Highlighted)
		
		/*
		To lighten the status bar - add the
		"View controller-based status bar appearance = NO"
		to your info.plist file and set the following property.
		*/
		toolbar.backgroundColor = MaterialColor.blue.base
		toolbar.leftControls = [menuButton]
		toolbar.rightControls = [switchControl, searchButton]
	}
}
