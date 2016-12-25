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

@objc(FABMenuDirection)
public enum FABMenuDirection: Int {
    case up
    case down
    case left
    case right
}

@objc(FABMenuDelegate)
public protocol FABMenuDelegate {
    /**
     Gets called when the user taps while the menu is opened.
     - Parameter menu: A FABMenu.
     - Parameter tappedAt point: A CGPoint.
     - Parameter isOutside: A boolean indicating whether the tap
     was outside the menu button area.
     */
    @objc
    optional func fabMenu(fabMenu: FABMenu, tappedAt point: CGPoint, isOutside: Bool)
}


@objc(FABMenu)
open class FABMenu: View, SpringableMotion {
    /// A reference to the SpringMotion object.
    internal let spring = SpringMotion()
    
    /// The direction in which the animation opens the menu.
    open var springDirection = SpringMotionDirection.up {
        didSet {
            layoutSubviews()
        }
    }
    
    open var baseSize: CGSize {
        get {
            return spring.baseSize
        }
        set(value) {
            spring.baseSize = value
        }
    }
    
    open var itemSize: CGSize {
        get {
            return spring.itemSize
        }
        set(value) {
            spring.itemSize = value
        }
    }
    
    open var isOpened: Bool {
        get {
            return spring.isOpened
        }
        set(value) {
            spring.isOpened = value
        }
    }
    
    open var isEnable: Bool {
        get {
            return spring.isEnabled
        }
        set(value) {
            spring.isEnabled = value
        }
    }
    
    /// A preset wrapper around interimSpace.
    open var interimSpacePreset: InterimSpacePreset {
        get {
            return spring.interimSpacePreset
        }
        set(value) {
            spring.interimSpacePreset = value
        }
    }
    
    /// The space between views.
    open var interimSpace: InterimSpace {
        get {
            return spring.interimSpace
        }
        set(value) {
            spring.interimSpace = value
        }
    }
    
    /// An optional delegation handler.
    open weak var delegate: FABMenuDelegate?
    
    /// A reference to the FABMenuItems
    open var items: [FABMenuItem] {
        get {
            return spring.views as! [FABMenuItem]
        }
        set(value) {
            for v in spring.views {
                v.removeFromSuperview()
            }
            
            for v in value {
                addSubview(v)
            }
            
            spring.views = value
        }
    }
    
    open override func prepare() {
        super.prepare()
        backgroundColor = nil
        interimSpacePreset = .interimSpace6
    }
}

extension FABMenu {
    /**
     Handles the hit test for the Menu and views outside of the Menu bounds.
     - Parameter _ point: A CGPoint.
     - Parameter with event: An optional UIEvent.
     - Returns: An optional UIView.
     */
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard spring.isOpened, spring.isEnabled else {
            return super.hitTest(point, with: event)
        }
        
        for v in subviews {
            let p = v.convert(point, from: self)
            if v.bounds.contains(p) {
                delegate?.fabMenu?(fabMenu: self, tappedAt: point, isOutside: false)
                return v.hitTest(p, with: event)
            }
        }
        
        delegate?.fabMenu?(fabMenu: self, tappedAt: point, isOutside: true)
        
        return self.hitTest(point, with: event)
    }
}

extension FABMenu {
    /**
     Open the Menu component with animation options.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    open func open(duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIViewAnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
        spring.expand(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
    }
    
    /**
     Close the Menu component with animation options.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    open func close(duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIViewAnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
        spring.contract(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
    }
}
