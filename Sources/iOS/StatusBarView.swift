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

public class StatusBarView : ControlView {
	/// The height of the StatusBar.
	@IBInspectable public var heightForStatusBar: CGFloat = 20
	
	/// The height when in Portrait orientation mode.
	@IBInspectable public var heightForPortraitOrientation: CGFloat = 64
	
	/// The height when in Landscape orientation mode.
	@IBInspectable public var heightForLandscapeOrientation: CGFloat = 44
	
	/// Device status bar style.
	public var statusBarStyle: UIStatusBarStyle {
		get {
			return MaterialDevice.statusBarStyle
		}
		set(value) {
			MaterialDevice.statusBarStyle = value
		}
	}
	
	/// Handles the rotation factor top inset.
	internal var rotationFactor: CGFloat = 0
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: CGRectZero)
	}
	
	/**
	A convenience initializer with parameter settings.
	- Parameter leftControls: An Array of UIControls that go on the left side.
	- Parameter rightControls: An Array of UIControls that go on the right side.
	*/
	public convenience init?(leftControls: Array<UIControl>? = nil, rightControls: Array<UIControl>? = nil) {
		self.init(frame: CGRectZero)
		prepareProperties(leftControls, rightControls: rightControls)
	}
	
	public override func layoutSubviews() {
		// Ensures a width.
		if !willRenderView {
			width = MaterialDevice.width
		}
		
		grid.axis.columns = Int(width / 56)
		
		// General alignment.
		if .iPhone == MaterialDevice.type && MaterialDevice.isLandscape {
			if heightForStatusBar == rotationFactor {
				contentInset.top -= rotationFactor
				rotationFactor = 0
			}
			height = heightForLandscapeOrientation
		} else {
			if 0 == rotationFactor {
				rotationFactor = heightForStatusBar
				contentInset.top += rotationFactor
			}
			height = heightForPortraitOrientation
		}
		
		// We can call super now that we have a width.
		super.layoutSubviews()
	}
	
	public override func intrinsicContentSize() -> CGSize {
		return CGSizeMake(MaterialDevice.width, .iPhone == MaterialDevice.type && MaterialDevice.isLandscape ? heightForLandscapeOrientation : heightForPortraitOrientation)
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
		depth = .Depth1
		spacingPreset = .Spacing1
		contentInsetPreset = .Square1
		autoresizingMask = .FlexibleWidth
		shadowPathAutoSizeEnabled = false
	}
}
