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
There are 3 button types that may be easily customized -- a FlatButton,
RaisedButton, and FabButton. Below are examples of their usage.
*/

import UIKit
import Material

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareFlatButtonExample()
		prepareRaisedButtonExample()
		prepareFabButtonExample()
//		prepareFabButtonAnimationExample()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the FlatButton.
	private func prepareFlatButtonExample() {
		let button: FlatButton = FlatButton(frame: CGRectMake(107, 107, 200, 65))
		button.setTitle("Flat", forState: .Normal)
		button.titleLabel!.font = RobotoFont.mediumWithSize(32)
		
		// Add button to UIViewController.
		view.addSubview(button)
	}
	
	/// Prepares the RaisedButton.
	private func prepareRaisedButtonExample() {
		let button: RaisedButton = RaisedButton(frame: CGRectMake(107, 207, 200, 65))
		button.setTitle("Raised", forState: .Normal)
		button.titleLabel!.font = RobotoFont.mediumWithSize(32)
		
		// Add button to UIViewController.
		view.addSubview(button)
	}
	
	/// Prepares the FabButton.
	private func prepareFabButtonExample() {
		let img: UIImage? = UIImage(named: "ic_create_white")
		let button: FabButton = FabButton(frame: CGRectMake(175, 315, 64, 64))
		button.setImage(img, forState: .Normal)
		button.setImage(img, forState: .Highlighted)
		
		// Add button to UIViewController.
		view.addSubview(button)
	}
	
	/// Prepares the FabButton animation example. 
	private func prepareFabButtonAnimationExample() {
		let img: UIImage? = UIImage(named: "ic_create_white")
		let button: FabButton = FabButton(frame: CGRectMake(175, 315, 64, 64))
		button.setImage(img, forState: .Normal)
		button.setImage(img, forState: .Highlighted)
		
		// Add button to UIViewController.
		view.addSubview(button)
		
		UIView.animateWithDuration(0.4,
			delay: 3,
			usingSpringWithDamping: 0.6,
			initialSpringVelocity: 0,
			options: .AllowUserInteraction,
			animations: {
				button.frame.origin.x = 300
			}, completion: nil)
	}
}

