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
	//	:name:	layoutConstraints
	//
	internal lazy var layoutConstraints: Array<NSLayoutConstraint> = Array<NSLayoutConstraint>()
	
	/**
		:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepareView()
	}
	
	/**
		:name:	init
	*/
	public override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		if CGRectZero == frame {
			translatesAutoresizingMaskIntoConstraints = false
		}
		prepareView()
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
	public var placeholderLabel: UILabel? {
		didSet {
			if let p = placeholderLabel {
				p.translatesAutoresizingMaskIntoConstraints = false
				p.font = font
				p.textAlignment = textAlignment
				p.numberOfLines = 0
				p.backgroundColor = MaterialTheme.clear.color
				addSubview(p)
				updateLabelConstraints()
				textViewTextDidChange()
			}
		}
	}
	
	
	/**
		:name:	text
		:description:	When set, updates the placeholder text.
	*/
	public override var text: String! {
		didSet {
			textViewTextDidChange()
		}
	}
	
	/**
		:name:	attributedText
		:description:	When set, updates the placeholder attributedText.
	*/
	public override var attributedText: NSAttributedString! {
		didSet {
			textViewTextDidChange()
		}
	}
	
	/**
		:name:	textContainerInset
		:description:	When set, updates the placeholder constraints.
	*/
	public override var textContainerInset: UIEdgeInsets {
		didSet {
			updateLabelConstraints()
		}
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		placeholderLabel?.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2
	}
	
	//
	//	:name:	textViewTextDidChange
	//	:description:	Updates the label visibility when text is empty or not.
	//
	internal func textViewTextDidChange() {
		if let p = placeholderLabel {
			p.hidden = !text.isEmpty
		}
	}
	
	//
	//	:name:	prepareView
	//	:description:	Sets up the common initilized values.
	//
	private func prepareView() {
		// label needs to be added to the view
		// hierarchy before setting insets
		textContainerInset = UIEdgeInsetsMake(16, 16, 16, 16)
		backgroundColor = MaterialTheme.clear.color
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewTextDidChange", name: UITextViewTextDidChangeNotification, object: nil)
		updateLabelConstraints()
	}
	
	//
	//	:name:	updateLabelConstraints
	//	:description:	Updates the placeholder constraints.
	//	
	private func updateLabelConstraints() {
		if let p = placeholderLabel {
			NSLayoutConstraint.deactivateConstraints(layoutConstraints)
			layoutConstraints = Layout.constraint("H:|-(left)-[placeholderLabel]-(right)-|",
									options: [],
									metrics: [
										"left": textContainerInset.left + textContainer.lineFragmentPadding,
										"right": textContainerInset.right + textContainer.lineFragmentPadding
									], views: [
										"placeholderLabel": p
									])
				
			layoutConstraints += Layout.constraint("V:|-(top)-[placeholderLabel]-(>=bottom)-|",
									options: [],
									metrics: [
										"top": textContainerInset.top,
										"bottom": textContainerInset.bottom
									],
									views: [
										"placeholderLabel": p
									])
			NSLayoutConstraint.activateConstraints(layoutConstraints)
		}
	}
}
