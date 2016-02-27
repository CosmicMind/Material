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

class FeedViewController: UIViewController {
	private var collectionView: BasicCollectionView = BasicCollectionView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareCollectionView()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		collectionView.frame = view.bounds
		collectionView.reloadData()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationBarViewController?.navigationBarView.titleLabel?.text = "Feed"
	}
	
	/// Prepares view.
	private func prepareView() {
		view.backgroundColor = MaterialColor.grey.lighten4
	}
	
	/// Prepares the collectionView
	private func prepareCollectionView() {
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.spacingPreset = .Spacing1
		collectionView.contentInsetPreset = .Square1
		view.addSubview(collectionView)
	}
}

extension FeedViewController: MaterialCollectionViewDataSource {
	/// Retrieves the items for the collectionView.
	func items() -> Array<MaterialDataSourceItem> {
		return [
			MaterialDataSourceItem(
				data: [
					"title": "MaterialColor",
					"detail": "MaterialColor is a complete Material Design color library. It uses base color values that expand to a range of lighter and darker shades, with the addition of accents.",
					"date": "February 26, 2016"
				],
				itemSize: .Small
			),
			MaterialDataSourceItem(
				data: [
					"title": "MaterialColor",
					"detail": "MaterialColor is a complete Material Design color library. It uses base color values that expand to a range of lighter and darker shades, with the addition of accents.",
					"date": "February 26, 2016"
				],
				itemSize: .Small
			),
			MaterialDataSourceItem(
				data: [
					"title": "MaterialColor",
					"detail": "MaterialColor is a complete Material Design color library. It uses base color values that expand to a range of lighter and darker shades, with the addition of accents.",
					"date": "February 26, 2016"
				],
				itemSize: .Small
			),
			MaterialDataSourceItem(
				data: [
					"title": "MaterialColor",
					"detail": "MaterialColor is a complete Material Design color library. It uses base color values that expand to a range of lighter and darker shades, with the addition of accents.",
					"date": "February 26, 2016"
				],
				itemSize: .Small
			),
			MaterialDataSourceItem(
				data: [
					"title": "MaterialColor",
					"detail": "MaterialColor is a complete Material Design color library. It uses base color values that expand to a range of lighter and darker shades, with the addition of accents.",
					"date": "February 26, 2016"
				],
				itemSize: .Small
			),
			MaterialDataSourceItem(
				data: [
					"title": "MaterialColor",
					"detail": "MaterialColor is a complete Material Design color library. It uses base color values that expand to a range of lighter and darker shades, with the addition of accents.",
					"date": "February 26, 2016"
				],
				itemSize: .Small
			)
		]
	}
	
	/// Number of sections.
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	/// Number of cells in each section.
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items().count
	}
	
	/// Retrieves a UICollectionViewCell.
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let c: BasicCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("BasicCollectionViewCell", forIndexPath: indexPath) as! BasicCollectionViewCell
		let item: MaterialDataSourceItem = items()[indexPath.item]
		
		// Set the data for the view objects.
		if let data: Dictionary<String, AnyObject> = item.data as? Dictionary<String, AnyObject> {
			
			// Only load the titleLabel if it has not been.
			if nil == data["title"] {
				c.titleLabel = nil
			} else if nil == c.titleLabel {
				let titleLabel: UILabel = UILabel()
				titleLabel.textColor = MaterialColor.grey.darken4
				c.titleLabel = titleLabel
			}
			
			// Only load the detailLabel if it has not been.
			if nil == data["detail"] {
				c.detailLabel = nil
			} else if nil == c.detailLabel {
				let detailLabel: UILabel = UILabel()
				detailLabel.numberOfLines = 0
				detailLabel.lineBreakMode = .ByTruncatingTail
				detailLabel.font = RobotoFont.regularWithSize(12)
				detailLabel.textColor = MaterialColor.grey.darken4
				c.detailLabel = detailLabel
			}
			
			// Only load the controlView if it has not been.
			if nil == c.controlView {
				c.controlView = ControlView()
				c.controlView!.backgroundColor = nil
				
				// Create a date UILabel for the ControlView's contentView.
				let date: UILabel = UILabel()
				date.font = RobotoFont.regularWithSize(12)
				date.textColor = MaterialColor.grey.base
				
				/**
				ControlViews have a contentView. In this example, I am using Grid
				to maintain its alignment. A ControlView's contentView is inbetween
				the leftControls and rightControls.
				*/
				c.controlView?.contentView.addSubview(date)
				c.controlView?.contentView.grid.views = [date]
				
				let image = UIImage(named: "ic_share_white_18pt")?.imageWithRenderingMode(.AlwaysTemplate)
				
				// Share button.
				let shareButton: FlatButton = FlatButton()
				shareButton.pulseScale = false
				shareButton.pulseColor = MaterialColor.grey.lighten1
				shareButton.tintColor = MaterialColor.grey.base
				shareButton.setImage(image, forState: .Normal)
				shareButton.setImage(image, forState: .Highlighted)
				
				c.controlView?.rightControls = [shareButton]
			}
			
			c.titleLabel?.text = data["title"] as? String
			c.detailLabel?.text = data["detail"] as? String
			(c.controlView?.contentView.subviews.first as? UILabel)?.text = data["date"] as? String
			
			c.reloadView()
		}
		
		return c
	}
}

/// MaterialCollectionViewDelegate methods.
extension FeedViewController: MaterialCollectionViewDelegate {
	/// Executed when an item is selected.
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		print(indexPath)
	}
}