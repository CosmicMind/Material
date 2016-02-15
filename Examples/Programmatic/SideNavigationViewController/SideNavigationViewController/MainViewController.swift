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

private struct Item {
	var text: String
	var detail: String
	var image: UIImage?
}

class MainViewController: UIViewController {
	/// A tableView used to display Bond entries.
	private let tableView: UITableView = UITableView()
	
	/// MenuView.
	let menuView: MenuView = MenuView()
	
	/// A list of all the Author Bond types.
	private var items: Array<Item> = Array<Item>()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareItems()
		prepareTableView()
		prepareNavigationBarView()
		prepareMenuView()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		/*
		Set the width of the SideNavigationViewController. Be mindful
		of when setting this value. It is set in the viewWillAppear method,
		because any earlier may cause a race condition when instantiating
		the MainViewController and SideViewController.
		*/
		sideNavigationViewController?.setLeftViewWidth(view.bounds.width - 88, hidden: true, animated: false)
		sideNavigationViewController?.delegate = self
	}
	
	/**
	Handles the menu button click, which opens the
	SideNavigationViewController.
	*/
	func handleMenuButton() {
		sideNavigationViewController?.openLeftView()
	}
	
	/**
	Handles the search button click, which opens the
	SideNavigationViewController.
	*/
	func handleSearchButton() {
		sideNavigationViewController?.openRightView()
	}
	
	/// Handle the menuView touch event.
	func handleMenu() {
		let image: UIImage?
		
		if menuView.menu.opened {
			menuView.menu.close()
			image = UIImage(named: "ic_add_white")
		} else {
			menuView.menu.open() { (v: UIView) in
				(v as? MaterialButton)?.pulse()
			}
			image = UIImage(named: "ic_close_white")
		}
		
		// Add a nice rotation animation to the base button.
		let first: MaterialButton? = menuView.menu.views?.first as? MaterialButton
		first?.animate(MaterialAnimation.rotate(1))
		first?.setImage(image, forState: .Normal)
		first?.setImage(image, forState: .Highlighted)
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
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		tableView.dataSource = self
		tableView.delegate = self
		
		// Use MaterialLayout to easily align the tableView.
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignToParent(view, child: tableView, top: 70)
	}
	
	/// Prepares the navigationBarView.
	private func prepareNavigationBarView() {
		let navigationBarView: NavigationBarView = NavigationBarView()
		navigationBarView.backgroundColor = MaterialColor.grey.darken4
		
		/*
		To lighten the status bar - add the
		"View controller-based status bar appearance = NO"
		to your info.plist file and set the following property.
		*/
		navigationBarView.statusBarStyle = .LightContent
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "Inbox"
		titleLabel.textAlignment = .Left
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.regularWithSize(17)
		navigationBarView.titleLabel = titleLabel
		
		// Menu button.
		let img1: UIImage? = UIImage(named: "ic_menu_white")
		let menuButton: FlatButton = FlatButton()
		menuButton.pulseColor = MaterialColor.white
		menuButton.pulseScale = false
		menuButton.setImage(img1, forState: .Normal)
		menuButton.setImage(img1, forState: .Highlighted)
		menuButton.addTarget(self, action: "handleMenuButton", forControlEvents: .TouchUpInside)
		
		// Add menuButton to left side.
		navigationBarView.leftControls = [menuButton]
		
		// MaterialSwitch control.
		let materialSwitch: MaterialSwitch = MaterialSwitch(state: .Off)
		
		// Search button.
		let img2: UIImage? = UIImage(named: "ic_more_vert_white")
		let searchButton: FlatButton = FlatButton()
		searchButton.pulseColor = MaterialColor.white
		searchButton.pulseScale = false
		searchButton.setImage(img2, forState: .Normal)
		searchButton.setImage(img2, forState: .Highlighted)
		searchButton.addTarget(self, action: "handleSearchButton", forControlEvents: .TouchUpInside)
		
		// Add searchButton to right side.
		navigationBarView.rightControls = [materialSwitch, searchButton]
		
		// To support orientation changes, use MaterialLayout.
		view.addSubview(navigationBarView)
	}
	
	/// Prepares the add button.
	private func prepareMenuView() {
		/// MenuView diameter.
		let diameter: CGFloat = 56
		
		var image: UIImage? = UIImage(named: "ic_add_white")
		let btn1: FabButton = FabButton()
		/**
		Remove the pulse animation, so the rotation animation
		doesn't seem like too much with the pulse animation.
		*/
		btn1.pulseColor = nil
		btn1.setImage(image, forState: .Normal)
		btn1.setImage(image, forState: .Highlighted)
		btn1.addTarget(self, action: "handleMenu", forControlEvents: .TouchUpInside)
		menuView.addSubview(btn1)
		
		image = UIImage(named: "ic_create_white")
		let btn2: FabButton = FabButton()
		btn2.backgroundColor = MaterialColor.blue.base
		btn2.setImage(image, forState: .Normal)
		btn2.setImage(image, forState: .Highlighted)
		menuView.addSubview(btn2)
		
		image = UIImage(named: "ic_photo_camera_white")
		let btn3: FabButton = FabButton()
		btn3.backgroundColor = MaterialColor.green.base
		btn3.setImage(image, forState: .Normal)
		btn3.setImage(image, forState: .Highlighted)
		menuView.addSubview(btn3)
		
		image = UIImage(named: "ic_note_add_white")
		let btn4: FabButton = FabButton()
		btn4.backgroundColor = MaterialColor.amber.base
		btn4.setImage(image, forState: .Normal)
		btn4.setImage(image, forState: .Highlighted)
		menuView.addSubview(btn4)
		
		// Initialize the menu and setup the configuration options.
		menuView.menu.direction = .Up
		menuView.menu.baseViewSize = CGSizeMake(diameter, diameter)
		menuView.menu.views = [btn1, btn2, btn3, btn4]
		
		view.addSubview(menuView)
		menuView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.size(view, child: menuView, width: diameter, height: diameter)
		MaterialLayout.alignFromBottomRight(view, child: menuView, bottom: 16, right: 16)
	}
}

/// TableViewDataSource methods.
extension MainViewController: UITableViewDataSource {
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
		let cell: UITableViewCell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
		
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
	
	/// Prepares the header within the tableView.
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = UIView(frame: CGRectMake(0, 0, view.bounds.width, 48))
		header.backgroundColor = MaterialColor.white
		
		let label: UILabel = UILabel()
		label.font = RobotoFont.medium
		label.textColor = MaterialColor.grey.darken1
		label.text = "Today"
		
		header.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignToParent(header, child: label, left: 24)
		
		return header
	}
}

/// UITableViewDelegate methods.
extension MainViewController: UITableViewDelegate {
	/// Sets the tableView cell height.
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 80
	}
	
	/// Sets the tableView header height.
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 48
	}
}

/// SideNavigationViewControllerDelegate methods.
extension MainViewController: SideNavigationViewControllerDelegate {
	/**
	An optional delegation method that is fired before the
	SideNavigationViewController opens.
	*/
	func sideNavigationViewWillOpen(sideNavigationViewController: SideNavigationViewController, position: SideNavigationPosition) {
		print("Will open", .Left == position ? "Left" : "Right", "view.")
	}
	
	/**
	An optional delegation method that is fired after the
	SideNavigationViewController opened.
	*/
	func sideNavigationViewDidOpen(sideNavigationViewController: SideNavigationViewController, position: SideNavigationPosition) {
		print("Did open", .Left == position ? "Left" : "Right", "view.")
	}
	
	/**
	An optional delegation method that is fired before the
	SideNavigationViewController closes.
	*/
	func sideNavigationViewWillClose(sideNavigationViewController: SideNavigationViewController, position: SideNavigationPosition) {
		print("Will close", .Left == position ? "Left" : "Right", "view.")
	}
	
	/**
	An optional delegation method that is fired after the
	SideNavigationViewController closed.
	*/
	func sideNavigationViewDidClose(sideNavigationViewController: SideNavigationViewController, position: SideNavigationPosition) {
		print("Did close", .Left == position ? "Left" : "Right", "view.")
	}
	
	/**
	An optional delegation method that is fired when the
	SideNavigationViewController pan gesture begins.
	*/
	func sideNavigationViewPanDidBegin(sideNavigationViewController: SideNavigationViewController, point: CGPoint, position: SideNavigationPosition) {
		print("Pan did begin for", .Left == position ? "Left" : "Right", "view.")
	}
	
	/**
	An optional delegation method that is fired when the
	SideNavigationViewController pan gesture changes position.
	*/
	func sideNavigationViewPanDidChange(sideNavigationViewController: SideNavigationViewController, point: CGPoint, position: SideNavigationPosition) {
		print("Pan did change for", .Left == position ? "Left" : "Right", "view.")
	}
	
	/**
	An optional delegation method that is fired when the
	SideNavigationViewController pan gesture ends.
	*/
	func sideNavigationViewPanDidEnd(sideNavigationViewController: SideNavigationViewController, point: CGPoint, position: SideNavigationPosition) {
		print("Pan did end for", .Left == position ? "Left" : "Right", "view.")
	}
	
	/**
	An optional delegation method that is fired when the
	SideNavigationViewController tap gesture executes.
	*/
	func sideNavigationViewDidTap(sideNavigationViewController: SideNavigationViewController, point: CGPoint, position: SideNavigationPosition) {
		print("Did Tap for", .Left == position ? "Left" : "Right", "view.")
	}
}
