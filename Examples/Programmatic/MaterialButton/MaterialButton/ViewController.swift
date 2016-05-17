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
		prepareIconButtonExample()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the FlatButton.
	private func prepareFlatButtonExample() {
		let w: CGFloat = 200
		let button: FlatButton = FlatButton(frame: CGRectMake((view.bounds.width - w) / 2, 100, w, 48))
		button.setTitle("Flat", forState: .Normal)
		button.setTitleColor(MaterialColor.blue.base, forState: .Normal)
		button.pulseColor = MaterialColor.blue.base
		button.titleLabel!.font = RobotoFont.mediumWithSize(24)
		
		// Add button to UIViewController.
		view.addSubview(button)
	}
	
	/// Prepares the RaisedButton.
	private func prepareRaisedButtonExample() {
		let w: CGFloat = 200
		let button: RaisedButton = RaisedButton(frame: CGRectMake((view.bounds.width - w) / 2, 200, w, 48))
		button.setTitle("Raised", forState: .Normal)
		button.setTitleColor(MaterialColor.blue.base, forState: .Normal)
		button.pulseColor = MaterialColor.blue.base
		button.titleLabel!.font = RobotoFont.mediumWithSize(24)
		
		// Add button to UIViewController.
		view.addSubview(button)
	}
	
	/// Prepares the FabButton.
	private func prepareFabButtonExample() {
		let w: CGFloat = 64
		let img: UIImage? = MaterialIcon.cm.pen
		let button: FabButton = FabButton(frame: CGRectMake((view.bounds.width - w) / 2, 300, w, w))
		button.setImage(img, forState: .Normal)
		button.setImage(img, forState: .Highlighted)
		
		// Add button to UIViewController.
		view.addSubview(button)
	}
	
	/// Prepares the IconButton.
	private func prepareIconButtonExample() {
		let w: CGFloat = 64
		let img: UIImage? = MaterialIcon.cm.search
		let button: IconButton = IconButton(frame: CGRectMake((view.bounds.width - w) / 2, 400, w, w))
		button.setImage(img, forState: .Normal)
		button.setImage(img, forState: .Highlighted)
		
		// Add button to UIViewController.
		view.addSubview(button)
	}
}

