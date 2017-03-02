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

open class BottomNavigationController: UITabBarController {
	/**
     An initializer that initializes the object with a NSCoder object.
     - Parameter aDecoder: A NSCoder instance.
     */
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
     An initializer that initializes the object with an Optional nib and bundle.
     - Parameter nibNameOrNil: An Optional String for the nib.
     - Parameter bundle: An Optional NSBundle where the nib is located.
     */
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
    /// An initializer that accepts no parameters.
	public init() {
		super.init(nibName: nil, bundle: nil)
	}
    
    /**
     An initializer that initializes the object an Array of UIViewControllers.
     - Parameter viewControllers: An Array of UIViewControllers.
     */
    public init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		prepare()
	}
	
	open override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		layoutSubviews()
	}
	
	open func layoutSubviews() {
		if let v = tabBar.items {
			for item in v {
				if .phone == Device.userInterfaceIdiom {
					if nil == item.title {
						let inset: CGFloat = 7
						item.imageInsets = UIEdgeInsetsMake(inset, 0, -inset, 0)
					} else {
						let inset: CGFloat = 6
						item.titlePositionAdjustment.vertical = -inset
					}
				} else {
					if nil == item.title {
						let inset: CGFloat = 9
						item.imageInsets = UIEdgeInsetsMake(inset, 0, -inset, 0)
					} else {
						let inset: CGFloat = 3
						item.imageInsets = UIEdgeInsetsMake(inset, 0, -inset, 0)
						item.titlePositionAdjustment.vertical = -inset
					}
				}
			}
		}
        
        tabBar.divider.reload()
	}
	
	/**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
	open func prepare() {
		view.clipsToBounds = true
		view.contentScaleFactor = Screen.scale
		view.backgroundColor = .white
        prepareTabBar()
	}
	
	/// Prepares the tabBar.
	private func prepareTabBar() {
		tabBar.heightPreset = .normal
        tabBar.depthPreset = .depth1
        tabBar.dividerAlignment = .top
        let image = UIImage()
		tabBar.shadowImage = image
		tabBar.backgroundImage = image
		tabBar.backgroundColor = .white
	}
}
