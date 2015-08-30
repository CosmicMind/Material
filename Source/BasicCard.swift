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
	
	//
	//	:name:	detailTextContainer
	//
	internal var detailTextContainer: UIView?
	
	//
	//	:name:	buttonsContainer
	//
	internal var buttonsContainer: UIView?
	
	/**
	:name:	titleLabel
	*/
	public var titleLabel: UILabel? {
		didSet {
			titleLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
			titleLabel!.textColor = MaterialTheme.white.color
			titleLabel!.font = Roboto.regularWithSize(24)
			addSubview(titleLabel!)
			prepareCard()
		}
	}
	
	/**
	:name:	detailTextLabel
	*/
	public var detailTextLabel: UILabel? {
		didSet {
			// container
			if nil == detailTextContainer {
				detailTextContainer = UIView()
				detailTextContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
				detailTextContainer!.backgroundColor = MaterialTheme.white.color
				addSubview(detailTextContainer!)
			}
			
			// text
			detailTextContainer!.addSubview(detailTextLabel!)
			detailTextLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
			detailTextLabel!.textColor = MaterialTheme.black.color
			detailTextLabel!.font = Roboto.lightWithSize(14)
			detailTextLabel!.numberOfLines = 0
			detailTextLabel!.lineBreakMode = .ByWordWrapping
			prepareCard()
		}
	}
	
	/**
	:name:	divider
	*/
	public var divider: UIView? {
		didSet {
			divider!.setTranslatesAutoresizingMaskIntoConstraints(false)
			divider!.backgroundColor = MaterialTheme.blueGrey.lighten4
			addSubview(divider!)
			prepareCard()
		}
	}
	
	/**
	:name:	buttons
	*/
	public var buttons: Array<MaterialButton>? {
		didSet {
			if nil == buttonsContainer {
				buttonsContainer = UIView()
				buttonsContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
				buttonsContainer!.backgroundColor = MaterialTheme.white.color
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
		backgroundColor = MaterialTheme.clear.color
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
		if nil != titleLabel {
			layoutConstraints += Layout.constraint("H:|-(16)-[titleLabel]-(16)-|", options: nil, metrics: nil, views: ["titleLabel": titleLabel!])
			verticalFormat += "-(16)-[titleLabel(24)]"
			views["titleLabel"] = titleLabel!
		}
		
		// details
		if nil != detailTextContainer && nil != detailTextLabel {
			// container
			layoutConstraints += Layout.constraint("H:|[detailTextContainer]|", options: nil, metrics: nil, views: ["detailTextContainer": detailTextContainer!])
			verticalFormat += "[detailTextContainer]"
			views["detailTextContainer"] = detailTextContainer!
			
			// text
			detailTextContainer!.addConstraints(Layout.constraint("H:|-(16)-[detailTextLabel]-(16)-|", options: nil, metrics: nil, views: ["detailTextLabel": detailTextLabel!]))
			detailTextContainer!.addConstraints(Layout.constraint("V:|-(16)-[detailTextLabel(<=128)]|", options: nil, metrics: nil, views: ["detailTextLabel": detailTextLabel!]))
		}
		
		if nil != buttons && nil != buttonsContainer {
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
			
			// buttons
			var horizontalFormat: String = "H:|"
			var buttonViews: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
			for var i: Int = 0, l: Int = buttons!.count; i < l; ++i {
				let button: MaterialButton = buttons![i]
				buttonsContainer!.addSubview(button)
				buttonViews["button\(i)"] = button
				horizontalFormat += "-(8)-[button\(i)]"
				Layout.expandToParentVerticallyWithPad(buttonsContainer!, child: button, top: 8, bottom: 8)
				buttonsContainer!.addConstraints(Layout.constraint(horizontalFormat, options: nil, metrics: nil, views: buttonViews))
			}
			layoutConstraints += Layout.constraint(horizontalFormat, options: nil, metrics: nil, views: buttonViews)
		}
		
		verticalFormat += "|"
		
		// combine constraints
		if 0 < layoutConstraints.count {
			layoutConstraints += Layout.constraint(verticalFormat, options: nil, metrics: nil, views: views)
			NSLayoutConstraint.activateConstraints(layoutConstraints)
		}
	}
}
