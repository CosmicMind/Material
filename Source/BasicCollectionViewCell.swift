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

public class BasicCollectionViewCell : MaterialPanCollectionViewCell {
	/**
		:name:	titleLayer
	*/
	public private(set) lazy var titleLayer: MaterialTextLayer = MaterialTextLayer()
	
	/**
		:name:	detailLayer
	*/
	public private(set) lazy var detailLayer: MaterialTextLayer = MaterialTextLayer()
	
	/**
		:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		
		// title
		layer.addSublayer(titleLayer)
		
		// detail
		layer.addSublayer(detailLayer)
	}
}