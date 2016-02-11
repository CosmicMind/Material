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
A NavigationBarView is a fully featured NavigationBar that supports orientation 
changes, background images, title and detail labels, both left and right button 
sets, and status bar settings. Below are examples of its usage.
*/

import UIKit
import Material

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		
		/*
		Examples of using NavigationBarView.
		Uncomment different examples and read
		the comments below.
		*/
//		prepareGeneralUsageExample()
//		prepareOrientationSupportExample()
//		prepareDetailLabelExample()
//		prepareBackgroundImageExample()
//		prepareButtonExample()
		prepareAlignTitleAndDetailLabelToLeftExample()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares a general usage example.
	private func prepareGeneralUsageExample() {
		let navigationBarView: NavigationBarView = NavigationBarView()
		navigationBarView.backgroundColor = MaterialColor.blue.darken1
		
		/*
		To lighten the status bar - add the
		"View controller-based status bar appearance = NO"
		to your info.plist file and set the following property.
		*/
		navigationBarView.statusBarStyle = .LightContent
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Material"
		titleLabel.textAlignment = .Center
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.regularWithSize(20)
		navigationBarView.titleLabel = titleLabel
		
		// Add NavigationBarView without support for orientation change.
		view.addSubview(navigationBarView)
	}
	
	/// Prepare an example using MaterialLayout that support orientation change.
	private func prepareOrientationSupportExample() {
		let navigationBarView: NavigationBarView = NavigationBarView()
		navigationBarView.backgroundColor = MaterialColor.red.darken1
		
		/*
		To lighten the status bar - add the
		"View controller-based status bar appearance = NO"
		to your info.plist file and set the following property.
		*/
		navigationBarView.statusBarStyle = .LightContent
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Material"
		titleLabel.textAlignment = .Center
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.regularWithSize(20)
		navigationBarView.titleLabel = titleLabel
		
		
		// To support orientation changes, use MaterialLayout.
		view.addSubview(navigationBarView)
		navigationBarView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: navigationBarView)
		MaterialLayout.alignToParentHorizontally(view, child: navigationBarView)
		MaterialLayout.height(view, child: navigationBarView, height: 70)
	}
	
	/// Prepares an example that uses a detailLabel.
	private func prepareDetailLabelExample() {
		let navigationBarView: NavigationBarView = NavigationBarView()
		navigationBarView.backgroundColor = MaterialColor.purple.darken1
		
		/*
		To lighten the status bar - add the
		"View controller-based status bar appearance = NO"
		to your info.plist file and set the following property.
		*/
		navigationBarView.statusBarStyle = .LightContent
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Material"
		titleLabel.textAlignment = .Center
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.regularWithSize(20)
		navigationBarView.titleLabel = titleLabel
		
		// Detail label.
		let detailLabel: UILabel = UILabel()
		detailLabel.text = "Build Beautiful Software"
		detailLabel.textAlignment = .Center
		detailLabel.textColor = MaterialColor.white
		detailLabel.font = RobotoFont.regularWithSize(12)
		navigationBarView.detailLabel = detailLabel
		
		// To support orientation changes, use MaterialLayout.
		view.addSubview(navigationBarView)
		navigationBarView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: navigationBarView)
		MaterialLayout.alignToParentHorizontally(view, child: navigationBarView)
		MaterialLayout.height(view, child: navigationBarView, height: 70)
	}
	
	/// Prepares an example that uses a background image.
	private func prepareBackgroundImageExample() {
		let navigationBarView: NavigationBarView = NavigationBarView()
		navigationBarView.image = UIImage(named: "NavigationBarViewTexture")
		navigationBarView.contentsGravity = .ResizeAspectFill
		
		/*
		To lighten the status bar - add the
		"View controller-based status bar appearance = NO"
		to your info.plist file and set the following property.
		*/
		navigationBarView.statusBarStyle = .LightContent
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Material"
		titleLabel.textAlignment = .Center
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.boldWithSize(22)
		navigationBarView.titleLabel = titleLabel
		
		// To support orientation changes, use MaterialLayout.
		view.addSubview(navigationBarView)
		navigationBarView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: navigationBarView)
		MaterialLayout.alignToParentHorizontally(view, child: navigationBarView)
		MaterialLayout.height(view, child: navigationBarView, height: 70)
	}
	
	/// Prepares an example that uses buttons.
	private func prepareButtonExample() {
		let navigationBarView: NavigationBarView = NavigationBarView()
		navigationBarView.backgroundColor = MaterialColor.blueGrey.darken4
		
		/*
		To lighten the status bar - add the
		"View controller-based status bar appearance = NO"
		to your info.plist file and set the following property.
		*/
		navigationBarView.statusBarStyle = .LightContent
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Material"
		titleLabel.textAlignment = .Center
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.regularWithSize(20)
		navigationBarView.titleLabel = titleLabel
		
		// Menu button.
		let img1: UIImage? = UIImage(named: "ic_menu_white")
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.white
		btn1.pulseScale = false
		btn1.setImage(img1, forState: .Normal)
		btn1.setImage(img1, forState: .Highlighted)
		
		// Star button.
		let img2: UIImage? = UIImage(named: "ic_star_white")
		let btn2: FlatButton = FlatButton()
		btn2.pulseColor = MaterialColor.white
		btn2.pulseScale = false
		btn2.setImage(img2, forState: .Normal)
		btn2.setImage(img2, forState: .Highlighted)
		
		// Search button.
		let img3: UIImage? = UIImage(named: "ic_search_white")
		let btn3: FlatButton = FlatButton()
		btn3.pulseColor = MaterialColor.white
		btn3.pulseScale = false
		btn3.setImage(img3, forState: .Normal)
		btn3.setImage(img3, forState: .Highlighted)
		
		// Add buttons to left side.
		navigationBarView.leftButtons = [btn1]
		
		// Add buttons to right side.
		navigationBarView.rightButtons = [btn2, btn3]
		
		// To support orientation changes, use MaterialLayout.
		view.addSubview(navigationBarView)
		navigationBarView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: navigationBarView)
		MaterialLayout.alignToParentHorizontally(view, child: navigationBarView)
		MaterialLayout.height(view, child: navigationBarView, height: 70)
	}
	
	/// Prepares a text alignment example.
	private func prepareAlignTitleAndDetailLabelToLeftExample() {
		let navigationBarView: NavigationBarView = NavigationBarView()
		navigationBarView.backgroundColor = MaterialColor.blue.base
		
		/*
		To lighten the status bar - add the
		"View controller-based status bar appearance = NO"
		to your info.plist file and set the following property.
		*/
		navigationBarView.statusBarStyle = .LightContent
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Material"
		titleLabel.textAlignment = .Left
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.regularWithSize(20)
		navigationBarView.titleLabel = titleLabel
		navigationBarView.titleLabelInset.left = 64
		
		// Detail label.
		let detailLabel: UILabel = UILabel()
		detailLabel.text = "Build Beautiful Software"
		detailLabel.textAlignment = .Left
		detailLabel.textColor = MaterialColor.white
		detailLabel.font = RobotoFont.regularWithSize(12)
		navigationBarView.detailLabel = detailLabel
		navigationBarView.detailLabelInset.left = 64
		
		// Menu button.
		let img1: UIImage? = UIImage(named: "ic_menu_white")
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.white
		btn1.pulseScale = false
		btn1.setImage(img1, forState: .Normal)
		btn1.setImage(img1, forState: .Highlighted)
		
		// Star button.
		let img2: UIImage? = UIImage(named: "ic_star_white")
		let btn2: FlatButton = FlatButton()
		btn2.pulseColor = MaterialColor.white
		btn2.pulseScale = false
		btn2.setImage(img2, forState: .Normal)
		btn2.setImage(img2, forState: .Highlighted)
		
		// Search button.
		let img3: UIImage? = UIImage(named: "ic_search_white")
		let btn3: FlatButton = FlatButton()
		btn3.pulseColor = MaterialColor.white
		btn3.pulseScale = false
		btn3.setImage(img3, forState: .Normal)
		btn3.setImage(img3, forState: .Highlighted)
		
		// Add buttons to left side.
		navigationBarView.leftButtons = [btn1]
		
		// Add buttons to right side.
		navigationBarView.rightButtons = [btn2, btn3]
		
		// To support orientation changes, use MaterialLayout.
		view.addSubview(navigationBarView)
		navigationBarView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: navigationBarView)
		MaterialLayout.alignToParentHorizontally(view, child: navigationBarView)
		MaterialLayout.height(view, child: navigationBarView, height: 70)
	}
}

