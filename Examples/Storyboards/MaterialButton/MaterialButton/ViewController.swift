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

    @IBOutlet weak var flatButton: FlatButton!
    @IBOutlet weak var raisedButton: RaisedButton!
    @IBOutlet weak var fabButton: FabButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Examples of using MaterialButton.
        prepareFlatButtonExample()
        prepareRaisedButtonExample()
        prepareFabButtonExample()
    }
    
    /**
     :name:	prepareFlatButtonExample
     :description: General preparation statements.
     */
    func prepareFlatButtonExample() {
        flatButton.setTitle("Flat", forState: .Normal)
        flatButton.titleLabel!.font = RobotoFont.mediumWithSize(32)
    }
    
    /**
     :name:	prepareRaisedButtonExample
     :description: General preparation statements.
     */
    func prepareRaisedButtonExample() {
        raisedButton.setTitle("Raised", forState: .Normal)
        raisedButton.titleLabel!.font = RobotoFont.mediumWithSize(28)
    }
    
    /**
     :name:	prepareFabButtonExample
     :description: General preparation statements.
     */
    func prepareFabButtonExample() {
        let img: UIImage? = UIImage(named: "ic_edit_white")
        fabButton.setImage(img, forState: .Normal)
        fabButton.setImage(img, forState: .Highlighted)
        fabButton.tintColor = UIColor.whiteColor()
    }
}

