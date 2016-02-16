/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of Material nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit
import Material

class FeedCollectionViewCell : UICollectionViewCell {
	private var cardView: MaterialPulseView!
	let titleLabel: UILabel = UILabel()
	let detailLabel: UILabel = UILabel()
	let imageView: MaterialView = MaterialView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
	}
	
	convenience init() {
		self.init(frame: CGRectNull)
		prepareView()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	private func prepareView() {
		cardView = MaterialPulseView(frame: CGRectMake(4, 0, bounds.width - 8, 156))
		cardView.pulseScale = false
		cardView.pulseColor = MaterialColor.blue.lighten4
		addSubview(cardView)
		
		var image: UIImage?
		
		imageView.contentsGravity = .ResizeAspectFill
		cardView.addSubview(imageView)
		
		let contentView: MaterialView = MaterialView()
		contentView.backgroundColor = MaterialColor.clear
		cardView.addSubview(contentView)
		
		titleLabel.textColor = MaterialColor.blueGrey.darken4
		titleLabel.backgroundColor = MaterialColor.clear
		contentView.addSubview(titleLabel)
		
		image = UIImage(named: "ic_more_vert_white")?.imageWithRenderingMode(.AlwaysTemplate)
		let moreButton: FlatButton = FlatButton()
		moreButton.contentInsetPreset = .None
		moreButton.pulseColor = MaterialColor.blueGrey.darken4
		moreButton.tintColor = MaterialColor.blueGrey.darken4
		moreButton.setImage(image, forState: .Normal)
		moreButton.setImage(image, forState: .Highlighted)
		contentView.addSubview(moreButton)
		
		detailLabel.numberOfLines = 0
		detailLabel.lineBreakMode = .ByTruncatingTail
		detailLabel.font = RobotoFont.regularWithSize(12)
		detailLabel.textColor = MaterialColor.blueGrey.darken4
		detailLabel.backgroundColor = MaterialColor.clear
		contentView.addSubview(detailLabel)
		
		imageView.grid.columns = 4
		
		contentView.grid.columns = 8
		
		cardView.grid.views = [
			imageView,
			contentView
		]
		
		titleLabel.grid.rows = 4
		titleLabel.grid.columns = 8
		
		moreButton.grid.rows = 3
		moreButton.grid.columns = 2
		moreButton.grid.offset.columns = 10
		
		detailLabel.grid.rows = 8
		detailLabel.grid.offset.rows = 4
		
		contentView.grid.spacing = 8
		contentView.grid.axis.inherited = false
		contentView.grid.axis.direction = .None
		contentView.grid.contentInsetPreset = .Square3
		contentView.grid.views = [
			titleLabel,
			moreButton,
			detailLabel
		]
	}
}
