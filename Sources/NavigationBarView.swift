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

public class NavigationBarView : StatusBarView {
	/// Title label.
	public var titleLabel: UILabel? {
		didSet {
			if let v: UILabel = titleLabel {
				contentView.addSubview(v)
			}
			layoutSubviews()
		}
	}
	
	/// Detail label.
	public var detailLabel: UILabel? {
		didSet {
			if let v: UILabel = detailLabel {
				contentView.addSubview(v)
			}
			layoutSubviews()
		}
	}
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: CGRectZero)
	}
	
	/**
	A convenience initializer with parameter settings.
	- Parameter titleLabel: UILabel for the title.
	- Parameter detailLabel: UILabel for the details.
	- Parameter leftControls: An Array of UIControls that go on the left side.
	- Parameter rightControls: An Array of UIControls that go on the right side.
	*/
	public convenience init?(titleLabel: UILabel? = nil, detailLabel: UILabel? = nil, leftControls: Array<UIControl>? = nil, rightControls: Array<UIControl>? = nil) {
		self.init(frame: CGRectZero)
		prepareProperties(titleLabel, detailLabel: detailLabel, leftControls: leftControls, rightControls: rightControls)
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		if willRenderView {
			// TitleView alignment.
			if let v: UILabel = titleLabel {
				if let d: UILabel = detailLabel {
					v.grid.rows = 2
					v.font = v.font.fontWithSize(17)
					d.grid.rows = 2
					d.font = d.font.fontWithSize(12)
					contentView.grid.axis.rows = 3
					contentView.grid.spacing = -8
					contentView.grid.contentInset.top = -8
				} else {
					v.grid.rows = 1
					v.font = v.font?.fontWithSize(20)
					contentView.grid.axis.rows = 1
					contentView.grid.spacing = 0
					contentView.grid.contentInset.top = 0
				}
			}
			
			contentView.grid.views = []
			
			if let v: UILabel = titleLabel {
				contentView.grid.views?.append(v)
			}
			if let v: UILabel = detailLabel {
				contentView.grid.views?.append(v)
			}
			
			grid.reloadLayout()
			contentView.grid.reloadLayout()
		}
	}
	
	/// Prepares the contentView.
	public override func prepareContentView() {
		super.prepareContentView()
		contentView.grid.axis.direction = .Vertical
	}
	
	/**
	Used to trigger property changes  that initializers avoid.
	- Parameter titleLabel: UILabel for the title.
	- Parameter detailLabel: UILabel for the details.
	- Parameter leftControls: An Array of UIControls that go on the left side.
	- Parameter rightControls: An Array of UIControls that go on the right side.
	*/
	internal func prepareProperties(titleLabel: UILabel?, detailLabel: UILabel?, leftControls: Array<UIControl>?, rightControls: Array<UIControl>?) {
		prepareProperties(leftControls, rightControls: rightControls)
		self.titleLabel = titleLabel
		self.detailLabel = detailLabel
	}
}
