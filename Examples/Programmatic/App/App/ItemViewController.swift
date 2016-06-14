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

class ItemViewController: UIViewController {
	/// MaterialDataSourceItem.
	private var dataSource: MaterialDataSourceItem!
	
	/// ImageCardView to display item.
	private var imageCardView: ImageCardView!
	
	/// NavigationBar title label.
	private var titleLabel: UILabel!
	
	/// NavigationBar detail label.
	private var detailLabel: UILabel!
	
	/// NavigationBar share button.
	private var shareButton: IconButton!
	
	/// MaterialScrollView.
	private var scrollView: UIScrollView!
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	convenience init(dataSource: MaterialDataSourceItem) {
		self.init(nibName: nil, bundle: nil)
		self.dataSource = dataSource
	}

	required init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareShareButton()
		prepareNavigationItem()
		prepareScrollView()
		prepareImageCardView()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationDrawerController?.enabled = false
		(menuController as? AppMenuController)?.hideMenuView()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		scrollView.frame = view.bounds
		scrollView.removeConstraints(scrollView.constraints)
		
		scrollView.layout(imageCardView).width(scrollView.bounds.width)
		imageCardView.layoutIfNeeded()
		
		scrollView.contentSize = CGSizeMake(view.bounds.width, imageCardView.height)
		
		imageCardView.reloadView()
		imageCardView.contentsGravityPreset = .ResizeAspectFill
		imageCardView.titleLabelInset.top = imageCardView.imageLayer!.frame.height
	}
	
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
		automaticallyAdjustsScrollViewInsets = false
	}
	
	/// Prepares the shareButton.
	private func prepareShareButton() {
		let image: UIImage? = MaterialIcon.cm.share
		shareButton = IconButton()
		shareButton.pulseColor = MaterialColor.white
		shareButton.setImage(image, forState: .Normal)
		shareButton.setImage(image, forState: .Highlighted)
	}
	
	/// Prepares the navigationItem.
	private func prepareNavigationItem() {
		navigationItem.title = "Item"
		navigationItem.titleLabel.textAlignment = .Left
		navigationItem.titleLabel.textColor = MaterialColor.white
		
		navigationItem.detail = "January 22, 2016"
		navigationItem.detailLabel.textAlignment = .Left
		navigationItem.detailLabel.textColor = MaterialColor.white
		
		navigationItem.rightControls = [shareButton]
	}
	
	/// Prepares the scrollView.
	private func prepareScrollView() {
		scrollView = UIScrollView(frame: view.bounds)
		view.addSubview(scrollView)
	}
	
	/// Prepares the imageCardView.
	private func prepareImageCardView() {
		if let data: Dictionary<String, AnyObject> =  dataSource.data as? Dictionary<String, AnyObject> {
			
			imageCardView = ImageCardView()
			
			imageCardView.pulseAnimation = .None
			imageCardView.divider = false
			imageCardView.depth = .None
			imageCardView.contentInsetPreset = .Square3
			imageCardView.cornerRadiusPreset = .None
			imageCardView.maxImageHeight = 300
			
			imageCardView.titleLabel = UILabel()
			imageCardView.titleLabel?.text = data["title"] as? String
			imageCardView.titleLabel?.textColor = MaterialColor.grey.darken4
			imageCardView.titleLabel?.font = RobotoFont.regularWithSize(20)

			let detailLabel: UILabel = UILabel()
			detailLabel.text = data["detail"] as? String
			detailLabel.textColor = MaterialColor.grey.darken2
			detailLabel.font = RobotoFont.regular
			detailLabel.numberOfLines = 0

			imageCardView.contentView = detailLabel
			imageCardView.contentViewInset.top = 52

			let image: UIImage? = UIImage(named: data["image"] as! String)
			imageCardView.image = image
            
            scrollView.addSubview(imageCardView)
            imageCardView.translatesAutoresizingMaskIntoConstraints = false
		}
	}
}
