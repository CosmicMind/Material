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
import QuartzCore

public class BasicCard : MaterialCard {
    public lazy var cancelButton: FlatButton = FlatButton()
    public lazy var otherButton: FlatButton = FlatButton()
	public lazy var buttonColor: UIColor = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 38.0/255.0, alpha: 1.0)
    public lazy var titleLabel: UILabel = UILabel()
    public lazy var detailTextLabel: UILabel = UILabel()
    public lazy var horizontalSeparator: UIView = UIView()
    
	internal override func prepareCard() {
		super.prepareCard()
		prepareShadow()
		prepareTitleLabel()
        prepareDetailTextLabel()
        prepareHorizontalSeparator()
		prepareCancelButton()
		prepareOtherButton()
		addConstraints(Layout.constraint("H:|-(20)-[titleLabel]-(20)-|", options: nil, metrics: nil, views: ["titleLabel": titleLabel]))
		addConstraints(Layout.constraint("H:|-(20)-[detailTextLabel]-(20)-|", options: nil, metrics: nil, views: ["detailTextLabel": detailTextLabel]))
		addConstraints(Layout.constraint("H:|[horizontalSeparator]|", options: nil, metrics: nil, views: ["horizontalSeparator": horizontalSeparator]))
		addConstraints(Layout.constraint("H:|-(10)-[cancelButton(80)]-(10)-[otherButton(80)]", options: nil, metrics: nil, views: ["cancelButton": cancelButton, "otherButton": otherButton]))
		addConstraints(Layout.constraint("V:|-(20)-[titleLabel(22)]-(10)-[detailTextLabel]-(20)-[horizontalSeparator(1)]-(10)-[cancelButton]-(10)-|", options: nil, metrics: nil, views: ["titleLabel": titleLabel, "detailTextLabel": detailTextLabel, "horizontalSeparator": horizontalSeparator, "cancelButton": cancelButton, "otherButton": otherButton]))
		addConstraints(Layout.constraint("V:|-(20)-[titleLabel(22)]-(10)-[detailTextLabel]-(20)-[horizontalSeparator(1)]-(10)-[otherButton]-(10)-|", options: nil, metrics: nil, views: ["titleLabel": titleLabel, "detailTextLabel": detailTextLabel, "horizontalSeparator": horizontalSeparator, "otherButton": otherButton]))
	}
	
    private func prepareTitleLabel() {
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.font = Roboto.regularWithSize(22.0)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "Card Title"
        addSubview(titleLabel)
    }
    
    private func prepareDetailTextLabel() {
        detailTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        detailTextLabel.font = Roboto.lightWithSize(16.0)
        detailTextLabel.textColor = UIColor.whiteColor()
        detailTextLabel.text = "I am a very simple card. I am good at containing small bits of information. I am convenient because I require little markup to use effectively."
        detailTextLabel.numberOfLines = 0
        detailTextLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        addSubview(detailTextLabel)
    }
    
    private func prepareHorizontalSeparator() {
        horizontalSeparator.setTranslatesAutoresizingMaskIntoConstraints(false)
        horizontalSeparator.backgroundColor = UIColor.whiteColor()
        horizontalSeparator.alpha = 0.2
        addSubview(horizontalSeparator)
    }
	
    private func prepareCancelButton() {
		cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(buttonColor, forState: .Normal)
        cancelButton.pulseColor = buttonColor
        addSubview(cancelButton)
    }
    
    private func prepareOtherButton() {
		otherButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        otherButton.setTitle("Confirm", forState: .Normal)
		otherButton.setTitleColor(buttonColor, forState: .Normal)
        otherButton.pulseColor = buttonColor
        addSubview(otherButton)
    }
}
