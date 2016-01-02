//
// Copyright (C) 2015 - 2016 CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.. 
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

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		
		// Toggle SideNavigationViewController.
		let img: UIImage? = UIImage(named: "ic_create_white")
		let fabButton: FabButton = FabButton()
		fabButton.setImage(img, forState: .Normal)
		fabButton.setImage(img, forState: .Highlighted)
		fabButton.addTarget(self, action: "handleFabButton", forControlEvents: .TouchUpInside)
		
		view.addSubview(fabButton)
		fabButton.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromBottomRight(view, child: fabButton, bottom: 16, right: 16)
		MaterialLayout.size(view, child: fabButton, width: 64, height: 64)
    }
	
	// FabButton handler.
	func handleFabButton() {
		sideNavigationViewController?.toggle()
	}
}

