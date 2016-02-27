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

/*
The following example shows how to dynamically size MaterialCollectionViewCells.
*/

import UIKit
import Material

class FeedViewController: UIViewController {
	private var collectionView: MaterialCollectionView = MaterialCollectionView()
	
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
		collectionView.registerClass(MaterialCollectionViewCell.self, forCellWithReuseIdentifier: "MaterialCollectionViewCell")
		
		// To avoid being hidden under the hovering MenuView.
		view.addSubview(collectionView)
		
//		collectionView.scrollDirection = .Horizontal // Uncomment to see the horizontal scroll direction.
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
				width: 150, // Applied when scrollDirection is .Horizontal
				height: 150 // Applied when scrollDirection is .Vertical
			),
			MaterialDataSourceItem(
				data: [
					"title": "MaterialColor",
					"detail": "MaterialColor is a complete Material Design color library. It uses base color values that expand to a range of lighter and darker shades, with the addition of accents.",
					"date": "February 26, 2016"
				],
				width: 250, // Applied when scrollDirection is .Horizontal
				height: 250 // Applied when scrollDirection is .Vertical
			),
			MaterialDataSourceItem(
				data: [
					"title": "MaterialColor",
					"detail": "MaterialColor is a complete Material Design color library. It uses base color values that expand to a range of lighter and darker shades, with the addition of accents.",
					"date": "February 26, 2016"
				],
				width: 350, // Applied when scrollDirection is .Horizontal
				height: 350 // Applied when scrollDirection is .Vertical
			),
			MaterialDataSourceItem(
				data: [
					"title": "MaterialColor",
					"detail": "MaterialColor is a complete Material Design color library. It uses base color values that expand to a range of lighter and darker shades, with the addition of accents.",
					"date": "February 26, 2016"
				],
				width: 150, // Applied when scrollDirection is .Horizontal
				height: 150 // Applied when scrollDirection is .Vertical
			),
			MaterialDataSourceItem(
				data: [
					"title": "MaterialColor",
					"detail": "MaterialColor is a complete Material Design color library. It uses base color values that expand to a range of lighter and darker shades, with the addition of accents.",
					"date": "February 26, 2016"
				],
				width: 250, // Applied when scrollDirection is .Horizontal
				height: 250 // Applied when scrollDirection is .Vertical
			),
			MaterialDataSourceItem(
				data: [
					"title": "MaterialColor",
					"detail": "MaterialColor is a complete Material Design color library. It uses base color values that expand to a range of lighter and darker shades, with the addition of accents.",
					"date": "February 26, 2016"
				],
				width: 350, // Applied when scrollDirection is .Horizontal
				height: 350 // Applied when scrollDirection is .Vertical
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
		let c: MaterialCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("MaterialCollectionViewCell", forIndexPath: indexPath) as! MaterialCollectionViewCell
		
		c.backgroundColor = MaterialColor.grey.darken1
		
//		Access the item data property to set data values.
//		let item: MaterialDataSourceItem = items()[indexPath.item]
//		let data: Dictionary<String, AnyObject>? = item.data as? Dictionary<String, AnyObject>
//		print(data)
		
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