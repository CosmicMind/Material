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

public class RaisedButton : MaterialButton {
	//
	//	:name:	prepareButton
	//
	internal override func prepareButton() {
		super.prepareButton()
		prepareShadow()
		setTitleColor(MaterialTheme.white.color, forState: .Normal)
		backgroundColor = MaterialTheme.indigo.darken1
		backgroundColorView.layer.cornerRadius = 3
	}
	
	//
	//	:name:	pulseBegan
	//
	internal override func pulseBegan(touches: Set<NSObject>, withEvent event: UIEvent)  {
		super.pulseBegan(touches, withEvent: event)
		UIView.animateWithDuration(0.3, animations: {
			self.pulseView!.transform = CGAffineTransformMakeScale(10, 10)
			self.transform = CGAffineTransformMakeScale(1.05, 1.1)
		})
	}
}

