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

public enum BarHeight {
    case Default
    case Short
    case Tall
    case FrameHeight
    
}


public class Toolbar : BarView {

    /// ToolBar's height.
    public var toolbarHeight: BarHeight = BarHeight.Default {
        didSet {
            layoutSubviews()
        }
    }
    
    /// Title label.
	public private(set) var titleLabel: UILabel!
	
	/// Detail label.
	public private(set) var detailLabel: UILabel!
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		if willRenderView {
			if let _: String = detailLabel.text {
				titleLabel.sizeToFit()
				detailLabel.sizeToFit()
				
				let diff: CGFloat = (contentView.frame.height - titleLabel.frame.height - detailLabel.frame.height) / 2
				titleLabel.frame.size.height += diff
				titleLabel.frame.size.width = contentView.frame.width
				detailLabel.frame.size.height += diff
				detailLabel.frame.size.width = contentView.frame.width
				detailLabel.frame.origin.y = titleLabel.frame.height
			} else {
				titleLabel.frame = contentView.bounds
			}
		}
	}
	
    
    /// A convenience initializer.
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: MaterialDevice.width, height: 32.0))
    }
    
    /// A convenience using BarHeight preset.
    public convenience init(heightPreset: BarHeight) {
        self.init(frame: CGRect(x: 0, y: 0, width: MaterialDevice.width, height: 32.0))
        toolbarHeight = heightPreset
    }
    
    /// Returns the intrinsinc content size for toolbar.
    public override func intrinsicContentSize() -> CGSize {
        var result: CGSize = super.intrinsicContentSize()
        var height: CGFloat = 32.0
        let insetHeight = contentInset.top + contentInset.bottom
        switch toolbarHeight {
        case .Default:
            height = 32.0 + insetHeight
        case .Short:
            height = 21.0 + insetHeight
        case .Tall:
            height = 64.0 + insetHeight
        case .FrameHeight:
            height = frame.height
        }
        result.height = height
        return result
    }

    
    
	/**
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
	An initializer that initializes the object with a CGRect object.
	If AutoLayout is used, it is better to initilize the instance
	using the init() initializer.
	- Parameter frame: A CGRect instance.
	*/
	public override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	/// Basic initializer.
	public override init() {
		super.init()
		print("Toolbar", intrinsicContentSize())
	}
	
	/**
	A convenience initializer with parameter settings.
	- Parameter leftControls: An Array of UIControls that go on the left side.
	- Parameter rightControls: An Array of UIControls that go on the right side.
	*/
	public override init(leftControls: Array<UIControl>, rightControls: Array<UIControl>) {
		super.init(leftControls: leftControls, rightControls: rightControls)
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
		prepareTitleLabel()
		prepareDetailLabel()
	}
	
	/// Prepares the titleLabel.
	private func prepareTitleLabel() {
		titleLabel = UILabel()
		titleLabel.contentScaleFactor = MaterialDevice.scale
		titleLabel.font = RobotoFont.mediumWithSize(17)
		titleLabel.textAlignment = .Left
		contentView.addSubview(titleLabel)
	}
	
	/// Prepares the detailLabel.
	private func prepareDetailLabel() {
		detailLabel = UILabel()
		detailLabel.contentScaleFactor = MaterialDevice.scale
		detailLabel.font = RobotoFont.regularWithSize(12)
		detailLabel.textAlignment = .Left
		contentView.addSubview(detailLabel)
	}
}