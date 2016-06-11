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
    var name: String
    var mdIcon: UIImage?
    var cmIcon: UIImage?
}

class ViewController: UIViewController {
	/// A tableView used to display Bond entries.
	private let tableView: UITableView = UITableView()
	
    /// A list of all the Icons.
    private var icons: Array<Item> = Array<Item>()
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
		prepareView()
		prepareItems()
		prepareTableView()
	}
	
	/// Prepares view.
	private func prepareView() {
        view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the items Array.
    private func prepareItems() {
        icons.append(Item(name: "add", mdIcon: MaterialIcon.add, cmIcon: MaterialIcon.cm.add))
        icons.append(Item(name: "addCircle", mdIcon: MaterialIcon.addCircle, cmIcon: nil))
        icons.append(Item(name: "addCircleOutline", mdIcon: MaterialIcon.addCircleOutline, cmIcon: nil))
        icons.append(Item(name: "arrowBack", mdIcon: MaterialIcon.arrowBack, cmIcon: MaterialIcon.cm.arrowBack))
        icons.append(Item(name: "arrowDownward", mdIcon: MaterialIcon.arrowDownward, cmIcon: MaterialIcon.cm.arrowDownward))
        icons.append(Item(name: "audio", mdIcon: MaterialIcon.audio, cmIcon: MaterialIcon.cm.audio))
		icons.append(Item(name: "bell", mdIcon: nil, cmIcon: MaterialIcon.cm.bell))
		icons.append(Item(name: "check", mdIcon: MaterialIcon.check, cmIcon: MaterialIcon.cm.check))
		icons.append(Item(name: "clear", mdIcon: MaterialIcon.clear, cmIcon: MaterialIcon.cm.clear))
		icons.append(Item(name: "close", mdIcon: MaterialIcon.close, cmIcon: MaterialIcon.cm.close))
        icons.append(Item(name: "edit", mdIcon: MaterialIcon.edit, cmIcon: MaterialIcon.cm.edit))
		icons.append(Item(name: "favorite", mdIcon: MaterialIcon.favorite, cmIcon: nil))
		icons.append(Item(name: "favoriteBorder", mdIcon: MaterialIcon.favoriteBorder, cmIcon: nil))
		icons.append(Item(name: "history", mdIcon: MaterialIcon.history, cmIcon: nil))
		icons.append(Item(name: "home", mdIcon: MaterialIcon.home, cmIcon: nil))
		icons.append(Item(name: "image", mdIcon: MaterialIcon.image, cmIcon: MaterialIcon.cm.image))
        icons.append(Item(name: "menu", mdIcon: MaterialIcon.menu, cmIcon: MaterialIcon.cm.menu))
		icons.append(Item(name: "microphone", mdIcon: nil, cmIcon: MaterialIcon.cm.microphone))
		icons.append(Item(name: "moreVertical", mdIcon: MaterialIcon.moreHorizontal, cmIcon: MaterialIcon.cm.moreHorizontal))
        icons.append(Item(name: "moreHorizontal", mdIcon: MaterialIcon.moreVertical, cmIcon: MaterialIcon.cm.moreVertical))
        icons.append(Item(name: "movie", mdIcon: MaterialIcon.movie, cmIcon: MaterialIcon.cm.movie))
		icons.append(Item(name: "pause", mdIcon: nil, cmIcon: MaterialIcon.cm.pause))
		icons.append(Item(name: "pen", mdIcon: MaterialIcon.pen, cmIcon: MaterialIcon.cm.pen))
        icons.append(Item(name: "place", mdIcon: MaterialIcon.place, cmIcon: nil))
        icons.append(Item(name: "photoCamera", mdIcon: MaterialIcon.photoCamera, cmIcon: MaterialIcon.cm.photoCamera))
        icons.append(Item(name: "photoLibrary", mdIcon: MaterialIcon.photoLibrary, cmIcon: MaterialIcon.cm.photoLibrary))
		icons.append(Item(name: "play", mdIcon: nil, cmIcon: MaterialIcon.cm.play))
		icons.append(Item(name: "search", mdIcon: MaterialIcon.search, cmIcon: MaterialIcon.cm.search))
        icons.append(Item(name: "settings", mdIcon: MaterialIcon.settings, cmIcon: MaterialIcon.cm.settings))
        icons.append(Item(name: "share", mdIcon: MaterialIcon.share, cmIcon: MaterialIcon.cm.share))
		icons.append(Item(name: "shuffle", mdIcon: nil, cmIcon: MaterialIcon.cm.shuffle))
		icons.append(Item(name: "skipBackward", mdIcon: nil, cmIcon: MaterialIcon.cm.skipBackward))
		icons.append(Item(name: "skipForward", mdIcon: nil, cmIcon: MaterialIcon.cm.skipForward))
		icons.append(Item(name: "star", mdIcon: MaterialIcon.star, cmIcon: MaterialIcon.cm.star))
        icons.append(Item(name: "starBorder", mdIcon: MaterialIcon.starBorder, cmIcon: nil))
        icons.append(Item(name: "starHalf", mdIcon: MaterialIcon.starHalf, cmIcon: nil))
		icons.append(Item(name: "videocam", mdIcon: MaterialIcon.videocam, cmIcon: MaterialIcon.cm.videocam))
		icons.append(Item(name: "visibility", mdIcon: MaterialIcon.visibility, cmIcon: nil))
		icons.append(Item(name: "volumeHigh", mdIcon: nil, cmIcon: MaterialIcon.cm.volumeHigh))
		icons.append(Item(name: "volumeMedium", mdIcon: nil, cmIcon: MaterialIcon.cm.volumeMedium))
		icons.append(Item(name: "volumeOff", mdIcon: nil, cmIcon: MaterialIcon.cm.volumeOff))
	}
	
	/// Prepares the tableView.
	private func prepareTableView() {
        view.layout(tableView).edges(top: 20)
        tableView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "Cell")
		tableView.dataSource = self
        tableView.delegate = self
        
	}
    
    private func image(iconName:String!) -> UIImage? {
        
        return nil
    }
}

/// TableViewDataSource methods.
extension ViewController: UITableViewDataSource {
	/// Determines the number of rows in the tableView.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count;
	}
	
	/// Returns the number of sections.
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	/// Prepares the cells within the tableView.
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
        
        let item: Item = icons[indexPath.row]
		cell.selectionStyle = .None
		cell.textLabel!.text = item.name
		cell.textLabel!.font = RobotoFont.regular
        cell.textLabel?.textAlignment = .Center
		cell.imageView!.image = item.mdIcon
        cell.imageView!.contentMode = .Center
        
		let imageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, 24, 24))
            imageView.image = item.cmIcon
            
        cell.accessoryView = imageView
		return cell
	}
}

/// UITableViewDelegate methods.
extension ViewController: UITableViewDelegate {
	/// Sets the tableView cell height.
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 44
	}
    
	/// Sets the tableView header height.
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let v: UIView = UIView()
        v.backgroundColor = MaterialColor.grey.lighten4
		
		let leftLabel: UILabel = UILabel()
        leftLabel.grid.columns = 5
		leftLabel.grid.offset.columns = 1
		leftLabel.text = "Google Icons"
		
		let rightLabel: UILabel = UILabel()
        rightLabel.grid.columns = 5
		rightLabel.text = "CosmicMind Icons"
        rightLabel.textAlignment = .Right
        
        v.addSubview(leftLabel)
        v.addSubview(rightLabel)
        
        v.grid.views = [leftLabel, rightLabel]
        
        return v
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.grid.reloadLayout()
    }
}
