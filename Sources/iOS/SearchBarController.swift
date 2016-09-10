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
 *	*	Neither the name of CosmicMind nor the names of its
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

extension UIViewController {
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
			viewController = viewController?.parent
		}
		return nil
	}
}

open class SearchBarController: RootController {
	/// Reference to the SearchBar.
    open private(set) lazy var searchBar: SearchBar = SearchBar()
	
	/**
     To execute in the order of the layout chain, override this
     method. LayoutSubviews should be called immediately, unless you
     have a certain need.
     */
	open override func layoutSubviews() {
		super.layoutSubviews()
        
        searchBar.grid.layoutEdgeInsets.top = .phone == Device.userInterfaceIdiom && Device.isLandscape ? 0 : 20
        
        let p = searchBar.intrinsicContentSize.height + searchBar.grid.layoutEdgeInsets.top + searchBar.grid.layoutEdgeInsets.bottom
        
        searchBar.width = view.width + searchBar.grid.layoutEdgeInsets.left + searchBar.grid.layoutEdgeInsets.right
        searchBar.height = p
        
        rootViewController.view.y = p
        rootViewController.view.height = view.height - p
	}
	
	/**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
	open override func prepare() {
		super.prepare()
		prepareSearchBar()
	}
	
	/// Prepares the searchBar.
	private func prepareSearchBar() {
        searchBar.depthPreset = .depth1
        searchBar.zPosition = 1000
        view.addSubview(searchBar)
	}
}
