//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
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

public class TextView: UITextView {
	//
	//	:name:	label
	//	:description: Placeholder label.
	//
	private lazy var label: UILabel = UILabel()
	
	//
	//	:name:	labelConstraints
	//	:description:	Autoresize constraints for the placeholder label.
	//
	private var labelConstraints: Array<NSLayoutConstraint>?
	
	required public init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupView()
	}
	
	override public init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		if CGRectZero == frame {
			setTranslatesAutoresizingMaskIntoConstraints(false)
		}
		setupView()
	}
	
	//
	//	:name:	deinit
	//	:description:	Notification observer removed from UITextView.
	//	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidChangeNotification, object: nil)
	}
	
	/**
		:name:	placeholder
		:description:	The placeholder label string.
	*/
	public var placeholder: String = "" {
		didSet {
			label.text = placeholder
		}
	}
	
	/**
		:name:	placeholderColor
		:description:	The placeholder color.
	*/
	public var placeholderColor: UIColor = MaterialTheme.blueGrey.lighten1 {
		didSet {
			label.textColor = placeholderColor
		}
	}
	
	/**
		:name:	font
		:description:	Font to use for placeholder based on UITextView font.
	*/
	override public var font: UIFont! {
		didSet {
			label.font = font
		}
	}
	
	/**
		:name:	textAlignment
		:description:	Sets placeholder textAlignment based on UITextView textAlignment.
	*/
	override public var textAlignment: NSTextAlignment {
		didSet {
			label.textAlignment = textAlignment
		}
	}
	
	/**
		:name:	text
		:description:	When set, updates the placeholder text.
	*/
	override public var text: String! {
		didSet {
			textViewTextDidChange()
		}
	}
	
	/**
		:name:	attributedText
		:description:	When set, updates the placeholder attributedText.
	*/
	override public var attributedText: NSAttributedString! {
		didSet {
			textViewTextDidChange()
		}
	}
	
	/**
		:name:	textContainerInset
		:description:	When set, updates the placeholder constraints.
	*/
	override public var textContainerInset: UIEdgeInsets {
		didSet {
			updateLabelConstraints()
		}
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		label.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2
	}
	
	//
	//	:name:	textViewTextDidChange
	//	:description:	Updates the label visibility when text is empty or not.
	//
	internal func textViewTextDidChange() {
		label.hidden = !text.isEmpty
	}
	
	//
	//	:name:	setupView
	//	:description:	Sets up the common initilized values.
	//
	private func setupView() {
		backgroundColor = MaterialTheme.clear.color
		textColor = MaterialTheme.black.color
		label.font = font
		label.textColor = placeholderColor
		label.textAlignment = textAlignment
		label.text = placeholder
		label.numberOfLines = 0
		label.backgroundColor = MaterialTheme.clear.color
		label.setTranslatesAutoresizingMaskIntoConstraints(false)
		addSubview(label)
		
		// label needs to be added to the view
		// hierarchy before setting insets
		textContainerInset = UIEdgeInsetsMake(16, 16, 16, 16)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewTextDidChange", name: UITextViewTextDidChangeNotification, object: nil)
		updateLabelConstraints()
	}
	
	//
	//	:name:	updateLabelConstraints
	//	:description:	Updates the placeholder constraints.
	//	
	private func updateLabelConstraints() {
		if nil != labelConstraints {
			removeConstraints(labelConstraints!)
		}
		
		var constraints: Array<NSLayoutConstraint> = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(left)-[placeholder]-(right)-|", options: nil, metrics: ["left": textContainerInset.left + textContainer.lineFragmentPadding, "right": textContainerInset.right + textContainer.lineFragmentPadding], views: ["placeholder": label]) as! Array<NSLayoutConstraint>
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(top)-[placeholder]-(>=bottom)-|", options: nil, metrics: ["top": textContainerInset.top, "bottom": textContainerInset.bottom], views: ["placeholder": label]) as! Array<NSLayoutConstraint>
		
		labelConstraints = constraints
		addConstraints(constraints)
	}
}
