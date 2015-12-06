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

// helper method
public extension UIImage {
	class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
		let rect = CGRectMake(0, 0, size.width, size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		color.setFill()
		UIRectFill(rect)
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
}

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		
		// Examples of using CardView.
		// Uncomment different examples and read
		// the comments below.
//		prepareGeneralImageCardViewExample()
		prepareImageCardViewWithoutDetailLabelAndDividerExample()
	}
	
	/**
	:name:	prepareView
	:description: General preparation statements.
	*/
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/**
	:name:	prepareGeneralImageCardViewExample
	:description:	General usage example.
	*/
	private func prepareGeneralImageCardViewExample() {
		let imageCardView: ImageCardView = ImageCardView()
		
		// Image.
		imageCardView.image = UIImage.imageWithColor(MaterialColor.cyan.darken1, size: CGSizeMake(UIScreen.mainScreen().bounds.width - CGFloat(40), 150))
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Welcome Back!"
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.mediumWithSize(24)
		imageCardView.titleLabel = titleLabel
		imageCardView.titleLabelInsetsRef.top = 100
		
		// Detail label
		let detailLabel: UILabel = UILabel()
		detailLabel.text = "It’s been a while, have you read any new books lately?"
		detailLabel.numberOfLines = 0
		imageCardView.detailLabel = detailLabel
		
		// Yes button.
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.cyan.lighten1
		btn1.pulseFill = true
		btn1.pulseScale = false
		btn1.setTitle("YES", forState: .Normal)
		btn1.setTitleColor(MaterialColor.cyan.darken1, forState: .Normal)
		
		// No button.
		let btn2: FlatButton = FlatButton()
		btn2.pulseColor = MaterialColor.cyan.lighten1
		btn2.pulseFill = true
		btn2.pulseScale = false
		btn2.setTitle("NO", forState: .Normal)
		btn2.setTitleColor(MaterialColor.cyan.darken1, forState: .Normal)
		
		// Add buttons to left side.
		imageCardView.leftButtons = [btn1, btn2]
		
		// To support orientation changes, use MaterialLayout.
		view.addSubview(imageCardView)
		imageCardView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: imageCardView, top: 100)
		MaterialLayout.alignToParentHorizontally(view, child: imageCardView, left: 20, right: 20)
	}
	
	/**
	:name:	prepareImageCardViewWithoutDetailLabelAndDividerExample
	:description:	The following example removes the detailLabel to create a new look and feel to the general example.
	*/
	private func prepareImageCardViewWithoutDetailLabelAndDividerExample() {
		let imageCardView: ImageCardView = ImageCardView()
		imageCardView.divider = false
		
		// Image.
		imageCardView.image = UIImage(named: "MaterialKitImageCardViewBackgroundImage")
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Material Design"
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.regularWithSize(24)
		imageCardView.titleLabel = titleLabel
		imageCardView.titleLabelInsetsRef.top = 80
		
		// Check button.
		let img1: UIImage? = UIImage(named: "ic_check_blue_grey_darken_4")
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.blueGrey.lighten1
		btn1.pulseFill = true
		btn1.pulseScale = false
		btn1.setImage(img1, forState: .Normal)
		btn1.setImage(img1, forState: .Highlighted)
		
		// Star button.
		let img2: UIImage? = UIImage(named: "ic_star_blue_grey_darken_4")
		let btn2: FlatButton = FlatButton()
		btn2.pulseColor = MaterialColor.blueGrey.lighten1
		btn2.pulseFill = true
		btn2.pulseScale = false
		btn2.setImage(img2, forState: .Normal)
		btn2.setImage(img2, forState: .Highlighted)
		
		// Delete button.
		let img3: UIImage? = UIImage(named: "ic_delete_blue_grey_darken_4")
		let btn3: FlatButton = FlatButton()
		btn3.pulseColor = MaterialColor.blueGrey.lighten1
		btn3.pulseFill = true
		btn3.pulseScale = false
		btn3.setImage(img3, forState: .Normal)
		btn3.setImage(img3, forState: .Highlighted)
		
		// Add buttons to right side.
		imageCardView.rightButtons = [btn1, btn2, btn3]
		imageCardView.rightButtonsInsetsRef.top = imageCardView.contentInsetsRef.top
		
		// To support orientation changes, use MaterialLayout.
		view.addSubview(imageCardView)
		imageCardView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: imageCardView, top: 100)
		MaterialLayout.alignToParentHorizontally(view, child: imageCardView, left: 20, right: 20)
		
	}
}

