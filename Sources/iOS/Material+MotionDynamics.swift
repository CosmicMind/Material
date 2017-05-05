/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

open class MotionDynamics: UIDynamicBehavior {
    open var targetPoint: CGPoint {
        get {
            return attachmentBehavior.anchorPoint
        }
        set(value) {
            attachmentBehavior.anchorPoint = value
        }
        
    }
    
    open var velocity: CGPoint {
        get {
            return dynamicItemBehavior.linearVelocity(for: item)
        }
        set(value) {
            let v = velocity
            dynamicItemBehavior.addLinearVelocity(CGPoint(x: value.x - v.x, y: value.y - v.y), for: item)
        }
    }
    
    open fileprivate(set) var item: UIDynamicItem
    open fileprivate(set) var attachmentBehavior: UIAttachmentBehavior!
    open fileprivate(set) var dynamicItemBehavior: UIDynamicItemBehavior!
    
    public init(item: UIDynamicItem) {
        self.item = item
    }
    
    open func prepare() {
        prepareAttachmentBehavior()
        prepareDynamicItemBehavior()
    }
}

extension MotionDynamics {
    fileprivate func prepareAttachmentBehavior() {
        attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: .zero)
        attachmentBehavior.frequency = 3.5
        attachmentBehavior.damping = 0.4
        attachmentBehavior.length = 0
        addChildBehavior(attachmentBehavior)
    }
    
    fileprivate func prepareDynamicItemBehavior() {
        dynamicItemBehavior = UIDynamicItemBehavior(items: [item])
        dynamicItemBehavior.density = 100
        dynamicItemBehavior.resistance = 10
        addChildBehavior(dynamicItemBehavior)
    }
}

public enum PaneState: Int {
    case opened
    case closed
}

@objc(MotionDynamicsAnimatorDelegate)
public protocol MotionDynamicsAnimatorDelegate {
    
    
    //    - (void)animationTick:(CFTimeInterval)dt finished:(BOOL *)finished;
}

open class PaneMotionDynamicsAnimator: MotionDynamicsAnimatorDelegate {
    
    
//    - (void)animationTick:(CFTimeInterval)dt finished:(BOOL *)finished;
}

open class PaneController: UIViewController {
    fileprivate var motionDynamics: MotionDynamics?
    fileprivate var pane: UIView!
    fileprivate var paneMotionDynamicsAnimator: PaneMotionDynamicsAnimator!
    fileprivate var animator: UIDynamicItemBehavior!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    open func prepare() {
        prepareAnimator()
        preparePane()
        prepareMotionDynamics()
        preparePaneMotionDynamicsAnimator()
    }
}

extension PaneController {
    fileprivate func prepareAnimator() {
        animator = UIDynamicItemBehavior()
    }
    
    fileprivate func preparePane() {
        pane = UIView()
    }
    
    fileprivate func prepareMotionDynamics() {
        guard nil == motionDynamics else {
            return
        }
        
        motionDynamics = MotionDynamics(item: pane)
    }
    
    fileprivate func preparePaneMotionDynamicsAnimator() {
        paneMotionDynamicsAnimator = PaneMotionDynamicsAnimator()
    }
}

extension PaneController {
    fileprivate func targetPointFor(state: PaneState) -> CGPoint {
        return .zero
    }
}

extension PaneController {
    fileprivate func draggable(view: UIView, draggingEndedWith velocity: CGPoint) {
        animatePaneTo(state: velocity.y < 0 ? .opened : .closed, initialVelocity: velocity)
    }
    
    fileprivate func animatePaneTo(state: PaneState, initialVelocity: CGPoint) {
        prepareMotionDynamics()
        motionDynamics?.targetPoint = targetPointFor(state: state)
        
        if initialVelocity.equalTo(.zero) {
            motionDynamics?.velocity = initialVelocity
        }
        
//        animator.addChildBehavior(motionDynamics)
    }
}
