//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io> and other CosmicMind contributors
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

public class TextField : UITextField {
	/**
	:name:	bottomBorderLayer
	*/
	public private(set) lazy var bottomBorderLayer: MaterialLayer = MaterialLayer()
	
	/**
	:name:	titleLabel
	*/
	public var titleLabel: UILabel? {
		didSet {
			prepareTitleLabel()
		}
	}
	
	/**
	:name:	bottomBorderEnabled
	*/
	public var bottomBorderEnabled: Bool = true
	
	/**
	:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepareView()
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
		self.init(frame: CGRectNull)
	}
	
	/**
	:name:	layoutSubviews
	*/
	public override func layoutSubviews() {
		super.layoutSubviews()
		bottomBorderLayer.frame = CGRectMake(0, bounds.height - bottomBorderLayer.height, bounds.width, bottomBorderLayer.height)
	}
	
	/**
	:name:	prepareView
	*/
	public func prepareView() {
		prepareBottomBorderLayer()
	}
	
	/**
	:name:	prepareBottomBorderLayer
	*/
	private func prepareBottomBorderLayer() {
		bottomBorderLayer.frame = CGRectMake(0, bounds.height - 1, bounds.width, 1)
		bottomBorderLayer.backgroundColor = MaterialColor.grey.lighten3.CGColor
		layer.addSublayer(bottomBorderLayer)
	}
	
	/**
	:name:	prepareTitleLabel
	*/
	private func prepareTitleLabel() {
		if let v: UILabel = titleLabel {
			v.frame = bounds
			v.text = placeholder
			v.textColor = textColor
			addSubview(v)
		}
	}
}