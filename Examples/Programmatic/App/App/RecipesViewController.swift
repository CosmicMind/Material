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

class RecipesViewController: UIViewController {
	/// A list of all the data source items.
	private var dataSourceItems: Array<MaterialDataSourceItem>!
	
	/// A tableView used to display items.
	private var tableView: UITableView!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
		prepareTabBarItem()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareItems()
		prepareTableView()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		// Stops the tableView contentInsets from being automatically adjusted.
		edgesForExtendedLayout = .None
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		// Enable the NavigationDrawer.
		navigationDrawerController?.enabled = true
		(menuController as? AppMenuController)?.showMenuView()
	}
	
	/// Prepares the items Array.
	private func prepareItems() {
		dataSourceItems = [
			MaterialDataSourceItem(
				data: [
					"title": "Crepe Indulgence",
					"detail": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
					"date": "February 26, 2016",
					"image": "AssortmentOfDessert"
				]
			),
			MaterialDataSourceItem(
				data: [
					"title": "Avocado Chocolate Cake",
					"detail": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
					"date": "February 26, 2016",
					"image": "AssortmentOfFood"
				]
			),
			MaterialDataSourceItem(
				data: [
					"title": "Avocado Ice-Cream",
					"detail": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
					"date": "February 26, 2016",
					"image": "AvocadoIceCream"
				]
			),
			MaterialDataSourceItem(
				data: [
					"title": "Raw Vegan Chocolate Cookies",
					"detail": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
					"date": "February 26, 2016",
					"image": "HeartCookies"
				]
			),
			MaterialDataSourceItem(
				data: [
					"title": "Raw Vegan Nutty Sweets",
					"detail": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
					"date": "February 26, 2016",
					"image": "VeganHempBalls"
				]
			),
			MaterialDataSourceItem(
				data: [
					"title": "Blueberry Tart",
					"detail": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
					"date": "February 26, 2016",
					"image": "VeganPieAbove"
				]
			),
			MaterialDataSourceItem(
				data: [
					"title": "Crepe Indulgence",
					"detail": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
					"date": "February 26, 2016",
					"image": "AssortmentOfDessert"
				]
			),
			MaterialDataSourceItem(
				data: [
					"title": "Avocado Chocolate Cake",
					"detail": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
					"date": "February 26, 2016",
					"image": "AssortmentOfFood"
				]
			),
			MaterialDataSourceItem(
				data: [
					"title": "Avocado Ice-Cream",
					"detail": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
					"date": "February 26, 2016",
					"image": "AvocadoIceCream"
				]
			),
			MaterialDataSourceItem(
				data: [
					"title": "Raw Vegan Chocolate Cookies",
					"detail": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
					"date": "February 26, 2016",
					"image": "HeartCookies"
				]
			),
			MaterialDataSourceItem(
				data: [
					"title": "Raw Vegan Nutty Sweets",
					"detail": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
					"date": "February 26, 2016",
					"image": "VeganHempBalls"
				]
			),
			MaterialDataSourceItem(
				data: [
					"title": "Blueberry Tart",
					"detail": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
					"date": "February 26, 2016",
					"image": "VeganPieAbove"
				]
			)
		]
	}
	
	/// Prepares view.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the tableView.
	private func prepareTableView() {
		tableView = UITableView()
		tableView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "MaterialTableViewCell")
		tableView.dataSource = self
		tableView.delegate = self
		
		// Use Layout to easily align the tableView.
		view.layout(tableView).edges()
	}
	
	/// Prepare tabBarItem.
	private func prepareTabBarItem() {
		tabBarItem.image = MaterialIcon.cm.photoLibrary
		tabBarItem.setTitleColor(MaterialColor.grey.base, forState: .Normal)
		tabBarItem.setTitleColor(MaterialColor.white, forState: .Selected)
	}
}

/// TableViewDataSource methods.
extension RecipesViewController: UITableViewDataSource {
	/// Determines the number of rows in the tableView.
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSourceItems.count;
	}
	
	/// Returns the number of sections.
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	/// Prepares the cells within the tableView.
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Subtitle, reuseIdentifier: "MaterialTableViewCell")
		let item: MaterialDataSourceItem = dataSourceItems[indexPath.row]
		
		if let data: Dictionary<String, AnyObject> =  item.data as? Dictionary<String, AnyObject> {
			cell.selectionStyle = .None
			cell.textLabel?.text = data["title"] as? String
			cell.textLabel?.font = RobotoFont.regular
			cell.detailTextLabel?.text = data["detail"] as? String
			cell.detailTextLabel?.font = RobotoFont.regular
			cell.detailTextLabel?.textColor = MaterialColor.grey.darken1
			cell.imageView?.layer.cornerRadius = 32
			cell.imageView?.image = UIImage(named: data["image"] as! String)?.crop(toWidth: 64, toHeight: 64)
		}
		
		return cell
	}
	
	/// Prepares the header within the tableView.
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = UIView(frame: CGRectMake(0, 0, view.bounds.width, 48))
		header.backgroundColor = MaterialColor.white
		
		let label: UILabel = UILabel()
		label.font = RobotoFont.medium
		label.textColor = MaterialColor.grey.darken1
		label.text = "Favorites"
		
		header.layout(label).edges(left: 24)
		
		return header
	}
}

/// UITableViewDelegate methods.
extension RecipesViewController: UITableViewDelegate {
	/// Sets the tableView cell height.
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 80
	}
	
	/// Sets the tableView header height.
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 48
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		navigationController?.pushViewController(ItemViewController(dataSource: dataSourceItems[indexPath.row]), animated: true)
	}
}
