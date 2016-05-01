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

import UIKit
import Material

class ViewController: UIViewController {
	/// Reference for ControlView.
	private var controlView: ControlView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareControlView()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the controlView
	private func prepareControlView() {
		controlView = ControlView(frame: CGRectMake(0, view.bounds.height - 56, view.bounds.width, 56))
		
		// Undo button.
		let undoButton: FlatButton = FlatButton()
		undoButton.pulseColor = MaterialColor.white
		undoButton.setTitle("UNDO", forState: .Normal)
		undoButton.setTitleColor(MaterialColor.teal.accent1, forState: .Normal)
		
		let label: UILabel = UILabel()
		label.text = "Archived"
		label.textColor = MaterialColor.white
		
		controlView.backgroundColor = MaterialColor.grey.darken4
		controlView.contentView.addSubview(label)
		controlView.rightControls = [undoButton]
		controlView.contentInsetPreset = .WideRectangle3
		
		view.addSubview(controlView)
		controlView.contentView.grid.views = [label]
	}
}
