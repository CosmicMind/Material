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

@objc(MenuDirection)
public enum MenuDirection: Int {
    case up
    case down
    case left
    case right
}

@objc(MenuDelegate)
public protocol MenuDelegate {
    /// Gets called when the user taps outside menu buttons.
    @objc
    optional func menu(menu: Menu, tappedAt point: CGPoint)
}

open class Menu: View {
    /// A Boolean that indicates if the menu is open or not.
    open internal(set) var isOpened = false
    
    /// Enables the animations for the Menu.
    open internal(set) var isEnabled = true
    
    /// A preset wrapper around interimSpace.
    open var interimSpacePreset = InterimSpacePreset.none {
        didSet {
            interimSpace = InterimSpacePresetToValue(preset: interimSpacePreset)
        }
    }
    
    /// The space between views.
    open var interimSpace: InterimSpace = 0 {
        didSet {
            reload()
        }
    }
    
    /// The direction in which the animation opens the menu.
    open var direction = MenuDirection.up {
        didSet {
            reload()
        }
    }
    
    /// A delegation reference.
    open weak var delegate: MenuDelegate?
    
    /// An Array of UIViews.
    open var views = [UIView]() {
        didSet {
            for v in oldValue {
                v.removeFromSuperview()
            }
            
            for v in views {
                addSubview(v)
            }
            
            reload()
        }
    }
    
    /// An Optional base view size.
    open var baseSize = CGSize(width: 48, height: 48)
    
    /// Size of views, not including the first view.
    open var itemSize = CGSize(width: 48, height: 48)
    
    open override func prepareView() {
        super.prepareView()
        backgroundColor = nil
    }
    
    /// Reload the view layout.
    open func reload() {
        isOpened = false
        layoutButtons()
    }
    
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
        if isEnabled {
            disable()
            switch direction {
            case .up:
                openUpAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
            case .down:
                openDownAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
            case .left:
                openLeftAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
            case .right:
                openRightAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
            }
        }
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
        if isEnabled {
            disable()
            switch direction {
            case .up:
                closeUpAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
            case .down:
                closeDownAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
            case .left:
                closeLeftAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
            case .right:
                closeRightAnimation(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
            }
        }
    }
    
    /**
     Open the Menu component with animation options in the Up direction.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    private func openUpAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
        guard let base = views.first else {
            return
        }
        
        for i in 1..<views.count {
            let v = views[i]
            v.isHidden = false
            
            UIView.animate(withDuration: Double(i) * duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animations: { [weak self, base = base] in
                    guard let s = self else {
                        return
                    }
                    
                    v.alpha = 1
                    v.y = base.y - CGFloat(i) * s.itemSize.height - CGFloat(i) * s.interimSpace
                    
                    animations?(v)
            }) { [weak self] _ in
                guard let s = self else {
                    return
                }
                
                s.enable(view: v)
                
                if v == s.views.last {
                    s.isOpened = true
                }
                
                completion?(v)
            }
        }
    }
    
    /**
     Close the Menu component with animation options in the Up direction.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    private func closeUpAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
        
        for i in 1..<views.count {
            let v = views[i]
            
            UIView.animate(withDuration: Double(i) * duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animations: { [weak self] in
                    guard let s = self else {
                        return
                    }
                    
                    v.alpha = 0
                    v.y = s.y
                    
                    animations?(v)
                }) { [weak self] _ in
                    guard let s = self else {
                        return
                    }
                    
                    v.isHidden = true
                    s.enable(view: v)
                    
                    if v == s.views.last {
                        s.isOpened = false
                    }
                    
                    completion?(v)
                }
        }
    }
    
    /**
     Open the Menu component with animation options in the Down direction.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    private func openDownAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
        guard let base = views.first else {
            return
        }
        
        for i in 1..<views.count {
            let v = views[i]
            v.isHidden = false
                
            let h = baseSize.height
            UIView.animate(withDuration: Double(i) * duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animations: { [weak self, base = base] in
                    guard let s = self else {
                        return
                    }
                    
                    v.alpha = 1
                    v.y = base.y + h + CGFloat(i - 1) * s.itemSize.height + CGFloat(i) * s.interimSpace
                    
                    animations?(v)
                }) { [weak self] _ in
                    guard let s = self else {
                        return
                    }
                    
                    s.enable(view: v)
                    
                    if v == s.views.last {
                        s.isOpened = true
                    }
                    
                    completion?(v)
                }
        }
    }
    
    /**
     Close the Menu component with animation options in the Down direction.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    private func closeDownAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
            for i in 1..<views.count {
                let v = views[i]
                
                let h = baseSize.height
                UIView.animate(withDuration: Double(i) * duration,
                    delay: delay,
                    usingSpringWithDamping: usingSpringWithDamping,
                    initialSpringVelocity: initialSpringVelocity,
                    options: options,
                    animations: { [weak self] in
                        guard let s = self else {
                            return
                        }
                        
                        v.alpha = 0
                        v.y = s.y + h
                        
                        animations?(v)
                }) { [weak self] _ in
                    guard let s = self else {
                        return
                    }
                    
                    v.isHidden = true
                    s.enable(view: v)
                    
                    if v == s.views.last {
                        s.isOpened = false
                    }
                    
                    completion?(v)
                }
            }
    }
    
    /**
     Open the Menu component with animation options in the Left direction.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    private func openLeftAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
        guard let base = views.first else {
            return
        }
        
        for i in 1..<views.count {
            let v = views[i]
            v.isHidden = false
            
            UIView.animate(withDuration: Double(i) * duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animations: { [weak self, base = base] in
                    guard let s = self else {
                        return
                    }
                    
                    v.alpha = 1
                    v.x = base.x - CGFloat(i) * s.itemSize.width - CGFloat(i) * s.interimSpace
                    
                    animations?(v)
            }) { [weak self] _ in
                guard let s = self else {
                    return
                }
                
                s.enable(view: v)
                
                if v == s.views.last {
                    s.isOpened = true
                }
                
                completion?(v)
            }
        }
    }
    
    /**
     Close the Menu component with animation options in the Left direction.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    private func closeLeftAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
        for i in 1..<views.count {
            let v = views[i]
            
            UIView.animate(withDuration: Double(i) * duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animations: { [weak self] in
                    guard let s = self else {
                        return
                    }
                    
                    v.alpha = 0
                    v.x = s.x
                    
                    animations?(v)
                }) { [weak self] _ in
                    guard let s = self else {
                        return
                    }
                    
                    v.isHidden = true
                    s.enable(view: v)
                    
                    if v == s.views.last {
                        s.isOpened = false
                    }
                    
                    completion?(v)
                }
        }
    }
    
    /**
     Open the Menu component with animation options in the Right direction.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    private func openRightAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
        guard let base = views.first else {
            return
        }
        
        for i in 1..<views.count {
            let v = views[i]
            v.isHidden = false
            
            let h = baseSize.height
            UIView.animate(withDuration: Double(i) * duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animations: { [weak self, base = base] in
                    guard let s = self else {
                        return
                    }
                    
                    v.alpha = 1
                    v.x = base.x + h + CGFloat(i - 1) * s.itemSize.width + CGFloat(i) * s.interimSpace
                    
                    animations?(v)
                }) { [weak self] _ in
                    guard let s = self else {
                        return
                    }
                
                    s.enable(view: v)
                    
                    if v == s.views.last {
                        s.isOpened = true
                    }
                    
                    completion?(v)
                }
        }
    }
    
    /**
     Close the Menu component with animation options in the Right direction.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    private func closeRightAnimation(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
        for i in 1..<views.count {
            let v = views[i]
            let w = baseSize.width
            
            UIView.animate(withDuration: Double(i) * duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animations: { [weak self] in
                    guard let s = self else {
                        return
                    }
                    
                    v.alpha = 0
                    v.x = s.x + w
                    
                    animations?(v)
                }) { [weak self] _ in
                    guard let s = self else {
                        return
                    }
                    
                    v.isHidden = true
                    s.enable(view: v)
                    
                    if v == s.views.last {
                        s.isOpened = false
                    }
                    
                    completion?(v)
                }
        }
    }
    
    /// Layout the views.
    private func layoutButtons() {
        for i in 0..<views.count {
            let v = views[i]
            if 0 == i {
                v.frame.size = baseSize
                v.layer.zPosition = 10000
            } else {
                v.alpha = 0
                v.isHidden = true
                v.frame.size = itemSize
                v.x = x + (baseSize.width - itemSize.width) / 2
                v.y = y + (baseSize.height - itemSize.height) / 2
                v.layer.zPosition = CGFloat(10000 - views.count - i)
            }
        }
    }
    
    /// Disable the Menu if views exist.
    private func disable() {
        guard 0 < views.count else {
            return
        }
        isEnabled = false
    }
    
    /**
     Enable the Menu if the last view is equal to the passed in view.
     - Parameter view: UIView that is passed in to compare.
     */
    private func enable(view: UIView) {
        guard view == views.last else {
            return
        }
        isEnabled = true
    }
}
