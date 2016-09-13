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

@objc(TabBarDelegate)
public protocol TabBarDelegate {
    /**
     A delegation method that is executed when the button will trigger the
     animation to the next tab.
     - Parameter tabBar: A TabBar.
     - Parameter button: A UIButton.
     */
    @objc
    optional func tabBarWillSelectButton(tabBar: TabBar, button: UIButton)
    
    /**
     A delegation method that is executed when the button did complete the
     animation to the next tab.
     - Parameter tabBar: A TabBar.
     - Parameter button: A UIButton.
     */
    @objc
    optional func tabBarDidSelectButton(tabBar: TabBar, button: UIButton)
}

open class TabBar: BarView {
    /// A boolean indicating if the TabBar line is in an animation state.
    open internal(set) var isAnimating = false
    
    /// A delegation reference.
    open weak var delegate: TabBarDelegate?
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 49)
    }
    
    /// The currently selected button.
    open internal(set) var selected: UIButton?
    
	/// Buttons.
	open var buttons = [UIButton]() {
		didSet {
			for b in oldValue {
                b.removeFromSuperview()
            }
			
            contentView.grid.views = buttons as [UIView]
            
			layoutSubviews()
		}
	}
    
    /// A boolean to animate the line when touched.
    open var isLineAnimated = true {
        didSet {
            for b in buttons {
                if isLineAnimated {
                    prepareLineAnimationHandler(button: b)
                } else {
                    removeLineAnimationHandler(button: b)
                }
            }
        }
    }
    
    /// A reference to the line UIView.
    internal var line: UIView!
    
    /// The line color.
    open var lineColor: UIColor? {
        get {
            return line.backgroundColor
        }
        set(value) {
            line.backgroundColor = value
        }
    }
    
    /// A value for the line alignment.
    open var lineAlignment = TabBarLineAlignment.bottom {
        didSet {
            layoutSubviews()
        }
    }
    
    /// The line height.
    open var lineHeight: CGFloat {
        get {
            return line.height
        }
        set(value) {
            line.height = value
        }
    }
    
    open override func layoutSubviews() {
		super.layoutSubviews()
        guard willLayout else {
            return
        }
        
        guard 0 < buttons.count else {
            return
        }
            
        let columns: Int = contentView.grid.axis.columns / buttons.count
        for b in buttons {
            b.grid.columns = columns
            b.contentEdgeInsets = .zero
            b.cornerRadius = 0
            
            if isLineAnimated {
                prepareLineAnimationHandler(button: b)
            }
        }
        contentView.grid.reload()
            
        if nil == selected {
            selected = buttons.first
        }
            
        line.frame = CGRect(x: selected!.x, y: .bottom == lineAlignment ? height - lineHeight : 0, width: selected!.width, height: lineHeight)
	}
	
	/// Handles the button touch event.
    @objc
	internal func handleButton(button: UIButton) {
        animate(to: button)
	}
	
    /**
     Selects a given index from the buttons array.
     - Parameter at index: An Int.
     - Paramater completion: An optional completion block.
     */
    open func select(at index: Int, completion: ((UIButton) -> Void)? = nil) {
        guard -1 < index, index < buttons.count else {
            return
        }
        animate(to: buttons[index], completion: completion)
    }
    
    /**
     Animates to a given button.
     - Parameter to button: A UIButton.
     - Paramater completion: An optional completion block.
     */
    open func animate(to button: UIButton, completion: ((UIButton) -> Void)? = nil) {
        delegate?.tabBarWillSelectButton?(tabBar: self, button: button)
        selected = button
        isAnimating = true
        UIView.animate(withDuration: 0.25, animations: { [weak self, button = button] in
            guard let s = self else {
                return
            }
            s.line.center.x = button.center.x
            s.line.width = button.width
        }) { [weak self, button = button, completion = completion] _ in
            guard let s = self else {
                return
            }
            s.isAnimating = false
            s.delegate?.tabBarDidSelectButton?(tabBar: s, button: button)
            completion?(button)
        }
    }
    
	/**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
	open override func prepare() {
		super.prepare()
        
        autoresizingMask = .flexibleWidth
        prepareLine()
        prepareDivider()
	}
	
	// Prepares the line.
	private func prepareLine() {
		line = UIView()
        line.zPosition = 5100
		lineColor = Color.blueGrey.lighten3
		lineHeight = 3
        addSubview(line)
	}
    
    /// Prepares the divider.
    private func prepareDivider() {
        divider.alignment = .top
    }
    
    /**
     Prepares the line animation handlers.
     - Parameter button: A UIButton.
     */
    private func prepareLineAnimationHandler(button: UIButton) {
        removeLineAnimationHandler(button: button)
        button.addTarget(self, action: #selector(handleButton(button:)), for: .touchUpInside)
    }
    
    /**
     Removes the line animation handlers.
     - Parameter button: A UIButton.
     */
    private func removeLineAnimationHandler(button: UIButton) {
        button.removeTarget(self, action: #selector(handleButton(button:)), for: .touchUpInside)
    }
}
