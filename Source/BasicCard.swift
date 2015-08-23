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

public class BasicCard : MaterialPulseView {
    
    public var cancelButton: FlatButton = FlatButton()
    public var otherButton: FlatButton = FlatButton()
  
    public var titleLabel: UILabel = UILabel()
    public var detailTextLabel: UILabel = UILabel()
    
    public var horizontalSeparator: UIView = UIView()
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal override func initialize() {
        setupTitleLabel()
        setupDetailTextLabel()
        setupHorizontalLineSeparator()
        setupButtons()
        super.initialize()
    }
    
    func setupTitleLabel() {
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.font = Roboto.regularWithSize(22.0)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "Card Title"
        addSubview(titleLabel)
        views.setObject(titleLabel, forKey: "titleLabel")
    }
    
    func setupDetailTextLabel() {
        detailTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        detailTextLabel.font = Roboto.lightWithSize(16.0)
        detailTextLabel.textColor = UIColor.whiteColor()
        detailTextLabel.text = "I am a very simple card. I am good at containing small bits of information. I am convenient because I require little markup to use effectively."
        detailTextLabel.numberOfLines = 0
        detailTextLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        addSubview(detailTextLabel)
        views.setObject(detailTextLabel, forKey: "detailTextLabel")
    }
    
    func setupHorizontalLineSeparator() {
        horizontalSeparator.setTranslatesAutoresizingMaskIntoConstraints(false)
        horizontalSeparator.backgroundColor = UIColor.whiteColor()
        horizontalSeparator.alpha = 0.2
        addSubview(horizontalSeparator)
        views.setObject(horizontalSeparator, forKey: "line")
    }
    
    func setupButtons() {
        setupCancelButton()
        setupOtherButton()
    }
    
    func setupCancelButton() {
        cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        cancelButton.setTitle("Cancel", forState: .Normal)
        var orange = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        cancelButton.setTitleColor(orange, forState: .Normal)
        cancelButton.pulseColor = orange
        addSubview(cancelButton)
        views.setObject(cancelButton, forKey: "cancelButton")
    }
    
    func setupOtherButton() {
        otherButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        otherButton.setTitle("Confirm", forState: .Normal)
        var orange = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        otherButton.setTitleColor(orange, forState: .Normal)
        otherButton.pulseColor = orange
        addSubview(otherButton)
        views.setObject(otherButton, forKey: "otherButton")
    }
    
    internal override func constrainSubviews() {
        super.constrainSubviews()
        // Title & Detail Text Label
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[titleLabel]-(20)-|", options: nil, metrics: nil, views: views as [NSObject : AnyObject]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[detailTextLabel]-(20)-|", options: nil, metrics: nil, views: views as [NSObject : AnyObject]))
        
        // Horizontal line
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[line]-(0)-|", options: nil, metrics: nil, views: views as [NSObject : AnyObject]))
        
        // Cancel & Other Button
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(10)-[cancelButton(80)]-(10)-[otherButton(80)]", options: nil, metrics: nil, views: views as [NSObject : AnyObject]))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(20)-[titleLabel(22)]-(10)-[detailTextLabel]-(20)-[line(1)]-(10)-[cancelButton]-(10)-|", options: nil, metrics: nil, views: views as [NSObject : AnyObject]))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(20)-[titleLabel(22)]-(10)-[detailTextLabel]-(20)-[line(1)]-(10)-[otherButton]-(10)-|", options: nil, metrics: nil, views: views as [NSObject : AnyObject]))
    }
}
