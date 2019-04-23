/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

@objc(SpringDirection)
public enum SpringDirection: Int {
  case up
  case down
  case left
  case right
}

open class SpringAnimation {
  /// A SpringDirection value.
  open var springDirection = SpringDirection.up
  
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
    
    for i in 0..<views.count {
      let v = views[i]
      v.alpha = 0
      v.isHidden = true
      v.frame.size = itemSize
      v.frame.origin.x = (baseSize.width - itemSize.width) / 2
      v.frame.origin.y = (baseSize.height - itemSize.height) / 2
      v.layer.zPosition = CGFloat(10000 - views.count - i)
    }
  }
}

extension SpringAnimation {
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

extension SpringAnimation {
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
  open func expand(duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIView.AnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
    guard isEnabled else {
      return
    }
    
    disable()
    
    switch springDirection {
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
  open func contract(duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIView.AnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
    guard isEnabled else {
      return
    }
    
    disable()
    
    switch springDirection {
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

extension SpringAnimation {
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

extension SpringAnimation {
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
  fileprivate func expandUp(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIView.AnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
    for i in 0..<views.count {
      let v = views[i]
      v.isHidden = false
      
      UIView.animate(withDuration: Double(i) * duration,
                     delay: delay,
                     usingSpringWithDamping: usingSpringWithDamping,
                     initialSpringVelocity: initialSpringVelocity,
                     options: options,
                     animations: { [s = interimSpace, m = CGFloat(i + 1), v = v] in
                      v.alpha = 1
                      v.frame.origin.y = -m * (v.bounds.height + s)
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
  fileprivate func contractUp(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIView.AnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
    for i in 0..<views.count {
      let v = views[i]
      
      UIView.animate(withDuration: Double(i) * duration,
                     delay: delay,
                     usingSpringWithDamping: usingSpringWithDamping,
                     initialSpringVelocity: initialSpringVelocity,
                     options: options,
                     animations: { [v = v] in
                      v.alpha = 0
                      v.frame.origin.y = 0
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
  fileprivate func expandDown(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIView.AnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
    
    for i in 0..<views.count {
      let v = views[i]
      v.isHidden = false
      
      UIView.animate(withDuration: Double(i) * duration,
                     delay: delay,
                     usingSpringWithDamping: usingSpringWithDamping,
                     initialSpringVelocity: initialSpringVelocity,
                     options: options,
                     animations: { [s = interimSpace, m = CGFloat(i + 1), v = v] in
                      v.alpha = 1
                      v.frame.origin.y = m * (v.bounds.height + s)
                      
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
  fileprivate func contractDown(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIView.AnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
    guard let first = views.first else {
      return
    }
    
    for i in 0..<views.count {
      let v = views[i]
      
      UIView.animate(withDuration: Double(i) * duration,
                     delay: delay,
                     usingSpringWithDamping: usingSpringWithDamping,
                     initialSpringVelocity: initialSpringVelocity,
                     options: options,
                     animations: { [first = first, v = v] in
                      v.alpha = 0
                      v.frame.origin.y = first.frame.origin.y
                      
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
  fileprivate func expandLeft(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIView.AnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
    
    for i in 0..<views.count {
      let v = views[i]
      v.isHidden = false
      
      UIView.animate(withDuration: Double(i) * duration,
                     delay: delay,
                     usingSpringWithDamping: usingSpringWithDamping,
                     initialSpringVelocity: initialSpringVelocity,
                     options: options,
                     animations: { [s = interimSpace, m = CGFloat(i + 1), v = v] in
                      v.alpha = 1
                      v.frame.origin.x = -m * (v.bounds.width + s)
                      
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
  fileprivate func contractLeft(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIView.AnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
    guard let first = views.first else {
      return
    }
    
    for i in 0..<views.count {
      let v = views[i]
      
      UIView.animate(withDuration: Double(i) * duration,
                     delay: delay,
                     usingSpringWithDamping: usingSpringWithDamping,
                     initialSpringVelocity: initialSpringVelocity,
                     options: options,
                     animations: { [first = first, v = v] in
                      v.alpha = 0
                      v.frame.origin.x = first.frame.origin.x
                      
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
  fileprivate func expandRight(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIView.AnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
    
    for i in 0..<views.count {
      let v = views[i]
      v.isHidden = false
      
      UIView.animate(withDuration: Double(i) * duration,
                     delay: delay,
                     usingSpringWithDamping: usingSpringWithDamping,
                     initialSpringVelocity: initialSpringVelocity,
                     options: options,
                     animations: { [s = interimSpace, m = CGFloat(i + 1), v = v] in
                      v.alpha = 1
                      v.frame.origin.x = m * (v.bounds.width + s)
                      
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
  fileprivate func contractRight(duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIView.AnimationOptions, animations: ((UIView) -> Void)?, completion: ((UIView) -> Void)?) {
    guard let first = views.first else {
      return
    }
    
    let w = baseSize.width
    
    for i in 0..<views.count {
      let v = views[i]
      
      UIView.animate(withDuration: Double(i) * duration,
                     delay: delay,
                     usingSpringWithDamping: usingSpringWithDamping,
                     initialSpringVelocity: initialSpringVelocity,
                     options: options,
                     animations: { [first = first, v = v] in
                      v.alpha = 0
                      v.frame.origin.x = first.frame.origin.x + w
                      
                      animations?(v)
      }) { [weak self, v = v] _ in
        self?.handleCloseCompletion(view: v, completion: completion)
      }
    }
  }
}
