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
	/// TitleView that holds the titleLabel and detailLabel.
	public private(set) lazy var titleView: MaterialView = MaterialView()
	
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
	public var contentInset: UIEdgeInsets = MaterialEdgeInsetToValue(.Square2) {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	titleLabel
	*/
	public var titleLabel: UILabel? {
		didSet {
			if let v: UILabel = titleLabel {
				v.grid.rows = nil == detailLabel ? 3 : 2
				titleView.addSubview(v)
			}
			reloadView()
		}
	}
	
	/**
	:name:	detailLabel
	*/
	public var detailLabel: UILabel? {
		didSet {
			if let v: UILabel = detailLabel {
				v.grid.rows = 1
				titleView.addSubview(v)
				titleLabel?.grid.rows = 2
			} else {
				titleLabel?.grid.rows = 3
			}
			reloadView()
		}
	}
	
	/**
	:name:	leftControls
	*/
	public var leftControls: Array<UIControl>? {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	rightControls
	*/
	public var rightControls: Array<UIControl>? {
		didSet {
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
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		reloadView()
	}
	
	public override func didMoveToSuperview() {
		super.didMoveToSuperview()
		reloadView()
	}
	
	/**
	:name:	reloadView
	*/
	public func reloadView() {
		layoutIfNeeded()
		
		// clear constraints so new ones do not conflict
		removeConstraints(constraints)
		for v in subviews {
			if v != titleView {
				v.removeFromSuperview()
			}
		}
		
		// Size of single grid column.
		let g: CGFloat = width / CGFloat(0 < grid.columns ? grid.columns : 1)
		
		grid.views = []
		titleView.grid.columns = grid.axis.columns
		
		// leftControls
		if let v: Array<UIControl> = leftControls {
			for c in v {
				let w: CGFloat = c.intrinsicContentSize().width
				if let b: UIButton = c as? UIButton {
					b.contentEdgeInsets = UIEdgeInsetsZero
				}
				
				c.grid.columns = 0 == g ? 1 : Int(ceil(w / g))
				titleView.grid.columns -= c.grid.columns
				
				addSubview(c)
				grid.views?.append(c)
			}
		}
		
		grid.views?.append(titleView)
		
		// rightControls
		if let v: Array<UIControl> = rightControls {
			for c in v {
				let w: CGFloat = c.intrinsicContentSize().width
				if let b: UIButton = c as? UIButton {
					b.contentEdgeInsets = UIEdgeInsetsZero
				}
				
				c.grid.columns = 0 == g ? 1 : Int(ceil(w / g))
				titleView.grid.columns -= c.grid.columns
				
				addSubview(c)
				grid.views?.append(c)
			}
		}
		
		titleView.grid.columns -= titleView.grid.offset.columns
		
		grid.reloadLayout()
		
		titleView.grid.views = []
		if let v: UILabel = titleLabel {
			titleView.grid.views?.append(v)
		}
		if let v: UILabel = detailLabel {
			titleView.grid.views?.append(v)
		}
		titleView.grid.reloadLayout()
	}
	
	/**
	:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		super.prepareView()
		grid.spacing = 10
		grid.axis.columns = 8
		grid.axis.inherited = false
		grid.contentInset.top = 25
		grid.contentInset.left = 10
		grid.contentInset.bottom = 10
		grid.contentInset.right = 10
		depth = .Depth1
		prepareTextView()
	}
	
	public func prepareTextView() {
		titleView.backgroundColor = nil
		titleView.grid.spacing = 4
		titleView.grid.axis.rows = 3
		titleView.grid.axis.inherited = false
		titleView.grid.axis.direction = .Vertical
		addSubview(titleView)
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
