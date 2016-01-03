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

class ViewController: UIViewController {

    @IBOutlet weak var imageCardView: ImageCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Example of image card view
        prepareImageCardViewExample()
    }
    
    /**
     :name:	prepareImageCardViewExample
     :description: General preparation statements.
     */
    func prepareImageCardViewExample() {
		imageCardView.divider = false
		
		// Image.
		imageCardView.image = UIImage(named: "MaterialKitImageCardViewBackgroundImage")
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Material Design"
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.regularWithSize(24)
		imageCardView.titleLabel = titleLabel
		imageCardView.titleLabelInset.top = 80
		
		// Star button.
		let img1: UIImage? = UIImage(named: "ic_star_grey_darken_2")
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.blueGrey.lighten1
		btn1.pulseFill = true
		btn1.pulseScale = false
		btn1.setImage(img1, forState: .Normal)
		btn1.setImage(img1, forState: .Highlighted)
		
		// Favorite button.
		let img2: UIImage? = UIImage(named: "ic_favorite_grey_darken_2")
		let btn2: FlatButton = FlatButton()
		btn2.pulseColor = MaterialColor.blueGrey.lighten1
		btn2.pulseFill = true
		btn2.pulseScale = false
		btn2.setImage(img2, forState: .Normal)
		btn2.setImage(img2, forState: .Highlighted)
		
		// Share button.
		let img3: UIImage? = UIImage(named: "ic_share_grey_darken_2")
		let btn3: FlatButton = FlatButton()
		btn3.pulseColor = MaterialColor.blueGrey.lighten1
		btn3.pulseFill = true
		btn3.pulseScale = false
		btn3.setImage(img3, forState: .Normal)
		btn3.setImage(img3, forState: .Highlighted)
		
		// Add buttons to right side.
		imageCardView.rightButtons = [btn1, btn2, btn3]
		imageCardView.rightButtonsInset.top = imageCardView.contentInset.top
    }
}

