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

public class FabButton : MaterialButton {
    
    var lineWidth: CGFloat = 2.0
	
    public convenience init() {
		self.init(frame: CGRectZero)
	}
	
    public override func drawRect(rect: CGRect) {
        setupContext(rect)
        setupBackgroundColorView()
        setupPlus()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
        applyShadow()
    }
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        applyShadow()
    }
    
    func initialize() {
        color = UIColor.redColor()
        pulseColor = UIColor.whiteColor()
        setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    func setupContext(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context);
        CGContextAddEllipseInRect(context, rect)
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        CGContextFillPath(context)
        CGContextRestoreGState(context);
    }
    
    // We need this view so we can use the masksToBounds
    // so the pulse doesn't animate off the button
    func setupBackgroundColorView() {
        backgroundColorView = UIView()
        backgroundColorView!.frame = bounds
        backgroundColorView!.layer.cornerRadius = bounds.width / 2.0
        backgroundColorView!.backgroundColor = color
        backgroundColorView!.layer.masksToBounds = true
		backgroundColorView!.userInteractionEnabled = false
        insertSubview(backgroundColorView!, atIndex: 0)
    }
    
    // I make the + with two views because
    // The label is not actually vertically and horizontally aligned
    // Quick hack instead of subclassing UILabel and override drawTextInRect
    func setupPlus() {
        setupVerticalLine()
        setupHorizontalLine()
    }
    
    func setupVerticalLine() {
        verticalLine = UIView(frame: CGRectMake(0, 0, lineWidth, CGRectGetHeight(backgroundColorView!.frame) / 3.0))
        verticalLine!.backgroundColor = UIColor.whiteColor()
        verticalLine!.center = backgroundColorView!.center
        backgroundColorView!.addSubview(verticalLine!)
    }
    
    func setupHorizontalLine() {
        horizontalLine = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(backgroundColorView!.frame) / 3.0, lineWidth))
        horizontalLine!.backgroundColor = UIColor.whiteColor()
        horizontalLine!.center = backgroundColorView!.center
        backgroundColorView!.addSubview(horizontalLine!)
    }
    
    func applyShadow() {
        layer.shadowOffset = CGSizeMake(1, 1)
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
    }
    
	public override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		super.touchesBegan(touches, withEvent: event)
		pulseTouches(touches)
	}
	
	public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
		super.touchesEnded(touches, withEvent: event)
		shrink()
		removePulse()
	}
	
	public override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
		super.touchesCancelled(touches, withEvent: event)
		shrink()
		removePulse()
	}
	
    func pulseTouches(touches: NSSet) {
        let touch = touches.allObjects.last as! UITouch
        let touchLocation = touch.locationInView(self)
        pulseView = UIView()
        pulseView!.frame = CGRectMake(0, 0, bounds.width, bounds.height)
        pulseView!.layer.cornerRadius = bounds.width / 2.0
        pulseView!.center = touchLocation
        pulseView!.backgroundColor = pulseColor!.colorWithAlphaComponent(0.5)
        backgroundColorView!.addSubview(pulseView!)
        UIView.animateWithDuration(0.3, animations: {
           self.pulseView!.transform = CGAffineTransformMakeScale(3, 3)
           self.transform = CGAffineTransformMakeScale(1.1, 1.1)
        }, completion: nil)
    }
    
    func shrink() {
        UIView.animateWithDuration(0.3,
			delay: 0.0,
			usingSpringWithDamping: 0.2,
			initialSpringVelocity: 10,
			options: nil,
			animations: {
				self.transform = CGAffineTransformIdentity
			},
			completion: nil
		)
    }
    
    func removePulse() {
        UIView.animateWithDuration(0.3, animations: { _ in
            self.pulseView?.alpha = 0.0
        }) { (finished) -> Void in
            self.pulseView?.removeFromSuperview()
            self.pulseView = nil
        }
    }
}
