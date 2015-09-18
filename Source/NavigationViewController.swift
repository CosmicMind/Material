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
	//	:name:	titleLabel
	//
	public var titleLabel: UILabel? {
		didSet {
			if let v = titleLabel {
				view.addSubview(v)
			}
		}
	}
	
	/**
		:name:	leftButton
	*/
	public var leftButton: FlatButton? {
		didSet {
			if let v = leftButton {
				view.addSubview(v)
			}
		}
	}
	
	/**
		:name:	rightButton
	*/
	public var rightButton: FlatButton? {
		didSet {
			if let v = rightButton {
				view.addSubview(v)
			}
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
	
	//
	//	:name:	viewDidLoad
	//
	public override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
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
}