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
import Motion

open class PulseView: View, Pulseable, PulseableLayer {
  /// A Pulse reference.
  internal var pulse: Pulse!
  
  /// A reference to the pulse layer.
  internal var pulseLayer: CALayer? {
    return pulse.pulseLayer
  }
  
  /// PulseAnimation value.
  open var pulseAnimation: PulseAnimation {
    get {
      return pulse.animation
    }
    set(value) {
      pulse.animation = value
    }
  }
  
  /// PulseAnimation color.
  @IBInspectable
  open var pulseColor: UIColor {
    get {
      return pulse.color
    }
    set(value) {
      pulse.color = value
    }
  }
  
  /// Pulse opacity.
  @IBInspectable
  open var pulseOpacity: CGFloat {
    get {
      return pulse.opacity
    }
    set(value) {
      pulse.opacity = value
    }
  }
  
  /**
   Triggers the pulse animation.
   - Parameter point: A Optional point to pulse from, otherwise pulses
   from the center.
   */
  open func pulse(point: CGPoint? = nil) {
    pulse.expand(point: point ?? center)
    Motion.delay(0.35) { [weak self] in
      self?.pulse.contract()
    }
  }
  
  /**
   A delegation method that is executed when the view has began a
   touch event.
   - Parameter touches: A set of UITouch objects.
   - Parameter event: A UIEvent object.
   */
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    pulse.expand(point: layer.convert(touches.first!.location(in: self), from: layer))
  }
  
  /**
   A delegation method that is executed when the view touch event has
   ended.
   - Parameter touches: A set of UITouch objects.
   - Parameter event: A UIEvent object.
   */
  open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    pulse.contract()
  }
  
  /**
   A delegation method that is executed when the view touch event has
   been cancelled.
   - Parameter touches: A set of UITouch objects.
   - Parameter event: A UIEvent object.
   */
  open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    pulse.contract()
  }
  
  open override func prepare() {
    super.prepare()
    preparePulse()
  }
}

extension PulseView {
  /// Prepares the pulse motion.
  fileprivate func preparePulse() {
    pulse = Pulse(pulseView: self, pulseLayer: visualLayer)
  }
}
