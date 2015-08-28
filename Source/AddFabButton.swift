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

public class AddFabButton : FabButton {
	/**
		:name:	lineWidth
	*/
	public var lineWidth: CGFloat = 2
	
	//
	//	:name:	verticalLine
	//
	private var verticalLine: UIView!
	
	//
	//	:name:	horizontalLine
	//
	private var horizontalLine: UIView!
	
	//
	//	:name:	prepareButton
	//
	public override func prepareButton() {
		super.prepareButton()
		prepareVerticalLine()
		prepareHorizontalLine()
	}
	
	//
	//	:name:	prepareVerticalLine
	//
	private func prepareVerticalLine() {
		verticalLine = UIView(frame: CGRectMake(0, 0, lineWidth, CGRectGetHeight(backgroundColorView.frame) / 3))
		verticalLine.backgroundColor = MaterialTheme.white.color
		verticalLine.center = backgroundColorView.center
		backgroundColorView.addSubview(verticalLine)
	}
	
	//
	//	:name:	prepareHorizontalLine
	//
	private func prepareHorizontalLine() {
		horizontalLine = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(backgroundColorView.frame) / 3, lineWidth))
		horizontalLine.backgroundColor = MaterialTheme.white.color
		horizontalLine.center = backgroundColorView.center
		backgroundColorView.addSubview(horizontalLine)
	}
}
