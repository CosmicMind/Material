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

class BMainViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		
		// Examples of using Capture.
		// Uncomment different examples and read
		// the comments below.
		prepareSwapSideNavigationViewControllerExample()
	}
	
	internal func handleSwapViewControllers() {
		sideNavigationViewController?.mainViewController = AMainViewController()
	}
	
	/**
	:name:	prepareView
	:description: General preparation statements.
	*/
	private func prepareView() {
		view.backgroundColor = MaterialColor.blue.base
	}
	
	/**
	:name:	prepareGeneralSideNavigationViewControllerExample
	:description:	General usage example.
	*/
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

