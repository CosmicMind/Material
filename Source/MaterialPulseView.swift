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

public class MaterialPulseView : MaterialView {
    internal lazy var views: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
    
    public var backgroundColorView: UIView?
    public var pulseView: UIView?
    
    public var color: UIColor?
    public var pulseColor: UIColor?
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
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
	
    internal func initialize() {
        setupSelf()
        setupLayer()
        setupBackgroundColorView()
        constrainSubviews()
    }
	
	internal func constrainSubviews() {
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[backgroundColorView]|", options: nil, metrics: nil, views: views))
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[backgroundColorView]|", options: nil, metrics: nil, views: views))
	}
	
    private func setupSelf() {
        color = UIColor.clearColor()
        pulseColor = UIColor.whiteColor()
        setTranslatesAutoresizingMaskIntoConstraints(false)
        backgroundColor = UIColor(red: 66.0/255.0, green: 91.0/255.0, blue: 103.0/255.0, alpha: 1.0)
    }
    
    private func setupLayer() {
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeMake(0.5, 0.5)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.4
        layer.shadowPath = UIBezierPath(rect: bounds).CGPath
        layer.cornerRadius = 2.0
    }
    
    // We need this view so we can use the masksToBounds
    // so the pulse doesn't animate off the button
    private func setupBackgroundColorView() {
        backgroundColorView = UIView()
        backgroundColorView?.userInteractionEnabled = false
        backgroundColorView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        backgroundColorView!.layer.cornerRadius = 2.0
        backgroundColorView!.backgroundColor = color
        backgroundColorView!.layer.masksToBounds = true
        addSubview(backgroundColorView!)
        views["backgroundColorView"] = backgroundColorView
    }
	
    private func pulseTouches(touches: NSSet) {
        let touch = touches.allObjects.last as! UITouch
        let touchLocation = touch.locationInView(self)
        pulseView = UIView()
        pulseView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        var width = bounds.size.width / 3.0
        pulseView!.frame = CGRectMake(0, 0, width, width)
        pulseView!.layer.cornerRadius = width / 2.0
        pulseView!.center = touchLocation
        pulseView!.backgroundColor = pulseColor!.colorWithAlphaComponent(0.1)
        backgroundColorView!.addSubview(pulseView!)
        UIView.animateWithDuration(0.3, animations: {
            self.pulseView!.transform = CGAffineTransformMakeScale(3, 3)
            self.transform = CGAffineTransformMakeScale(1.05, 1.05)
        }, completion: nil)
    }
    
    private func shrink() {
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: nil, animations: {
            self.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    private func removePulse() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.pulseView?.alpha = 0.0
            }) { (finished) -> Void in
			self.pulseView?.removeFromSuperview()
			self.pulseView = nil
        }
    }
}
