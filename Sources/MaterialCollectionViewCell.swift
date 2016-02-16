///*
//* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
//* All rights reserved.
//*
//* Redistribution and use in source and binary forms, with or without
//* modification, are permitted provided that the following conditions are met:
//*
//*	*	Redistributions of source code must retain the above copyright notice, this
//*		list of conditions and the following disclaimer.
//*
//*	*	Redistributions in binary form must reproduce the above copyright notice,
//*		this list of conditions and the following disclaimer in the documentation
//*		and/or other materials provided with the distribution.
//*
//*	*	Neither the name of Material nor the names of its
//*		contributors may be used to endorse or promote products derived from
//*		this software without specific prior written permission.
//*
//* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//*/
//
//import UIKit
//
//@objc(floatingViewControllerCollectionViewCellDelegate)
//public protocol MaterialCollectionViewCellDelegate : MaterialDelegate {
//	optional func collectionViewCellWillPassThresholdForLeftLayer(cell: MaterialCollectionViewCell)
//	optional func collectionViewCellWillPassThresholdForRightLayer(cell: MaterialCollectionViewCell)
//	optional func collectionViewCellDidRevealLeftLayer(cell: MaterialCollectionViewCell)
//	optional func collectionViewCellDidRevealRightLayer(cell: MaterialCollectionViewCell)
//	optional func collectionViewCellDidCloseLeftLayer(cell: MaterialCollectionViewCell)
//	optional func collectionViewCellDidCloseRightLayer(cell: MaterialCollectionViewCell)
//}
//
//@objc(MaterialCollectionViewCell)
//public class MaterialCollectionViewCell : MaterialPulseCollectionViewCell, UIGestureRecognizerDelegate {
//	//
//	//	:name:	panRecognizer
//	//
//	private var panRecognizer: UIPanGestureRecognizer!
//	
//	//
//	//	:name:	originalPosition
//	//
//	private var originalPosition: CGPoint!
//	
//	//
//	//	:name:	leftOnDragRelease
//	//
//	private lazy var leftOnDragRelease: Bool = false
//	
//	//
//	//	:name:	rightOnDragRelease
//	//
//	private lazy var rightOnDragRelease: Bool = false
//	
//	/**
//	:name:	leftView
//	*/
//	public private(set) lazy var leftView: MaterialView = MaterialView()
//	
//	/**
//	:name:	rightView
//	*/
//	public private(set) lazy var rightView: MaterialView = MaterialView()
//	
//	/**
//	:name:	revealed
//	*/
//	public private(set) lazy var revealed: Bool = false
//	
//	/**
//	:name:	closeAutomatically
//	*/
//	public lazy var closeAutomatically: Bool = true
//	
//	/**
//	:name:	gestureRecognizerShouldBegin
//	*/
//	public override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
//		if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
//			let translation = panGestureRecognizer.translationInView(superview!)
//			return fabs(translation.x) > fabs(translation.y)
//		}
//		return false
//	}
//	
//	/**
//	:name:	prepareView
//	*/
//	public override func prepareView() {
//		super.prepareView()
//		
//		userInteractionEnabled = MaterialTheme.pulseCollectionView.userInteractionEnabled
//		backgroundColor = MaterialTheme.pulseCollectionView.backgroundColor
//		pulseColorOpacity = MaterialTheme.pulseCollectionView.pulseColorOpacity
//		pulseColor = MaterialTheme.pulseCollectionView.pulseColor
//		
//		depth = MaterialTheme.pulseCollectionView.depth
//		shadowColor = MaterialTheme.pulseCollectionView.shadowColor
//		zPosition = MaterialTheme.pulseCollectionView.zPosition
//		borderWidth = MaterialTheme.pulseCollectionView.borderWidth
//		borderColor = MaterialTheme.pulseCollectionView.bordercolor
//		masksToBounds = true
//		
//		prepareLeftView()
//		prepareRightView()
//		preparePanGesture()
//	}
//	
//	/**
//	:name:	animationDidStop
//	*/
//	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//		super.animationDidStop(anim, finished: flag)
//		
//		if let a: CABasicAnimation = anim as? CABasicAnimation {
//			if "position" == a.keyPath {
//				masksToBounds = true
//				if leftOnDragRelease {
//					(delegate as? MaterialCollectionViewCellDelegate)?.collectionViewCellDidCloseLeftLayer?(self)
//				} else if rightOnDragRelease {
//					(delegate as? MaterialCollectionViewCellDelegate)?.collectionViewCellDidCloseRightLayer?(self)
//				}
//			}
//		}
//	}
//	
//	/**
//	:name:	open
//	*/
//	public func open() {
//		animate(MaterialAnimation.position(CGPointMake(width * 1.5, y + height / 2), duration: 0.25))
//	}
//	
//	/**
//	:name:	close
//	*/
//	public func close() {
//		animate(MaterialAnimation.position(CGPointMake(width / 2, y + height / 2), duration: 0.25))
//	}
//	
//	//
//	//	:name:	prepareLeftView
//	//
//	internal func prepareLeftView() {
//		leftView.frame = CGRectMake(-width, 0, width, height)
//		addSubview(leftView)
//	}
//	
//	//
//	//	:name:	prepareRightView
//	//
//	internal func prepareRightView() {
//		rightView.frame = CGRectMake(width, 0, width, height)
//		addSubview(rightView)
//	}
//	
//	//
//	//	:name:	preparePanGesture
//	//
//	internal func preparePanGesture() {
//		panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
//		panRecognizer.delegate = self
//		addGestureRecognizer(panRecognizer)
//	}
//	
//	//
//	//	:name:	handlePanGesture
//	//
//	internal func handlePanGesture(recognizer: UIPanGestureRecognizer) {
//		switch recognizer.state {
//		case .Began:
//			originalPosition = position
//			masksToBounds = false
//			leftOnDragRelease = x > width / 2
//			rightOnDragRelease = x < -width / 2
//			
//		case .Changed:
//			let translation = recognizer.translationInView(self)
//			MaterialAnimation.animationDisabled {
//				self.position.x = self.originalPosition.x + translation.x
//			}
//			
//			leftOnDragRelease = x > width / 2
//			rightOnDragRelease = x < -width / 2
//			
//			if !revealed && (leftOnDragRelease || rightOnDragRelease) {
//				revealed = true
//				if leftOnDragRelease {
//					(delegate as? MaterialCollectionViewCellDelegate)?.collectionViewCellWillPassThresholdForLeftLayer?(self)
//				} else if rightOnDragRelease {
//					(delegate as? MaterialCollectionViewCellDelegate)?.collectionViewCellWillPassThresholdForRightLayer?(self)
//				}
//			}
//		case .Ended:
//			revealed = false
//			
//			if leftOnDragRelease {
//				(delegate as? MaterialCollectionViewCellDelegate)?.collectionViewCellDidRevealLeftLayer?(self)
//			} else if rightOnDragRelease {
//				(delegate as? MaterialCollectionViewCellDelegate)?.collectionViewCellDidRevealRightLayer?(self)
//			}
//			
//			if !leftOnDragRelease && !rightOnDragRelease {
//				close()
//			} else if closeAutomatically && (leftOnDragRelease || rightOnDragRelease) {
//				close()
//			}
//		default:break
//		}
//	}
//}