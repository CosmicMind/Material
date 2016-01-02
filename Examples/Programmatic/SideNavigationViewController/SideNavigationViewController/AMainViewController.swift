//
// Copyright (C) 2015 - 2016 CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved. 
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

class AMainViewController: UIViewController {
	lazy var enabledButton: RaisedButton = RaisedButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareSwapSideNavigationViewControllerExample()
	}
	
	internal func handleSwapViewControllers() {
		sideNavigationViewController?.transitionFromMainViewController(BMainViewController(),
			duration: 0.25,
			options: .TransitionCrossDissolve,
			animations: nil,
			completion: nil)
	}
	
	internal func handleEnabledButton() {
		if true == sideNavigationViewController?.enabled {
			sideNavigationViewController?.enabled = false
			enabledButton.setTitle("Disabled", forState: .Normal)
		} else {
			sideNavigationViewController?.enabled = true
			enabledButton.setTitle("Enabled", forState: .Normal)
		}
	}
	
	private func prepareView() {
		view.backgroundColor = MaterialColor.blue.base
		prepareEnabledButton()
	}
	
	private func prepareEnabledButton() {
		enabledButton.setTitle("Enabled", forState: .Normal)
		enabledButton.addTarget(self, action: "handleEnabledButton", forControlEvents: .TouchUpInside)
		
		// Add the enabledButton through MaterialLayout.
		view.addSubview(enabledButton)
		enabledButton.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTopRight(view, child: enabledButton, top: 124, right: 24)
		MaterialLayout.size(view, child: enabledButton, width: 200, height: 50)
	}
	
	private func prepareSwapSideNavigationViewControllerExample() {
		let button: FabButton = FabButton()
		button.addTarget(self, action: "handleSwapViewControllers", forControlEvents: .TouchUpInside)
		
		// Add the button through MaterialLayout.
		view.addSubview(button)
		button.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromBottomRight(view, child: button, bottom: 24, right: 24)
		MaterialLayout.size(view, child: button, width: 64, height: 64)
	}
}

