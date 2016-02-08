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

*/

import UIKit
import Material

class ViewController: UIViewController {
	private var menuLayout: MenuLayout!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareMenuLayoutExample()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
	}
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
		menuLayout.width = size.width
		menuLayout.height = size.height
		menuLayout.reloadLayout()
	}
	
	internal func handleOpenMenuLayout() {
		if menuLayout.opened {
			menuLayout.close()
		} else {
//			(menuLayout.items?.first?.button as? MaterialButton)?.animate(MaterialAnimation.rotate(1))
			menuLayout.open() { (item: MenuLayoutItem) in
				(item.button as? MaterialButton)?.pulse()
			}
		}
	}
	
	/// General preparation statements are placed here.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the MenuLayout example.
	private func prepareMenuLayoutExample() {
//		let btn: FlatButton = FlatButton(frame: CGRectMake(100, 100, 100, 100))
//		btn.backgroundColor = MaterialColor.red.base
//		view.addSubview(btn)
		
		let image: UIImage? = UIImage(named: "ic_add_white")
		let btn1: FabButton = FabButton()
		btn1.depth = .Depth1
		btn1.setImage(image, forState: .Normal)
		btn1.setImage(image, forState: .Highlighted)
		btn1.addTarget(self, action: "handleOpenMenuLayout", forControlEvents: .TouchUpInside)
		view.addSubview(btn1)
		
		let btn2: FabButton = FabButton()
		btn2.depth = .Depth1
		btn2.backgroundColor = MaterialColor.blue.base
		btn2.setImage(image, forState: .Normal)
		btn2.setImage(image, forState: .Highlighted)
		view.addSubview(btn2)
		
		let btn3: FabButton = FabButton()
		btn3.depth = .Depth1
		btn3.backgroundColor = MaterialColor.green.base
		btn3.setImage(image, forState: .Normal)
		btn3.setImage(image, forState: .Highlighted)
		view.addSubview(btn3)
		
		let btn4: FabButton = FabButton()
		btn4.depth = .Depth1
		btn4.backgroundColor = MaterialColor.yellow.base
		btn4.setImage(image, forState: .Normal)
		btn4.setImage(image, forState: .Highlighted)
		view.addSubview(btn4)
		
		menuLayout = MenuLayout()
		menuLayout.baseSize = CGSizeMake(56, 56)
		menuLayout.itemSize = CGSizeMake(48, 48)
		
		menuLayout.items = [
			MenuLayoutItem(button: btn1),
			MenuLayoutItem(button: btn2),
			MenuLayoutItem(button: btn3),
			MenuLayoutItem(button: btn4)
		]
	}
}

