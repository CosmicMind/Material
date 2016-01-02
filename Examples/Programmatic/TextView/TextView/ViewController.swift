//
// Copyright (C) 2015 - 2016 CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.
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

class ViewController: UIViewController, TextDelegate, TextViewDelegate {
	lazy var text: Text = Text()
	var textView: TextView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareTextView()
	}
	
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	func prepareTextView() {
		let layoutManager: NSLayoutManager = NSLayoutManager()
		let textContainer = NSTextContainer(size: view.bounds.size)
		layoutManager.addTextContainer(textContainer)
		
		text.delegate = self
		text.textStorage.addLayoutManager(layoutManager)
		
		textView = TextView(frame: CGRectNull, textContainer: textContainer)
		textView?.delegate = self
		textView!.editable = true
		textView!.selectable = true
		textView!.font = RobotoFont.regular
		
		textView!.placeholderLabel = UILabel()
		textView!.placeholderLabel!.textColor = MaterialColor.grey.base
		textView!.placeholderLabel!.text = "MaterialKit TextView"
		
		view.addSubview(textView!)
		textView!.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignToParent(view, child: textView!, top: 24, left: 24, bottom: 24, right: 24)
	}
	
	func textWillProcessEdit(text: Text, textStorage: TextStorage, string: String, range: NSRange) {
		textStorage.removeAttribute(NSFontAttributeName, range: range)
		textStorage.addAttribute(NSFontAttributeName, value: RobotoFont.regular, range: range)
	}
	
	func textDidProcessEdit(text: Text, textStorage: TextStorage, string: String, result: NSTextCheckingResult?, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) {
		textStorage.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(16), range: result!.range)
	}
	
}

