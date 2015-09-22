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

public class NavigationViewController: UIViewController {
	//
	//	:name:	layoutConstraints
	//
	internal lazy var layoutConstraints: Array<NSLayoutConstraint> = Array<NSLayoutConstraint>()
	
	/**
		:name:	maximumTitleLabelHeight
	*/
	public var maximumTitleLabelHeight: CGFloat = 0 {
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
					view.addSubview(titleLabelContainer!)
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
				view.addSubview(leftButtonsContainer!)
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
				view.addSubview(rightButtonsContainer!)
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
	public init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	/**
		:name:	init
	*/
	public init?(titleLabel: UILabel? = nil, leftButtons: Array<MaterialButton>? = nil, rightButtons: Array<MaterialButton>? = nil) {
		super.init(nibName: nil, bundle: nil)
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
	//	:name:	viewDidLoad
	//
	public override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareNavigation()
	}
	
	/**
		:name:	viewWillAppear
	*/
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	/**
		:name:	viewDidDisappear
	*/
	public override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	//
	//	:name:	prepareView
	//
	private func prepareView() {
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.shadowColor = MaterialTheme.blueGrey.darken4.CGColor
		view.layer.shadowOffset = CGSizeMake(0.2, 0.2)
		view.layer.shadowOpacity = 0.5
		view.layer.shadowRadius = 1
		view.clipsToBounds = false
	}
	
	//
	//	:name:	prepareNavigation
	//
	internal func prepareNavigation() {
		// clear all constraints
		NSLayoutConstraint.deactivateConstraints(layoutConstraints)
		layoutConstraints.removeAll(keepCapacity: false)
		
		// detect all components and create constraints
		var verticalFormat: String = "V:|"
		var horizontalFormat: String = "H:|"
		var views: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
		
		// left buttons
		if nil != leftButtonsContainer && (nil != leftButtons) {
			// clear for updated constraints
			leftButtonsContainer!.removeConstraints(leftButtonsContainer!.constraints)
			
			//container
			verticalFormat += "[leftButtonsContainer]"
			horizontalFormat += "|[leftButtonsContainer]"
			views["leftButtonsContainer"] = leftButtonsContainer!
			
			// leftButtons
			var hFormat: String = "H:|"
			var buttonViews: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
			for var i: Int = 0, l: Int = leftButtons!.count; i < l; ++i {
				let button: MaterialButton = leftButtons![i]
				leftButtonsContainer!.addSubview(button)
				buttonViews["button\(i)"] = button
				hFormat += "-(buttonLeftInset)-[button\(i)]"
				Layout.expandToParentVerticallyWithPad(leftButtonsContainer!, child: button, top: 8, bottom: 8)
			}
			leftButtonsContainer!.addConstraints(Layout.constraint(hFormat, options: [], metrics: ["buttonLeftInset": 8], views: buttonViews))
		}
		
		// title
		if nil != titleLabelContainer && nil != titleLabel {
			// clear for updated constraints
			titleLabelContainer!.removeConstraints(titleLabelContainer!.constraints)
			
			// container
			verticalFormat += "[titleLabelContainer]"
			horizontalFormat += "[titleLabelContainer]"
			views["titleLabelContainer"] = titleLabelContainer!
			
			// common text
			if 0 == maximumTitleLabelHeight {
				Layout.expandToParentWithPad(titleLabelContainer!, child: titleLabel!, top: 8, left: 8, bottom: 8, right: 8)
			} else {
				Layout.expandToParentHorizontallyWithPad(titleLabelContainer!, child: titleLabel!, left: 8, right: 8)
				titleLabelContainer!.addConstraints(Layout.constraint("V:|-(titleLabelTopInset)-[titleLabel(<=maximumTitleLabelHeight)]-(titleLabelBottomInset)-|", options: [], metrics: ["titleLabelTopInset": 8, "titleLabelBottomInset": 8, "maximumTitleLabelHeight": maximumTitleLabelHeight], views: ["titleLabel": titleLabel!]))
			}
		}
		
		// left buttons
		if nil != rightButtonsContainer && (nil != leftButtons) {
			// clear for updated constraints
			rightButtonsContainer!.removeConstraints(rightButtonsContainer!.constraints)
			
			//container
			verticalFormat += "[rightButtonsContainer]"
			horizontalFormat += "[rightButtonsContainer]|"
			views["rightButtonsContainer"] = rightButtonsContainer!
			
			// leftButtons
			var hFormat: String = "H:"
			var buttonViews: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
			for var i: Int = 0, l: Int = leftButtons!.count; i < l; ++i {
				let button: MaterialButton = leftButtons![i]
				rightButtonsContainer!.addSubview(button)
				buttonViews["button\(i)"] = button
				hFormat += "[button\(i)]-(buttonLeftInset)-"
				Layout.expandToParentVerticallyWithPad(rightButtonsContainer!, child: button, top: 8, bottom: 8)
			}
			rightButtonsContainer!.addConstraints(Layout.constraint(hFormat + "|", options: [], metrics: ["buttonLeftInset": 8], views: buttonViews))
		}
		
		verticalFormat += "|"
		
		// combine constraints
		if 0 < layoutConstraints.count {
			layoutConstraints += Layout.constraint(verticalFormat, options: [], metrics: nil, views: views)
			layoutConstraints += Layout.constraint(horizontalFormat, options: [], metrics: nil, views: views)
			NSLayoutConstraint.activateConstraints(layoutConstraints)
		}
	}
}