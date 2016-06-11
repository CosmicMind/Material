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
Layout is an excellent tool to ease the use of AutoLayout. The following
examples demonstrate laying out a collection of UILabel objects in the vertical,
horizontal, anc center positions.
*/

import UIKit
import Material

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareAlignToParentHorizontallyAndVerticallyExample()
		prepareCenterExample()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Layout views horizontally with equal width.
	private func prepareAlignToParentHorizontallyAndVerticallyExample() {
		let label1: UILabel = UILabel()
		label1.backgroundColor = MaterialColor.red.base
		label1.text = "A"
		label1.textAlignment = .Center
		
		let label2: UILabel = UILabel()
		label2.backgroundColor = MaterialColor.green.base
		label2.text = "B"
		label2.textAlignment = .Center
		
		let label3: UILabel = UILabel()
		label3.backgroundColor = MaterialColor.blue.base
		label3.text = "C"
		label3.textAlignment = .Center
		
		let label4: UILabel = UILabel()
		label4.backgroundColor = MaterialColor.yellow.base
		label4.text = "D"
		label4.textAlignment = .Center
		
		let children: Array<UIView> = [label1, label2, label3, label4]
		
		// Align the labels horizontally with an equal width and vertically with an equal height.
        view.layout.horizontally(children, left: 30, right: 30, spacing: 30).vertically(children, top: 100, bottom: 100)
        
		
		// Print out the dimensions of the labels.
		for v in children {
			v.layoutIfNeeded()
			print(v.frame)
		}
	}
	
	// Lays out test views to the center of different axes
	private func prepareCenterExample() {
		let length: CGFloat = 100
		
		let labelCX = UILabel()
		labelCX.backgroundColor = MaterialColor.grey.base
		labelCX.text = "centerX"
		labelCX.textAlignment = .Center
		labelCX.layer.cornerRadius = length / 2.0
		labelCX.clipsToBounds = true
		
		view.layout(labelCX).width(length).height(length).centerHorizontally()
		
		let labelCY = UILabel()
		labelCY.backgroundColor = MaterialColor.grey.base
		labelCY.text = "centerY"
		labelCY.textAlignment = .Center
		labelCY.layer.cornerRadius = length / 2.0
		labelCY.clipsToBounds = true
		
		view.layout(labelCY).width(length).height(length).centerVertically()
		
		let labelCXY = UILabel()
		labelCXY.backgroundColor = MaterialColor.grey.base
		labelCXY.text = "centerXY"
		labelCXY.textAlignment = .Center
		labelCXY.layer.cornerRadius = length / 2.0
		labelCXY.clipsToBounds = true
		
        view.layout(labelCXY).width(length).height(length).center()		
	}
}

