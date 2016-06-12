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
within a NavigationDrawerController.
*/

import UIKit
import Material

private struct Item {
	var text: String
	var imageName: String
}

class AppLeftViewController: UIViewController {
	/// A tableView used to display navigation items.
	private let tableView: UITableView = UITableView()
	
	/// A list of all the navigation items.
	private var items: Array<Item> = Array<Item>()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareCells()
		prepareTableView()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		/*
		The dimensions of the view will not be updated by the side navigation
		until the view appears, so loading a dyanimc width is better done here.
		The user will not see this, as it is hidden, by the drawer being closed
		when launching the app. There are other strategies to mitigate from this.
		This is one approach that works nicely here.
		*/
		prepareProfileView()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.grey.darken4
	}
	
	/// Prepares the items that are displayed within the tableView.
	private func prepareCells() {
		items.append(Item(text: "Feed", imageName: "ic_today"))
		items.append(Item(text: "Recipes", imageName: "ic_inbox"))
	}
	
	/// Prepares profile view.
	private func prepareProfileView() {
		let backgroundView: MaterialView = MaterialView()
		backgroundView.image = UIImage(named: "MaterialBackground")
		
		let profileView: MaterialView = MaterialView()
		profileView.image = UIImage(named: "Profile9")?.resize(toWidth: 72)
		profileView.backgroundColor = MaterialColor.clear
		profileView.shape = .Circle
		profileView.borderColor = MaterialColor.white
		profileView.borderWidth = 3
		
		let nameLabel: UILabel = UILabel()
		nameLabel.text = "Michael Smith"
		nameLabel.textColor = MaterialColor.white
		nameLabel.font = RobotoFont.mediumWithSize(18)
		
		view.layout(profileView).width(72).height(72).top(30).centerHorizontally()
        view.layout(nameLabel).top(130).left(20).right(20)
	}
	
	/// Prepares the tableView.
	private func prepareTableView() {
		tableView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "MaterialTableViewCell")
		tableView.backgroundColor = MaterialColor.clear
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .None
		
		// Use Layout to easily align the tableView.
        view.layout(tableView).edges(top: 170)
	}
}

/// TableViewDataSource methods.
extension AppLeftViewController: UITableViewDataSource {
	/// Determines the number of rows in the tableView.
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count;
	}
	
	/// Prepares the cells within the tableView.
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: MaterialTableViewCell = tableView.dequeueReusableCellWithIdentifier("MaterialTableViewCell", forIndexPath: indexPath) as! MaterialTableViewCell
		
		let item: Item = items[indexPath.row]
		
		cell.textLabel!.text = item.text
		cell.textLabel!.textColor = MaterialColor.grey.lighten2
		cell.textLabel!.font = RobotoFont.medium
		cell.imageView!.image = UIImage(named: item.imageName)?.imageWithRenderingMode(.AlwaysTemplate)
		cell.imageView!.tintColor = MaterialColor.grey.lighten2
		cell.backgroundColor = MaterialColor.clear
		
		return cell
	}
}

/// UITableViewDelegate methods.
extension AppLeftViewController: UITableViewDelegate {
	/// Sets the tableView cell height.
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 64
	}
	
	/// Select item at row in tableView.
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//		print("Selected")
	}
}
