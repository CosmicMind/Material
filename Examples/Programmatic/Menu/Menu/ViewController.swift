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
of views and provide a facility to animate them opened and closed as a group.
*/

import UIKit
import Material

class ViewController: UIViewController {
	/// FabMenu component.
	private var fabMenu: Menu!
	
	/// FlatMenu component.
	private var flatMenu: Menu!
	
	/// FlashMenu component.
	private var flashMenu: Menu!
	
	/// Default spacing size
	let spacing: CGFloat = 16
	
	/// Diameter for FabButtons.
	let diameter: CGFloat = 56
	
	/// Height for FlatButtons.
	let height: CGFloat = 36
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareFabMenuExample()
		prepareFlatbMenuExample()
		prepareFlashMenuExample()
	}
	
	/// Handle orientation.
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
		
		// Handle orientation change.
		fabMenu.origin = CGPointMake(view.bounds.height - diameter - spacing, view.bounds.width - diameter - spacing)
		flatMenu.origin = CGPointMake(spacing, view.bounds.height - height - spacing)
	}
	
	/// Handle the fabMenu touch event.
	internal func handleFabMenu() {
		let image: UIImage?
		
		if fabMenu.opened {
			fabMenu.close()
			image = MaterialIcon.cm.add
		} else {
			fabMenu.open() { (v: UIView) in
				(v as? MaterialButton)?.pulse()
			}
			image = MaterialIcon.cm.close
		}
		
		// Add a nice rotation animation to the base button.
		let first: MaterialButton? = fabMenu.views?.first as? MaterialButton
		first?.animate(MaterialAnimation.rotate(rotation: 1))
		first?.setImage(image, forState: .Normal)
		first?.setImage(image, forState: .Highlighted)
	}
	
	/// Handle the flatMenu touch event.
	internal func handleFlatMenu() {
		// Only trigger open and close animations when enabled.
		if flatMenu.enabled {
			if flatMenu.opened {
				flatMenu.close()
			} else {
				flatMenu.open()
			}
		}
	}
	
	/// Handle the flashMenu touch event.
	internal func handleFlashMenu() {
		// Only trigger open and close animations when enabled.
		if flashMenu.enabled {
			if flashMenu.opened {
				flashMenu.close()
			} else {
				flashMenu.open()
			}
		}
	}
	
	/// General preparation statements are placed here.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the FabMenu example.
	private func prepareFabMenuExample() {
		var image: UIImage? = UIImage(named: "ic_add_white")
		let btn1: FabButton = FabButton()
		btn1.setImage(image, forState: .Normal)
		btn1.setImage(image, forState: .Highlighted)
		btn1.addTarget(self, action: #selector(handleFabMenu), forControlEvents: .TouchUpInside)
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
		fabMenu = Menu(origin: CGPointMake(view.bounds.width - diameter - spacing, view.bounds.height - diameter - spacing))
		fabMenu.direction = .Up
		fabMenu.baseSize = CGSizeMake(diameter, diameter)
		fabMenu.views = [btn1, btn2, btn3, btn4]
	}
	
	/// Prepares the FlatMenu example.
	private func prepareFlatbMenuExample() {
		let btn1: FlatButton = FlatButton()
		btn1.addTarget(self, action: #selector(handleFlatMenu), forControlEvents: .TouchUpInside)
		btn1.setTitleColor(MaterialColor.white, forState: .Normal)
		btn1.backgroundColor = MaterialColor.blue.accent3
		btn1.pulseColor = MaterialColor.white
		btn1.setTitle("Base", forState: .Normal)
		view.addSubview(btn1)
		
		let btn2: FlatButton = FlatButton()
		btn2.setTitleColor(MaterialColor.blue.accent3, forState: .Normal)
		btn2.borderColor = MaterialColor.blue.accent3
		btn2.pulseColor = MaterialColor.blue.accent3
		btn2.borderWidth = 1
		btn2.setTitle("Item", forState: .Normal)
		view.addSubview(btn2)
		
		let btn3: FlatButton = FlatButton()
		btn3.setTitleColor(MaterialColor.blue.accent3, forState: .Normal)
		btn3.borderColor = MaterialColor.blue.accent3
		btn3.pulseColor = MaterialColor.blue.accent3
		btn3.borderWidth = 1
		btn3.setTitle("Item", forState: .Normal)
		view.addSubview(btn3)
		
		let btn4: FlatButton = FlatButton()
		btn4.setTitleColor(MaterialColor.blue.accent3, forState: .Normal)
		btn4.borderColor = MaterialColor.blue.accent3
		btn4.pulseColor = MaterialColor.blue.accent3
		btn4.borderWidth = 1
		btn4.setTitle("Item", forState: .Normal)
		view.addSubview(btn4)
		
		// Initialize the menu and setup the configuration options.
		flatMenu = Menu(origin: CGPointMake(spacing, view.bounds.height - height - spacing))
		flatMenu.direction = .Up
		flatMenu.spacing = 8
		flatMenu.itemSize = CGSizeMake(120, height)
		flatMenu.views = [btn1, btn2, btn3, btn4]
	}
	
	/// Prepares the FlashMenu example.
	private func prepareFlashMenuExample() {
		var image: UIImage? = UIImage(named: "ic_flash_auto_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.blueGrey.darken4
		btn1.tintColor = MaterialColor.blueGrey.darken4
		btn1.setImage(image, forState: .Normal)
		btn1.setImage(image, forState: .Highlighted)
		btn1.addTarget(self, action: #selector(handleFlashMenu), forControlEvents: .TouchUpInside)
		view.addSubview(btn1)
		
		image = UIImage(named: "ic_flash_off_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn2: FlatButton = FlatButton()
		btn2.pulseColor = MaterialColor.blueGrey.darken4
		btn2.tintColor = MaterialColor.blueGrey.darken4
		btn2.setImage(image, forState: .Normal)
		btn2.setImage(image, forState: .Highlighted)
		view.addSubview(btn2)
		
		image = UIImage(named: "ic_flash_on_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn3: FlatButton = FlatButton()
		btn3.pulseColor = MaterialColor.blueGrey.darken4
		btn3.tintColor = MaterialColor.blueGrey.darken4
		btn3.setImage(image, forState: .Normal)
		btn3.setImage(image, forState: .Highlighted)
		view.addSubview(btn3)
		
		// Initialize the menu and setup the configuration options.
		flashMenu = Menu(origin: CGPointMake((view.bounds.width + btn1.width) / 2, 100))
		flashMenu.direction = .Left
		flashMenu.itemSize = btn1.intrinsicContentSize()
		flashMenu.views = [btn1, btn2, btn3]
	}
}

