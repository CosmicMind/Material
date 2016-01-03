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

public protocol TextViewDelegate : UITextViewDelegate {}

public class TextView: UITextView {
	public var titleLabel: UILabel? {
		didSet {
			prepareTitleLabel()
		}
	}
	
	/**
	:name:	titleLabelNormalColor
	*/
	public var titleLabelNormalColor: UIColor? {
		didSet {
			titleLabel?.textColor = titleLabelNormalColor
		}
	}
	
	/**
	:name:	titleLabelHighlightedColor
	*/
	public var titleLabelHighlightedColor: UIColor?
	
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
		prepareView()
	}
	
	//
	//	:name:	deinit
	//
	deinit {
		removeNotificationHandlers()
	}
	
	/**
		:name:	placeholderLabel
	*/
	public var placeholderLabel: UILabel? {
		didSet {
			preparePlaceholderLabel()
		}
	}
	
	
	/**
		:name:	text
	*/
	public override var text: String! {
		didSet {
			handleTextViewTextDidChange()
		}
	}
	
	/**
		:name:	attributedText
	*/
	public override var attributedText: NSAttributedString! {
		didSet {
			handleTextViewTextDidChange()
		}
	}
	
	/**
		:name:	textContainerInset
	*/
	public override var textContainerInset: UIEdgeInsets {
		didSet {
			reloadView()
		}
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		placeholderLabel?.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2
		titleLabel?.frame.size.width = bounds.width
	}
	
	/**
		:name:	reloadView
	*/
	internal func reloadView() {
		if let p = placeholderLabel {
			removeConstraints(constraints)
			MaterialLayout.alignToParent(self,
				child: p,
				top: textContainerInset.top,
				left: textContainerInset.left + textContainer.lineFragmentPadding,
				bottom: textContainerInset.bottom,
				right: textContainerInset.right + textContainer.lineFragmentPadding)
		}
	}
	
	/**
	:name:	textFieldDidBegin
	*/
	internal func handleTextViewTextDidBegin() {
		titleLabel?.text = placeholderLabel?.text
		if 0 == text?.utf16.count {
			titleLabel?.textColor = titleLabelNormalColor
		} else {
			titleLabel?.textColor = titleLabelHighlightedColor
		}
	}
	
	/**
	:name:	textFieldDidChange
	*/
	internal func handleTextViewTextDidChange() {
		if let p = placeholderLabel {
			p.hidden = !text.isEmpty
		}
		
		if 0 < text?.utf16.count {
			showTitleLabel()
			titleLabel?.textColor = titleLabelHighlightedColor
		} else if 0 == text?.utf16.count {
			hideTitleLabel()
		}
	}
	
	/**
	:name:	textFieldDidEnd
	*/
	internal func handleTextViewTextDidEnd() {
		if 0 < text?.utf16.count {
			showTitleLabel()
		} else if 0 == text?.utf16.count {
			hideTitleLabel()
		}
		titleLabel?.textColor = titleLabelNormalColor
	}
	
	//
	//	:name:	prepareView
	//
	private func prepareView() {
		textContainerInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
		backgroundColor = MaterialColor.clear
		clipsToBounds = false
		removeNotificationHandlers()
		prepareNotificationHandlers()
		reloadView()
	}
	
	private func preparePlaceholderLabel() {
		if let v: UILabel = placeholderLabel {
			v.translatesAutoresizingMaskIntoConstraints = false
			v.font = font
			v.textAlignment = textAlignment
			v.numberOfLines = 0
			v.backgroundColor = .clearColor()
			titleLabel?.text = placeholderLabel?.text
			addSubview(v)
			reloadView()
			handleTextViewTextDidChange()
		}
	}
	
	/**
	:name:	prepareTitleLabel
	*/
	private func prepareTitleLabel() {
		if let v: UILabel = titleLabel {
			MaterialAnimation.animationDisabled {
				v.hidden = true
				v.alpha = 0
			}
			titleLabel?.text = placeholderLabel?.text
			let h: CGFloat = v.font.pointSize
			v.frame = CGRectMake(0, -h, bounds.width, h)
			addSubview(v)
		}
	}
	
	/**
	:name:	showTitleLabel
	*/
	private func showTitleLabel() {
		if let v: UILabel = titleLabel {
			v.frame.size.height = v.font.pointSize
			v.hidden = false
			UIView.animateWithDuration(0.25, animations: {
				v.alpha = 1
				v.frame.origin.y = -v.frame.height - 4
			})
		}
	}
	
	/**
	:name:	hideTitleLabel
	*/
	private func hideTitleLabel() {
		if let v: UILabel = titleLabel {
			UIView.animateWithDuration(0.25, animations: {
				v.alpha = 0
				v.frame.origin.y = -v.frame.height
			}) { _ in
				v.hidden = true
			}
		}
	}
	
	private func prepareNotificationHandlers() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleTextViewTextDidBegin", name: UITextViewTextDidBeginEditingNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleTextViewTextDidChange", name: UITextViewTextDidChangeNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleTextViewTextDidEnd", name: UITextViewTextDidEndEditingNotification, object: nil)
	}
	
	private func removeNotificationHandlers() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidBeginEditingNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidChangeNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidEndEditingNotification, object: nil)
	}
}
