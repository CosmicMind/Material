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
The following is an example of setting a UITableView as the contentView for a
CardView.
*/

import UIKit
import Material

private struct Item {
	var text: String
	var detail: String
	var image: UIImage?
}

class ViewController: UIViewController {
	/// A tableView used to display Bond entries.
	private let tableView: UITableView = UITableView()
	
	/// A list of all the Author Bond types.
	private var items: Array<Item> = Array<Item>()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareItems()
		prepareTableView()
		prepareCardView()
	}
	
	/// Prepares view.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the items Array.
	private func prepareItems() {
		items.append(Item(text: "Summer BBQ", detail: "Wish I could come, but I am out of town this weekend.", image: UIImage(named: "Profile1")))
		items.append(Item(text: "Birthday gift", detail: "Have any ideas about what we should get Heidi for her birthday?", image: UIImage(named: "Profile2")))
		items.append(Item(text: "Brunch this weekend?", detail: "I'll be in your neighborhood doing errands this weekend.", image: UIImage(named: "Profile3")))
		items.append(Item(text: "Giants game", detail: "Are we on this weekend for the game?", image: UIImage(named: "Profile4")))
		items.append(Item(text: "Recipe to try", detail: "We should eat this: Squash, Corn and tomatillo Tacos.", image: UIImage(named: "Profile5")))
		items.append(Item(text: "Interview", detail: "The candidate will be arriving at 11:30, are you free?", image: UIImage(named: "Profile6")))
		items.append(Item(text: "Book recommendation", detail: "I found the book title, Surely You’re Joking, Mr. Feynman!", image: UIImage(named: "Profile7")))
		items.append(Item(text: "Oui oui", detail: "Do you have Paris recommendations? Have you ever been?", image: UIImage(named: "Profile8")))
	}
	
	/// Prepares the tableView.
	private func prepareTableView() {
		tableView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "Cell")
		tableView.dataSource = self
		tableView.delegate = self
	}
	
	/// Prepares the CardView.
	func prepareCardView() {
		let cardView: CardView = CardView()
		cardView.backgroundColor = MaterialColor.grey.lighten5
		cardView.cornerRadiusPreset = .Radius1
		cardView.divider = false
		cardView.contentInsetPreset = .None
		cardView.leftButtonsInsetPreset = .Square2
		cardView.rightButtonsInsetPreset = .Square2
		cardView.contentViewInsetPreset = .None
		
		let titleLabel: UILabel = UILabel()
		titleLabel.font = RobotoFont.mediumWithSize(20)
		titleLabel.text = "Messages"
		titleLabel.textAlignment = .Center
		titleLabel.textColor = MaterialColor.blueGrey.darken4
		
		let v: UIView = UIView()
		v.backgroundColor = MaterialColor.blue.accent1
		
		let closeButton: FlatButton = FlatButton()
		closeButton.setTitle("Close", forState: .Normal)
		closeButton.setTitleColor(MaterialColor.blue.accent3, forState: .Normal)
		
		let image: UIImage? = MaterialIcon.cm.settings
		let settingButton: IconButton = IconButton()
		settingButton.tintColor = MaterialColor.blue.accent3
		settingButton.setImage(image, forState: .Normal)
		settingButton.setImage(image, forState: .Highlighted)
		
		// Use Layout to easily align the tableView.
		cardView.titleLabel = titleLabel
		cardView.contentView = tableView
		cardView.leftButtons = [closeButton]
		cardView.rightButtons = [settingButton]
		
		view.layout(cardView).edges(left: 10, right: 10, top: 100, bottom: 100)
	}
}

/// TableViewDataSource methods.
extension ViewController: UITableViewDataSource {
	/// Determines the number of rows in the tableView.
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count;
	}
	
	/// Returns the number of sections.
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	/// Prepares the cells within the tableView.
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
		
		let item: Item = items[indexPath.row]
		cell.selectionStyle = .None
		cell.textLabel!.text = item.text
		cell.textLabel!.font = RobotoFont.regular
		cell.detailTextLabel!.text = item.detail
		cell.detailTextLabel!.font = RobotoFont.regular
		cell.detailTextLabel!.textColor = MaterialColor.grey.darken1
		cell.imageView!.image = item.image?.resize(toWidth: 40)
		cell.imageView!.layer.cornerRadius = 20
		
		return cell
	}
}

/// UITableViewDelegate methods.
extension ViewController: UITableViewDelegate {
	/// Sets the tableView cell height.
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 80
	}
}
