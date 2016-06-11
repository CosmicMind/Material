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

class ViewController: UIViewController {
	/// A list of all the data source items.
	private var dataSourceItems: Array<MaterialDataSourceItem>!
	
	/// A collectionView used to display entries.
	private var collectionView: MaterialCollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareItems()
		prepareCollectionView()
	}
	
	/// Prepares the items Array.
	private func prepareItems() {
		dataSourceItems = [
			MaterialDataSourceItem(
				data: [
					"placeholder": "Field Placeholder",
					"detailLabelHidden": false
				],
				height: 80
			),
			MaterialDataSourceItem(
				data: [
					"placeholder": "Field Placeholder",
					"detailLabelHidden": false
				],
				height: 80
			),
			MaterialDataSourceItem(
				data: [
					"placeholder": "Field Placeholder",
					"detailLabelHidden": false
				],
				height: 80
			)
		]
	}
	
	/// Prepares view.
	private func prepareView() {
		view.backgroundColor = MaterialColor.grey.lighten3
	}
	
	/// Prepares the collectionView.
	private func prepareCollectionView() {
		collectionView = MaterialCollectionView(frame: view.bounds)
		collectionView.registerClass(MaterialCollectionViewCell.self, forCellWithReuseIdentifier: "MaterialCollectionViewCell")
		collectionView.dataSource = self
		collectionView.contentInset.top = 100
		collectionView.spacing = 16
		
		view.layout(collectionView).edges()
	}
}

/// CollectionViewDataSource methods.
extension ViewController: MaterialCollectionViewDataSource {
	
	func items() -> Array<MaterialDataSourceItem> {
		return dataSourceItems
	}
	
	/// Determines the number of items in the collectionView.
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataSourceItems.count;
	}
	
	/// Returns the number of sections.
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	/// Prepares the cells within the collectionView.
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell: MaterialCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("MaterialCollectionViewCell", forIndexPath: indexPath) as! MaterialCollectionViewCell
		let item: MaterialDataSourceItem = dataSourceItems[indexPath.item]
		
		if let _: Dictionary<String, AnyObject> =  item.data as? Dictionary<String, AnyObject> {
			cell.backgroundColor = MaterialColor.white
		}
		
		return cell
	}
}
