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

public class FlatButton : UIButton {
    
    public var textColor: UIColor?
    public var pulseColor: UIColor?
    
    private var vLine: UIView = UIView()
    private var hLine: UIView = UIView()
    private var backgroundColorView: UIView = UIView()
    private var pulseView: UIView?
    
    public override func drawRect(rect: CGRect) {
        setupContext(rect)
        setupBackgroundColorView()
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
        pulseColor = UIColor.whiteColor()
        setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    func setupContext(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        CGContextFillPath(context)
        CGContextRestoreGState(context);
    }
    
    // We need this view so we can use the masksToBounds
    // so the pulse doesn't animate off the button
    func setupBackgroundColorView() {
        backgroundColorView.frame = self.bounds
        backgroundColorView.layer.cornerRadius = 3.0
        backgroundColorView.backgroundColor = UIColor.clearColor()
        backgroundColorView.layer.masksToBounds = true
        self.insertSubview(backgroundColorView, atIndex: 0)
    }
    
    func applyShadow() {
        layer.shadowOffset = CGSizeMake(1, 1)
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
    }
    
    public override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        pulseTouches(touches)
    }
    
    public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        shrink()
        removePulse()
    }
    
    func pulseTouches(touches: NSSet) {
        let touch = touches.allObjects.last as! UITouch
        let touchLocation = touch.locationInView(self)
        pulseView = UIView()
        pulseView!.frame = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)
        pulseView!.layer.cornerRadius = bounds.height / 2.0
        pulseView!.center = touchLocation
        pulseView!.backgroundColor = pulseColor!.colorWithAlphaComponent(0.5)
        backgroundColorView.addSubview(pulseView!)
        textColor = self.titleLabel?.textColor
        UIView.animateWithDuration(0.3, animations: {
            self.pulseView!.transform = CGAffineTransformMakeScale(10, 10)
            self.transform = CGAffineTransformMakeScale(1.05, 1.1)
            self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            }, completion: nil)
    }
    
    func shrink() {
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: nil, animations: {
            self.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func removePulse() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.pulseView!.alpha = 0.0
            self.setTitleColor(self.textColor, forState: .Normal)
            }) { (finished) -> Void in
            self.pulseView!.removeFromSuperview()
            self.pulseView = nil
        }
    }
}
