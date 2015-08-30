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

public class ImageCard : MaterialCard {
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
		:name:	imageView
	*/
	public var imageView: UIImageView? {
		didSet {
			imageView!.setTranslatesAutoresizingMaskIntoConstraints(false)
			imageView!.contentMode = .ScaleAspectFill
			imageView!.userInteractionEnabled = false
			imageView!.clipsToBounds = true
			insertSubview(imageView!, belowSubview: backgroundColorView)
			if nil != titleLabel {
				titleLabel!.removeFromSuperview()
				imageView!.addSubview(titleLabel!)
			}
			prepareCard()
		}
	}
	
	/**
		:name:	titleLabel
	*/
	public var titleLabel: UILabel? {
		didSet {
			titleLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
			titleLabel!.textColor = MaterialTheme.white.color
			titleLabel!.font = Roboto.regularWithSize(22.0)
			if nil == imageView {
				addSubview(titleLabel!)
			} else {
				imageView!.addSubview(titleLabel!)
			}
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
			detailTextLabel!.font = Roboto.lightWithSize(16.0)
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
		
		if nil != imageView {
			layoutConstraints += Layout.constraint("H:|[imageView]|", options: nil, metrics: nil, views: ["imageView": imageView!])
			verticalFormat += "[imageView(200)]"
			views["imageView"] = imageView!
		}
		
		// title
		if nil != titleLabel {
			if nil == imageView {
				layoutConstraints += Layout.constraint("H:|-(16)-[titleLabel]-(16)-|", options: nil, metrics: nil, views: ["titleLabel": titleLabel!])
				verticalFormat += "-(16)-[titleLabel(22)]"
			} else {
				layoutConstraints += Layout.constraint("H:[titleLabel]-(16)-|", options: nil, metrics: nil, views: ["titleLabel": titleLabel!])
				Layout.alignFromBottomLeft(imageView!, child: titleLabel!, bottom: 16, left: 16)
			}
			views["titleLabel"] = titleLabel!
		}
		
		// details
		if nil != detailTextContainer && nil != detailTextLabel {
			// container
			layoutConstraints += Layout.constraint("H:|[detailTextContainer]|", options: nil, metrics: nil, views: ["detailTextContainer": detailTextContainer!])
			verticalFormat += "-(0)-[detailTextContainer]"
			views["detailTextContainer"] = detailTextContainer!
			
			// text
			layoutConstraints += Layout.constraint("H:|-(16)-[detailTextLabel]-(16)-|", options: nil, metrics: nil, views: ["detailTextLabel": detailTextLabel!])
			layoutConstraints += Layout.constraint("V:|-(16)-[detailTextLabel(<=128)]-(16)-|", options: nil, metrics: nil, views: ["detailTextLabel": detailTextLabel!])
			views["detailTextLabel"] = detailTextLabel!
		}
		
		if nil != buttons && nil != buttonsContainer {
			// divider
			if nil != divider {
				layoutConstraints += Layout.constraint("H:|[divider]|", options: nil, metrics: nil, views: ["divider": divider!])
				views["divider"] = divider!
				verticalFormat += "-(0)-[divider(1)]"
			}
			
			//container
			layoutConstraints += Layout.constraint("H:|[buttonsContainer]|", options: nil, metrics: nil, views: ["buttonsContainer": buttonsContainer!])
			verticalFormat += "-(0)-[buttonsContainer]|"
			views["buttonsContainer"] = buttonsContainer!
			
			// buttons
			var horizontalFormat: String = "H:|"
			var buttonViews: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
			for var i: Int = 0, l: Int = buttons!.count; i < l; ++i {
				let button: MaterialButton = buttons![i]
				buttonsContainer!.addSubview(button)
				buttonViews["button\(i)"] = button
				views["button\(i)"] = button as AnyObject
				horizontalFormat += "-(8)-[button\(i)]"
				layoutConstraints += Layout.constraint("V:|-(8)-[button\(i)]-(8)-|", options: nil, metrics: nil, views: views)
			}
			layoutConstraints += Layout.constraint(horizontalFormat, options: nil, metrics: nil, views: buttonViews)
			
		} else {
			verticalFormat += "|"
		}
		
		// combine constraints
		if 0 < layoutConstraints.count {
			layoutConstraints += Layout.constraint(verticalFormat, options: nil, metrics: nil, views: views)
			NSLayoutConstraint.activateConstraints(layoutConstraints)
		}
	}
}
