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
	private lazy var captureView: CaptureView = CaptureView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareCaptureView()
	}
	
	/**
	:name:	prepareView
	*/
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/**
	:name:	prepareCaptureView
	*/
	private func prepareCaptureView() {
		let img1: UIImage? = UIImage(named: "ic_flash_auto_white")
		let btn1: FlatButton = FlatButton()
		btn1.pulseColor = nil
		btn1.setImage(img1, forState: .Normal)
		btn1.setImage(img1, forState: .Highlighted)
		btn1.addTarget(self, action: "handleFlash:", forControlEvents: .TouchUpInside)
		
		let img2: UIImage? = UIImage(named: "ic_switch_camera_white")
		let btn2: FlatButton = FlatButton()
		btn2.pulseColor = nil
		btn2.setImage(img2, forState: .Normal)
		btn2.setImage(img2, forState: .Highlighted)
		
		captureView.flashAutoButton = btn1
		captureView.switchCamerasButton = btn2
		captureView.navigationBarView.rightButtons = [btn1, btn2]
		
		view.addSubview(captureView)
		captureView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignToParent(view, child: captureView)
	}
	
	internal func handleFlash(sender: AnyObject) {
		var img: UIImage?
		switch captureView.previewView.captureSession.flashMode {
		case .Off:
			img = UIImage(named: "ic_flash_on_white")
			print("Flash On")
		case .On:
			img = UIImage(named: "ic_flash_auto_white")
			print("Flash Auto")
		case .Auto:
			img = UIImage(named: "ic_flash_off_white")
			print("Flash Off")
		}
		captureView.flashAutoButton?.setImage(img, forState: .Normal)
		captureView.flashAutoButton?.setImage(img, forState: .Highlighted)
	}
}

