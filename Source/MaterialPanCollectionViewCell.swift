//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

@objc(MaterialPanCollectionViewCellDelegate)
public protocol MaterialPanCollectionViewCellDelegate : MaterialDelegate {
	optional func materialCollectionViewCellWillPassThresholdForLeftLayer(cell: MaterialPanCollectionViewCell)
	optional func materialCollectionViewCellWillPassThresholdForRightLayer(cell: MaterialPanCollectionViewCell)
	optional func materialCollectionViewCellDidRevealLeftLayer(cell: MaterialPanCollectionViewCell)
	optional func materialCollectionViewCellDidRevealRightLayer(cell: MaterialPanCollectionViewCell)
	optional func materialCollectionViewCellDidCloseLeftLayer(cell: MaterialPanCollectionViewCell)
	optional func materialCollectionViewCellDidCloseRightLayer(cell: MaterialPanCollectionViewCell)
}

@objc(MaterialPanCollectionViewCell)
public class MaterialPanCollectionViewCell : MaterialPulseCollectionViewCell, UIGestureRecognizerDelegate {
	//
	//	:name:	panRecognizer
	//
	private var panRecognizer: UIPanGestureRecognizer!
	
	//
	//	:name:	originalPosition
	//
	private var originalPosition: CGPoint!
	
	//
	//	:name:	leftOnDragRelease
	//
	private lazy var leftOnDragRelease: Bool = false
	
	//
	//	:name:	rightOnDragRelease
	//
	private lazy var rightOnDragRelease: Bool = false
	
	/**
		:name:	leftView
	*/
	public private(set) lazy var leftView: MaterialView = MaterialView()
	
	/**
		:name:	rightView
	*/
	public private(set) lazy var rightView: MaterialView = MaterialView()
	
	/**
		:name:	revealed
	*/
	public private(set) lazy var revealed: Bool = false
	
	/**
		:name:	closeAutomatically
	*/
	public lazy var closeAutomatically: Bool = true
	
	/**
		:name:	gestureRecognizerShouldBegin
	*/
	public override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
			let translation = panGestureRecognizer.translationInView(superview!)
			return fabs(translation.x) > fabs(translation.y)
		}
		return false
	}
	
	/**
		:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		
		userInteractionEnabled = MaterialTheme.pulseCollectionView.userInteractionEnabled
		backgroundColor = MaterialTheme.pulseCollectionView.backgroundColor
		pulseColorOpacity = MaterialTheme.pulseCollectionView.pulseColorOpacity
		pulseColor = MaterialTheme.pulseCollectionView.pulseColor
		
		shadowDepth = MaterialTheme.pulseCollectionView.shadowDepth
		shadowColor = MaterialTheme.pulseCollectionView.shadowColor
		zPosition = MaterialTheme.pulseCollectionView.zPosition
		borderWidth = MaterialTheme.pulseCollectionView.borderWidth
		borderColor = MaterialTheme.pulseCollectionView.bordercolor
		masksToBounds = true
		
		prepareLeftView()
		prepareRightView()
		preparePanGesture()
	}
	
	/**
		:name:	animationDidStop
	*/
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		super.animationDidStop(anim, finished: flag)
		
		if let a: CABasicAnimation = anim as? CABasicAnimation {
			if "position" == a.keyPath {
				masksToBounds = true
				if leftOnDragRelease {
					(delegate as? MaterialPanCollectionViewCellDelegate)?.materialCollectionViewCellDidCloseLeftLayer?(self)
				} else if rightOnDragRelease {
					(delegate as? MaterialPanCollectionViewCellDelegate)?.materialCollectionViewCellDidCloseRightLayer?(self)
				}
			}
		}
	}
	
	/**
		:name:	close
	*/
	public func close() {
		animation(MaterialAnimation.position(CGPointMake(width / 2, y + height / 2), duration: 0.25))
	}
	
	//
	//	:name:	prepareLeftView
	//
	internal func prepareLeftView() {
		leftView.frame = CGRectMake(-width, 0, width, height)
		addSubview(leftView)
	}
	
	//
	//	:name:	prepareRightView
	//
	internal func prepareRightView() {
		rightView.frame = CGRectMake(width, 0, width, height)
		addSubview(rightView)
	}
	
	//
	//	:name:	preparePanGesture
	//
	internal func preparePanGesture() {
		panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
		panRecognizer.delegate = self
		addGestureRecognizer(panRecognizer)
	}
	
	//
	//	:name:	handlePanGesture
	//
	internal func handlePanGesture(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .Began:
			originalPosition = position
			masksToBounds = false
			leftOnDragRelease = x > width / 2
			rightOnDragRelease = x < -width / 2
			
		case .Changed:
			let translation = recognizer.translationInView(self)
			MaterialAnimation.animationDisabled({
				self.position.x = self.originalPosition.x + translation.x
			})
			
			leftOnDragRelease = x > width / 2
			rightOnDragRelease = x < -width / 2
			
			if !revealed && (leftOnDragRelease || rightOnDragRelease) {
				revealed = true
				if leftOnDragRelease {
					(delegate as? MaterialPanCollectionViewCellDelegate)?.materialCollectionViewCellWillPassThresholdForLeftLayer?(self)
				} else if rightOnDragRelease {
					(delegate as? MaterialPanCollectionViewCellDelegate)?.materialCollectionViewCellWillPassThresholdForRightLayer?(self)
				}
			}
			
			if leftOnDragRelease {
				(delegate as? MaterialPanCollectionViewCellDelegate)?.materialCollectionViewCellDidRevealLeftLayer?(self)
			} else if rightOnDragRelease {
				(delegate as? MaterialPanCollectionViewCellDelegate)?.materialCollectionViewCellDidRevealRightLayer?(self)
			}
			
		case .Ended:
			revealed = false
			// snap back
			if !leftOnDragRelease || !rightOnDragRelease {
				close()
			} else if closeAutomatically && (leftOnDragRelease || rightOnDragRelease) {
				close()
			}
			
		default:break
		}
	}
}