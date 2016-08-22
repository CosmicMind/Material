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

open class PulseView: View {
	/// An Array of pulse layers.
	open private(set) lazy var pulseLayers = [CAShapeLayer]()
	
	/// The opcaity value for the pulse animation.
	@IBInspectable
    open var pulseOpacity: CGFloat = 0.25
	
	/// The color of the pulse effect.
	@IBInspectable
    open var pulseColor = Color.grey.base
	
	/// The type of PulseAnimation.
	open var pulseAnimation = PulseAnimation.pointWithBacking
	
	/**
	Triggers the pulse animation.
	- Parameter point: A Optional point to pulse from, otherwise pulses
	from the center.
	*/
	open func pulse(point: CGPoint? = nil) {
        let p: CGPoint = nil == point ? CGPoint(x: CGFloat(width / 2), y: CGFloat(height / 2)) : point!
		Animation.pulseExpandAnimation(layer: layer, visualLayer: visualLayer, pulseColor: pulseColor, pulseOpacity: pulseOpacity, point: p, width: width, height: height, pulseLayers: &pulseLayers, pulseAnimation: pulseAnimation)
		_ = Animation.delay(time: 0.35) { [weak self] in
            guard let s = self else {
                return
            }
            Animation.pulseContractAnimation(layer: s.layer, visualLayer: s.visualLayer, pulseColor: s.pulseColor, pulseLayers: &s.pulseLayers, pulseAnimation: s.pulseAnimation)
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
		Animation.pulseExpandAnimation(layer: layer, visualLayer: visualLayer, pulseColor: pulseColor, pulseOpacity: pulseOpacity, point: layer.convert(touches.first!.location(in: self), from: layer), width: width, height: height, pulseLayers: &pulseLayers, pulseAnimation: pulseAnimation)
	}
	
	/**
     A delegation method that is executed when the view touch event has
     ended.
     - Parameter touches: A set of UITouch objects.
     - Parameter event: A UIEvent object.
     */
	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		Animation.pulseContractAnimation(layer: layer, visualLayer: visualLayer, pulseColor: pulseColor, pulseLayers: &pulseLayers, pulseAnimation: pulseAnimation)
	}
	
	/**
     A delegation method that is executed when the view touch event has
     been cancelled.
     - Parameter touches: A set of UITouch objects.
     - Parameter event: A UIEvent object.
     */
	open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesCancelled(touches, with: event)
		Animation.pulseContractAnimation(layer: layer, visualLayer: visualLayer, pulseColor: pulseColor, pulseLayers: &pulseLayers, pulseAnimation: pulseAnimation)
	}
}
