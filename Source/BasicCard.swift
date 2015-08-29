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
import QuartzCore

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
	//	:name:	horizontalSeparator
	//
	public lazy var horizontalSeparator: UIView = UIView()
	
	/**
		:name:	titleLabel
	*/
	public var titleLabel: UILabel? {
		didSet {
			titleLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
			titleLabel!.textColor = MaterialTheme.white.color
			titleLabel!.font = Roboto.regularWithSize(22.0)
			addSubview(titleLabel!)
			prepareCard()
		}
	}
	
	/**
		:name:	detailTextLabel
	*/
	public var detailTextLabel: UILabel? {
		didSet {
			detailTextLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
			detailTextLabel!.textColor = MaterialTheme.white.color
			detailTextLabel!.font = Roboto.lightWithSize(16.0)
			detailTextLabel!.numberOfLines = 0
			detailTextLabel!.lineBreakMode = .ByWordWrapping
			addSubview(detailTextLabel!)
			prepareCard()
		}
	}
	
	/**
		:name:	buttons
	*/
	public var buttons: Array<MaterialButton>? {
		didSet {
			prepareCard()
		}
	}
	
	//
	//	:name:	prepareCard
	//
	internal override func prepareCard() {
		super.prepareCard()
		prepareShadow()
		
		// deactivate and clear all constraints
		NSLayoutConstraint.deactivateConstraints(layoutConstraints)
		layoutConstraints.removeAll(keepCapacity: false)
		
		// detect all components and create constraints
		var verticalFormat: String = "V:|"
		
		// title
		if nil != titleLabel {
			layoutConstraints += Layout.constraint("H:|-(20)-[titleLabel]-(20)-|", options: nil, metrics: nil, views: ["titleLabel": titleLabel!])
			verticalFormat += "-(20)-[titleLabel(22)]"
			views["titleLabel"] = titleLabel!
		}
		
		// details
		if nil != detailTextLabel {
			layoutConstraints += Layout.constraint("H:|-(20)-[detailTextLabel]-(20)-|", options: nil, metrics: nil, views: ["detailTextLabel": detailTextLabel!])
			verticalFormat += "-(20)-[detailTextLabel]"
			views["detailTextLabel"] = detailTextLabel!
		}
		
		if nil != buttons {
			var horizontalFormat: String = "H:|"
			var buttonViews: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
			for var i: Int = 0, l: Int = buttons!.count; i < l; ++i {
				let button: MaterialButton = buttons![i]
				addSubview(button)
				buttonViews["button\(i)"] = button
				views["button\(i)"] = button as AnyObject
				horizontalFormat += "-(20)-[button\(i)]"
				verticalFormat += "-(20)-[button\(i)]"
			}
			layoutConstraints += Layout.constraint(horizontalFormat, options: nil, metrics: nil, views: buttonViews)
		}
		
//		addConstraints(Layout.constraint("H:|-(20)-[detailTextLabel]-(20)-|", options: nil, metrics: nil, views: ["detailTextLabel": detailTextLabel]))
//		addConstraints(Layout.constraint("H:|[horizontalSeparator]|", options: nil, metrics: nil, views: ["horizontalSeparator": horizontalSeparator]))
//		addConstraints(Layout.constraint("H:|-(10)-[cancelButton(80)]-(10)-[otherButton(80)]", options: nil, metrics: nil, views: ["cancelButton": cancelButton, "otherButton": otherButton]))
//		addConstraints(Layout.constraint("V:|-(20)-[titleLabel(22)]-(10)-[detailTextLabel]-(20)-[horizontalSeparator(1)]-(10)-[cancelButton]-(10)-|", options: nil, metrics: nil, views: ["titleLabel": titleLabel, "detailTextLabel": detailTextLabel, "horizontalSeparator": horizontalSeparator, "cancelButton": cancelButton, "otherButton": otherButton]))
//		addConstraints(Layout.constraint("V:|-(20)-[titleLabel(22)]-(10)-[detailTextLabel]-(20)-[horizontalSeparator(1)]-(10)-[otherButton]-(10)-|", options: nil, metrics: nil, views: ["titleLabel": titleLabel, "detailTextLabel": detailTextLabel, "horizontalSeparator": horizontalSeparator, "otherButton": otherButton]))
		
		
		if 0 < layoutConstraints.count {
			verticalFormat += "-(20)-|"
			layoutConstraints += Layout.constraint(verticalFormat, options: nil, metrics: nil, views: views)
			NSLayoutConstraint.activateConstraints(layoutConstraints)
		}
	}
}
