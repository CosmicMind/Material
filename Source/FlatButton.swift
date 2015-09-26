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

public class FlatButton : MaterialButton {
	//
	//	:name:	prepareView
	//
	internal override func prepareView() {
		super.prepareView()
		setTitleColor(MaterialTheme.button.flat.titleLabelColorForNormalState, forState: .Normal)
		titleLabel!.font = MaterialTheme.button.flat.titleLabelFont
		backgroundColor = MaterialColor.red.base //MaterialTheme.button.flat.backgroudColor
		
//		contentEdgeInsets = UIEdgeInsetsMake(8, 12, 8, 12)
	}
	
	//
	//	:name:	prepareLayer
	//
	internal override func prepareLayer() {
		super.prepareLayer()
		shadow = MaterialTheme.button.flat.shadow
		shadowColor = MaterialTheme.button.flat.shadowColor
		zPosition = MaterialTheme.button.flat.zPosition
		masksToBounds = MaterialTheme.button.flat.masksToBounds
	}
}