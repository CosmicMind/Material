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

private struct Item {
	var text: String
	var image: UIImage?
}

class AppLeftViewController: UIViewController {
	/// A tableView used to display navigation items.
	private var tableView: UITableView!
	
	/// A list of all the navigation items.
	private var dataSourceItems: Array<Item>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareCells()
		prepareTableView()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.grey.darken4
	}
	
	/// Prepares the items that are displayed within the tableView.
	private func prepareCells() {
		dataSourceItems = Array<Item>()
		dataSourceItems.append(Item(text: "Orange", image: MaterialIcon.cm.audioLibrary))
		dataSourceItems.append(Item(text: "Purple", image: MaterialIcon.cm.photoLibrary))
		dataSourceItems.append(Item(text: "Green", image: MaterialIcon.cm.microphone))
		dataSourceItems.append(Item(text: "Blue", image: MaterialIcon.cm.audio))
	}
	
	/// Prepares the tableView.
	private func prepareTableView() {
		tableView = UITableView()
		tableView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "MaterialTableViewCell")
		tableView.backgroundColor = MaterialColor.clear
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .None
		
		// Use Layout to easily align the tableView.
		view.layout(tableView).edges(top: 64)
	}
}

/// TableViewDataSource methods.
extension AppLeftViewController: UITableViewDataSource {
	/// Determines the number of rows in the tableView.
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSourceItems.count;
	}
	
	/// Prepares the cells within the tableView.
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: MaterialTableViewCell = tableView.dequeueReusableCellWithIdentifier("MaterialTableViewCell", forIndexPath: indexPath) as! MaterialTableViewCell
		
		let item: Item = dataSourceItems[indexPath.row]
		
		cell.textLabel!.text = item.text
		cell.textLabel!.textColor = MaterialColor.grey.lighten2
		cell.textLabel!.font = RobotoFont.medium
		cell.imageView!.image = item.image
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
		let item: Item = dataSourceItems[indexPath.row]
		
		if let v: NavigationController = navigationDrawerController?.rootViewController as? NavigationController {
			switch item.text {
			case "Orange":
				v.pushViewController(OrangeViewController(), animated: true)
			case "Purple":
				v.pushViewController(PurpleViewController(), animated: true)
			case "Green":
				v.pushViewController(GreenViewController(), animated: true)
			case "Blue":
				v.pushViewController(BlueViewController(), animated: true)
			default:break
			}
		}
	}
}
