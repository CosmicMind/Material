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

public protocol TextFieldDelegate : UITextFieldDelegate {}

public class TextField : UITextField {
	/**
	:name:	count
	*/
	private var count: Int?
	
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
	:name:	titleLabel
	*/
	public var titleLabel: UILabel? {
		didSet {
			prepareTitleLabel()
		}
	}
	
	/**
	:name:	bottomBorderEnabled
	*/
	public var bottomBorderEnabled: Bool = true
	
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
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
	}
	
	/**
	:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectNull)
	}
	
	/**
	:name:	prepareView
	*/
	public func prepareView() {
		clipsToBounds = false
	}
	
	/**
	:name:	textFieldDidBegin
	*/
	internal func textFieldDidBegin(textField: TextField) {
		count = text?.utf16.count
		titleLabel?.text = placeholder
		titleLabel?.textColor = 0 == count ? titleLabelNormalColor : titleLabelHighlightedColor
	}
	
	/**
	:name:	textFieldDidChange
	*/
	internal func textFieldDidChange(textField: TextField) {
		if 0 == count && 1 == text?.utf16.count {
			if let v: UILabel = titleLabel {
				v.hidden = false
				UIView.animateWithDuration(0.25, animations: {
					v.alpha = 1
					v.frame.origin.y = -v.frame.height
				})
				titleLabel?.textColor = titleLabelHighlightedColor
			}
		} else if 1 == count && 0 == text?.utf16.count {
			if let v: UILabel = titleLabel {
				UIView.animateWithDuration(0.25, animations: {
					v.alpha = 0
					v.frame.origin.y = -v.frame.height + 4
				}) { _ in
					v.hidden = true
				}
			}
		}
		count = text?.utf16.count
	}
	
	/**
	:name:	textFieldDidEnd
	*/
	internal func textFieldDidEnd(textField: TextField) {
		if 0 < count {
			if let v: UILabel = titleLabel {
				v.hidden = false
				UIView.animateWithDuration(0.25, animations: {
					v.alpha = 1
					v.frame.origin.y = -v.frame.height
				})
			}
		} else if 0 == count {
			if let v: UILabel = titleLabel {
				UIView.animateWithDuration(0.25, animations: {
					v.alpha = 0
					v.frame.origin.y = -v.frame.height + 4
				}) { _ in
					v.hidden = true
				}
			}
		}
		titleLabel?.textColor = titleLabelNormalColor
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
			titleLabel?.text = placeholder
			let h: CGFloat = v.font.stringSize(v.text!, constrainedToWidth: Double(bounds.width)).height
			v.frame = CGRectMake(0, -h, bounds.width, h)
			addSubview(v)
			addTarget(self, action: "textFieldDidBegin:", forControlEvents: .EditingDidBegin)
			addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
			addTarget(self, action: "textFieldDidEnd:", forControlEvents: .EditingDidEnd)
		}
	}
}