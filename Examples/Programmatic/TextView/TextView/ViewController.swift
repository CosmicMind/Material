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
The following is an example of using a TextView. TextViews allow for patterns 
in text to be detected.
*/

import UIKit
import Material

class ViewController: UIViewController, TextDelegate {
	/// A Text storage object that monitors the changes within the textView.
	lazy var text: Text = Text()
	
	/// A TextView UI Component.
	var textView: TextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareTextView()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the textView.
	func prepareTextView() {
		let layoutManager: NSLayoutManager = NSLayoutManager()
		let textContainer: NSTextContainer = NSTextContainer(size: view.bounds.size)
		layoutManager.addTextContainer(textContainer)
		
		text.delegate = self
		text.textStorage.addLayoutManager(layoutManager)
		
		textView = TextView(textContainer: textContainer)
		textView.font = RobotoFont.regular
		
		textView.placeholderLabel = UILabel()
		textView.placeholderLabel!.textColor = MaterialColor.grey.base
		textView.placeholderLabel!.text = "Description"
		
		textView.titleLabel = UILabel()
		textView.titleLabel!.font = RobotoFont.mediumWithSize(12)
		textView.titleLabelColor = MaterialColor.grey.base
		textView.titleLabelActiveColor = MaterialColor.blue.accent3
		
		view.layout(textView!).edges(top: 124, left: 24, bottom: 24, right: 24)
	}
	
	/**
	When changes in the textView text are made, this delegation method 
	is executed with the added text string and range.
	*/
	func textWillProcessEdit(text: Text, textStorage: TextStorage, string: String, range: NSRange) {
		textStorage.removeAttribute(NSFontAttributeName, range: range)
		textStorage.addAttribute(NSFontAttributeName, value: RobotoFont.regular, range: range)
	}
	
	/**
	When a match is detected within the textView text, this delegation
	method is executed with the added text string and range.
	*/
	func textDidProcessEdit(text: Text, textStorage: TextStorage, string: String, result: NSTextCheckingResult?, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) {
		textStorage.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(16), range: result!.range)
	}
}

