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
MaterialPulseView is at the heart of all pulse animations. Any view that subclasses 
MaterialPulseView instantly inherits the pulse animation with full customizability. 
Below is an example of using MaterialPulseView.
*/

import UIKit
import Material

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareMaterialPulseView()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the MaterialPulseView example.
	private func prepareMaterialPulseView() {
		let diameter: CGFloat = 150
		let point: CGFloat = (MaterialDevice.width - diameter) / 2
		
		let pulseView: MaterialPulseView = MaterialPulseView(frame: CGRectMake(point, point, diameter, diameter))
//		pulseView.image = UIImage(named: "Graph")
		pulseView.shape = .Square
		pulseView.depth = .Depth1
		pulseView.cornerRadiusPreset = .Radius3
		pulseView.pulseAnimation = .CenterRadialBeyondBounds
		
		// Add pulseView to UIViewController.
		view.addSubview(pulseView)
		
		// Trigger the pulse animation.
//		MaterialAnimation.delay(4) {
//			pulseView.pulse(CGPointMake(30, 30))
//		}
		
//		pulseView.animate(MaterialAnimation.animationGroup([
//			MaterialAnimation.rotate(rotation: 0.5),
//			MaterialAnimation.rotateX(rotation: 2),
//			MaterialAnimation.translateY(200)
//		], duration: 4))
	}
}

