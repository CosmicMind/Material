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

public class NavigationBarView: UIView {
	//
	//	:name:	layoutConstraints
	//
	internal lazy var layoutConstraints: Array<NSLayoutConstraint> = Array<NSLayoutConstraint>()
	
	//
	//	:name:	horizontalInset
	//
	public var horizontalInset: CGFloat = MaterialTheme.cardHorizontalInset / 2 {
		didSet {
			prepareNavigation()
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
				t.numberOfLines = 1
				t.lineBreakMode = .ByTruncatingTail
				t.textColor = MaterialTheme.white.color
			} else {
				titleLabelContainer?.removeFromSuperview()
				titleLabelContainer = nil
			}
			prepareNavigation()
		}
	}
	
	/**
		:name:	leftButtonsContainer
	*/
	public private(set) var leftButtonsContainer: UIView?
	
	/**
		:name:	leftButtons
	*/
	public var leftButtons: Array<MaterialButton>? {
		didSet {
			if nil == leftButtons {
				leftButtonsContainer?.removeFromSuperview()
				leftButtonsContainer = nil
			} else if nil == leftButtonsContainer {
				leftButtonsContainer = UIView()
				leftButtonsContainer!.translatesAutoresizingMaskIntoConstraints = false
				leftButtonsContainer!.backgroundColor = MaterialTheme.clear.color
				addSubview(leftButtonsContainer!)
			}
			prepareNavigation()
		}
	}
	
	/**
		:name:	rightButtonsContainer
	*/
	public private(set) var rightButtonsContainer: UIView?
	
	/**
		:name:	rightButtons
	*/
	public var rightButtons: Array<MaterialButton>? {
		didSet {
			if nil == rightButtons {
				rightButtonsContainer?.removeFromSuperview()
				rightButtonsContainer = nil
			} else if nil == rightButtonsContainer {
				rightButtonsContainer = UIView()
				rightButtonsContainer!.translatesAutoresizingMaskIntoConstraints = false
				rightButtonsContainer!.backgroundColor = MaterialTheme.clear.color
				addSubview(rightButtonsContainer!)
			}
			prepareNavigation()
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
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
	}
	
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRect.null)
	}
	
	/**
		:name:	init
	*/
	public convenience init?(titleLabel: UILabel? = nil, leftButtons: Array<MaterialButton>? = nil, rightButtons: Array<MaterialButton>? = nil) {
		self.init(frame: CGRect.null)
		prepareProperties(titleLabel, leftButtons: leftButtons, rightButtons: rightButtons)
	}
	
	//
	//	:name:	prepareProperties
	//
	internal func prepareProperties(titleLabel: UILabel?, leftButtons: Array<MaterialButton>?, rightButtons: Array<MaterialButton>?) {
		self.titleLabel = titleLabel
		self.leftButtons = leftButtons
		self.rightButtons = rightButtons
	}
	
	//
	//	:name:	prepareView
	//
	private func prepareView() {
		translatesAutoresizingMaskIntoConstraints = false
		layer.shadowColor = MaterialTheme.blueGrey.darken4.CGColor
		layer.shadowOffset = CGSizeMake(0.2, 0.2)
		layer.shadowOpacity = 0.5
		layer.shadowRadius = 1
		clipsToBounds = false
	}
	
	//
	//	:name:	prepareNavigation
	//
	internal func prepareNavigation() {
		// clear all constraints
		NSLayoutConstraint.deactivateConstraints(layoutConstraints)
		layoutConstraints.removeAll(keepCapacity: false)
		
		// detect all components and create constraints
		var views: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
		
		// left buttons
		if nil != leftButtons {
			// clear for updated constraints
			leftButtonsContainer!.removeConstraints(leftButtonsContainer!.constraints)
			
			//container
			views["leftButtonsContainer"] = leftButtonsContainer!
			
			// leftButtons
			var hFormat: String = "H:|"
			var buttonViews: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
			for var i: Int = 0, l: Int = leftButtons!.count; i < l; ++i {
				let button: MaterialButton = leftButtons![i]
				leftButtonsContainer!.addSubview(button)
				buttonViews["button\(i)"] = button
				hFormat += "-(horizontalInset)-[button\(i)]"
				Layout.expandToParentVerticallyWithPad(leftButtonsContainer!, child: button)
			}
			leftButtonsContainer!.addConstraints(Layout.constraint(hFormat + "|", options: [], metrics: ["horizontalInset": horizontalInset], views: buttonViews))
		}
		
		// title
		if nil != titleLabel {
			// clear for updated constraints
			titleLabelContainer!.removeConstraints(titleLabelContainer!.constraints)
			
			// container
			views["titleLabelContainer"] = titleLabelContainer!
			
			// common text
			Layout.expandToParentVerticallyWithPad(titleLabelContainer!, child: titleLabel!)
			Layout.expandToParentHorizontallyWithPad(titleLabelContainer!, child: titleLabel!)
		}
		
		// right buttons
		if nil != rightButtons {
			// clear for updated constraints
			rightButtonsContainer!.removeConstraints(rightButtonsContainer!.constraints)
			
			//container
			views["rightButtonsContainer"] = rightButtonsContainer!
			
			// leftButtons
			var hFormat: String = "H:|"
			var buttonViews: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
			for var i: Int = 0, l: Int = rightButtons!.count; i < l; ++i {
				let button: MaterialButton = rightButtons![i]
				rightButtonsContainer!.addSubview(button)
				buttonViews["button\(i)"] = button
				hFormat += "[button\(i)]-(horizontalInset)-"
				Layout.expandToParentVerticallyWithPad(rightButtonsContainer!, child: button)
			}
			rightButtonsContainer!.addConstraints(Layout.constraint(hFormat + "|", options: [], metrics: ["horizontalInset": horizontalInset], views: buttonViews))
		}
		
		if nil != leftButtons && nil != titleLabel {
			layoutConstraints += Layout.constraint("H:|[leftButtonsContainer]-(inset)-[titleLabelContainer]", options: [], metrics: ["inset": horizontalInset], views: ["leftButtonsContainer": leftButtonsContainer!, "titleLabelContainer": titleLabelContainer!])
			Layout.alignFromBottom(self, child: leftButtonsContainer!, bottom: horizontalInset)
			Layout.alignFromBottom(self, child: titleLabelContainer!, bottom: horizontalInset + MaterialTheme.buttonVerticalInset - 1)
		} else if nil != leftButtons {
			layoutConstraints += Layout.constraint("H:|[leftButtonsContainer]", options: [], metrics: ["inset": horizontalInset], views: ["leftButtonsContainer": leftButtonsContainer!])
			Layout.alignFromBottom(self, child: leftButtonsContainer!, bottom: horizontalInset)
		} else if nil != titleLabel {
			layoutConstraints += Layout.constraint("H:|-(inset)-[titleLabelContainer]", options: [], metrics: ["inset": horizontalInset], views: ["titleLabelContainer": titleLabelContainer!])
			Layout.alignFromBottom(self, child: titleLabelContainer!, bottom: horizontalInset + MaterialTheme.buttonVerticalInset - 1)
		}
		
		if nil != rightButtons {
			layoutConstraints += Layout.constraint("H:[rightButtonsContainer]|", options: [], metrics: ["inset": horizontalInset], views: ["rightButtonsContainer": rightButtonsContainer!])
			Layout.alignFromBottom(self, child: rightButtonsContainer!, bottom: horizontalInset)
		}
		
		// constraints
		NSLayoutConstraint.activateConstraints(layoutConstraints)
	}
}