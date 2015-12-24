//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io>..
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

public class MaterialTableViewCell: UITableViewCell {
    
    public lazy var pulseView: MaterialPulseView = MaterialPulseView()
    
    /**
     :name:	initWithCoder:
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     :name:	initWithStyle:
     */
    public override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
        preparePulseView()
    }
    
    /**
     :name:	layoutSubviews
     */
    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutPulseView()
    }
    
    /**
     :name:	prepare
     */
    public func prepare() {
        selectionStyle = .None
        imageView?.userInteractionEnabled = false
        textLabel?.userInteractionEnabled = false
        detailTextLabel?.userInteractionEnabled = false
    }
    
    /**
     :name:	preparePulseView
     */
    public func preparePulseView() {
        pulseView.pulseColor = MaterialColor.red.darken1.colorWithAlphaComponent(0.2)
        contentView.addSubview(pulseView)
    }
    
    /**
     :name:	layoutPulseView
     */
    public func layoutPulseView() {
        pulseView.frame = contentView.bounds
    }
}
