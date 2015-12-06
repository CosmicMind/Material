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
		
		// Examples of using CardView.
		// Uncomment different examples and read
		// the comments below.
//		prepareGeneralCardViewExample()
//		prepareCardViewWithoutPulseBackgroundImageExample()
//		prepareCardViewWithAlteredAlignmentExample()
		prepareCardViewButtonBar()
	}
	
	/**
	:name:	prepareView
	:description: General preparation statements.
	*/
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/**
	:name:	prepareGeneralCardViewExample
	:description:	General usage example.
	*/
	private func prepareGeneralCardViewExample() {
		let cardView: CardView = CardView()
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Welcome Back!"
		titleLabel.textColor = MaterialColor.blue.darken1
		titleLabel.font = RobotoFont.mediumWithSize(20)
		cardView.titleLabel = titleLabel
		
		// Detail label
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
		
		// To support orientation changes, use MaterialLayout.
		view.addSubview(cardView)
		cardView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: cardView, top: 100)
		MaterialLayout.alignToParentHorizontally(view, child: cardView, left: 20, right: 20)
		
	}
	
	/**
	:name:	prepareCardViewWithoutPulseBackgroundImageExample
	:description:	An example of the CardView without the pulse animation and an added background image.
	*/
	private func prepareCardViewWithoutPulseBackgroundImageExample() {
		let cardView: CardView = CardView()
		cardView.divider = false
		cardView.backgroundColor = MaterialColor.red.darken1
		cardView.pulseScale = false
		cardView.pulseColor = nil
		
		// Image.
		cardView.image = UIImage(named: "iTunesArtwork")?.resize(toWidth: 400)
		cardView.contentsGravity = .BottomRight
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "MaterialKit"
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.mediumWithSize(24)
		cardView.titleLabel = titleLabel
		
		// Detail label
		let detailLabel: UILabel = UILabel()
		detailLabel.text = "Build beautiful software."
		detailLabel.textColor = MaterialColor.white
		detailLabel.numberOfLines = 0
		cardView.detailLabel = detailLabel
		
		// Favorite button.
		let img1: UIImage? = UIImage(named: "ic_favorite_white")
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.white
		btn1.pulseFill = true
		btn1.pulseScale = false
		btn1.setImage(img1, forState: .Normal)
		btn1.setImage(img1, forState: .Highlighted)
		
		// Add buttons to left side.
		cardView.leftButtons = [btn1]
		
		// To support orientation changes, use MaterialLayout.
		view.addSubview(cardView)
		cardView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: cardView, top: 100)
		MaterialLayout.alignToParentHorizontally(view, child: cardView, left: 20, right: 20)
	}
	
	/**
	:name:	prepareCardViewWithAlteredAlignmentExample
	:description:	An example of the CardView with an altered alignment of the UI elements.
	*/
	private func prepareCardViewWithAlteredAlignmentExample() {
		let cardView: CardView = CardView()
		cardView.dividerInsetsRef.left = 100
		cardView.titleLabelInsetsRef.left = 100
		cardView.detailLabelInsetsRef.left = 100
		cardView.pulseColor = MaterialColor.teal.lighten4
		
		// Image.
		cardView.image = UIImage(named: "GraphKit")
		cardView.contentsGravity = .TopLeft
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "GraphKit"
		titleLabel.font = RobotoFont.mediumWithSize(24)
		cardView.titleLabel = titleLabel
		
		// Detail label
		let detailLabel: UILabel = UILabel()
		detailLabel.text = "Build scalable data-driven apps."
		detailLabel.numberOfLines = 0
		cardView.detailLabel = detailLabel
		
		// LEARN MORE button.
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.teal.lighten1
		btn1.pulseFill = true
		btn1.pulseScale = false
		btn1.setTitle("LEARN MORE", forState: .Normal)
		btn1.setTitleColor(MaterialColor.teal.darken1, forState: .Normal)
		
		// Add buttons to right side.
		cardView.rightButtons = [btn1]
		
		// To support orientation changes, use MaterialLayout.
		view.addSubview(cardView)
		cardView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: cardView, top: 100)
		MaterialLayout.alignToParentHorizontally(view, child: cardView, left: 20, right: 20)
	}
	
	/**
	:name:	prepareCardViewButtonBar
	:description:	An example of the CardView with only buttons to create a button bar.
	*/
	private func prepareCardViewButtonBar() {
		let cardView: CardView = CardView()
		cardView.divider = false
		cardView.pulseColor = nil
		cardView.pulseScale = false
		cardView.backgroundColor = MaterialColor.blueGrey.darken4
		
		// Favorite button.
		let img1: UIImage? = UIImage(named: "ic_search_white")
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.white
		btn1.pulseFill = true
		btn1.pulseScale = false
		btn1.setImage(img1, forState: .Normal)
		btn1.setImage(img1, forState: .Highlighted)
		
		// BUTTON 1 button.
		let btn2: FlatButton = FlatButton()
		btn2.pulseColor = MaterialColor.teal.lighten3
		btn2.pulseFill = true
		btn2.pulseScale = false
		btn2.setTitle("BUTTON 1", forState: .Normal)
		btn2.setTitleColor(MaterialColor.teal.lighten3, forState: .Normal)
		
		// BUTTON 2 button.
		let btn3: FlatButton = FlatButton()
		btn3.pulseColor = MaterialColor.teal.lighten3
		btn3.pulseFill = true
		btn3.pulseScale = false
		btn3.setTitle("BUTTON 2", forState: .Normal)
		btn3.setTitleColor(MaterialColor.teal.lighten3, forState: .Normal)
		
		// Add buttons to left side.
		cardView.leftButtons = [btn1]
		
		// Add buttons to right side.
		cardView.rightButtons = [btn2, btn3]
		
		// To support orientation changes, use MaterialLayout.
		view.addSubview(cardView)
		cardView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: cardView, top: 100)
		MaterialLayout.alignToParentHorizontally(view, child: cardView, left: 20, right: 20)
	}
}

