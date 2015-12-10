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

public class FlatButton : MaterialButton {
	/**
	:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		setTitleColor(MaterialTheme.flatButton.titleLabelColorForNormalState, forState: .Normal)
		titleLabel?.font = MaterialTheme.flatButton.titleLabelFont
		
		userInteractionEnabled = MaterialTheme.flatButton.userInteractionEnabled
		backgroundColor = MaterialTheme.flatButton.backgroundColor
		pulseColorOpacity = MaterialTheme.flatButton.pulseColorOpacity
		pulseColor = MaterialTheme.flatButton.pulseColor
		
		shadowDepth = MaterialTheme.flatButton.shadowDepth
		shadowColor = MaterialTheme.flatButton.shadowColor
		zPosition = MaterialTheme.flatButton.zPosition
		cornerRadius = MaterialTheme.flatButton.cornerRadius
		borderWidth = MaterialTheme.flatButton.borderWidth
		borderColor = MaterialTheme.flatButton.bordercolor
		contentInsets = MaterialTheme.flatButton.contentInsets
		shape = MaterialTheme.flatButton.shape
	}
}