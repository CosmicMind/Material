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
	/// Reference for NavigationBar.
	private var bottomNavigationBar: BottomNavigationBar!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareBottomNavigationBar()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepare bottomNavigationBar.
	private func prepareBottomNavigationBar() {
		bottomNavigationBar = BottomNavigationBar()
		bottomNavigationBar.backgroundColor = MaterialColor.teal.base
		view.addSubview(bottomNavigationBar)
		
		let item1: BottomNavigationBarItem = BottomNavigationBarItem(title: "Music", image: UIImage(named:"ic_music_note_white")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named:"ic_music_note_white"))
		item1.setTitleColor(MaterialColor.white, forState: .Normal)
		item1.setTitleColor(MaterialColor.white, forState: .Selected)
		
		
		let item2: BottomNavigationBarItem = BottomNavigationBarItem(title: "Music", image: UIImage(named:"ic_music_note_white")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named:"ic_music_note_white"))
		item2.setTitleColor(MaterialColor.white, forState: .Normal)
		item2.setTitleColor(MaterialColor.white, forState: .Selected)
		
		let item3: BottomNavigationBarItem = BottomNavigationBarItem(title: "Music", image: UIImage(named:"ic_music_note_white"), selectedImage: UIImage(named:"ic_music_note_white"))
		item3.setTitleColor(MaterialColor.blue.lighten3, forState: .Normal)
		item3.setTitleColor(MaterialColor.white, forState: .Selected)
		
		bottomNavigationBar.setItems([item1, item2, item3], animated: true)
//		bottomNavigationBar.tintColor = MaterialColor.white
	}
}
