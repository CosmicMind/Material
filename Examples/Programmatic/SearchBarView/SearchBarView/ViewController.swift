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
A SearchBarView is a fully featured SearchBar that supports orientation
changes, background images, both left and right UIControl sets, and status bar 
settings. Below is an example of its usage.
*/

import UIKit
import Material

class ViewController: UIViewController {
	/// Reference for SearchBarView.
	private var searchBarView: SearchBarView = SearchBarView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareSearchBarView()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepare navigationBarView.
	private func prepareSearchBarView() {
		var image = UIImage(named: "ic_close_white")
		
		let clearButton: FlatButton = FlatButton()
		clearButton.pulseColor = MaterialColor.white
		clearButton.pulseScale = false
		clearButton.setImage(image, forState: .Normal)
		clearButton.setImage(image, forState: .Highlighted)
		
		image = UIImage(named: "ic_menu_white")
		let menuButton: FlatButton = FlatButton()
		menuButton.pulseColor = MaterialColor.white
		menuButton.pulseScale = false
		menuButton.setImage(image, forState: .Normal)
		menuButton.setImage(image, forState: .Highlighted)
	
		// Switch control.
		let switchControl: MaterialSwitch = MaterialSwitch(state: .Off, style: .LightContent, size: .Small)
		
		/*
		To lighten the status bar - add the
		"View controller-based status bar appearance = NO"
		to your info.plist file and set the following property.
		*/
		searchBarView.statusBarStyle = .LightContent
		
		searchBarView.delegate = self
		searchBarView.backgroundColor = MaterialColor.blue.base
		searchBarView.placeholder = "Search"
		searchBarView.tintColor = MaterialColor.white
		searchBarView.textColor = MaterialColor.white
		searchBarView.placeholderTextColor = MaterialColor.white
		searchBarView.textField.font = RobotoFont.regularWithSize(17)
		
		searchBarView.clearButton = clearButton
		searchBarView.leftControls = [menuButton]
		searchBarView.rightControls = [switchControl]
		
		view.addSubview(searchBarView)
	}
}


/// SearchBarViewDelegate methods.
extension ViewController: SearchBarViewDelegate {
	func searchBarViewDidChangeLayout(searchBarView: SearchBarView) {
		print("Updated Frame: \(searchBarView.frame)")
	}
}

