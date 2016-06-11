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
		
		prepareBasicCardViewExample()
//		prepareCardViewWithoutPulseBackgroundImageExample()
//		prepareCardViewWithPulseBackgroundImageExample()
//		prepareCardViewButtonBarExample()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	private func prepareBasicCardViewExample() {
		let cardView: CardView = CardView()
		
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
		cardView.contentView = detailLabel
		
		// Yes button.
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = MaterialColor.blue.lighten1
		btn1.setTitle("YES", forState: .Normal)
		btn1.setTitleColor(MaterialColor.blue.darken1, forState: .Normal)
		
		// No button.
		let btn2: FlatButton = FlatButton()
		btn2.pulseColor = MaterialColor.blue.lighten1
		btn2.setTitle("NO", forState: .Normal)
		btn2.setTitleColor(MaterialColor.blue.darken1, forState: .Normal)

		// Add buttons to left side.
		cardView.leftButtons = [btn1, btn2]
		
		// To support orientation changes, use Layout.
        view.layout(cardView).top(100).left(20).right(20)
	}
	
	private func prepareCardViewWithoutPulseBackgroundImageExample() {
		let cardView: CardView = CardView()
		cardView.divider = false
		cardView.backgroundColor = MaterialColor.red.base
		
		cardView.image = UIImage(named: "Material-iTunesArtWork")?.resize(toHeight: 75)
		cardView.contentsGravityPreset = .BottomRight
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Material"
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.mediumWithSize(24)
		cardView.titleLabel = titleLabel
		
		// Detail label.
		let detailLabel: UILabel = UILabel()
		detailLabel.text = "Beautiful Material Design"
		detailLabel.textColor = MaterialColor.white
		detailLabel.numberOfLines = 0
		cardView.contentView = detailLabel
		
		// Share button.
		let img1: UIImage? = MaterialIcon.cm.share
		let btn1: IconButton = IconButton()
		btn1.pulseColor = MaterialColor.white
		btn1.tintColor = MaterialColor.white
		btn1.setImage(img1, forState: .Normal)
		btn1.setImage(img1, forState: .Highlighted)
		
		// Add buttons to left side.
		cardView.leftButtons = [btn1]
		
		// To support orientation changes, use Layout.
		view.layout(cardView).top(100).left(20).right(20)
	}
	
	private func prepareCardViewWithPulseBackgroundImageExample() {
		let cardView: CardView = CardView()
		cardView.backgroundColor = MaterialColor.blue.base
		cardView.divider = false
		
		// Image.
		cardView.image = UIImage(named: "Graph")?.resize(toHeight: 75)
		cardView.contentsGravityPreset = .Right
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Graph"
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.mediumWithSize(24)
		cardView.titleLabel = titleLabel
		
		// Detail label.
		let detailLabel: UILabel = UILabel()
		detailLabel.text = "Data-Driven Framework"
		detailLabel.textColor = MaterialColor.white
		detailLabel.numberOfLines = 0
		cardView.contentView = detailLabel
		
		// Share button.
		let img1: UIImage? = MaterialIcon.cm.share
		let btn1: IconButton = IconButton()
		btn1.pulseColor = MaterialColor.white
		btn1.tintColor = MaterialColor.white
		btn1.setImage(img1, forState: .Normal)
		btn1.setImage(img1, forState: .Highlighted)
		
		// Add buttons to left side.
		cardView.leftButtons = [btn1]
		
		// To support orientation changes, use Layout.
		view.layout(cardView).top(100).left(20).right(20)
	}
	
	private func prepareCardViewButtonBarExample() {
		let cardView: CardView = CardView()
		cardView.divider = false
		cardView.backgroundColor = MaterialColor.blueGrey.darken4
		
		// Search button.
		let img1: UIImage? = MaterialIcon.cm.search
		let btn1: IconButton = IconButton()
		btn1.pulseColor = MaterialColor.white
		btn1.tintColor = MaterialColor.white
		btn1.setImage(img1, forState: .Normal)
		btn1.setImage(img1, forState: .Highlighted)
		
		// BUTTON 1 button.
		let btn2: FlatButton = FlatButton()
		btn2.pulseColor = MaterialColor.teal.lighten3
		btn2.setTitle("BUTTON 1", forState: .Normal)
		btn2.setTitleColor(MaterialColor.teal.lighten3, forState: .Normal)
		btn2.titleLabel!.font = RobotoFont.regularWithSize(20)
		
		// BUTTON 2 button.
		let btn3: FlatButton = FlatButton()
		btn3.pulseColor = MaterialColor.teal.lighten3
		btn3.setTitle("BUTTON 2", forState: .Normal)
		btn3.setTitleColor(MaterialColor.teal.lighten3, forState: .Normal)
		btn3.titleLabel!.font = RobotoFont.regularWithSize(20)
		
		// Add buttons to left side.
		cardView.leftButtons = [btn1]
		
		// Add buttons to right side.
		cardView.rightButtons = [btn2, btn3]
		
		// To support orientation changes, use Layout.
		view.layout(cardView).top(100).left(20).right(20)		
	}
}

