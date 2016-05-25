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

public enum TabBarLineAlignment {
	case Top
	case Bottom
}

public class TabBar : MaterialView {
	/// A reference to the line UIView.
	public private(set) var line: UIView!
	
	/// A value for the line alignment.
	public var lineAlignment: TabBarLineAlignment = .Bottom {
		didSet {
			layoutSubviews()
		}
	}
	
	/// Will render the view.
	public var willRenderView: Bool {
		return 0 < width
	}
	
	/// Buttons.
	public var buttons: Array<UIButton>? {
		didSet {
			if let v: Array<UIButton> = oldValue {
				for b in v {
					b.removeFromSuperview()
				}
			}
			
			if let v: Array<UIButton> = buttons {
				for b in v {
					addSubview(b)
				}
			}
			layoutSubviews()
		}
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		if willRenderView {
			if let v: Array<UIButton> = buttons {
				if 0 < v.count {
					let columns: Int = grid.axis.columns / v.count
					for b in v {
						b.grid.columns = columns
						b.contentEdgeInsets = UIEdgeInsetsZero
						b.layer.cornerRadius = 0
						b.removeTarget(self, action: #selector(handleButton(_:)), forControlEvents: .TouchUpInside)
						b.addTarget(self, action: #selector(handleButton(_:)), forControlEvents: .TouchUpInside)
					}
					grid.views = v as Array<UIView>
					line.frame = CGRectMake(0, .Bottom == lineAlignment ? height - 3 : 0, v.first!.frame.width, 3)
				}
			}
		}
	}
	
	/// Handles the button touch event.
	internal func handleButton(button: UIButton) {
		UIView.animateWithDuration(0.25, animations: { [weak self] in
			if let s: TabBar = self {
				s.line.frame.origin.x = button.frame.origin.x
				s.line.frame.size.width = button.frame.size.width
			}
		})
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
		autoresizingMask = .FlexibleWidth
		contentScaleFactor = MaterialDevice.scale
		prepareBottomLayer()
	}
	
	// Prepares the bottomLayer.
	private func prepareBottomLayer() {
		line = UIView()
		line.backgroundColor = MaterialColor.yellow.base
		addSubview(line)
	}
}