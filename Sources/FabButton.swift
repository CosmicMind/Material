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

public class FabButton : MaterialButton {	
	/**
	:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		setTitleColor(MaterialTheme.fabButton.titleLabelColorForNormalState, forState: .Normal)
		titleLabel?.font = MaterialTheme.fabButton.titleLabelFont
		
		userInteractionEnabled = MaterialTheme.fabButton.userInteractionEnabled
		backgroundColor = MaterialTheme.fabButton.backgroundColor
		pulseColorOpacity = MaterialTheme.fabButton.pulseColorOpacity
		pulseColor = MaterialTheme.fabButton.pulseColor
		
		shadowDepth = MaterialTheme.fabButton.shadowDepth
		shadowColor = MaterialTheme.fabButton.shadowColor
		zPosition = MaterialTheme.fabButton.zPosition
		borderWidth = MaterialTheme.fabButton.borderWidth
		borderColor = MaterialTheme.fabButton.bordercolor
		contentInsets = MaterialTheme.fabButton.contentInsets
		shape = MaterialTheme.fabButton.shape
	}
}