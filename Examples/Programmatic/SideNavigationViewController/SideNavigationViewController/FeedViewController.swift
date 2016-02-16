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
*	*	Neither the name of GraphKit nor the names of its
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
The following is an example of setting a UITableView as the MainViewController
within a SideNavigationViewController. There is a NavigationBarView that is
used for navigation, with a menu button that opens the
SideNavigationViewController.
*/

import UIKit
import Material

struct Item {
	var title: String
	var detail: String
	var image: UIImage?
}

class FeedViewController: UIViewController {
	/// A tableView used to display Bond entries.
	private lazy var collectionView: FeedCollectionView = FeedCollectionView(frame: CGRectNull, collectionViewLayout: FeedCollectionViewLayout())
	
	/// Feed items.
	private(set) lazy var items: Array<Item> = Array<Item>()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareItems()
		prepareCollectionView()
	}
	
	/// Prepares view.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}

	/// Prepares the items Array.
	private func prepareItems() {
		items.append(Item(
			title: "Raw Vegan Blackberry Tart!",
			detail: "Treat yourself today and every day with this sweet nutritious cake!",
			image: UIImage(named: "VeganCakeFull")
			))
		
		items.append(Item(
			title: "Raw Vegan Pumpkin Pie",
			detail: "Pumpkin lovers, desert lovers, and anyone who likes simple healthy cooking and enjoys eating! Light up your day with a piece of happiness- raw vegan pumpkin pie :)",
			image: UIImage(named: "VeganPieAbove")
			))
		
		items.append(Item(
			title: "Raw Vegan Nutty Sweets!",
			detail: "Since most of my readers have a sweet tooth, here is another simple recipe to boost your happiness :)",
			image: UIImage(named: "VeganHempBalls")
			))
		
		items.append(Item(
			title: "Avocado Chocolate Cake!",
			detail: "Do you know what are the two best things about vegan food besides that it's healthy and full of nutrition? It's absolutely delicious and easy to make!",
			image: UIImage(named: "AssortmentOfFood")
			))
		
		items.append(Item(
			title: "Homemade brunch: Crepe Indulgence",
			detail: "Looking for a perfect sunday brunch spot? How about staying in and making something to die for?:)",
			image: UIImage(named: "AssortmentOfDessert")
			))
		
		items.append(Item(
			title: "Raw Vegan Chocolate Cookies",
			detail: "Once I start making sweets it's hard for me to stop! I've got another exciting recipe, which hopefully you will love! :D",
			image: UIImage(named: "HeartCookies")
			))
		
		items.append(Item(
			title: "Homemade Avocado Ice Cream",
			detail: "Avocado ice cream (and vegan!) might not sound so appealing to some of you, but the truth is- it's mind blowing!!!",
			image: UIImage(named: "AvocadoIceCream")
			))
	}
	
	/// Prepares the tableView.
	private func prepareCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = MaterialColor.grey.lighten4
		
		view.addSubview(collectionView)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignToParent(view, child: collectionView)
	}
}

/// UICollectionViewDelegate
extension FeedViewController: UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let c: FeedCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("FeedCollectionViewCell", forIndexPath: indexPath) as! FeedCollectionViewCell
		
		let item: Item = items[indexPath.row] as Item
		c.titleLabel.text = item.title
		c.detailLabel.text = item.detail
		c.imageView.image = item.image
		
		return c
	}
}

/// UICollectionViewDataSource
extension FeedViewController: UICollectionViewDataSource {
	/// Number of sections in the collection.
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	/// Number of items in each section.
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
}
