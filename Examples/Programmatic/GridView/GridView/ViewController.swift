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
		prepareHorizontalGridViewExample()
//		prepareVerticalGridViewExample()
//		prepareSmallCardViewExample()
	}
	
	
	/// General preparation statements are placed here.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the small card example.
	private func prepareSmallCardViewExample() {
		var image: UIImage? = UIImage.imageWithColor(MaterialColor.blueGrey.darken4, size: CGSizeMake(100, 100))
		let imageView: MaterialView = MaterialView()
		imageView.column = .Grid3
		imageView.image = image
		
		let contentView: MaterialView = MaterialView()
		contentView.column = .Grid9
//		contentView.backgroundColor = MaterialColor.blue.base
		
//		let titleGridView: GridView = GridView()
//		titleGridView.grid = .Grid9
//		titleGridView.spacing = 8
//		titleGridView.unifiedHeight = 40
		
//		image = UIImage(named: "ic_more_vert_white")?.imageWithRenderingMode(.AlwaysTemplate)
//		let moreButton: FlatButton = FlatButton()
//		moreButton.column = .Grid2
//		moreButton.contentInsetPreset = .None
//		moreButton.pulseColor = MaterialColor.blueGrey.darken4
//		moreButton.tintColor = MaterialColor.blueGrey.darken4
////		moreButton.backgroundColor = MaterialColor.green.base
//		moreButton.setImage(image, forState: .Normal)
//		moreButton.setImage(image, forState: .Highlighted)
//		
//		let titleView: MaterialView = MaterialView()
//		
//		let titleLabel: MaterialLabel = MaterialLabel()
//		titleLabel.column = .Grid10
//		titleLabel.text = "Title"
//		titleLabel.textColor = MaterialColor.blueGrey.darken4
////		titleLabel.backgroundColor = MaterialColor.red.base
//		
//		let detailLabel: MaterialLabel = MaterialLabel()
//		detailLabel.column = .Grid12
//		detailLabel.row = .Grid1
//		detailLabel.numberOfLines = 0
//		detailLabel.font = RobotoFont.regularWithSize(12)
//		detailLabel.text = "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable."
//		detailLabel.textColor = MaterialColor.blueGrey.darken4
////		detailLabel.backgroundColor = MaterialColor.purple.base
//		
		let cardView: MaterialView = MaterialView(frame: CGRectMake(16, 120, view.bounds.width - 32, 120))
		cardView.depth = .Depth1
//
//		let buttonView: MaterialView = MaterialView()
//		
//		image = UIImage(named: "ic_flash_auto_white")?.imageWithRenderingMode(.AlwaysTemplate)
//		let btn1: FlatButton = FlatButton()
//		btn1.pulseColor = MaterialColor.blueGrey.darken4
//		btn1.tintColor = MaterialColor.blueGrey.darken4
//		btn1.setImage(image, forState: .Normal)
//		btn1.setImage(image, forState: .Highlighted)
//		
//		image = UIImage(named: "ic_flash_off_white")?.imageWithRenderingMode(.AlwaysTemplate)
//		let btn2: FlatButton = FlatButton()
//		btn2.pulseColor = MaterialColor.blueGrey.darken4
//		btn2.tintColor = MaterialColor.blueGrey.darken4
//		btn2.setImage(image, forState: .Normal)
//		btn2.setImage(image, forState: .Highlighted)
//
//		image = UIImage(named: "ic_flash_on_white")?.imageWithRenderingMode(.AlwaysTemplate)
//		let btn3: FlatButton = FlatButton()
//		btn3.pulseColor = MaterialColor.blueGrey.darken4
//		btn3.tintColor = MaterialColor.blueGrey.darken4
//		btn3.setImage(image, forState: .Normal)
//		btn3.setImage(image, forState: .Highlighted)
		
		var grid1: Grid = Grid()
		grid1.size = CGSizeMake(cardView.width, 120)
		grid1.views = [imageView, contentView]
		
//		var grid2: Grid = Grid()
//		grid2.spacing = 8
//		grid2.size = CGSizeMake(contentView.width - 8, 40)
//		grid2.views = [titleLabel, moreButton]
//		
//		var grid3: Grid = Grid(row: .Grid3)
//		grid3.layout = .Vertical
//		grid3.size = CGSizeMake(contentView.width - 8, contentView.height)
//		grid3.contentInset.left = 8
//		grid3.views = [titleView, detailLabel, buttonView]
//		
//		var grid4: Grid = Grid()
//		grid4.column = .Grid3
//		grid4.spacing = 8
//		grid4.size = CGSizeMake(contentView.width - 8, buttonView.height)
//		grid4.views = [btn1, btn2, btn3]
		
		print(imageView.column)
		view.addSubview(cardView)
		cardView.addSubview(imageView)
		cardView.addSubview(contentView)
//		contentView.addSubview(titleView)
//		contentView.addSubview(detailLabel)
//		contentView.addSubview(buttonView)
//		titleView.addSubview(titleLabel)
//		titleView.addSubview(moreButton)
//		buttonView.addSubview(btn1)
//		buttonView.addSubview(btn2)
//		buttonView.addSubview(btn3)
	}
	
	/// Prepares the Horizontal GridView example.
	private func prepareHorizontalGridViewExample() {
		var image: UIImage? = UIImage(named: "ic_flash_auto_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn1: FlatButton = FlatButton()
		btn1.column = .Grid3
		btn1.pulseColor = MaterialColor.blueGrey.darken4
		btn1.tintColor = MaterialColor.blueGrey.darken4
		btn1.backgroundColor = MaterialColor.grey.lighten3
		btn1.setImage(image, forState: .Normal)
		btn1.setImage(image, forState: .Highlighted)
		view.addSubview(btn1)
		
		image = UIImage(named: "ic_flash_off_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn2: FlatButton = FlatButton()
		btn2.column = .Grid3
		btn2.pulseColor = MaterialColor.blueGrey.darken4
		btn2.tintColor = MaterialColor.blueGrey.darken4
		btn2.backgroundColor = MaterialColor.grey.lighten3
		btn2.setImage(image, forState: .Normal)
		btn2.setImage(image, forState: .Highlighted)
		view.addSubview(btn2)
		
		image = UIImage(named: "ic_flash_on_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn3: FlatButton = FlatButton()
		btn3.column = .Grid3
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
		
		view.size = CGSizeMake(view.bounds.width, 40)
		view.column = .Grid9
		view.spacing = 16
		view.views = [btn1, btn2, btn3]
	}
//
//	internal func handleButton() {
//		print("Clicked Button")
//	}
//	
//	/// Prepares the Vertical GridView example.
//	private func prepareVerticalGridViewExample() {
//		var image: UIImage? = UIImage(named: "ic_flash_auto_white")?.imageWithRenderingMode(.AlwaysTemplate)
//		let btn1: FlatButton = FlatButton()
////		btn1.grid = .Grid2
//		btn1.pulseColor = MaterialColor.blueGrey.darken4
//		btn1.tintColor = MaterialColor.blueGrey.darken4
//		btn1.backgroundColor = MaterialColor.grey.lighten3
//		btn1.setImage(image, forState: .Normal)
//		btn1.setImage(image, forState: .Highlighted)
//		btn1.addTarget(self, action: "handleButton", forControlEvents: .TouchUpInside)
//		
//		image = UIImage(named: "ic_flash_off_white")?.imageWithRenderingMode(.AlwaysTemplate)
//		let btn2: FlatButton = FlatButton()
//		//		btn2.grid = .Grid3
//		btn2.pulseColor = MaterialColor.blueGrey.darken4
//		btn2.tintColor = MaterialColor.blueGrey.darken4
//		btn2.backgroundColor = MaterialColor.grey.lighten3
//		btn2.setImage(image, forState: .Normal)
//		btn2.setImage(image, forState: .Highlighted)
//		
//		image = UIImage(named: "ic_flash_on_white")?.imageWithRenderingMode(.AlwaysTemplate)
//		let btn3: FlatButton = FlatButton()
//		btn3.pulseColor = MaterialColor.blueGrey.darken4
//		btn3.tintColor = MaterialColor.blueGrey.darken4
//		btn3.backgroundColor = MaterialColor.grey.lighten3
//		btn3.setImage(image, forState: .Normal)
//		btn3.setImage(image, forState: .Highlighted)
//		
//		let label1: MaterialLabel = MaterialLabel()
//		label1.text = "A"
//		label1.backgroundColor = MaterialColor.blue.base
//		
//		let label2: MaterialLabel = MaterialLabel()
//		label2.text = "B"
////		label2.grid = .Grid2
//		label2.backgroundColor = MaterialColor.blue.base
//		
//		let gridView: GridView = GridView()
////		let gridView: GridView = GridView(frame: CGRectMake(0, 100, view.bounds.width, 100))
//		gridView.grid = .Grid12
//		gridView.layout = .Vertical
////		gridView.spacing = 32
////		gridView.unifiedHeight = 40
//		gridView.views = [btn1, btn2, label2]
//		
//		view.addSubview(gridView)
//		gridView.translatesAutoresizingMaskIntoConstraints = false
//		MaterialLayout.alignFromTop(view, child: gridView, top: 100)
//		MaterialLayout.alignToParentHorizontally(view, child: gridView)
//		MaterialLayout.height(view, child: gridView, height: view.bounds.height - 100)
//	}
}

