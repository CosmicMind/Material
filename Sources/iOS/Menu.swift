/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

@objc(MenuDirection)
public enum MenuDirection: Int {
    case up
    case down
    case left
    case right
}

@objc(MenuDelegate)
public protocol MenuDelegate {
    /**
     A delegation method that is execited when the menu will open.
     - Parameter menu: A Menu.
     */
    @objc
    optional func menuWillOpen(menu: Menu)
    
    /**
     A delegation method that is execited when the menu did open.
     - Parameter menu: A Menu.
     */
    @objc
    optional func menuDidOpen(menu: Menu)
    
    /**
     A delegation method that is execited when the menu will close.
     - Parameter menu: A Menu.
     */
    @objc
    optional func menuWillClose(menu: Menu)
    
    /**
     A delegation method that is execited when the menu did close.
     - Parameter menu: A Menu.
     */
    @objc
    optional func menuDidClose(menu: Menu)
    
    /**
     A delegation method that is executed when the user taps while
     the menu is opened.
     - Parameter menu: A Menu.
     - Parameter tappedAt point: A CGPoint.
     - Parameter isOutside: A boolean indicating whether the tap
     was outside the menu button area.
     */
    @objc
    optional func menu(menu: Menu, tappedAt point: CGPoint, isOutside: Bool)
}


@objc(Menu)
open class Menu: Button {
    /// The direction in which the animation opens the menu.
    open var direction = MenuDirection.up {
        didSet {
            layoutSubviews()
        }
    }
    
    /// A reference to the contentView.
    open let contentView = UIView()
    
    /// A reference to the contentView.
    open let container = UIView()
    
    /// A reference to the MenuItems.
    open var items = [MenuItem]() {
        didSet {
            reload()
        }
    }
    
    /// A boolean indicating if the menu is open or not.
    open var isOpened = false
    
    /// An optional delegation handler.
    open weak var delegate: MenuDelegate?
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = container.bounds
    }
    
    open override func prepare() {
        super.prepare()
        prepareContentView()
        prepareContainer()
        prepareHandler()
    }
}

extension Menu {
    fileprivate func reload() {
        
    }
}

extension Menu {
    /// Prepares the contentView.
    fileprivate func prepareContentView() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        contentView.cornerRadiusPreset = .cornerRadius1
    }
    
    /// Prepares the container.
    fileprivate func prepareContainer() {
        container.depthPreset = .depth1
        container.addSubview(contentView)
    }
    
    /// Prepares the button.
    fileprivate func prepareHandler() {
        addTarget(self, action: #selector(handleToggleMenu), for: .touchUpInside)
    }
}

extension Menu {
    /**
     Handles the hit test for the Menu and views outside of the Menu bounds.
     - Parameter _ point: A CGPoint.
     - Parameter with event: An optional UIEvent.
     - Returns: An optional UIView.
     */
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard isOpened, isEnabled else {
            return super.hitTest(point, with: event)
        }
        
        for v in subviews {
            let p = v.convert(point, from: self)
            if v.bounds.contains(p) {
                delegate?.menu?(menu: self, tappedAt: point, isOutside: false)
                return v.hitTest(p, with: event)
            }
        }
        
        delegate?.menu?(menu: self, tappedAt: point, isOutside: true)
        
        close()
        
        return self.hitTest(point, with: event)
    }
}


extension Menu {
    open func open() {
        guard !isOpened, isEnabled else {
            return
        }
        
        guard nil == container.superview else {
            return
        }
        
        delegate?.menuWillOpen?(menu: self)
        
        switch direction {
        case .up, .down, .left, .right:
            layout(container).bottom().width(100).height(200).centerHorizontally()
        }
        
        isOpened = true
        
        delegate?.menuDidOpen?(menu: self)
    }
    
    open func close() {
        guard isOpened, isEnabled else {
            return
        }
        
        delegate?.menuWillClose?(menu: self)
        
        container.removeFromSuperview()
        
        isOpened = false
        
        delegate?.menuDidClose?(menu: self)
    }
}

extension Menu {
    /**
     Handler to toggle the Menu opened or closed.
     - Parameter button: A UIButton.
     */
    @objc
    fileprivate func handleToggleMenu(button: UIButton) {
        guard isOpened else {
            open()
            return
        }
        
        close()
    }
}
