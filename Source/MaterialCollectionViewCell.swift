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
	//	:name:	leftOnDragRelease
	//
	private lazy var leftOnDragRelease: Bool = false
	
	//
	//	:name:	rightOnDragRelease
	//
	private lazy var rightOnDragRelease: Bool = false
	
	//
	//	:name:	originalPosition
	//
	private var originalPosition: CGPoint!
	
	/**
		:name:	leftLayer
	*/
	public private(set) lazy var leftLayer: MaterialLayer = MaterialLayer()
	
	/**
		:name:	rightLayer
	*/
	public private(set) lazy var rightLayer: MaterialLayer = MaterialLayer()
	
	/**
		:name:	revealed
	*/
	public private(set) lazy var revealed: Bool = false
	
	/**
		:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
		:name:	init
	*/
	public override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectNull)
	}
	
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
		userInteractionEnabled = MaterialTheme.flatButton.userInteractionEnabled
		backgroundColor = MaterialTheme.flatButton.backgroundColor
		pulseColorOpacity = MaterialTheme.flatButton.pulseColorOpacity
		pulseColor = MaterialTheme.flatButton.pulseColor
		
		shadowDepth = MaterialTheme.flatButton.shadowDepth
		shadowColor = MaterialTheme.flatButton.shadowColor
		zPosition = MaterialTheme.flatButton.zPosition
		cornerRadius = MaterialTheme.flatButton.cornerRadius
		borderWidth = MaterialTheme.flatButton.borderWidth
		borderColor = MaterialTheme.flatButton.bordercolor
		shape = MaterialTheme.flatButton.shape
		
		prepareVisualLayer()
		preparePulseLayer()
		prepareLeftLayer()
		prepareRightLayer()
		preparePanGesture()
	}
	
	//
	//	:name:	prepareLeftLayer
	//
	internal func prepareLeftLayer() {
		leftLayer.frame = CGRectMake(-width, 0, width, height)
		layer.addSublayer(leftLayer)
	}
	
	//
	//	:name:	prepareRightLayer
	//
	internal func prepareRightLayer() {
		rightLayer.frame = CGRectMake(width, 0, width, height)
		layer.addSublayer(rightLayer)
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
			
			rightOnDragRelease = x < -width / 2
			leftOnDragRelease = x > width / 2
			
		case .Changed:
			let translation = recognizer.translationInView(self)
			MaterialAnimation.animationDisabled({
				self.position.x = self.originalPosition.x + translation.x
			})
			
			rightOnDragRelease = x < -width / 2
			leftOnDragRelease = x > width / 2
			
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
			let a: CABasicAnimation = MaterialAnimation.position(CGPointMake(width / 2, y + height / 2), duration: 0.25)
			a.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
			animation(a)
			
			if leftOnDragRelease {
				(delegate as? MaterialPanCollectionViewCellDelegate)?.materialCollectionViewCellDidCloseLeftLayer?(self)
			} else if rightOnDragRelease {
				(delegate as? MaterialPanCollectionViewCellDelegate)?.materialCollectionViewCellDidCloseRightLayer?(self)
			}
			
		default:break
		}
	}
}