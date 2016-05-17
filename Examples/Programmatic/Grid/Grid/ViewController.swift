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

/**
The following UIViewController uses Grid to make complex layouts.
*/

import UIKit
import Material

class ViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
//		prepareHorizontalGridViewExample()
//		prepareVerticalGridViewExample()
//		prepareGridDirectionNoneExample()
//		prepareSmallCardViewExample()
//		prepareMediumCardViewExample()
		prepareLargeCardViewExample()
	}
	
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the Horizontal GridView example.
	private func prepareHorizontalGridViewExample() {
		var image: UIImage? = UIImage(named: "ic_flash_auto_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn1: IconButton = IconButton()
		btn1.pulseColor = MaterialColor.blueGrey.darken4
		btn1.tintColor = MaterialColor.blueGrey.darken4
		btn1.backgroundColor = MaterialColor.grey.lighten3
		btn1.setImage(image, forState: .Normal)
		btn1.setImage(image, forState: .Highlighted)
		view.addSubview(btn1)
		
		image = UIImage(named: "ic_flash_off_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn2: IconButton = IconButton()
		btn2.pulseColor = MaterialColor.blueGrey.darken4
		btn2.tintColor = MaterialColor.blueGrey.darken4
		btn2.backgroundColor = MaterialColor.grey.lighten3
		btn2.setImage(image, forState: .Normal)
		btn2.setImage(image, forState: .Highlighted)
		view.addSubview(btn2)
		
		image = UIImage(named: "ic_flash_on_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn3: IconButton = IconButton()
		btn3.pulseColor = MaterialColor.blueGrey.darken4
		btn3.tintColor = MaterialColor.blueGrey.darken4
		btn3.backgroundColor = MaterialColor.grey.lighten3
		btn3.setImage(image, forState: .Normal)
		btn3.setImage(image, forState: .Highlighted)
		view.addSubview(btn3)
		
		btn1.grid.rows = 2
		
		btn2.grid.rows = 2
		
		btn3.grid.rows = 2
		
		view.grid.axis.rows = 6
		view.grid.spacing = 16
		view.grid.axis.direction = .Vertical
		view.grid.contentInset.left = 16
		view.grid.contentInset.right = 16
		view.grid.contentInset.top = 100
		view.grid.contentInset.bottom = 100
		view.grid.views = [btn2, btn1, btn3]
		
		for v in view.grid.views! {
			print(v.frame)
		}
	}
	
	/// Prepares the Vertical GridView example.
	private func prepareVerticalGridViewExample() {
		var image: UIImage? = UIImage(named: "ic_flash_auto_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn1: IconButton = IconButton()
		btn1.pulseColor = MaterialColor.blueGrey.darken4
		btn1.tintColor = MaterialColor.blueGrey.darken4
		btn1.backgroundColor = MaterialColor.grey.lighten3
		btn1.setImage(image, forState: .Normal)
		btn1.setImage(image, forState: .Highlighted)
		view.addSubview(btn1)
		
		image = UIImage(named: "ic_flash_off_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn2: IconButton = IconButton()
		btn2.pulseColor = MaterialColor.blueGrey.darken4
		btn2.tintColor = MaterialColor.blueGrey.darken4
		btn2.backgroundColor = MaterialColor.grey.lighten3
		btn2.setImage(image, forState: .Normal)
		btn2.setImage(image, forState: .Highlighted)
		view.addSubview(btn2)
		
		image = UIImage(named: "ic_flash_on_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn3: IconButton = IconButton()
		btn3.pulseColor = MaterialColor.blueGrey.darken4
		btn3.tintColor = MaterialColor.blueGrey.darken4
		btn3.backgroundColor = MaterialColor.grey.lighten3
		btn3.setImage(image, forState: .Normal)
		btn3.setImage(image, forState: .Highlighted)
		view.addSubview(btn3)
		
		btn1.grid.rows = 3
		
		btn2.grid.rows = 3
		
		btn3.grid.rows = 3
		
		view.grid.rows = 9
		view.grid.spacing = 16
		view.grid.contentInset.left = 16
		view.grid.contentInset.right = 16
		view.grid.contentInset.top = 100
		view.grid.contentInset.bottom = 100
		view.grid.axis.direction = .Vertical
		view.grid.views = [btn1, btn2, btn3]
		
		for v in view.grid.views! {
			print(v.frame)
		}
	}
	
	private func prepareGridDirectionNoneExample() {
		let labelA: UILabel = UILabel()
		labelA.text = "A"
		labelA.textAlignment = .Center
		labelA.backgroundColor = MaterialColor.yellow.lighten3
		view.addSubview(labelA)
		
		let labelB: UILabel = UILabel()
		labelB.text = "B"
		labelB.textAlignment = .Center
		labelB.backgroundColor = MaterialColor.green.lighten3
		view.addSubview(labelB)
		
		labelA.grid.rows = 6
		labelA.grid.columns = 6
		
		labelB.grid.rows = 6
		labelB.grid.columns = 6
		labelB.grid.offset.rows = 6
		labelB.grid.offset.columns = 6
		
		view.grid.spacing = 16
		view.grid.axis.direction = .None
		view.grid.contentInsetPreset = .Square6
		view.grid.views = [labelA, labelB]
	}
	
	/// Prepares the small card example.
	private func prepareSmallCardViewExample() {
		let cardView: MaterialPulseView = MaterialPulseView(frame: CGRectMake(16, 100, view.bounds.width - 32, 152))
		cardView.pulseColor = MaterialColor.blueGrey.base
		cardView.depth = .Depth1
		view.addSubview(cardView)
		
		var image: UIImage? = UIImage(named: "CosmicMindInverted")
		let imageView: MaterialView = MaterialView()
		imageView.image = image
		imageView.contentsGravityPreset = .ResizeAspectFill
		cardView.addSubview(imageView)
		
		let contentView: MaterialView = MaterialView()
		contentView.backgroundColor = MaterialColor.clear
		cardView.addSubview(contentView)
		
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Material"
		titleLabel.textColor = MaterialColor.blueGrey.darken4
		titleLabel.backgroundColor = MaterialColor.clear
		contentView.addSubview(titleLabel)
		
		image = MaterialIcon.cm.moreVertical
		let moreButton: IconButton = IconButton()
		moreButton.contentEdgeInsetsPreset = .None
		moreButton.pulseColor = MaterialColor.blueGrey.darken4
		moreButton.tintColor = MaterialColor.blueGrey.darken4
		moreButton.setImage(image, forState: .Normal)
		moreButton.setImage(image, forState: .Highlighted)
		contentView.addSubview(moreButton)
		
		let detailLabel: UILabel = UILabel()
		detailLabel.numberOfLines = 0
		detailLabel.lineBreakMode = .ByTruncatingTail
		detailLabel.font = RobotoFont.regularWithSize(12)
		detailLabel.text = "Express your creativity with Material, an animation and graphics framework for Google's Material Design and Apple's Flat UI in Swift."
		detailLabel.textColor = MaterialColor.blueGrey.darken4
		detailLabel.backgroundColor = MaterialColor.clear
		contentView.addSubview(detailLabel)
		
		let alarmLabel: UILabel = UILabel()
		alarmLabel.font = RobotoFont.regularWithSize(12)
		alarmLabel.text = "34 min"
		alarmLabel.textColor = MaterialColor.blueGrey.darken4
		alarmLabel.backgroundColor = MaterialColor.clear
		contentView.addSubview(alarmLabel)
		
		image = UIImage(named: "ic_alarm_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let alarmButton: IconButton = IconButton()
		alarmButton.contentEdgeInsetsPreset = .None
		alarmButton.pulseColor = MaterialColor.blueGrey.darken4
		alarmButton.tintColor = MaterialColor.red.base
		alarmButton.setImage(image, forState: .Normal)
		alarmButton.setImage(image, forState: .Highlighted)
		contentView.addSubview(alarmButton)
		
		imageView.grid.columns = 4
		
		contentView.grid.columns = 8
		
		cardView.grid.views = [
			imageView,
			contentView
		]
		
		titleLabel.grid.rows = 3
		titleLabel.grid.columns = 9
		
		moreButton.grid.rows = 3
		moreButton.grid.columns = 2
		moreButton.grid.offset.columns = 10
		
		detailLabel.grid.rows = 4
		detailLabel.grid.offset.rows = 4
		
		alarmLabel.grid.rows = 3
		alarmLabel.grid.offset.rows = 9
		alarmLabel.grid.columns = 9
		
		alarmButton.grid.rows = 3
		alarmButton.grid.offset.rows = 9
		alarmButton.grid.columns = 2
		alarmButton.grid.offset.columns = 10
		
		contentView.grid.spacing = 8
		contentView.grid.axis.direction = .None
		contentView.grid.contentInsetPreset = .Square3
		contentView.grid.views = [
			titleLabel,
			moreButton,
			detailLabel,
			alarmLabel,
			alarmButton
		]
	}

	/// Prepares the medium card example.
	private func prepareMediumCardViewExample() {
		let cardView: MaterialPulseView = MaterialPulseView(frame: CGRectMake(16, 100, view.bounds.width - 32, 240))
		cardView.pulseColor = MaterialColor.blueGrey.base
		cardView.depth = .Depth1
		view.addSubview(cardView)
		
		var image: UIImage? = UIImage(named: "CosmicMindInverted")
		let imageView: MaterialView = MaterialView()
		imageView.image = image
		imageView.contentsGravityPreset = .ResizeAspectFill
		cardView.addSubview(imageView)
		
		let contentView: MaterialView = MaterialView()
		contentView.backgroundColor = MaterialColor.clear
		cardView.addSubview(contentView)
		
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Material"
		titleLabel.textColor = MaterialColor.blueGrey.darken4
		titleLabel.backgroundColor = MaterialColor.clear
		contentView.addSubview(titleLabel)
		
		image = MaterialIcon.cm.moreVertical
		let moreButton: IconButton = IconButton()
		moreButton.contentEdgeInsetsPreset = .None
		moreButton.pulseColor = MaterialColor.blueGrey.darken4
		moreButton.tintColor = MaterialColor.blueGrey.darken4
		moreButton.setImage(image, forState: .Normal)
		moreButton.setImage(image, forState: .Highlighted)
		contentView.addSubview(moreButton)
		
		let detailLabel: UILabel = UILabel()
		detailLabel.numberOfLines = 0
		detailLabel.lineBreakMode = .ByTruncatingTail
		detailLabel.font = RobotoFont.regularWithSize(12)
		detailLabel.text = "Express your creativity with Material, an animation and graphics framework for Google's Material Design and Apple's Flat UI in Swift."
		detailLabel.textColor = MaterialColor.blueGrey.darken4
		detailLabel.backgroundColor = MaterialColor.clear
		contentView.addSubview(detailLabel)
		
		let alarmLabel: UILabel = UILabel()
		alarmLabel.font = RobotoFont.regularWithSize(12)
		alarmLabel.text = "34 min"
		alarmLabel.textColor = MaterialColor.blueGrey.darken4
		alarmLabel.backgroundColor = MaterialColor.clear
		contentView.addSubview(alarmLabel)
		
		image = UIImage(named: "ic_alarm_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let alarmButton: IconButton = IconButton()
		alarmButton.contentEdgeInsetsPreset = .None
		alarmButton.pulseColor = MaterialColor.blueGrey.darken4
		alarmButton.tintColor = MaterialColor.red.base
		alarmButton.setImage(image, forState: .Normal)
		alarmButton.setImage(image, forState: .Highlighted)
		contentView.addSubview(alarmButton)
		
		imageView.grid.columns = 6
		
		contentView.grid.columns = 6
		
		cardView.grid.views = [
			imageView,
			contentView
		]
		
		titleLabel.grid.rows = 2
		titleLabel.grid.columns = 9
		
		moreButton.grid.rows = 2
		moreButton.grid.columns = 3
		moreButton.grid.offset.columns = 9
		
		detailLabel.grid.rows = 8
		detailLabel.grid.offset.rows = 2
		
		alarmLabel.grid.rows = 2
		alarmLabel.grid.offset.rows = 10
		alarmLabel.grid.columns = 9
		
		alarmButton.grid.rows = 2
		alarmButton.grid.offset.rows = 10
		alarmButton.grid.columns = 3
		alarmButton.grid.offset.columns = 9
		
		contentView.grid.spacing = 8
		contentView.grid.axis.direction = .None
		contentView.grid.contentInsetPreset = .Square3
		contentView.grid.views = [
			titleLabel,
			moreButton,
			detailLabel,
			alarmLabel,
			alarmButton
		]
	}
	
	
	/// Prepares the medium card example.
	private func prepareLargeCardViewExample() {
		var image: UIImage? = UIImage(named: "CosmicMindInverted")
		
		let cardView: MaterialPulseView = MaterialPulseView(frame: CGRectMake(16, 100, view.bounds.width - 32, 400))
		cardView.pulseColor = MaterialColor.blueGrey.base
		cardView.depth = .Depth1
		view.addSubview(cardView)
		
		let leftImageView: MaterialView = MaterialView()
		leftImageView.image = image
		leftImageView.contentsGravityPreset = .ResizeAspectFill
		cardView.addSubview(leftImageView)

		let topImageView: MaterialView = MaterialView()
		topImageView.image = image
		topImageView.contentsGravityPreset = .ResizeAspectFill
		cardView.addSubview(topImageView)

		let bottomImageView: MaterialView = MaterialView()
		bottomImageView.image = image
		bottomImageView.contentsGravityPreset = .ResizeAspectFill
		cardView.addSubview(bottomImageView)

		let contentView: MaterialView = MaterialView()
		contentView.backgroundColor = MaterialColor.clear
		cardView.addSubview(contentView)
		
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Material"
		titleLabel.textColor = MaterialColor.blueGrey.darken4
		titleLabel.backgroundColor = MaterialColor.clear
		contentView.addSubview(titleLabel)
		
		image = MaterialIcon.cm.moreHorizontal
		let moreButton: IconButton = IconButton()
		moreButton.contentEdgeInsetsPreset = .None
		moreButton.pulseColor = MaterialColor.blueGrey.darken4
		moreButton.tintColor = MaterialColor.blueGrey.darken4
		moreButton.setImage(image, forState: .Normal)
		moreButton.setImage(image, forState: .Highlighted)
		contentView.addSubview(moreButton)

		let detailLabel: UILabel = UILabel()
		detailLabel.numberOfLines = 0
		detailLabel.lineBreakMode = .ByTruncatingTail
		detailLabel.font = RobotoFont.regularWithSize(12)
		detailLabel.text = "Express your creativity with Material, an animation and graphics framework for Google's Material Design and Apple's Flat UI in Swift."
		detailLabel.textColor = MaterialColor.blueGrey.darken4
		detailLabel.backgroundColor = MaterialColor.clear
		contentView.addSubview(detailLabel)

		let alarmLabel: UILabel = UILabel()
		alarmLabel.font = RobotoFont.regularWithSize(12)
		alarmLabel.text = "34 min"
		alarmLabel.textColor = MaterialColor.blueGrey.darken4
		alarmLabel.backgroundColor = MaterialColor.clear
		contentView.addSubview(alarmLabel)
		
		image = UIImage(named: "ic_alarm_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let alarmButton: IconButton = IconButton()
		alarmButton.contentEdgeInsetsPreset = .None
		alarmButton.pulseColor = MaterialColor.blueGrey.darken4
		alarmButton.tintColor = MaterialColor.red.base
		alarmButton.setImage(image, forState: .Normal)
		alarmButton.setImage(image, forState: .Highlighted)
		contentView.addSubview(alarmButton)

		leftImageView.grid.rows = 7
		leftImageView.grid.columns = 6
		
		topImageView.grid.rows = 4
		topImageView.grid.columns = 6
		topImageView.grid.offset.columns = 6
		
		bottomImageView.grid.rows = 3
		bottomImageView.grid.offset.rows = 4
		bottomImageView.grid.columns = 6
		bottomImageView.grid.offset.columns = 6
		
		contentView.grid.rows = 5
		contentView.grid.offset.rows = 7
		
		cardView.grid.axis.direction = .None
		cardView.grid.spacing = 4
		cardView.grid.views = [
			leftImageView,
			topImageView,
			bottomImageView,
			contentView
		]
		
		titleLabel.grid.rows = 3
		titleLabel.grid.columns = 8
		
		moreButton.grid.rows = 3
		moreButton.grid.columns = 2
		moreButton.grid.offset.columns = 10
		
		detailLabel.grid.rows = 6
		detailLabel.grid.offset.rows = 3
		
		alarmLabel.grid.rows = 3
		alarmLabel.grid.columns = 8
		alarmLabel.grid.offset.rows = 9
		
		alarmButton.grid.rows = 3
		alarmButton.grid.offset.rows = 9
		alarmButton.grid.columns = 2
		alarmButton.grid.offset.columns = 10
		
		contentView.grid.spacing = 8
		contentView.grid.axis.direction = .None
		contentView.grid.contentInsetPreset = .Square3
		contentView.grid.views = [
			titleLabel,
			moreButton,
			detailLabel,
			alarmLabel,
			alarmButton
		]
	}
}

