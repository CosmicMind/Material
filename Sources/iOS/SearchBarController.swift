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

public extension UIViewController {
	/**
	A convenience property that provides access to the SearchBarController.
	This is the recommended method of accessing the SearchBarController
	through child UIViewControllers.
	*/
	public var searchBarController: SearchBarController? {
		var viewController: UIViewController? = self
		while nil != viewController {
			if viewController is SearchBarController {
				return viewController as? SearchBarController
			}
			viewController = viewController?.parentViewController
		}
		return nil
	}
}

public class SearchBarController : BarController {
	/// Reference to the SearchBar.
	public private(set) var searchBar: SearchBar!
	
	public override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		layoutSubviews()
	}
	
	/// Layout subviews.
	public func layoutSubviews() {
		if let v: SearchBar = searchBar {
			v.grid.layoutInset.top = .iPhone == MaterialDevice.type && MaterialDevice.isLandscape ? 0 : 20
			
			let h: CGFloat = MaterialDevice.height
			let w: CGFloat = MaterialDevice.width
			let p: CGFloat = v.intrinsicContentSize().height + v.grid.layoutInset.top + v.grid.layoutInset.bottom
			
			v.width = w + v.grid.layoutInset.left + v.grid.layoutInset.right
			v.height = p
			
			rootViewController.view.frame.origin.y = p
			rootViewController.view.frame.size.height = h - p
		}
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public override func prepareView() {
		super.prepareView()
		prepareSearchBar()
	}
	
	/// Prepares the SearchBar.
	private func prepareSearchBar() {
		if nil == searchBar {
			searchBar = SearchBar()
			searchBar.zPosition = 1000
			view.addSubview(searchBar)
		}
	}
}
