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

*/

import UIKit
import Material

class ViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
//		prepareHorizontalGridViewExample()
//		prepareVerticalGridViewExample()
		prepareSmallCardViewExample()
	}
	
	
	/// General preparation statements are placed here.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the small card example.
	private func prepareSmallCardViewExample() {
		let cardView: MaterialPulseView = MaterialPulseView(frame: CGRectMake(16, 100, view.bounds.width - 32, 200))
		cardView.pulseColor = MaterialColor.blueGrey.lighten5
		cardView.depth = .Depth1
		view.addSubview(cardView)
		
		var image: UIImage? = UIImage(named: "CosmicMindInverted")
		let imageView: MaterialView = MaterialView()
		imageView.grid.column = .Column4
		imageView.image = image
		imageView.contentsGravity = .ResizeAspectFill
		cardView.addSubview(imageView)
		
		let contentView: MaterialView = MaterialView()
		contentView.grid.column = .Column8
		contentView.grid.layout = .Vertical
		contentView.grid.contentInsetPreset = .Square3
		contentView.grid.spacing = 16
		contentView.backgroundColor = MaterialColor.clear
		cardView.addSubview(contentView)
		
		let titleView: MaterialView = MaterialView()
		titleView.grid.column = .Column8
		titleView.grid.row = .Row3
		titleView.backgroundColor = MaterialColor.clear
		contentView.addSubview(titleView)
		
		let titleLabel: UILabel = UILabel()
		titleLabel.grid.column = .Column7
		titleLabel.text = "Material"
		titleLabel.textColor = MaterialColor.blueGrey.darken4
		titleLabel.backgroundColor = MaterialColor.clear
		titleView.addSubview(titleLabel)
		
		image = UIImage(named: "ic_more_vert_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let moreButton: FlatButton = FlatButton()
		moreButton.grid.column = .Column1
		moreButton.contentInsetPreset = .None
		moreButton.pulseColor = MaterialColor.blueGrey.darken4
		moreButton.tintColor = MaterialColor.blueGrey.darken4
		moreButton.setImage(image, forState: .Normal)
		moreButton.setImage(image, forState: .Highlighted)
		titleView.addSubview(moreButton)
		
		let detailLabel: UILabel = UILabel()
		detailLabel.grid.row = .Row6
		detailLabel.numberOfLines = 0
		detailLabel.lineBreakMode = .ByTruncatingTail
		detailLabel.font = RobotoFont.regularWithSize(12)
		detailLabel.text = "Material is a graphics and animation framework for Google's Material Design. It is designed to allow the creativity of others to easily be expressed."
		detailLabel.textColor = MaterialColor.blueGrey.darken4
		detailLabel.backgroundColor = MaterialColor.clear
		contentView.addSubview(detailLabel)

		let alarmView: MaterialView = MaterialView()
		alarmView.grid.column = .Column8
		alarmView.grid.row = .Row3
		alarmView.backgroundColor = MaterialColor.clear
		contentView.addSubview(alarmView)
		
		let alarmLabel: UILabel = UILabel()
		alarmLabel.grid.column = .Column7
		alarmLabel.font = RobotoFont.regularWithSize(12)
		alarmLabel.text = "34 min"
		alarmLabel.textColor = MaterialColor.blueGrey.darken4
		alarmLabel.backgroundColor = MaterialColor.clear
		alarmView.addSubview(alarmLabel)
		
		image = UIImage(named: "ic_alarm_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let alarmButton: FlatButton = FlatButton()
		alarmButton.grid.column = .Column1
		alarmButton.contentInsetPreset = .None
		alarmButton.pulseColor = MaterialColor.blueGrey.darken4
		alarmButton.tintColor = MaterialColor.red.base
		alarmButton.setImage(image, forState: .Normal)
		alarmButton.setImage(image, forState: .Highlighted)
		alarmView.addSubview(alarmButton)
		
		cardView.grid.views = [imageView, contentView]
		contentView.grid.views = [titleView, detailLabel, alarmView]
		titleView.grid.views = [titleLabel, moreButton]
		alarmView.grid.views = [alarmLabel, alarmButton]
	}
	
	/// Prepares the Horizontal GridView example.
	private func prepareHorizontalGridViewExample() {
		var image: UIImage? = UIImage(named: "ic_flash_auto_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn1: FlatButton = FlatButton()
		btn1.grid.column = .Column3
		btn1.pulseColor = MaterialColor.blueGrey.darken4
		btn1.tintColor = MaterialColor.blueGrey.darken4
		btn1.backgroundColor = MaterialColor.grey.lighten3
		btn1.setImage(image, forState: .Normal)
		btn1.setImage(image, forState: .Highlighted)
		view.addSubview(btn1)
		
		image = UIImage(named: "ic_flash_off_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn2: FlatButton = FlatButton()
		btn2.grid.column = .Column3
		btn2.pulseColor = MaterialColor.blueGrey.darken4
		btn2.tintColor = MaterialColor.blueGrey.darken4
		btn2.backgroundColor = MaterialColor.grey.lighten3
		btn2.setImage(image, forState: .Normal)
		btn2.setImage(image, forState: .Highlighted)
		view.addSubview(btn2)
		
		image = UIImage(named: "ic_flash_on_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn3: FlatButton = FlatButton()
		btn3.grid.column = .Column3
		btn3.pulseColor = MaterialColor.blueGrey.darken4
		btn3.tintColor = MaterialColor.blueGrey.darken4
		btn3.backgroundColor = MaterialColor.grey.lighten3
		btn3.setImage(image, forState: .Normal)
		btn3.setImage(image, forState: .Highlighted)
		view.addSubview(btn3)
		
		let label1: MaterialLabel = MaterialLabel()
		label1.text = "A"
		label1.backgroundColor = MaterialColor.blue.base
		
		let label2: MaterialLabel = MaterialLabel()
		label2.text = "B"
		label2.backgroundColor = MaterialColor.blue.base
		
		view.grid.column = .Column9
		view.grid.spacing = 16
		view.grid.contentInset.left = 16
		view.grid.contentInset.right = 16
		view.grid.contentInset.top = 100
		view.grid.contentInset.bottom = 100
		view.grid.views = [btn1, btn2, btn3]
		
		for v in view.grid.views! {
			print(v.frame)
		}
	}

	internal func handleButton() {
		print("Clicked Button")
	}
	
	/// Prepares the Vertical GridView example.
	private func prepareVerticalGridViewExample() {
		var image: UIImage? = UIImage(named: "ic_flash_auto_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn1: FlatButton = FlatButton()
		btn1.grid.row = .Row3
		btn1.pulseColor = MaterialColor.blueGrey.darken4
		btn1.tintColor = MaterialColor.blueGrey.darken4
		btn1.backgroundColor = MaterialColor.grey.lighten3
		btn1.setImage(image, forState: .Normal)
		btn1.setImage(image, forState: .Highlighted)
		view.addSubview(btn1)
		
		image = UIImage(named: "ic_flash_off_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn2: FlatButton = FlatButton()
		btn2.grid.row = .Row3
		btn2.pulseColor = MaterialColor.blueGrey.darken4
		btn2.tintColor = MaterialColor.blueGrey.darken4
		btn2.backgroundColor = MaterialColor.grey.lighten3
		btn2.setImage(image, forState: .Normal)
		btn2.setImage(image, forState: .Highlighted)
		view.addSubview(btn2)
		
		image = UIImage(named: "ic_flash_on_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn3: FlatButton = FlatButton()
		btn3.grid.row = .Row3
		btn3.pulseColor = MaterialColor.blueGrey.darken4
		btn3.tintColor = MaterialColor.blueGrey.darken4
		btn3.backgroundColor = MaterialColor.grey.lighten3
		btn3.setImage(image, forState: .Normal)
		btn3.setImage(image, forState: .Highlighted)
		view.addSubview(btn3)
		
		let label1: MaterialLabel = MaterialLabel()
		label1.text = "A"
		label1.backgroundColor = MaterialColor.blue.base
		
		let label2: MaterialLabel = MaterialLabel()
		label2.text = "B"
		label2.backgroundColor = MaterialColor.blue.base
		
		view.grid.layout = .Vertical
		view.grid.row = .Row9
		view.grid.spacing = 16
		view.grid.contentInset.left = 16
		view.grid.contentInset.right = 16
		view.grid.contentInset.top = 100
		view.grid.contentInset.bottom = 100
		view.grid.views = [btn1, btn2, btn3]
		
		for v in view.grid.views! {
			print(v.frame)
		}
	}
}

