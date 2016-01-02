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

class ViewController: UIViewController {

    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var secondCardView: CardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Examples of using CardView
        prepareCardViewExample()
        prepareCardViewExampleTwo()
    }
    
    /**
     :name:	prepareView
     :description: General preparation statements.
     */
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }
    
    /**
     :name:	prepareCardViewExample
     :description:	General usage example.
     */
    func prepareCardViewExample() {
        // Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Welcome Back!"
		titleLabel.textColor = MaterialColor.blue.darken1
		titleLabel.font = RobotoFont.mediumWithSize(20)
		cardView.titleLabel = titleLabel
		
		// Detail label.
		let detailLabel: UILabel = UILabel()
		detailLabel.text = "It’s been a while, have you read any new books lately?"
		detailLabel.numberOfLines = 0
		cardView.detailLabel = detailLabel
		
		// Yes button.
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.blue.lighten1
		btn1.pulseFill = true
		btn1.pulseScale = false
		btn1.setTitle("YES", forState: .Normal)
		btn1.setTitleColor(MaterialColor.blue.darken1, forState: .Normal)
		
		// No button.
		let btn2: FlatButton = FlatButton()
		btn2.pulseColor = MaterialColor.blue.lighten1
		btn2.pulseFill = true
		btn2.pulseScale = false
		btn2.setTitle("NO", forState: .Normal)
		btn2.setTitleColor(MaterialColor.blue.darken1, forState: .Normal)
		
		// Add buttons to left side.
		cardView.leftButtons = [btn1, btn2]
	}
    
    /**
     :name:	prepareCardViewExampleTwo
     :description:	General usage example.
     */
    func prepareCardViewExampleTwo() {
        secondCardView.dividerInsetsRef.left = 100
        secondCardView.titleLabelInsetsRef.left = 100
        secondCardView.detailLabelInsetsRef.left = 100
        secondCardView.pulseColor = MaterialColor.teal.lighten4
        
        // Image.
        secondCardView.image = UIImage(named: "GraphKit")
        secondCardView.contentsGravity = .TopLeft
        
        // Title label.
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "GraphKit"
        titleLabel.font = RobotoFont.mediumWithSize(24)
        secondCardView.titleLabel = titleLabel
        
        // Detail label.
        let detailLabel: UILabel = UILabel()
        detailLabel.text = "Build scalable data-driven apps."
        detailLabel.numberOfLines = 0
        secondCardView.detailLabel = detailLabel
        
        // LEARN MORE button.
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.teal.lighten1
		btn1.pulseFill = true
		btn1.pulseScale = false
		btn1.setTitle("LEARN MORE", forState: .Normal)
		btn1.setTitleColor(MaterialColor.teal.darken1, forState: .Normal)
		
        // Add buttons to right side.
        secondCardView.rightButtons = [btn1]
    }
}

