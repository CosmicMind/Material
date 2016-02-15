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
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareSmallMaterialSwitch()
		prepareDefaultMaterialSwitch()
		prepareLargeMaterialSwitch()
		prepareLightOnDisabledMaterialSwitch()
		prepareLightOffDisabledMaterialSwitch()
		prepareDarkOnDisabledMaterialSwitch()
		prepareDarkOffDisabledMaterialSwitch()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the Small MaterialSwitch.
	private func prepareSmallMaterialSwitch() {
		let switchControl: MaterialSwitch = MaterialSwitch(state: .Off, style: .Light, size: .Small)
		switchControl.center = view.center
		switchControl.y -= 100
		switchControl.delegate = self
		view.addSubview(switchControl)
	}
	
	/// Prepares the Default MaterialSwitch.
	private func prepareDefaultMaterialSwitch() {
		let switchControl: MaterialSwitch = MaterialSwitch(state: .On, style: .Light)
		switchControl.delegate = self
		
		view.addSubview(switchControl)
		switchControl.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromBottomRight(view, child: switchControl, bottom: 16, right: 16)
	}
	
	/// Prepares the Large MaterialSwitch.
	private func prepareLargeMaterialSwitch() {
		let image: UIImage? = UIImage(named: "ic_alarm_white_18pt")
		let switchControl: MaterialSwitch = MaterialSwitch(state: .Off, style: .Light, size: .Large)
		switchControl.center = view.center
		switchControl.y -= 50
		switchControl.delegate = self
		switchControl.button.setImage(image, forState: .Normal)
		switchControl.button.setImage(image, forState: .Highlighted)
		view.addSubview(switchControl)
	}
	
	/// Prepares the Light On enabled = false MaterialSwitch.
	private func prepareLightOnDisabledMaterialSwitch() {
		let switchControl: MaterialSwitch = MaterialSwitch(state: .On, style: .Light)
		switchControl.enabled = false
		switchControl.center = view.center
		switchControl.delegate = self
		view.addSubview(switchControl)
	}
	
	/// Prepares the Light Off enabled = false MaterialSwitch.
	private func prepareLightOffDisabledMaterialSwitch() {
		let switchControl: MaterialSwitch = MaterialSwitch(state: .Off, style: .Light)
		switchControl.enabled = false
		switchControl.center = view.center
		switchControl.y += 50
		switchControl.delegate = self
		view.addSubview(switchControl)
	}
	
	/// Prepares the Dark On enabled = false MaterialSwitch.
	private func prepareDarkOnDisabledMaterialSwitch() {
		let switchControl: MaterialSwitch = MaterialSwitch(state: .On, style: .Dark)
		switchControl.enabled = false
		switchControl.center = view.center
		switchControl.y += 100
		switchControl.delegate = self
		view.addSubview(switchControl)
	}
	
	/// Prepares the Dark On enabled = false MaterialSwitch.
	private func prepareDarkOffDisabledMaterialSwitch() {
		let switchControl: MaterialSwitch = MaterialSwitch(state: .Off, style: .Dark)
		switchControl.enabled = false
		switchControl.center = view.center
		switchControl.y += 150
		switchControl.delegate = self
		view.addSubview(switchControl)
	}
	
	internal func switchControlStateChanged(control: MaterialSwitch, state: MaterialSwitchState) {
		print("MaterialSwitch - Size: \(control.switchSize) State: \(state)")
	}
}
