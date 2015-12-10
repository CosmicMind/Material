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

public class RaisedButton : MaterialButton {
	/**
	:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		setTitleColor(MaterialTheme.raisedButton.titleLabelColorForNormalState, forState: .Normal)
		titleLabel!.font = MaterialTheme.raisedButton.titleLabelFont
		
		userInteractionEnabled = MaterialTheme.raisedButton.userInteractionEnabled
		backgroundColor = MaterialTheme.raisedButton.backgroundColor
		pulseColorOpacity = MaterialTheme.raisedButton.pulseColorOpacity
		pulseColor = MaterialTheme.raisedButton.pulseColor
		
		shadowDepth = MaterialTheme.raisedButton.shadowDepth
		shadowColor = MaterialTheme.raisedButton.shadowColor
		zPosition = MaterialTheme.raisedButton.zPosition
		cornerRadius = MaterialTheme.raisedButton.cornerRadius
		borderWidth = MaterialTheme.raisedButton.borderWidth
		borderColor = MaterialTheme.raisedButton.bordercolor
		contentInsets = MaterialTheme.raisedButton.contentInsets
		shape = MaterialTheme.raisedButton.shape
	}
}