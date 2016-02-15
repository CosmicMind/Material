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
The following is an example of setting a UITableView as the LeftViewController
within a SideNavigationViewController.
*/

import UIKit
import Material

private struct Item {
	var text: String
	var imageName: String
	var selected: Bool
}

class LeftViewController: UIViewController {
	/// A tableView used to display navigation items.
	private let tableView: UITableView = UITableView()
	
	/// A list of all the navigation items.
	private var items: Array<Item> = Array<Item>()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareItems()
		prepareProfileView()
		prepareTableView()
		
		// Reload the Grid layout.
		view.grid.reloadLayout()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.clear
		view.grid.axis.direction = .None
		view.grid.views = []
	}
	
	/// Prepares the items that are displayed within the tableView.
	private func prepareItems() {
		items.append(Item(text: "Inbox", imageName: "ic_inbox", selected: true))
		items.append(Item(text: "Today", imageName: "ic_today", selected: false))
		items.append(Item(text: "Bookmarks", imageName: "ic_book", selected: false))
		items.append(Item(text: "Work", imageName: "ic_work", selected: false))
		items.append(Item(text: "Contacts", imageName: "ic_contacts", selected: false))
		items.append(Item(text: "Settings", imageName: "ic_settings", selected: false))
	}
	
	/// Prepares profile view.
	private func prepareProfileView() {
		let imageView: MaterialView = MaterialView()
		imageView.image = UIImage(named: "Profile9")?.resize(toWidth: 72)
		imageView.shape = .Circle
		imageView.borderColor = MaterialColor.white
		imageView.borderWidth = 3
		view.addSubview(imageView)
		
		let nameLabel: UILabel = UILabel()
		nameLabel.text = "Michael Smith"
		nameLabel.textColor = MaterialColor.white
		nameLabel.font = RobotoFont.mediumWithSize(18)
		
		view.addSubview(nameLabel)
		
		nameLabel.grid.rows = 1
		nameLabel.grid.offset.rows = 3
		
		view.grid.views?.append(nameLabel)
		
		print(nameLabel.frame.width)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTopLeft(view, child: imageView, top: (nameLabel.frame.origin.y - 72) / 2 , left: (nameLabel.frame.width - 72) / 2)
		MaterialLayout.size(view, child: imageView, width: 72, height: 72)
	}
	
	/// Prepares the tableView.
	private func prepareTableView() {
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .None
		
		view.addSubview(tableView)
		
		tableView.grid.rows = 8
		tableView.grid.offset.rows = 4
		view.grid.views?.append(tableView)
	}
}

/// TableViewDataSource methods.
extension LeftViewController: UITableViewDataSource {
	/// Determines the number of rows in the tableView.
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count;
	}
	
	/// Prepares the cells within the tableView.
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
		cell.backgroundColor = MaterialColor.clear
		
		let item: Item = items[indexPath.row]
		cell.selectionStyle = .None
		cell.textLabel!.text = item.text
		cell.textLabel!.font = RobotoFont.medium
		cell.imageView!.image = UIImage(named: item.imageName)?.imageWithRenderingMode(.AlwaysTemplate)
		cell.imageView!.tintColor = MaterialColor.cyan.darken4
		
		if item.selected {
			cell.textLabel!.textColor = MaterialColor.cyan.base
		}
		
		return cell
	}
}

/// UITableViewDelegate methods.
extension LeftViewController: UITableViewDelegate {
	/// Sets the tableView cell height.
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 64
	}
	
	/// Select item at row in tableView.
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("Item selected")
	}
}
