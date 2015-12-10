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
		prepareAlignToParentHorizontallyExample()
//		prepareAlignToParentVerticallyExample()
	}
	
	/**
	:name:	prepareView
	:description: General preparation statements.
	*/
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/**
	:name:	prepareAlignToParentHorizontallyExample
	:description:	Laying out views horizontally with equal width.
	*/
	private func prepareAlignToParentHorizontallyExample() {
		let label1: UILabel = UILabel()
		label1.translatesAutoresizingMaskIntoConstraints = false
		label1.backgroundColor = MaterialColor.red.base
		label1.text = "A"
		label1.textAlignment = .Center
		view.addSubview(label1)
		
		let label2: UILabel = UILabel()
		label2.translatesAutoresizingMaskIntoConstraints = false
		label2.backgroundColor = MaterialColor.green.base
		label2.text = "B"
		label2.textAlignment = .Center
		view.addSubview(label2)
		
		let label3: UILabel = UILabel()
		label3.translatesAutoresizingMaskIntoConstraints = false
		label3.backgroundColor = MaterialColor.blue.base
		label3.text = "C"
		label3.textAlignment = .Center
		view.addSubview(label3)
		
		let label4: UILabel = UILabel()
		label4.translatesAutoresizingMaskIntoConstraints = false
		label4.backgroundColor = MaterialColor.yellow.base
		label4.text = "D"
		label4.textAlignment = .Center
		view.addSubview(label4)
		
		let children: Array<UIView> = [label1, label2, label3, label4]
		
		// Align the labels horizontally with an equal width.
		MaterialLayout.alignToParentHorizontally(view, children: children, left: 30, right: 30, spacing: 30)
		
		// Individually set the labels' vertical alignment.
		// If this is left out, the intrinsic value is used for the view.
		for v in children {
			MaterialLayout.alignToParentVertically(view, child: v, top: 100, bottom: 100)
		}
		
		// Print out the dimensions of the labels.
		for v in children {
			v.layoutIfNeeded()
			print(v.frame)
		}
	}
	
	/**
	:name:	prepareAlignToParentVerticallyExample
	:description:	Laying out views vertically with equal height.
	*/
	private func prepareAlignToParentVerticallyExample() {
		let label1: UILabel = UILabel()
		label1.translatesAutoresizingMaskIntoConstraints = false
		label1.backgroundColor = MaterialColor.red.base
		label1.text = "A"
		label1.textAlignment = .Center
		view.addSubview(label1)
		
		let label2: UILabel = UILabel()
		label2.translatesAutoresizingMaskIntoConstraints = false
		label2.backgroundColor = MaterialColor.green.base
		label2.text = "B"
		label2.textAlignment = .Center
		view.addSubview(label2)
		
		let label3: UILabel = UILabel()
		label3.translatesAutoresizingMaskIntoConstraints = false
		label3.backgroundColor = MaterialColor.blue.base
		label3.text = "C"
		label3.textAlignment = .Center
		view.addSubview(label3)
		
		let label4: UILabel = UILabel()
		label4.translatesAutoresizingMaskIntoConstraints = false
		label4.backgroundColor = MaterialColor.yellow.base
		label4.text = "D"
		label4.textAlignment = .Center
		view.addSubview(label4)
		
		let children: Array<UIView> = [label1, label2, label3, label4]
		
		// Align the labels vertically with an equal height.
		MaterialLayout.alignToParentVertically(view, children: children, top: 100, bottom: 100, spacing: 100)
		
		// Individually set the labels' horizontal alignment.
		// If this is left out, the intrinsic value is used for the view.
		for v in children {
			MaterialLayout.alignToParentHorizontally(view, child: v, left: 100, right: 100)
		}
		
		// Print out the dimensions of the labels.
		for v in children {
			v.layoutIfNeeded()
			print(v.frame)
		}
	}
}

