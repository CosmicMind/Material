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
	/// Menu component.
	private var menu: Menu!
	
	/// Default spacing size
	let spacing: CGFloat = 16
	
	/// Base button diameter, otherwise default to buttonSize (48 x 48)
	let diameter: CGFloat = 56
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareMenuExample()
	}
	
	/// Handle orientation.
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
		
		// Handle orientation change.
		menu.origin = CGPointMake(view.bounds.height - diameter - spacing, view.bounds.width - diameter - spacing)
	}
	
	/// Handle the base button touch event.
	internal func handleOpenMenu() {
		// Only trigger open and close animations when enabled.
		if menu.enabled {
			let image: UIImage?
			if menu.opened {
				menu.close()
				image = UIImage(named: "ic_add_white")
			} else {
				menu.open() { (button: UIButton) in
					(button as? MaterialButton)?.pulse()
				}
				image = UIImage(named: "ic_close_white")
			}
			
			// Add a nice rotation animation to the base button.
			(menu.buttons?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(1))
			menu.buttons?.first?.setImage(image, forState: .Normal)
			menu.buttons?.first?.setImage(image, forState: .Highlighted)
		}
	}
	
	/// General preparation statements are placed here.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the Menu example.
	private func prepareMenuExample() {
		var image: UIImage? = UIImage(named: "ic_add_white")
		let btn1: FabButton = FabButton()
		/**
		Remove the pulse animation, so the rotation animation 
		doesn't seem like too much with the pulse animation.
		*/
		btn1.pulseColor = nil
		btn1.setImage(image, forState: .Normal)
		btn1.setImage(image, forState: .Highlighted)
		btn1.addTarget(self, action: "handleOpenMenu", forControlEvents: .TouchUpInside)
		view.addSubview(btn1)
		
		image = UIImage(named: "ic_create_white")
		let btn2: FabButton = FabButton()
		btn2.backgroundColor = MaterialColor.blue.base
		btn2.setImage(image, forState: .Normal)
		btn2.setImage(image, forState: .Highlighted)
		view.addSubview(btn2)
		
		image = UIImage(named: "ic_photo_camera_white")
		let btn3: FabButton = FabButton()
		btn3.backgroundColor = MaterialColor.green.base
		btn3.setImage(image, forState: .Normal)
		btn3.setImage(image, forState: .Highlighted)
		view.addSubview(btn3)
		
		image = UIImage(named: "ic_note_add_white")
		let btn4: FabButton = FabButton()
		btn4.backgroundColor = MaterialColor.amber.base
		btn4.setImage(image, forState: .Normal)
		btn4.setImage(image, forState: .Highlighted)
		view.addSubview(btn4)
		
		// Initialize the menu and setup the configuration options.
		menu = Menu(origin: CGPointMake(view.bounds.width - diameter - spacing, view.bounds.height - diameter - spacing))
		menu.direction = .Up
		menu.baseSize = CGSizeMake(diameter, diameter)
		menu.buttons = [btn1, btn2, btn3, btn4]
	}
}

