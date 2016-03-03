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
	A convenience property that provides access to the SearchBarViewController.
	This is the recommended method of accessing the SearchBarViewController
	through child UIViewControllers.
	*/
	public var searchBarViewController: SearchBarViewController? {
		var viewController: UIViewController? = self
		while nil != viewController {
			if viewController is SearchBarViewController {
				return viewController as? SearchBarViewController
			}
			viewController = viewController?.parentViewController
		}
		return nil
	}
}

public class SearchBarViewController: StatusBarViewController {
	/// The height of the StatusBar.
	public override var heightForStatusBar: CGFloat {
		get {
			return searchBarView.heightForStatusBar
		}
		set(value) {
			searchBarView.heightForStatusBar = value
		}
	}
	
	/// The height when in Portrait orientation mode.
	public override var heightForPortraitOrientation: CGFloat {
		get {
			return searchBarView.heightForPortraitOrientation
		}
		set(value) {
			searchBarView.heightForPortraitOrientation = value
		}
	}
	
	/// The height when in Landscape orientation mode.
	public override var heightForLandscapeOrientation: CGFloat {
		get {
			return searchBarView.heightForLandscapeOrientation
		}
		set(value) {
			searchBarView.heightForLandscapeOrientation = value
		}
	}
	
	/// Reference to the SearchBarView.
	public private(set) lazy var searchBarView: SearchBarView = SearchBarView()
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public override func prepareView() {
		super.prepareView()
		prepareSearchBarView()
	}
	
	/// Prepares the SearchBarView.
	private func prepareSearchBarView() {
		searchBarView.zPosition = 1000
		view.addSubview(searchBarView)
	}
}
