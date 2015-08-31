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

public class BasicCard : MaterialCard {
	//
	//	:name:	layoutConstraints
	//
	internal lazy var layoutConstraints: Array<NSLayoutConstraint> = Array<NSLayoutConstraint>()
	
	//
	//	:name:	views
	//
	internal lazy var views: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
	
	/**
		:name:	verticalSpace
	*/
	public var verticalSpace: CGFloat = 8
	
	/**
		:name:	maximumDetailHeight
	*/
	public var maximumDetailHeight: CGFloat = 144
	
	/**
		:name:	titleLabelContainer
	*/
	public private(set) var titleLabelContainer: UIView?
	
	/**
		:name:	shadow
	*/
	public var shadow: Bool = true {
		didSet {
			false == shadow ? removeShadow() : prepareShadow()
		}
	}
	
	/**
		:name:	titleLabel
	*/
	public var titleLabel: UILabel? {
		didSet {
			// container
			if nil == titleLabelContainer {
				titleLabelContainer = UIView()
				titleLabelContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
				titleLabelContainer!.backgroundColor = MaterialTheme.clear.color
				addSubview(titleLabelContainer!)
			}
			
			// text
			titleLabelContainer!.addSubview(titleLabel!)
			titleLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
			titleLabel!.textColor = MaterialTheme.white.color
			titleLabel!.backgroundColor = MaterialTheme.clear.color
			titleLabel!.font = Roboto.mediumWithSize(18)
			titleLabel!.numberOfLines = 1
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
			// container
			if nil == detailLabelContainer {
				detailLabelContainer = UIView()
				detailLabelContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
				detailLabelContainer!.backgroundColor = MaterialTheme.clear.color
				addSubview(detailLabelContainer!)
			}
			
			// text
			detailLabelContainer!.addSubview(detailLabel!)
			detailLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
			detailLabel!.textColor = MaterialTheme.white.color
			detailLabel!.backgroundColor = MaterialTheme.clear.color
			detailLabel!.font = Roboto.lightWithSize(12)
			detailLabel!.numberOfLines = 0
			detailLabel!.lineBreakMode = .ByWordWrapping
			prepareCard()
		}
	}
	
	/**
		:name:	divider
	*/
	public var divider: UIView? {
		didSet {
			divider!.setTranslatesAutoresizingMaskIntoConstraints(false)
			divider!.backgroundColor = MaterialTheme.blueGrey.color
			addSubview(divider!)
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
			if nil == buttonsContainer {
				buttonsContainer = UIView()
				buttonsContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
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
			if nil == buttonsContainer {
				buttonsContainer = UIView()
				buttonsContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
				buttonsContainer!.backgroundColor = MaterialTheme.clear.color
				addSubview(buttonsContainer!)
			}
			prepareCard()
		}
	}
	
	//
	//	:name:	prepareView
	//
	internal override func prepareView() {
		super.prepareView()
		prepareShadow()
		backgroundColor = MaterialTheme.blueGrey.darken1
	}
	
	//
	//	:name:	prepareCard
	//
	internal override func prepareCard() {
		super.prepareCard()
		
		// deactivate and clear all constraints
		NSLayoutConstraint.deactivateConstraints(layoutConstraints)
		layoutConstraints.removeAll(keepCapacity: false)
		
		// detect all components and create constraints
		var verticalFormat: String = "V:|"
		
		// title
		if nil != titleLabelContainer && nil != titleLabel {
			// container
			layoutConstraints += Layout.constraint("H:|[titleLabelContainer]|", options: nil, metrics: nil, views: ["titleLabelContainer": titleLabelContainer!])
			verticalFormat += "[titleLabelContainer]"
			views["titleLabelContainer"] = titleLabelContainer!
			
			// text
			titleLabelContainer!.addConstraints(Layout.constraint("H:|-(verticalSpace)-[titleLabel]-(verticalSpace)-|", options: nil, metrics: ["verticalSpace": verticalSpace], views: ["titleLabel": titleLabel!]))
			titleLabelContainer!.addConstraints(Layout.constraint("V:|-(verticalSpace)-[titleLabel(height)]-(verticalSpace)-|", options: nil, metrics: ["verticalSpace": verticalSpace, "height": titleLabel!.font.pointSize], views: ["titleLabel": titleLabel!]))
		}
		
		// detail
		if nil != detailLabelContainer && nil != detailLabel {
			// container
			layoutConstraints += Layout.constraint("H:|[detailLabelContainer]|", options: nil, metrics: nil, views: ["detailLabelContainer": detailLabelContainer!])
			verticalFormat += "[detailLabelContainer]"
			views["detailLabelContainer"] = detailLabelContainer!
			
			// text
			detailLabelContainer!.addConstraints(Layout.constraint("H:|-(verticalSpace)-[detailLabel]-(verticalSpace)-|", options: nil, metrics: ["verticalSpace": verticalSpace], views: ["detailLabel": detailLabel!]))
			detailLabelContainer!.addConstraints(Layout.constraint("V:|-(verticalSpace)-[detailLabel(<=maximumDetailHeight)]-(verticalSpace)-|", options: nil, metrics: ["verticalSpace": verticalSpace, "maximumDetailHeight": maximumDetailHeight], views: ["detailLabel": detailLabel!]))
		}
		
		if nil != buttonsContainer && (nil != leftButtons || nil != rightButtons) {
			// divider
			if nil != divider {
				layoutConstraints += Layout.constraint("H:|[divider]|", options: nil, metrics: nil, views: ["divider": divider!])
				views["divider"] = divider!
				verticalFormat += "[divider(1)]"
			}
			
			//container
			layoutConstraints += Layout.constraint("H:|[buttonsContainer]|", options: nil, metrics: nil, views: ["buttonsContainer": buttonsContainer!])
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
					horizontalFormat += "-(verticalSpace)-[button\(i)]"
					Layout.expandToParentVerticallyWithPad(buttonsContainer!, child: button, top: verticalSpace, bottom: verticalSpace)
				}
				buttonsContainer!.addConstraints(Layout.constraint(horizontalFormat, options: nil, metrics: ["verticalSpace": verticalSpace], views: buttonViews))
			}
			
			// rightButtons
			if nil != rightButtons {
				var horizontalFormat: String = "H:"
				var buttonViews: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				for var i: Int = 0, l: Int = rightButtons!.count; i < l; ++i {
					let button: MaterialButton = rightButtons![i]
					buttonsContainer!.addSubview(button)
					buttonViews["button\(i)"] = button
					horizontalFormat += "[button\(i)]-(verticalSpace)-"
					Layout.expandToParentVerticallyWithPad(buttonsContainer!, child: button, top: verticalSpace, bottom: verticalSpace)
				}
				buttonsContainer!.addConstraints(Layout.constraint(horizontalFormat + "|", options: nil, metrics: ["verticalSpace": verticalSpace], views: buttonViews))
			}
		}
		
		verticalFormat += "|"
		
		// combine constraints
		if 0 < layoutConstraints.count {
			layoutConstraints += Layout.constraint(verticalFormat, options: nil, metrics: nil, views: views)
			NSLayoutConstraint.activateConstraints(layoutConstraints)
		}
	}
}
