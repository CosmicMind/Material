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
		
		// Examples of using MaterialLayout.
		prepareAlignCollectionToParentHorizontallyExample()
	}
	
	/**
	:name:	prepareView
	:description: General preparation statements.
	*/
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/**
	:name:	prepareAlignCollectionToParentHorizontallyExample
	:description:	General usage example.
	*/
	private func prepareAlignCollectionToParentHorizontallyExample() {
		let view1: MaterialView = MaterialView()
		view1.translatesAutoresizingMaskIntoConstraints = false
		view1.backgroundColor = MaterialColor.blueGrey.base
		view.addSubview(view1)
		
		let view2: MaterialView = MaterialView()
		view2.translatesAutoresizingMaskIntoConstraints = false
		view2.backgroundColor = MaterialColor.blueGrey.darken1
		view.addSubview(view2)
		
		let view3: MaterialView = MaterialView()
		view3.translatesAutoresizingMaskIntoConstraints = false
		view3.backgroundColor = MaterialColor.blueGrey.darken2
		view.addSubview(view3)
		
		let view4: MaterialView = MaterialView()
		view4.translatesAutoresizingMaskIntoConstraints = false
		view4.backgroundColor = MaterialColor.blueGrey.darken3
		view.addSubview(view4)
		
		let view5: MaterialView = MaterialView()
		view5.translatesAutoresizingMaskIntoConstraints = false
		view5.backgroundColor = MaterialColor.blueGrey.darken4
		view.addSubview(view5)
		
//		let children: Array<UIView> = [view1, view2, view3, view4, view5]
//		MaterialLayout.alignChildrenToParentHorizontally(view, children: children, left: 10, right: 10, options: [NSLayoutFormatOptions.AlignAllCenterX])
//		for v in children {
//			MaterialLayout.height(view, child: v, height: 100)
//		}
	}
}

