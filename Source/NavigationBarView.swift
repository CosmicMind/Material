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

public class NavigationBarView: MaterialView {
	//
	//	:name:	isLoading
	//
	internal lazy var isLoading: Bool = false
	
	/**
		:name:	statusBarStyle
	*/
	public var statusBarStyle: MaterialStatusBarStyle! {
		didSet {
			UIApplication.sharedApplication().setStatusBarStyle(.LightContent == statusBarStyle ? .LightContent : .Default, animated: true)
		}
	}
	
	/**
		:name:	contentInsets
	*/
	public var contentInsets: MaterialInsets? {
		didSet {
			contentInsetsRef = MaterialInsetsToValue(nil == contentInsets ? .Inset0 : contentInsets!)
		}
	}
	
	/**
		:name:	contentInsetsRef
	*/
	public var contentInsetsRef: MaterialInsetsType! {
		didSet {
			reloadView()
		}
	}
	
	/**
		:name:	titleLabel
	*/
	public var titleLabel: UILabel? {
		didSet {
			if let v = titleLabel {
				v.translatesAutoresizingMaskIntoConstraints = false
				addSubview(v)
			}
			reloadView()
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
	}
	
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectMake(MaterialTheme.navigation.x, MaterialTheme.navigation.y, MaterialTheme.navigation.width, MaterialTheme.navigation.height))
	}
	
	/**
		:name:	init
	*/
	public convenience init?(titleLabel: UILabel? = nil) {
		self.init(frame: CGRectMake(MaterialTheme.navigation.x, MaterialTheme.navigation.y, MaterialTheme.navigation.width, MaterialTheme.navigation.height))
		self.prepareProperties(titleLabel)
	}
	
	/**
		:name:	reloadView
	*/
	public func reloadView() {
		if false == isLoading && nil != contentInsetsRef {
			isLoading = true
			
			// clear constraints so new ones do not conflict
			removeConstraints(constraints)
			
			if nil != titleLabel {
				MaterialLayout.alignToParentHorizontallyWithPad(self, child: titleLabel!, left: contentInsetsRef!.left, right: contentInsetsRef!.right)
				MaterialLayout.alignFromBottom(self, child: titleLabel!, bottom: contentInsetsRef!.bottom)
			}
		
			isLoading = false
		}
	}
	
	//
	//	:name:	prepareProperties
	//
	internal func prepareProperties(titleLabel: UILabel?) {
		self.titleLabel = titleLabel
	}
	
	//
	//	:name:	prepareView
	//
	internal override func prepareView() {
		super.prepareView()
		userInteractionEnabled = MaterialTheme.navigation.userInteractionEnabled
		backgroundColor = MaterialTheme.navigation.backgroudColor
		statusBarStyle = MaterialTheme.navigation.statusBarStyle
		contentInsets = .Inset3
		
		contentsRect = MaterialTheme.navigation.contentsRect
		contentsCenter = MaterialTheme.navigation.contentsCenter
		contentsScale = MaterialTheme.navigation.contentsScale
		contentsGravity = MaterialTheme.navigation.contentsGravity
		shadowDepth = MaterialTheme.navigation.shadowDepth
		shadowColor = MaterialTheme.navigation.shadowColor
		zPosition = MaterialTheme.navigation.zPosition
		masksToBounds = MaterialTheme.navigation.masksToBounds
		cornerRadius = MaterialTheme.navigation.cornerRadius
		borderWidth = MaterialTheme.navigation.borderWidth
		borderColor = MaterialTheme.navigation.bordercolor
	}
}
