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

@objc(SearchBarViewDelegate)
public protocol SearchBarViewDelegate : MaterialDelegate {
	optional func searchBarViewDidChangeLayout(searchBarView: SearchBarView)
}

public class SearchBarView : StatusBarView {
	/// The UITextField for the searchBar.
	public private(set) lazy var textField: TextField = TextField()
	
	/// The UIImage for the clear icon.
	public var clearButton: UIButton? {
		get {
			return textField.clearButton
		}
		set(value) {
			textField.clearButton = value
		}
	}
	
	/// TintColor for searchBar.
	public override var tintColor: UIColor? {
		didSet {
			textField.tintColor = tintColor
		}
	}
	
	/// TextColor for searchBar.
	public var textColor: UIColor? {
		didSet {
			textField.textColor = textColor
		}
	}
	
	/// A wrapper for searchBar.placeholder.
	public var placeholder: String? {
		didSet {
			textField.placeholder = placeholder
		}
	}
	
	/// Placeholder textColor.
	public var placeholderTextColor: UIColor {
		get {
			return textField.placeholderTextColor
		}
		set(value) {
			textField.placeholderTextColor = value
		}
	}
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 64))
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		grid.axis.columns = Int(width / 48)
		
		reloadView()
	}
	
	public override func didMoveToSuperview() {
		super.didMoveToSuperview()
		reloadView()
	}
	
	/// Reloads the view.
	public override func reloadView() {
		super.reloadView()
		
		textField.grid.columns = contentView.grid.columns
		textField.reloadView()
		
		grid.reloadLayout()
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public override func prepareView() {
		super.prepareView()
		prepareTextField()
	}
	
	/// Prepares the textField.
	private func prepareTextField() {
		textField.placeholder = "Search"
		textField.backgroundColor = MaterialColor.clear
		textField.clearButtonMode = .WhileEditing
		contentView.addSubview(textField)
		contentView.grid.views = [textField]
	}
	
	internal override func statusBarViewDidChangeLayout() {
		(delegate as? SearchBarViewDelegate)?.searchBarViewDidChangeLayout?(self)
	}
}
