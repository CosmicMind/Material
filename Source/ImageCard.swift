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

public class ImageCard : MaterialPulseView {
    public lazy var imageView: UIImageView = UIImageView()
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal override func initialize() {
        setupImageView()
        super.initialize()
    }
	
	internal override func constrainSubviews() {
		super.constrainSubviews()
		addConstraints(Layout.constraint("H:|[imageView]|", options: nil, metrics: nil, views: views))
		addConstraints(Layout.constraint("V:|[imageView]|", options: nil, metrics: nil, views: views))
	}
	
    private func setupImageView() {
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = .ScaleAspectFill
        imageView.userInteractionEnabled = false
        imageView.clipsToBounds = true
        addSubview(imageView)
        views["imageView"] = imageView
    }
}
