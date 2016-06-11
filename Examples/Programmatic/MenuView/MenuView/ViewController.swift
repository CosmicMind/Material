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

/**
This is an example of using the Menu component. It is designed to take any array
of buttons and provide a facility to animate them opened and closed as a group.
*/

import UIKit
import Material

class ViewController: UIViewController {
	/// MenuView reference.
	private lazy var menuView: MenuView = MenuView()
	
	/// Default spacing size
	let spacing: CGFloat = 16
	
	/// Diameter for FabButtons.
	let diameter: CGFloat = 56
	
	/// Height for FlatButtons.
	let height: CGFloat = 36
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareMenuViewExample()
	}
	
	/// Handle the menuView touch event.
	internal func handleMenu() {
		if menuView.menu.opened {
			menuView.menu.close()
			(menuView.menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(rotation: 0))
		} else {
			menuView.menu.open() { (v: UIView) in
				(v as? MaterialButton)?.pulse()
			}
			(menuView.menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(rotation: 0.125))
		}
	}
	
	/// Handle the menuView touch event.
	@objc(handleButton:)
	internal func handleButton(button: UIButton) {
		print("Hit Button \(button)")
	}
	
	/// General preparation statements are placed here.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the MenuView example.
	private func prepareMenuViewExample() {
		var image: UIImage? = UIImage(named: "ic_add_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn1: FabButton = FabButton()
		btn1.depth = .None
		btn1.tintColor = MaterialColor.blue.accent3
		btn1.borderColor = MaterialColor.blue.accent3
		btn1.backgroundColor = MaterialColor.white
		btn1.borderWidth = 1
		btn1.setImage(image, forState: .Normal)
		btn1.setImage(image, forState: .Highlighted)
		btn1.addTarget(self, action: #selector(handleMenu), forControlEvents: .TouchUpInside)
		menuView.addSubview(btn1)
		
		image = UIImage(named: "ic_create_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn2: FabButton = FabButton()
		btn2.depth = .None
		btn2.tintColor = MaterialColor.blue.accent3
		btn2.pulseColor = MaterialColor.blue.accent3
		btn2.borderColor = MaterialColor.blue.accent3
		btn2.backgroundColor = MaterialColor.white
		btn2.borderWidth = 1
		btn2.setImage(image, forState: .Normal)
		btn2.setImage(image, forState: .Highlighted)
		btn2.addTarget(self, action: #selector(handleButton), forControlEvents: .TouchUpInside)
		menuView.addSubview(btn2)
		
		image = UIImage(named: "ic_photo_camera_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn3: FabButton = FabButton()
		btn3.depth = .None
		btn3.tintColor = MaterialColor.blue.accent3
		btn3.pulseColor = MaterialColor.blue.accent3
		btn3.borderColor = MaterialColor.blue.accent3
		btn3.backgroundColor = MaterialColor.white
		btn3.borderWidth = 1
		btn3.setImage(image, forState: .Normal)
		btn3.setImage(image, forState: .Highlighted)
		btn3.addTarget(self, action: #selector(handleButton), forControlEvents: .TouchUpInside)
		menuView.addSubview(btn3)
		
		image = UIImage(named: "ic_note_add_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn4: FabButton = FabButton()
		btn4.depth = .None
		btn4.tintColor = MaterialColor.blue.accent3
		btn4.pulseColor = MaterialColor.blue.accent3
		btn4.borderColor = MaterialColor.blue.accent3
		btn4.backgroundColor = MaterialColor.white
		btn4.borderWidth = 1
		btn4.setImage(image, forState: .Normal)
		btn4.setImage(image, forState: .Highlighted)
		btn4.addTarget(self, action: #selector(handleButton), forControlEvents: .TouchUpInside)
		menuView.addSubview(btn4)
		
		// Initialize the menu and setup the configuration options.
		menuView.menu.direction = .Up
		menuView.menu.baseSize = CGSizeMake(diameter, diameter)
		menuView.menu.views = [btn1, btn2, btn3, btn4]
		
		view.layout(menuView).width(diameter).height(diameter).bottom(16).centerHorizontally()		
	}
}

