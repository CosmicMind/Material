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

@objc(TabBarLineAlignment)
public enum TabBarLineAlignment: Int {
	case top
	case bottom
}

open class TabBar: View {
	/// A reference to the line UIView.
	open internal(set) var line: UIView!
	
	/// A value for the line alignment.
	open var lineAlignment: TabBarLineAlignment = .bottom {
		didSet {
			layoutSubviews()
		}
	}
	
	/// Will render the view.
	open var willRenderView: Bool {
		return 0 < width && 0 < height && nil != superview
	}
    
    /// A preset wrapper around contentInset.
    open var contentEdgeInsetsPreset: EdgeInsetsPreset {
        get {
            return grid.contentEdgeInsetsPreset
        }
        set(value) {
            grid.contentEdgeInsetsPreset = value
        }
    }
    
    /// A wrapper around grid.contentInset.
    @IBInspectable
    open var contentInset: EdgeInsets {
        get {
            return grid.contentEdgeInsets
        }
        set(value) {
            grid.contentEdgeInsets = value
        }
    }
    
    /// A preset wrapper around interimSpace.
    open var interimSpacePreset: InterimSpacePreset = .none {
        didSet {
            interimSpace = InterimSpacePresetToValue(preset: interimSpacePreset)
        }
    }
    
    /// A wrapper around grid.interimSpace.
    @IBInspectable
    open var interimSpace: InterimSpace {
        get {
            return grid.interimSpace
        }
        set(value) {
            grid.interimSpace = value
        }
    }
	
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 44)
    }
    
	/// Buttons.
	open var buttons: [UIButton]? {
		didSet {
			if let v: [UIButton] = oldValue {
				for b in v {
					b.removeFromSuperview()
				}
			}
			
			if let v: [UIButton] = buttons {
				for b in v {
					addSubview(b)
				}
			}
			layoutSubviews()
		}
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		if willRenderView {
			if let v = buttons {
				if 0 < v.count {
					let columns: Int = grid.axis.columns / v.count
					for b in v {
						b.grid.columns = columns
						b.contentEdgeInsets = UIEdgeInsets.zero
						b.layer.cornerRadius = 0
                        b.removeTarget(self, action: #selector(handleButton(button:)), for: .touchUpInside)
						b.addTarget(self, action: #selector(handleButton(button:)), for: .touchUpInside)
					}
					grid.views = v as [UIView]
                    line.frame = CGRect(x: 0, y: .bottom == lineAlignment ? height - 3 : 0, width: v.first!.frame.width, height: 3)
				}
			}
		}
	}
	
	/// Handles the button touch event.
    @objc
	internal func handleButton(button: UIButton) {
		UIView.animate(withDuration: 0.25, animations: { [weak self] in
			if let s = self {
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
	open override func prepareView() {
		super.prepareView()
        interimSpacePreset = .interimSpace1
        contentEdgeInsetsPreset = .square1
        autoresizingMask = .flexibleWidth
        prepareLine()
	}
	
	// Prepares the line.
	private func prepareLine() {
		line = UIView()
		line.backgroundColor = Color.yellow.base
		addSubview(line)
	}
}
