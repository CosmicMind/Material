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

@objc(SpringMotionDirection)
public enum SpringMotionDirection: Int {
    case up
    case down
    case left
    case right
}

public protocol SpringableMotion {
    /// A SpringMotionDirection value.
    var springDirection: SpringMotionDirection { get set }
}

open class SpringMotion {
    /// A SpringMotionDirection value.
    open var direction = SpringMotionDirection.up
    
    /// A Boolean that indicates if the menu is open or not.
    open var isOpened = false
    
    /// Enables the animations for the Menu.
    open var isEnabled = true
    
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
    
    /// An Array of UIViews.
    open var views = [UIView]() {
        didSet {
            reload()
        }
    }
    
    /// An Optional base view size.
    open var baseSize = CGSize(width: 48, height: 48) {
        didSet {
            reload()
        }
    }
    
    /// Size of views.
    open var itemSize = CGSize(width: 48, height: 48) {
        didSet {
            reload()
        }
    }
    
    /// Reload the view layout.
    open func reload() {
        isOpened = false
        
        guard let first = views.first else {
            return
        }
        
        first.frame.size = baseSize
        first.zPosition = 10000
        
        for i in 1..<views.count {
            let v = views[i]
            v.alpha = 0
            v.isHidden = true
            v.frame.size = itemSize
            v.x = first.x + (baseSize.width - itemSize.width) / 2
            v.y = first.y + (baseSize.height - itemSize.height) / 2
            v.zPosition = CGFloat(10000 - views.count - i)
        }
    }
}

extension SpringMotion {
    /// Disable the Menu if views exist.
    fileprivate func disable() {
        guard 0 < views.count else {
            return
        }
        
        isEnabled = false
    }
    
    /**
     Enable the Menu if the last view is equal to the passed in view.
     - Parameter view: UIView that is passed in to compare.
     */
    fileprivate func enable(view: UIView) {
        guard view == views.last else {
            return
        }
        
        isEnabled = true
    }
}

extension SpringMotion {
    /**
     Expands the Spring component with animation options.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    open func expand(duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIViewAnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
        guard isEnabled else {
            return
        }
        
        disable()
        
        switch direction {
        case .up:
            expandUp(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
        case .down:
            expandDown(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
        case .left:
            expandLeft(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
        case .right:
            expandRight(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
        }
    }
    
    /**
     Contracts the Spring component with animation options.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    open func contract(duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIViewAnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
        guard isEnabled else {
            return
        }
        
        disable()
    
        switch direction {
        case .up:
            contractUp(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
        case .down:
            contractDown(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
        case .left:
            contractLeft(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
        case .right:
            contractRight(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
        }
    }
}

extension SpringMotion {
    /**
     Handles the animation open completion.
     - Parameter view: A UIView.
     - Parameter completion: A completion handler.
     */
    fileprivate func handleOpenCompletion(view: UIView, completion: ((UIView) -> Void)?) {
        enable(view: view)
        
        if view == views.last {
            isOpened = true
        }
        
        completion?(view)
    }
    
    /**
     Handles the animation contract completion. 
     - Parameter view: A UIView.
     - Parameter completion: A completion handler.
     */
    fileprivate func handleCloseCompletion(view: UIView, completion: ((UIView) -> Void)?) {
        view.isHidden = true
        enable(view: view)
        
        if view == views.last {
            isOpened = false
        }
        
        completion?(view)
    }
}

extension SpringMotion {
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
    fileprivate func expandUp(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
        guard let first = views.first else {
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
                animations: { [s = self, first = first, v = v] in
                    v.alpha = 1
                    v.y = first.y - CGFloat(i) * v.height - CGFloat(i) * s.interimSpace
                    
                    animations?(v)
                }) { [weak self, v = v] _ in
                    self?.handleOpenCompletion(view: v, completion: completion)
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
    fileprivate func contractUp(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
        guard let first = views.first else {
            return
        }
        
        for i in 1..<views.count {
            let v = views[i]
            
            UIView.animate(withDuration: Double(i) * duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animations: { [base = first, v = v] in
                    v.alpha = 0
                    v.y = base.y
                            
                    animations?(v)
                }) { [weak self, v = v] _ in
                    self?.handleCloseCompletion(view: v, completion: completion)
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
    fileprivate func expandDown(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
        guard let first = views.first else {
            return
        }
        
        let h = baseSize.height
        
        for i in 1..<views.count {
            let v = views[i]
            v.isHidden = false
            
            UIView.animate(withDuration: Double(i) * duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animations: { [s = self, first = first, v = v] in
                    v.alpha = 1
                    v.y = first.y + h + CGFloat(i - 1) * s.itemSize.height + CGFloat(i) * s.interimSpace
                            
                    animations?(v)
                }) { [weak self, v = v] _ in
                    self?.handleOpenCompletion(view: v, completion: completion)
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
    fileprivate func contractDown(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
        guard let first = views.first else {
            return
        }
        
        let h = baseSize.height
        
        for i in 1..<views.count {
            let v = views[i]
            
            UIView.animate(withDuration: Double(i) * duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animations: { [first = first, v = v] in
                    v.alpha = 0
                    v.y = first.y + h
                            
                    animations?(v)
                }) { [weak self, v = v] _ in
                    self?.handleCloseCompletion(view: v, completion: completion)
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
    fileprivate func expandLeft(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
        guard let first = views.first else {
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
               animations: { [s = self, first = first, v = v] in
                    v.alpha = 1
                    v.x = first.x - CGFloat(i) * s.itemSize.width - CGFloat(i) * s.interimSpace
                
                    animations?(v)
                }) { [weak self, v = v] _ in
                    self?.handleOpenCompletion(view: v, completion: completion)
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
    fileprivate func contractLeft(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
        guard let first = views.first else {
            return
        }
        
        for i in 1..<views.count {
            let v = views[i]
            
            UIView.animate(withDuration: Double(i) * duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animations: { [first = first, v = v] in
                    v.alpha = 0
                    v.x = first.x
                            
                    animations?(v)
                }) { [weak self, v = v] _ in
                    self?.handleCloseCompletion(view: v, completion: completion)
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
    fileprivate func expandRight(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
        guard let first = views.first else {
            return
        }
        
        let h = baseSize.height
        
        for i in 1..<views.count {
            let v = views[i]
            v.isHidden = false
            
            UIView.animate(withDuration: Double(i) * duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animations: { [s = self, first = first, v = v] in
                    v.alpha = 1
                    v.x = first.x + h + CGFloat(i - 1) * s.itemSize.width + CGFloat(i) * s.interimSpace
                            
                    animations?(v)
                }) { [weak self, v = v] _ in
                    self?.handleOpenCompletion(view: v, completion: completion)
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
    fileprivate func contractRight(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
        guard let first = views.first else {
            return
        }
        
        let w = baseSize.width
        
        for i in 1..<views.count {
            let v = views[i]
            
            UIView.animate(withDuration: Double(i) * duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animations: { [first = first, v = v] in
                    v.alpha = 0
                    v.x = first.x + w
                            
                    animations?(v)
                }) { [weak self, v = v] _ in
                    self?.handleCloseCompletion(view: v, completion: completion)
                }
        }
    }
}
