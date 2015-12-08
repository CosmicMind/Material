//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io> and other CosmicMind contributors
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import MaterialKit

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		
		// Examples of using MaterialButton.
		prepareFlatButtonExample()
		prepareRaisedButtonExample()
		prepareFabButtonExample()
	}
	
	/**
	:name:	prepareView
	:description: General preparation statements.
	*/
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/**
	:name:	prepareFlatButtonExample
	:description:	FlatButton example.
	*/
	private func prepareFlatButtonExample() {
		let button: FlatButton = FlatButton(frame: CGRectMake(107, 107, 200, 65))
		button.setTitle("Flat", forState: .Normal)
		button.titleLabel!.font = RobotoFont.mediumWithSize(32)
		
		// Add to UIViewController.
		view.addSubview(button)
	}
	
	/**
	:name:	prepareRaisedButtonExample
	:description:	RaisedButton example.
	*/
	private func prepareRaisedButtonExample() {
		let button: RaisedButton = RaisedButton(frame: CGRectMake(107, 207, 200, 65))
		button.setTitle("Raised", forState: .Normal)
		button.titleLabel!.font = RobotoFont.mediumWithSize(32)
		
		// Add to UIViewController.
		view.addSubview(button)
	}
	
	/**
	:name:	prepareFabButtonExample
	:description:	FabButton example.
	*/
	private func prepareFabButtonExample() {
		let img: UIImage? = UIImage(named: "ic_create_white")
		let button: FabButton = FabButton(frame: CGRectMake(175, 315, 64, 64))
		button.setImage(img, forState: .Normal)
		button.setImage(img, forState: .Highlighted)
		
		// Add to UIViewController.
		view.addSubview(button)
	}
}

