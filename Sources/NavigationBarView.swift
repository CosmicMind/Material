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

public class NavigationBarView : MaterialView {
	/**
	:name:	statusBarStyle
	*/
	public var statusBarStyle: UIStatusBarStyle = UIApplication.sharedApplication().statusBarStyle {
		didSet {
			UIApplication.sharedApplication().statusBarStyle = statusBarStyle
		}
	}
	
	/**
	:name:	contentInsets
	*/
	public var contentInsetPreset: MaterialEdgeInset = .None {
		didSet {
			contentInset = MaterialEdgeInsetToValue(contentInsetPreset)
		}
	}
	
	/**
	:name:	contentInset
	*/
	public var contentInset: UIEdgeInsets = UIEdgeInsets(top: 24, left: 8, bottom: 8, right: 8) {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	titleLabel
	*/
	public var titleLabel: UILabel? {
		didSet {
			titleLabel?.translatesAutoresizingMaskIntoConstraints = false
			reloadView()
		}
	}
	
	/**
	:name:	detailLabel
	*/
	public var detailLabel: UILabel? {
		didSet {
			detailLabel?.translatesAutoresizingMaskIntoConstraints = false
			reloadView()
		}
	}
	
	/**
	:name:	leftControls
	*/
	public var leftControls: Array<UIControl>? {
		didSet {
			if let v = leftControls {
				for c in v {
//					c.translatesAutoresizingMaskIntoConstraints = false
				}
			}
			reloadView()
		}
	}
	
	/**
	:name:	rightControls
	*/
	public var rightControls: Array<UIControl>? {
		didSet {
			if let v: Array<UIControl> = rightControls {
				for c in v {
					c.translatesAutoresizingMaskIntoConstraints = false
				}
			}
			reloadView()
		}
	}
	
	/**
	:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
	:name:	init
	*/
	public override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	/**
	:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 70))
	}
	
	/**
	:name:	init
	*/
	public convenience init?(titleLabel: UILabel? = nil, detailLabel: UILabel? = nil, leftControls: Array<UIControl>? = nil, rightControls: Array<UIControl>? = nil) {
		self.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 70))
		prepareProperties(titleLabel, detailLabel: detailLabel, leftControls: leftControls, rightControls: rightControls)
	}
	
	/**
	:name:	reloadView
	*/
	public func reloadView() {
		// clear constraints so new ones do not conflict
		removeConstraints(constraints)
		for v in subviews {
			v.removeFromSuperview()
		}
		
		
		var views: Dictionary<String, UIView> = Dictionary<String, UIView>()
		var h: String = "H:|"
		
		
		// leftControls
		if let v: Array<UIControl> = leftControls {
			if 0 < v.count {
				var i: Int = 0
				for c in v {
					let k: String = "c\(i)"

					views[k] = c

					if 0 == i++ {
						h += "-(left)-"
					} else {
						h += "-(spacing)-"
					}
					
					h += "[\(k)]"

					addSubview(c)
					c.grid.columns = 1
					
//					if 0 < c.bounds.width {
//						MaterialLayout.size(self, child: c, width: c.bounds.width, height: c.bounds.height)
//					}
					if let btn: UIButton = c as? UIButton {
						btn.contentEdgeInsets = UIEdgeInsetsZero
					}
//					MaterialLayout.alignToParentVertically(self, child: c, top: contentInset.top, bottom: contentInset.bottom)
				}
			}
		}
		
		grid.contentInset.top = 20
		grid.contentInset.bottom = 10
		grid.columns = 10
		grid.views = leftControls
		
		
//		addConstraints(MaterialLayout.constraint(h + "|", options: [], metrics: ["left" : contentInset.left, "spacing" : 8], views: views))
	}
	
	/**
	:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		depth = .Depth1
	}
	
	/**
	:name:	prepareProperties
	*/
	internal func prepareProperties(titleLabel: UILabel?, detailLabel: UILabel?, leftControls: Array<UIControl>?, rightControls: Array<UIControl>?) {
		self.titleLabel = titleLabel
		self.detailLabel = detailLabel
		self.leftControls = leftControls
		self.rightControls = rightControls
	}
}
