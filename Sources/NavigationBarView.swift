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
	public var contentInsetPreset: MaterialEdgeInsetPreset = .None {
		didSet {
			contentInset = MaterialEdgeInsetPresetToValue(contentInsetPreset)
		}
	}
	
	/**
	:name:	contentInset
	*/
	public var contentInset: UIEdgeInsets = MaterialEdgeInsetPresetToValue(.Square2) {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	titleLabelInsets
	*/
	public var titleLabelInsetPreset: MaterialEdgeInsetPreset = .None {
		didSet {
			titleLabelInset = MaterialEdgeInsetPresetToValue(titleLabelInsetPreset)
		}
	}
	
	/**
	:name:	titleLabelInset
	*/
	public var titleLabelInset: UIEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0) {
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
	:name:	detailLabelInsets
	*/
	public var detailLabelInsetPreset: MaterialEdgeInsetPreset = .None {
		didSet {
			detailLabelInset = MaterialEdgeInsetPresetToValue(detailLabelInsetPreset)
		}
	}
	
	/**
	:name:	detailLabelInset
	*/
	public var detailLabelInset: UIEdgeInsets = MaterialEdgeInsetPresetToValue(.None) {
		didSet {
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
	:name:	leftButtonsInsets
	*/
	public var leftButtonsInsetPreset: MaterialEdgeInsetPreset = .None {
		didSet {
			leftButtonsInset = MaterialEdgeInsetPresetToValue(leftButtonsInsetPreset)
		}
	}
	
	/**
	:name:	leftButtonsInset
	*/
	public var leftButtonsInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0) {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	leftButtons
	*/
	public var leftButtons: Array<UIButton>? {
		didSet {
			if let v = leftButtons {
				for b in v {
					b.translatesAutoresizingMaskIntoConstraints = false
				}
			}
			reloadView()
		}
	}
	
	/**
	:name:	rightButtonsInsets
	*/
	public var rightButtonsInsetPreset: MaterialEdgeInsetPreset = .None {
		didSet {
			rightButtonsInset = MaterialEdgeInsetPresetToValue(rightButtonsInsetPreset)
		}
	}
	
	/**
	:name:	rightButtonsInset
	*/
	public var rightButtonsInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0) {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	rightButtons
	*/
	public var rightButtons: Array<UIButton>? {
		didSet {
			if let v = rightButtons {
				for b in v {
					b.translatesAutoresizingMaskIntoConstraints = false
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
	public convenience init?(titleLabel: UILabel? = nil, detailLabel: UILabel? = nil, leftButtons: Array<UIButton>? = nil, rightButtons: Array<UIButton>? = nil) {
		self.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 70))
		prepareProperties(titleLabel, detailLabel: detailLabel, leftButtons: leftButtons, rightButtons: rightButtons)
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
		
		var verticalFormat: String = "V:|"
		var views: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
		var metrics: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
		
		if nil != titleLabel {
			verticalFormat += "-(insetTop)"
			metrics["insetTop"] = contentInset.top + titleLabelInset.top
		} else if nil != detailLabel {
			verticalFormat += "-(insetTop)"
			metrics["insetTop"] = contentInset.top + detailLabelInset.top
		}
		
		// title
		if let v = titleLabel {
			verticalFormat += "-[titleLabel]"
			views["titleLabel"] = v
			
			addSubview(v)
			MaterialLayout.alignToParentHorizontally(self, child: v, left: contentInset.left + titleLabelInset.left, right: contentInset.right + titleLabelInset.right)
		}
		
		// detail
		if let v = detailLabel {
			if nil != titleLabel {
				verticalFormat += "-(insetB)"
				metrics["insetB"] = titleLabelInset.bottom + detailLabelInset.top
			}
			
			verticalFormat += "-[detailLabel]"
			views["detailLabel"] = v
			
			addSubview(v)
			MaterialLayout.alignToParentHorizontally(self, child: v, left: contentInset.left + detailLabelInset.left, right: contentInset.right + detailLabelInset.right)
		}
		
		// leftButtons
		if let v = leftButtons {
			if 0 < v.count {
				var h: String = "H:|"
				var d: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				var i: Int = 0
				for b in v {
					let k: String = "b\(i)"
					
					d[k] = b
					
					if 0 == i++ {
						h += "-(left)-"
					} else {
						h += "-(left_right)-"
					}
					
					h += "[\(k)]"
					
					addSubview(b)
					MaterialLayout.alignFromBottom(self, child: b, bottom: contentInset.bottom + leftButtonsInset.bottom)
				}
				
				addConstraints(MaterialLayout.constraint(h, options: [], metrics: ["left" : contentInset.left + leftButtonsInset.left, "left_right" : leftButtonsInset.left + leftButtonsInset.right], views: d))
			}
		}
		
		// rightButtons
		if let v = rightButtons {
			if 0 < v.count {
				var h: String = "H:"
				var d: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				var i: Int = v.count - 1
				
				for b in v {
					let k: String = "b\(i)"
					
					d[k] = b
					
					h += "[\(k)]"
					
					if 0 == i-- {
						h += "-(right)-"
					} else {
						h += "-(right_left)-"
					}
					
					addSubview(b)
					MaterialLayout.alignFromBottom(self, child: b, bottom: contentInset.bottom + rightButtonsInset.bottom)
				}
				
				addConstraints(MaterialLayout.constraint(h + "|", options: [], metrics: ["right" : contentInset.right + rightButtonsInset.right, "right_left" : rightButtonsInset.right + rightButtonsInset.left], views: d))
			}
		}
		
		if nil != detailLabel {
			if nil == metrics["insetC"] {
				metrics["insetBottom"] = contentInset.bottom + detailLabelInset.bottom
			} else {
				metrics["insetC"] = (metrics["insetC"] as! CGFloat) + detailLabelInset.bottom
			}
		} else if nil != titleLabel {
			if nil == metrics["insetC"] {
				metrics["insetBottom"] = contentInset.bottom + titleLabelInset.bottom
			} else {
				metrics["insetC"] = (metrics["insetC"] as! CGFloat) + titleLabelInset.bottom
			}
		}
		
		if 0 < views.count {
			verticalFormat += "-(insetBottom)-|"
			addConstraints(MaterialLayout.constraint(verticalFormat, options: [], metrics: metrics, views: views))
		}
	}
	
	/**
	:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		depth = .Depth2
	}
	
	/**
	:name:	prepareProperties
	*/
	internal func prepareProperties(titleLabel: UILabel?, detailLabel: UILabel?, leftButtons: Array<UIButton>?, rightButtons: Array<UIButton>?) {
		self.titleLabel = titleLabel
		self.detailLabel = detailLabel
		self.leftButtons = leftButtons
		self.rightButtons = rightButtons
	}
}
