//
// Copyright (C) 1615 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
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

public class BasicCardView : MaterialCardView, Comparable {
	//
	//	:name:	layoutConstraints
	//
	internal lazy var layoutConstraints: Array<NSLayoutConstraint> = Array<NSLayoutConstraint>()
	
	/**
		:name:	titleLabelVerticalInset
	*/
	public var titleLabelVerticalInset: CGFloat = MaterialTheme.cardVerticalInset {
		didSet {
			titleLabelTopInset = titleLabelVerticalInset
			titleLabelBottomInset = titleLabelVerticalInset
		}
	}
	
	/**
		:name:	titleLabelTopInset
	*/
	public var titleLabelTopInset: CGFloat = MaterialTheme.cardVerticalInset {
		didSet {
			prepareCard()
		}
	}
	
	/**
		:name:	titleLabelBottomInset
	*/
	public var titleLabelBottomInset: CGFloat = MaterialTheme.cardVerticalInset {
		didSet {
			prepareCard()
		}
	}
	
	/**
		:name:	titleLabelHorizontalInset
	*/
	public var titleLabelHorizontalInset: CGFloat = MaterialTheme.cardHorizontalInset {
		didSet {
			titleLabelLeftInset = titleLabelHorizontalInset
			titleLabelRightInset = titleLabelHorizontalInset
		}
	}
	
	/**
		:name:	titleLabelLeftInset
	*/
	public var titleLabelLeftInset: CGFloat = MaterialTheme.cardHorizontalInset {
		didSet {
			prepareCard()
		}
	}
	
	/**
		:name:	titleLabelRightInset
	*/
	public var titleLabelRightInset: CGFloat = MaterialTheme.cardHorizontalInset {
		didSet {
			prepareCard()
		}
	}
	
	/**
		:name:	detailLabelVerticalInset
	*/
	public var detailLabelVerticalInset: CGFloat = MaterialTheme.cardVerticalInset {
		didSet {
			detailLabelTopInset = detailLabelVerticalInset
			detailLabelBottomInset = detailLabelVerticalInset
		}
	}
	
	/**
		:name:	detailLabelTopInset
	*/
	public var detailLabelTopInset: CGFloat = MaterialTheme.cardVerticalInset {
		didSet {
			prepareCard()
		}
	}
	
	/**
		:name:	detailLabelBottomInset
	*/
	public var detailLabelBottomInset: CGFloat = MaterialTheme.cardVerticalInset {
		didSet {
			prepareCard()
		}
	}
	
	/**
		:name:	detailLabelHorizontalInset
	*/
	public var detailLabelHorizontalInset: CGFloat = MaterialTheme.cardHorizontalInset {
		didSet {
			detailLabelLeftInset = detailLabelHorizontalInset
			detailLabelRightInset = detailLabelHorizontalInset
		}
	}
	
	/**
		:name:	detailLabelLeftInset
	*/
	public var detailLabelLeftInset: CGFloat = MaterialTheme.cardHorizontalInset {
		didSet {
			prepareCard()
		}
	}
	
	/**
		:name:	detailLabelRightInset
	*/
	public var detailLabelRightInset: CGFloat = MaterialTheme.cardHorizontalInset {
		didSet {
			prepareCard()
		}
	}
	
	/**
		:name:	buttonVerticalInset
	*/
	public var buttonVerticalInset: CGFloat = MaterialTheme.cardVerticalInset {
		didSet {
			buttonTopInset = buttonVerticalInset
			buttonBottomInset = buttonVerticalInset
		}
	}
	
	/**
		:name:	buttonTopInset
	*/
	public var buttonTopInset: CGFloat = MaterialTheme.cardVerticalInset / 2 {
		didSet {
			prepareCard()
		}
	}
	
	/**
		:name:	buttonBottomInset
	*/
	public var buttonBottomInset: CGFloat = MaterialTheme.cardVerticalInset / 2 {
		didSet {
			prepareCard()
		}
	}
	
	/**
		:name:	buttonHorizontalInset
	*/
	public var buttonHorizontalInset: CGFloat = MaterialTheme.cardHorizontalInset {
		didSet {
			buttonLeftInset = buttonHorizontalInset
			buttonRightInset = buttonHorizontalInset
		}
	}
	
	/**
		:name:	buttonLeftInset
	*/
	public var buttonLeftInset: CGFloat = MaterialTheme.cardHorizontalInset / 2 {
		didSet {
			prepareCard()
		}
	}
	
	/**
		:name:	buttonRightInset
	*/
	public var buttonRightInset: CGFloat = MaterialTheme.cardHorizontalInset / 2 {
		didSet {
			prepareCard()
		}
	}
	
	/**
		:name:	shadow
	*/
	public var shadow: Bool = true {
		didSet {
			false == shadow ? removeShadow() : prepareShadow()
			prepareCard()
		}
	}
	
	/**
		:name:	maximumTitleLabelHeight
	*/
	public var maximumTitleLabelHeight: CGFloat = 0 {
		didSet {
			prepareCard()
		}
	}
	
	/**
		:name:	titleLabelContainer
	*/
	public private(set) var titleLabelContainer: UIView?
	
	/**
		:name:	titleLabel
	*/
	public var titleLabel: UILabel? {
		didSet {
			if let t = titleLabel {
				// container
				if nil == titleLabelContainer {
					titleLabelContainer = UIView()
					titleLabelContainer!.translatesAutoresizingMaskIntoConstraints = false
					titleLabelContainer!.backgroundColor = MaterialTheme.clear.color
					addSubview(titleLabelContainer!)
				}
				
				// text
				titleLabelContainer!.addSubview(t)
				t.translatesAutoresizingMaskIntoConstraints = false
				t.backgroundColor = MaterialTheme.clear.color
				t.font = Roboto.regular
				t.numberOfLines = 0
				t.lineBreakMode = .ByTruncatingTail
				t.textColor = MaterialTheme.white.color
			} else {
				titleLabelContainer?.removeFromSuperview()
				titleLabelContainer = nil
			}
			prepareCard()
		}
	}
	
	/**
		:name:	maximumDetailLabelHeight
	*/
	public var maximumDetailLabelHeight: CGFloat = 0 {
		didSet {
			prepareCard()
		}
	}
	
	/**
		:name:	detailLabelContainer
	*/
	public private(set) var detailLabelContainer: UIView?
	
	/**
		:name:	detailLabel
	*/
	public var detailLabel: UILabel? {
		didSet {
			if let l = detailLabel {
				// container
				if nil == detailLabelContainer {
					detailLabelContainer = UIView()
					detailLabelContainer!.translatesAutoresizingMaskIntoConstraints = false
					detailLabelContainer!.backgroundColor = MaterialTheme.clear.color
					addSubview(detailLabelContainer!)
				}
				
				// text
				detailLabelContainer!.addSubview(l)
				l.translatesAutoresizingMaskIntoConstraints = false
				l.textColor = MaterialTheme.white.color
				l.backgroundColor = MaterialTheme.clear.color
				l.font = Roboto.light
				l.numberOfLines = 0
				l.lineBreakMode = .ByTruncatingTail
			} else {
				detailLabelContainer?.removeFromSuperview()
				detailLabelContainer = nil
			}
			prepareCard()
		}
	}
	
	/**
		:name:	divider
	*/
	public var divider: UIView? {
		didSet {
			if let d = divider {
				d.translatesAutoresizingMaskIntoConstraints = false
				d.backgroundColor = MaterialTheme.blueGrey.darken1
				addSubview(d)
			} else {
				divider?.removeFromSuperview()
			}
			prepareCard()
		}
	}
	
	/**
		:name:	buttonsContainer
	*/
	public private(set) var buttonsContainer: UIView?
	
	/**
		:name:	leftButtons
	*/
	public var leftButtons: Array<MaterialButton>? {
		didSet {
			if nil == rightButtons && nil == leftButtons {
				buttonsContainer?.removeFromSuperview()
				buttonsContainer = nil
			} else if nil == buttonsContainer {
				buttonsContainer = UIView()
				buttonsContainer!.translatesAutoresizingMaskIntoConstraints = false
				buttonsContainer!.backgroundColor = MaterialTheme.clear.color
				addSubview(buttonsContainer!)
			}
			prepareCard()
		}
	}
	
	/**
		:name:	rightButtons
	*/
	public var rightButtons: Array<MaterialButton>? {
		didSet {
			if nil == rightButtons && nil == leftButtons {
				buttonsContainer?.removeFromSuperview()
				buttonsContainer = nil
			} else if nil == buttonsContainer {
				buttonsContainer = UIView()
				buttonsContainer!.translatesAutoresizingMaskIntoConstraints = false
				buttonsContainer!.backgroundColor = MaterialTheme.clear.color
				addSubview(buttonsContainer!)
			}
			prepareCard()
		}
	}
	
	/**
		:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
		:name:	init
	*/
	public convenience init?(titleLabel: UILabel? = nil, detailLabel: UILabel? = nil, divider: UIView? = nil, leftButtons: Array<MaterialButton>? = nil, rightButtons: Array<MaterialButton>? = nil) {
		self.init(frame: CGRectZero)
		prepareProperties(titleLabel, detailLabel: detailLabel, divider: divider, leftButtons: leftButtons, rightButtons: rightButtons)
	}
	
	/**
		:name:	init
	*/
	public required init(frame: CGRect) {
		super.init(frame: CGRectZero)
	}
	
	//
	//	:name:	prepareProperties
	//
	internal func prepareProperties(titleLabel: UILabel?, detailLabel: UILabel?, divider: UIView?, leftButtons: Array<MaterialButton>?, rightButtons: Array<MaterialButton>?) {
		self.titleLabel = titleLabel
		self.detailLabel = detailLabel
		self.divider = divider
		self.leftButtons = leftButtons
		self.rightButtons = rightButtons
	}
	
	//
	//	:name:	prepareView
	//
	internal override func prepareView() {
		super.prepareView()
		prepareShadow()
		backgroundColor = MaterialTheme.blueGrey.color
	}
	
	//
	//	:name:	prepareCard
	//
	internal override func prepareCard() {
		super.prepareCard()
		// clear all constraints
		NSLayoutConstraint.deactivateConstraints(layoutConstraints)
		layoutConstraints.removeAll(keepCapacity: false)
		
		// detect all components and create constraints
		var verticalFormat: String = "V:|"
		var views: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
		
		// title
		if nil != titleLabelContainer && nil != titleLabel {
			// clear for updated constraints
			titleLabelContainer!.removeConstraints(titleLabelContainer!.constraints)
			
			// container
			layoutConstraints += Layout.constraint("H:|[titleLabelContainer]|", options: [], metrics: nil, views: ["titleLabelContainer": titleLabelContainer!])
			verticalFormat += "[titleLabelContainer]"
			views["titleLabelContainer"] = titleLabelContainer!
		
			// common text
			if 0 == maximumTitleLabelHeight {
				Layout.expandToParentWithPad(titleLabelContainer!, child: titleLabel!, top: titleLabelTopInset, left: titleLabelLeftInset, bottom: titleLabelBottomInset, right: titleLabelRightInset)
			} else {
				Layout.expandToParentHorizontallyWithPad(titleLabelContainer!, child: titleLabel!, left: titleLabelLeftInset, right: titleLabelRightInset)
				titleLabelContainer!.addConstraints(Layout.constraint("V:|-(titleLabelTopInset)-[titleLabel(<=maximumTitleLabelHeight)]-(titleLabelBottomInset)-|", options: [], metrics: ["titleLabelTopInset": titleLabelTopInset, "titleLabelBottomInset": titleLabelBottomInset, "maximumTitleLabelHeight": maximumTitleLabelHeight], views: ["titleLabel": titleLabel!]))
			}
		}
		
		// detail
		if nil != detailLabelContainer && nil != detailLabel {
			// clear for updated constraints
			detailLabelContainer!.removeConstraints(detailLabelContainer!.constraints)
			
			// container
			layoutConstraints += Layout.constraint("H:|[detailLabelContainer]|", options: [], metrics: nil, views: ["detailLabelContainer": detailLabelContainer!])
			verticalFormat += "[detailLabelContainer]"
			views["detailLabelContainer"] = detailLabelContainer!

			if 0 == maximumDetailLabelHeight {
				Layout.expandToParentWithPad(detailLabelContainer!, child: detailLabel!, top: detailLabelTopInset, left: detailLabelLeftInset, bottom: detailLabelBottomInset, right: detailLabelRightInset)
			} else {
				Layout.expandToParentHorizontallyWithPad(detailLabelContainer!, child: detailLabel!, left: detailLabelLeftInset, right: detailLabelRightInset)
				detailLabelContainer!.addConstraints(Layout.constraint("V:|-(detailLabelTopInset)-[detailLabel(<=maximumDetailLabelHeight)]-(detailLabelBottomInset)-|", options: [], metrics: ["detailLabelTopInset": detailLabelTopInset, "detailLabelBottomInset": detailLabelBottomInset, "maximumDetailLabelHeight": maximumDetailLabelHeight], views: ["detailLabel": detailLabel!]))
			}
		}
		
		// buttons
		if nil != buttonsContainer && (nil != leftButtons || nil != rightButtons) {
			// clear for updated constraints
			buttonsContainer!.removeConstraints(buttonsContainer!.constraints)
			
			// divider
			if nil != divider {
				layoutConstraints += Layout.constraint("H:|[divider]|", options: [], metrics: nil, views: ["divider": divider!])
				views["divider"] = divider!
				verticalFormat += "[divider(1)]"
			}
			
			//container
			layoutConstraints += Layout.constraint("H:|[buttonsContainer]|", options: [], metrics: nil, views: ["buttonsContainer": buttonsContainer!])
			verticalFormat += "[buttonsContainer]"
			views["buttonsContainer"] = buttonsContainer!
			
			// leftButtons
			if nil != leftButtons {
				var horizontalFormat: String = "H:|"
				var buttonViews: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				for var i: Int = 0, l: Int = leftButtons!.count; i < l; ++i {
					let button: MaterialButton = leftButtons![i]
					buttonsContainer!.addSubview(button)
					buttonViews["button\(i)"] = button
					horizontalFormat += "-(buttonLeftInset)-[button\(i)]"
					Layout.expandToParentVerticallyWithPad(buttonsContainer!, child: button, top: buttonTopInset, bottom: buttonBottomInset)
				}
				buttonsContainer!.addConstraints(Layout.constraint(horizontalFormat, options: [], metrics: ["buttonLeftInset": buttonLeftInset], views: buttonViews))
			}
			
			// rightButtons
			if nil != rightButtons {
				var horizontalFormat: String = "H:"
				var buttonViews: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				for var i: Int = 0, l: Int = rightButtons!.count; i < l; ++i {
					let button: MaterialButton = rightButtons![i]
					buttonsContainer!.addSubview(button)
					buttonViews["button\(i)"] = button
					horizontalFormat += "[button\(i)]-(buttonRightInset)-"
					Layout.expandToParentVerticallyWithPad(buttonsContainer!, child: button, top: buttonTopInset, bottom: buttonBottomInset)
				}
				buttonsContainer!.addConstraints(Layout.constraint(horizontalFormat + "|", options: [], metrics: ["buttonRightInset": buttonRightInset], views: buttonViews))
			}
		}
		
		verticalFormat += "|"
		
		// combine constraints
		if 0 < layoutConstraints.count {
			layoutConstraints += Layout.constraint(verticalFormat, options: [], metrics: nil, views: views)
			NSLayoutConstraint.activateConstraints(layoutConstraints)
		}
	}
	
	/**
		:name:	isEqual
	*/
	public override func isEqual(object: AnyObject?) -> Bool {
		if let rhs = object as? BasicCardView {
			return tag == rhs.tag
		}
		return false
	}
}

public func <=(lhs: BasicCardView, rhs: BasicCardView) -> Bool {
	return lhs.tag <= rhs.tag
}

public func >=(lhs: BasicCardView, rhs: BasicCardView) -> Bool {
	return lhs.tag >= rhs.tag
}

public func >(lhs: BasicCardView, rhs: BasicCardView) -> Bool {
	return lhs.tag > rhs.tag
}

public func <(lhs: BasicCardView, rhs: BasicCardView) -> Bool {
	return lhs.tag < rhs.tag
}
