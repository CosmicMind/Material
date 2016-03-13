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
	private var shareButton: FlatButton!
	
	/// MaterialCollectionView.
	private var collectionView: MaterialCollectionView!
	
	/// Image thumbnail height.
	private var thumbnailHieght: CGFloat = 300
	
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
		prepareTitleLabel()
		prepareShareButton()
		prepareNavigationBar()
		prepareImageCardView()
	}
	
	/// Handler for shareButton.
	internal func handleShareButton() {
		print("Share Button Pressed")
	}
	
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
	
	/// Prepares the titleLabel.
	private func prepareTitleLabel() {
		titleLabel = UILabel()
		titleLabel.text = "Recipe"
		titleLabel.textAlignment = .Left
		titleLabel.textColor = MaterialColor.white
	}
	
	/// Prepares the detailLabel.
	private func prepareDetailLabel() {
		detailLabel = UILabel()
		detailLabel.text = "January 22, 2016"
		detailLabel.textAlignment = .Left
		detailLabel.textColor = MaterialColor.white
	}
	
	/// Prepares the shareButton.
	private func prepareShareButton() {
		let image: UIImage? = MaterialIcon.share
		shareButton = FlatButton()
		shareButton.pulseScale = false
		shareButton.pulseColor = MaterialColor.white
		shareButton.setImage(image, forState: .Normal)
		shareButton.setImage(image, forState: .Highlighted)
		shareButton.addTarget(self, action: "handleShareButton", forControlEvents: .TouchUpInside)
	}
	
	/// Prepares view.
	private func prepareNavigationBar() {
		navigationItem.titleLabel = titleLabel
		navigationItem.detailLabel = detailLabel
		navigationItem.rightControls = [shareButton]
	}
	
	/// Prepares the imageCardView.
	private func prepareImageCardView() {
		if let data: Dictionary<String, AnyObject> =  dataSource.data as? Dictionary<String, AnyObject> {
			let height: CGFloat = 300
			
			imageCardView = ImageCardView()
			
			imageCardView.pulseScale = false
			imageCardView.pulseColor = nil
			imageCardView.divider = false
			imageCardView.depth = .None
			imageCardView.contentInsetPreset = .Square3
			imageCardView.cornerRadiusPreset = .None
			
			imageCardView.titleLabel = UILabel()
			imageCardView.titleLabel?.text = data["title"] as? String
			imageCardView.titleLabel?.textColor = MaterialColor.grey.darken4
			imageCardView.titleLabel?.font = RobotoFont.regularWithSize(20)
			imageCardView.titleLabelInset.top = height
			
			let detailLabel: UILabel = UILabel()
			detailLabel.text = data["detail"] as? String
			detailLabel.textColor = MaterialColor.grey.darken2
			detailLabel.font = RobotoFont.regular
			detailLabel.numberOfLines = 0
			
			imageCardView.detailView = detailLabel
			imageCardView.detailViewInset.top = 52
			
			// Asynchronously the load image.
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { [weak self] in
				if let v: CGFloat = self?.view.bounds.width {
					let image: UIImage? = UIImage(named: data["image"] as! String)?.resize(toWidth: v)?.crop(toWidth: v, toHeight: height)
					dispatch_sync(dispatch_get_main_queue()) { [weak self] in
						self?.imageCardView.image = image
					}
				}
			}

			view.addSubview(imageCardView)
			imageCardView.translatesAutoresizingMaskIntoConstraints = false
			MaterialLayout.alignFromTop(view, child: imageCardView)
			MaterialLayout.alignToParentHorizontally(view, child: imageCardView)
		}
	}
}
