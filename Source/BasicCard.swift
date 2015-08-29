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
	
	/**
		:name:	buttons
	*/
	public var buttons: Array<MaterialButton>?
	
	/**
		:name:	titleLabel
	*/
	public var titleLabel: UILabel? {
		didSet {
			titleLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
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
			detailTextLabel!.font = Roboto.lightWithSize(16.0)
			detailTextLabel!.numberOfLines = 0
			detailTextLabel!.lineBreakMode = .ByWordWrapping
			addSubview(detailTextLabel!)
			prepareCard()
		}
	}
	
    public var horizontalSeparator: UIView?
    
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
	
//    
//    private func prepareDetailTextLabel() {
//        detailTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
//        detailTextLabel.font = Roboto.lightWithSize(16.0)
//        detailTextLabel.textColor = UIColor.whiteColor()
//        detailTextLabel.text = "I am a very simple card. I am good at containing small bits of information. I am convenient because I require little markup to use effectively."
//        detailTextLabel.numberOfLines = 0
//        detailTextLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        addSubview(detailTextLabel)
//    }
//    
//    private func prepareHorizontalSeparator() {
//        horizontalSeparator.setTranslatesAutoresizingMaskIntoConstraints(false)
//        horizontalSeparator.backgroundColor = UIColor.whiteColor()
//        horizontalSeparator.alpha = 0.2
//        addSubview(horizontalSeparator)
//    }
//	
//    private func prepareCancelButton() {
//		cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
//        cancelButton.setTitle("Cancel", forState: .Normal)
//        cancelButton.setTitleColor(buttonColor, forState: .Normal)
//        cancelButton.pulseColor = buttonColor
//        addSubview(cancelButton)
//    }
//    
//    private func prepareOtherButton() {
//		otherButton.setTranslatesAutoresizingMaskIntoConstraints(false)
//        otherButton.setTitle("Confirm", forState: .Normal)
//		otherButton.setTitleColor(buttonColor, forState: .Normal)
//        otherButton.pulseColor = buttonColor
//        addSubview(otherButton)
//    }
}
