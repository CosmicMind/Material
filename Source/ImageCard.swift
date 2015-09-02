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

public class ImageCard : MaterialCard, Comparable, Equatable {
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
		:name:	horizontalSpace
	*/
	public var horizontalSpace: CGFloat = 8
	
	/**
		:name:	shadow
	*/
	public var shadow: Bool = true {
		didSet {
			false == shadow ? removeShadow() : prepareShadow()
		}
	}
	
	/**
		:name:	maximumImageViewHeight
	*/
	public var maximumImageViewHeight: CGFloat = 200
	
	/**
		:name:	imageViewContainer
	*/
	public private(set) var imageViewContainer: UIView?
	
	/**
		:name:	imageView
	*/
	public var imageView: UIImageView? {
		didSet {
			if let t = imageView {
				// container
				if nil == imageViewContainer {
					imageViewContainer = UIView()
					imageViewContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
					imageViewContainer!.backgroundColor = MaterialTheme.clear.color
					insertSubview(imageViewContainer!, belowSubview: backgroundColorView)
				}
				
				// text
				imageViewContainer!.addSubview(t)
				t.setTranslatesAutoresizingMaskIntoConstraints(false)
				t.contentMode = .ScaleAspectFill
				t.userInteractionEnabled = false
				t.clipsToBounds = true
				if nil != titleLabel {
					titleLabelContainer!.removeFromSuperview()
					imageViewContainer!.addSubview(titleLabelContainer!)
				}
				prepareCard()
			} else {
				imageViewContainer?.removeFromSuperview()
			}
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
					titleLabelContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
					titleLabelContainer!.backgroundColor = MaterialTheme.clear.color
					addSubview(titleLabelContainer!)
				}
				
				// text
				titleLabelContainer!.addSubview(t)
				t.setTranslatesAutoresizingMaskIntoConstraints(false)
				t.textColor = MaterialTheme.white.color
				t.backgroundColor = MaterialTheme.clear.color
				t.font = Roboto.mediumWithSize(18)
				t.numberOfLines = 1
				if nil == imageView {
					titleLabelContainer!.addSubview(t)
				} else {
					titleLabelContainer!.removeFromSuperview()
					imageViewContainer!.addSubview(titleLabelContainer!)
				}
				prepareCard()
			} else {
				titleLabelContainer?.removeFromSuperview()
			}
		}
	}
	
	/**
		:name:	maximumDetailLabelHeight
	*/
	public var maximumDetailLabelHeight: CGFloat = 144
	
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
					detailLabelContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
					detailLabelContainer!.backgroundColor = MaterialTheme.white.color
					addSubview(detailLabelContainer!)
				}
				
				// text
				detailLabelContainer!.addSubview(l)
				l.setTranslatesAutoresizingMaskIntoConstraints(false)
				l.textColor = MaterialTheme.black.color
				l.backgroundColor = MaterialTheme.clear.color
				l.font = Roboto.lightWithSize(16)
				l.numberOfLines = 0
				l.lineBreakMode = .ByWordWrapping
				prepareCard()
			} else {
				detailLabelContainer?.removeFromSuperview()
			}
		}
	}
	
	/**
		:name:	divider
	*/
	public var divider: UIView? {
		didSet {
			if let d = divider {
				d.setTranslatesAutoresizingMaskIntoConstraints(false)
				d.backgroundColor = MaterialTheme.blueGrey.lighten5
				addSubview(d)
				prepareCard()
			} else {
				divider?.removeFromSuperview()
			}
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
			if let b = leftButtons {
				if nil == buttonsContainer {
					buttonsContainer = UIView()
					buttonsContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
					buttonsContainer!.backgroundColor = MaterialTheme.white.color
					addSubview(buttonsContainer!)
				}
				prepareCard()
			} else {
				buttonsContainer?.removeFromSuperview()
			}
		}
	}
	
	/**
		:name:	rightButtons
	*/
	public var rightButtons: Array<MaterialButton>? {
		didSet {
			if let b = rightButtons {
				if nil == buttonsContainer {
					buttonsContainer = UIView()
					buttonsContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
					buttonsContainer!.backgroundColor = MaterialTheme.white.color
					addSubview(buttonsContainer!)
				}
				prepareCard()
			} else {
				buttonsContainer?.removeFromSuperview()
			}
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
		
		// image
		if nil != imageViewContainer && nil != imageView {
			// container
			layoutConstraints += Layout.constraint("H:|[imageViewContainer]|", options: nil, metrics: nil, views: ["imageViewContainer": imageViewContainer!])
			verticalFormat += "[imageViewContainer]"
			views["imageViewContainer"] = imageViewContainer!
			
			// text
			imageViewContainer!.addConstraints(Layout.constraint("H:|[imageView]|", options: nil, metrics: nil, views: ["imageView": imageView!]))
			imageViewContainer!.addConstraints(Layout.constraint("V:|[imageView(maximumImageViewHeight)]|", options: nil, metrics: ["maximumImageViewHeight": maximumImageViewHeight], views: ["imageView": imageView!]))
		}
		
		// title
		if nil != titleLabelContainer && nil != titleLabel {
			if nil == imageView {
				// container
				layoutConstraints += Layout.constraint("H:|[titleLabelContainer]|", options: nil, metrics: nil, views: ["titleLabelContainer": titleLabelContainer!])
				verticalFormat += "[titleLabelContainer]"
				views["titleLabelContainer"] = titleLabelContainer!
				
				// text
				titleLabelContainer!.addConstraints(Layout.constraint("H:|-(horizontalSpace)-[titleLabel]-(horizontalSpace)-|", options: nil, metrics: ["horizontalSpace": horizontalSpace], views: ["titleLabel": titleLabel!]))
				titleLabelContainer!.addConstraints(Layout.constraint("V:|-(verticalSpace)-[titleLabel(height)]-(verticalSpace)-|", options: nil, metrics: ["verticalSpace": verticalSpace, "height": titleLabel!.font.pointSize + verticalSpace], views: ["titleLabel": titleLabel!]))
			} else {
				//container
				Layout.expandToParent(imageViewContainer!, child: titleLabelContainer!)
				
				// text
				titleLabelContainer!.addConstraints(Layout.constraint("H:|-(horizontalSpace)-[titleLabel]-(horizontalSpace)-|", options: nil, metrics: ["horizontalSpace": horizontalSpace], views: ["titleLabel": titleLabel!]))
				titleLabelContainer!.addConstraints(Layout.constraint("V:[titleLabel(height)]-(verticalSpace)-|", options: nil, metrics: ["verticalSpace": verticalSpace, "height": titleLabel!.font.pointSize + verticalSpace], views: ["titleLabel": titleLabel!]))
			}
		}
		
		// detail
		if nil != detailLabelContainer && nil != detailLabel {
			// container
			layoutConstraints += Layout.constraint("H:|[detailLabelContainer]|", options: nil, metrics: nil, views: ["detailLabelContainer": detailLabelContainer!])
			verticalFormat += "[detailLabelContainer]"
			views["detailLabelContainer"] = detailLabelContainer!
			
			// text
			detailLabelContainer!.addConstraints(Layout.constraint("H:|-(horizontalSpace)-[detailLabel]-(horizontalSpace)-|", options: nil, metrics: ["horizontalSpace": horizontalSpace], views: ["detailLabel": detailLabel!]))
			detailLabelContainer!.addConstraints(Layout.constraint("V:|-(verticalSpace)-[detailLabel(<=maximumDetailLabelHeight)]-(verticalSpace)-|", options: nil, metrics: ["verticalSpace": verticalSpace, "maximumDetailLabelHeight": maximumDetailLabelHeight], views: ["detailLabel": detailLabel!]))
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
					horizontalFormat += "-(horizontalSpace)-[button\(i)]"
					Layout.expandToParentVerticallyWithPad(buttonsContainer!, child: button, top: verticalSpace, bottom: verticalSpace)
				}
				buttonsContainer!.addConstraints(Layout.constraint(horizontalFormat, options: nil, metrics: ["horizontalSpace": horizontalSpace], views: buttonViews))
			}
			
			// rightButtons
			if nil != rightButtons {
				var horizontalFormat: String = "H:"
				var buttonViews: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				for var i: Int = 0, l: Int = rightButtons!.count; i < l; ++i {
					let button: MaterialButton = rightButtons![i]
					buttonsContainer!.addSubview(button)
					buttonViews["button\(i)"] = button
					horizontalFormat += "[button\(i)]-(horizontalSpace)-"
					Layout.expandToParentVerticallyWithPad(buttonsContainer!, child: button, top: verticalSpace, bottom: verticalSpace)
				}
				buttonsContainer!.addConstraints(Layout.constraint(horizontalFormat + "|", options: nil, metrics: ["horizontalSpace": horizontalSpace], views: buttonViews))
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

public func ==(lhs: ImageCard, rhs: ImageCard) -> Bool {
	return lhs.tag == rhs.tag
}

public func <=(lhs: ImageCard, rhs: ImageCard) -> Bool {
	return lhs.tag <= rhs.tag
}

public func >=(lhs: ImageCard, rhs: ImageCard) -> Bool {
	return lhs.tag >= rhs.tag
}

public func >(lhs: ImageCard, rhs: ImageCard) -> Bool {
	return lhs.tag > rhs.tag
}

public func <(lhs: ImageCard, rhs: ImageCard) -> Bool {
	return lhs.tag < rhs.tag
}
