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

/*
The following are examples of MaterialSwitch.
*/

import UIKit
import Material

class ViewController: UIViewController, MaterialSwitchDelegate {
	private var topView: MaterialView = MaterialView()
	private var bottomView: MaterialView = MaterialView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareLightContentMaterialSwitch()
		prepareDefaultMaterialSwitch()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
		
		bottomView.backgroundColor = MaterialColor.grey.darken4
		
		view.layout.horizontally(topView)
		view.layout.horizontally(bottomView)
		view.layout.vertically([topView, bottomView])
	}
	
	/// Prepares the LightContent MaterialSwitch.
	private func prepareLightContentMaterialSwitch() {
		let c1: MaterialSwitch = MaterialSwitch(state: .Off, style: .LightContent, size: .Small)
		c1.delegate = self
		
		let c2: MaterialSwitch = MaterialSwitch(state: .On, style: .LightContent)
		c2.delegate = self
		
		let c3: MaterialSwitch = MaterialSwitch(state: .Off, style: .LightContent, size: .Large)
		c3.delegate = self
		c3.enabled = false
		
		topView.layout.horizontally(c1)
		topView.layout.horizontally(c2)
		topView.layout.horizontally(c3)
		topView.layout.vertically([c1, c2, c3])
	}
	
	/// Prepares the LightContent MaterialSwitch.
	private func prepareDefaultMaterialSwitch() {
		let c1: MaterialSwitch = MaterialSwitch(state: .Off, style: .Default, size: .Small)
		c1.delegate = self
		
		let c2: MaterialSwitch = MaterialSwitch(state: .On)
		c2.delegate = self
		
		let c3: MaterialSwitch = MaterialSwitch(state: .Off, style: .Default, size: .Large)
		c3.delegate = self
		c3.enabled = false
		
		bottomView.layout.horizontally(c1)
		bottomView.layout.horizontally(c2)
		bottomView.layout.horizontally(c3)
		bottomView.layout.vertically([c1, c2, c3])
	}
	
	internal func materialSwitchStateChanged(control: MaterialSwitch) {
		print("MaterialSwitch - Style: \(control.switchStyle), Size: \(control.switchSize), State: \(control.switchState), On: \(control.on), Selected: \(control.selected),  Highlighted: \(control.highlighted)")
	}
}
