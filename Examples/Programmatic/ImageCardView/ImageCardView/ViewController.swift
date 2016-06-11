/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of Material nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit
import Material

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		
//		prepareBasicImageCardViewExample()
		prepareImageCardViewWithoutDetailLabelAndDividerExample()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	private func prepareBasicImageCardViewExample() {
		let imageCardView: ImageCardView = ImageCardView()
		imageCardView.maxImageHeight = 150
		
		// Image.
		let size: CGSize = CGSizeMake(MaterialDevice.width - CGFloat(40), 150)
		imageCardView.image = UIImage.imageWithColor(MaterialColor.cyan.darken1, size: size)
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Welcome Back!"
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.mediumWithSize(24)
		imageCardView.titleLabel = titleLabel
		imageCardView.titleLabelInset.top = 100
		
		// Detail label.
		let detailLabel: UILabel = UILabel()
		detailLabel.text = "It’s been a while, have you read any new books lately?"
		detailLabel.numberOfLines = 0
		imageCardView.contentView = detailLabel
		
		// Yes button.
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.cyan.lighten1
		btn1.setTitle("YES", forState: .Normal)
		btn1.setTitleColor(MaterialColor.cyan.darken1, forState: .Normal)
		
		// No button.
		let btn2: FlatButton = FlatButton()
		btn2.pulseColor = MaterialColor.cyan.lighten1
		btn2.setTitle("NO", forState: .Normal)
		btn2.setTitleColor(MaterialColor.cyan.darken1, forState: .Normal)
		
		// Add buttons to left side.
		imageCardView.leftButtons = [btn1, btn2]
		
		// To support orientation changes, use Layout.
		view.layout(imageCardView).top(100).left(20).right(20)
	}
	
	private func prepareImageCardViewWithoutDetailLabelAndDividerExample() {
		let imageCardView: ImageCardView = ImageCardView()
		imageCardView.pulseColor = MaterialColor.purple.base
		imageCardView.divider = false
		imageCardView.maxImageHeight = 130
		
		// Image.
		imageCardView.image = UIImage(named: "MaterialImageCardViewBackgroundImage")
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Material Design"
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.regularWithSize(24)
		imageCardView.titleLabel = titleLabel
		imageCardView.titleLabelInset.top = 80
		
		// Star button.
		let img1: UIImage? = MaterialIcon.cm.star
		let btn1: IconButton = IconButton()
		btn1.pulseColor = MaterialColor.blueGrey.lighten1
		btn1.tintColor = MaterialColor.blueGrey.darken3
		btn1.setImage(img1, forState: .Normal)
		btn1.setImage(img1, forState: .Highlighted)

		// Library button.
		let img2: UIImage? = MaterialIcon.cm.audioLibrary
		let btn2: IconButton = IconButton()
		btn2.pulseColor = MaterialColor.blueGrey.lighten1
		btn2.tintColor = MaterialColor.blueGrey.darken3
		btn2.setImage(img2, forState: .Normal)
		btn2.setImage(img2, forState: .Highlighted)
		
		// Share button.
		let img3: UIImage? = MaterialIcon.share
		let btn3: IconButton = IconButton()
		btn3.pulseColor = MaterialColor.blueGrey.lighten1
		btn3.tintColor = MaterialColor.blueGrey.darken3
		btn3.setImage(img3, forState: .Normal)
		btn3.setImage(img3, forState: .Highlighted)
		
		// Add buttons to right side.
		imageCardView.rightButtons = [btn1, btn2, btn3]
		
		// To support orientation changes, use Layout.
		view.layout(imageCardView).top(100).left(20).right(20)
	}
}

