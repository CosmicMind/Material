/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

@objc(SearchBarAlignment)
public enum SearchBarAlignment: Int {
    case top
    case bottom
}

public extension UIViewController {
    /**
     A convenience property that provides access to the SearchBarController.
     This is the recommended method of accessing the SearchBarController
     through child UIViewControllers.
     */
    var searchBarController: SearchBarController? {
        return traverseViewControllerHierarchyForClassType()
    }
}

open class SearchBarController: StatusBarController {
    /// Reference to the SearchBar.
    @IBInspectable
    open let searchBar = SearchBar()
	
    /// The searchBar alignment.
    open var searchBarAlignment = SearchBarAlignment.top {
        didSet {
            layoutSubviews()
        }
    }
    
	open override func layoutSubviews() {
		super.layoutSubviews()
        layoutSearchBar()
        layoutContainer()
        layoutRootViewController()
	}
	
	open override func prepare() {
		super.prepare()
        displayStyle = .partial
        
    	prepareSearchBar()
	}
}

fileprivate extension SearchBarController {
    /// Prepares the searchBar.
    func prepareSearchBar() {
        searchBar.zPosition = 1000
        searchBar.depthPreset = .depth1
        view.addSubview(searchBar)
    }
}

fileprivate extension SearchBarController {
    /// Layout the container.
    func layoutContainer() {
        switch displayStyle {
        case .partial:
            let p = searchBar.height
            let q = statusBarOffsetAdjustment
            let h = view.height - p - q
            
            switch searchBarAlignment {
            case .top:
                container.y = q + p
                container.height = h
            case .bottom:
                container.y = q
                container.height = h
            }
            
            container.width = view.width
            
        case .full:
            container.frame = view.bounds
        }
    }
    
    /// Layout the searchBar.
    func layoutSearchBar() {
        searchBar.x = 0
        searchBar.y = .top == searchBarAlignment ? statusBarOffsetAdjustment : view.height - searchBar.height
        searchBar.width = view.width
    }
    
    /// Layout the rootViewController.
    func layoutRootViewController() {
        rootViewController.view.frame = container.bounds
    }
}
