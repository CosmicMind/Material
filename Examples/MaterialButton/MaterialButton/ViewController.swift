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
		let v: FlatButton = FlatButton(frame: CGRectMake(107, 107, 200, 65))
		v.setTitle("Flat", forState: .Normal)
		v.titleLabel!.font = RobotoFont.mediumWithSize(32)
		
		// Add to UIViewController.
		view.addSubview(v)
	}
	
	/**
	:name:	prepareRaisedButtonExample
	:description:	RaisedButton example.
	*/
	private func prepareRaisedButtonExample() {
		let v: RaisedButton = RaisedButton(frame: CGRectMake(107, 207, 200, 65))
		v.setTitle("Raised", forState: .Normal)
		v.titleLabel!.font = RobotoFont.mediumWithSize(32)
		
		// Add to UIViewController.
		view.addSubview(v)
	}
	
	/**
	:name:	prepareFabButtonExample
	:description:	FabButton example.
	*/
	private func prepareFabButtonExample() {
		let v: FabButton = FabButton(frame: CGRectMake(175, 315, 64, 64))
		v.setImage(UIImage(named: "ic_create_white"), forState: .Normal)
		v.setImage(UIImage(named: "ic_create_white"), forState: .Highlighted)
		
		// Add to UIViewController.
		view.addSubview(v)
	}
}

