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
		var image: UIImage? = UIImage.imageWithColor(MaterialColor.blueGrey.darken4, size: CGSizeMake(100, 100))
		let imageView: MaterialView = MaterialView()
		imageView.grid = .Grid3
		imageView.image = image
		
		let contentView: GridView = GridView()
		contentView.grid = .Grid9
		contentView.unifiedHeight = 40
		contentView.backgroundColor = MaterialColor.blue.base
		
		let titleGridView: GridView = GridView()
		titleGridView.grid = .Grid9
		titleGridView.spacing = 8
		titleGridView.unifiedHeight = 40
		
		image = UIImage(named: "ic_more_vert_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let moreButton: FlatButton = FlatButton()
		moreButton.grid = .Grid2
		moreButton.pulseColor = MaterialColor.blueGrey.darken4
		moreButton.tintColor = MaterialColor.blueGrey.darken4
		moreButton.backgroundColor = MaterialColor.green.base
		moreButton.setImage(image, forState: .Normal)
		moreButton.setImage(image, forState: .Highlighted)
		
		let titleLabel: MaterialLabel = MaterialLabel()
		titleLabel.grid = .Grid7
		titleLabel.text = "Material GridView ahskjdha sjdha sjkdhas jkhd "
		titleLabel.textColor = MaterialColor.blueGrey.darken4
		titleGridView.views = [titleLabel, moreButton]
		
		contentView.views = [titleGridView]
		
		
		let gridView: GridView = GridView(frame: CGRectMake(16, 100, view.bounds.width - 32, 100))
		gridView.unifiedHeight = 100
		gridView.views = [imageView, contentView]
		
		view.addSubview(gridView)
	}
	
	/// Prepares the Horizontal GridView example.
	private func prepareHorizontalGridViewExample() {
		var image: UIImage? = UIImage(named: "ic_flash_auto_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn1: FlatButton = FlatButton()
		btn1.grid = .Grid2
		btn1.pulseColor = MaterialColor.blueGrey.darken4
		btn1.tintColor = MaterialColor.blueGrey.darken4
		btn1.backgroundColor = MaterialColor.grey.lighten3
		btn1.setImage(image, forState: .Normal)
		btn1.setImage(image, forState: .Highlighted)
		
		image = UIImage(named: "ic_flash_off_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn2: FlatButton = FlatButton()
//		btn2.grid = .Grid3
		btn2.pulseColor = MaterialColor.blueGrey.darken4
		btn2.tintColor = MaterialColor.blueGrey.darken4
		btn2.backgroundColor = MaterialColor.grey.lighten3
		btn2.setImage(image, forState: .Normal)
		btn2.setImage(image, forState: .Highlighted)
		
		image = UIImage(named: "ic_flash_on_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn3: FlatButton = FlatButton()
		btn3.pulseColor = MaterialColor.blueGrey.darken4
		btn3.tintColor = MaterialColor.blueGrey.darken4
		btn3.backgroundColor = MaterialColor.grey.lighten3
		btn3.setImage(image, forState: .Normal)
		btn3.setImage(image, forState: .Highlighted)
		
		let label1: MaterialLabel = MaterialLabel()
		label1.text = "A"
		label1.backgroundColor = MaterialColor.blue.base
		
		let label2: MaterialLabel = MaterialLabel()
		label2.text = "B"
		label2.grid = .Grid2
		label2.backgroundColor = MaterialColor.blue.base
		
		let gridView: GridView = GridView()
		gridView.grid = .Grid5
		gridView.spacing = 32
//		gridView.unifiedHeight = 40
		gridView.views = [btn1, btn2, label2]
		
		view.addSubview(gridView)
		gridView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: gridView)
		MaterialLayout.alignToParentHorizontally(view, child: gridView)
	}
	
	internal func handleButton() {
		print("Clicked Button")
	}
	
	/// Prepares the Vertical GridView example.
	private func prepareVerticalGridViewExample() {
		var image: UIImage? = UIImage(named: "ic_flash_auto_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn1: FlatButton = FlatButton()
//		btn1.grid = .Grid2
		btn1.pulseColor = MaterialColor.blueGrey.darken4
		btn1.tintColor = MaterialColor.blueGrey.darken4
		btn1.backgroundColor = MaterialColor.grey.lighten3
		btn1.setImage(image, forState: .Normal)
		btn1.setImage(image, forState: .Highlighted)
		btn1.addTarget(self, action: "handleButton", forControlEvents: .TouchUpInside)
		
		image = UIImage(named: "ic_flash_off_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn2: FlatButton = FlatButton()
		//		btn2.grid = .Grid3
		btn2.pulseColor = MaterialColor.blueGrey.darken4
		btn2.tintColor = MaterialColor.blueGrey.darken4
		btn2.backgroundColor = MaterialColor.grey.lighten3
		btn2.setImage(image, forState: .Normal)
		btn2.setImage(image, forState: .Highlighted)
		
		image = UIImage(named: "ic_flash_on_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let btn3: FlatButton = FlatButton()
		btn3.pulseColor = MaterialColor.blueGrey.darken4
		btn3.tintColor = MaterialColor.blueGrey.darken4
		btn3.backgroundColor = MaterialColor.grey.lighten3
		btn3.setImage(image, forState: .Normal)
		btn3.setImage(image, forState: .Highlighted)
		
		let label1: MaterialLabel = MaterialLabel()
		label1.text = "A"
		label1.backgroundColor = MaterialColor.blue.base
		
		let label2: MaterialLabel = MaterialLabel()
		label2.text = "B"
//		label2.grid = .Grid2
		label2.backgroundColor = MaterialColor.blue.base
		
		let gridView: GridView = GridView()
//		let gridView: GridView = GridView(frame: CGRectMake(0, 100, view.bounds.width, 100))
		gridView.grid = .Grid12
		gridView.layout = .Vertical
//		gridView.spacing = 32
//		gridView.unifiedHeight = 40
		gridView.views = [btn1, btn2, label2]
		
		view.addSubview(gridView)
		gridView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: gridView, top: 100)
		MaterialLayout.alignToParentHorizontally(view, child: gridView)
		MaterialLayout.height(view, child: gridView, height: 400)
	}
}

