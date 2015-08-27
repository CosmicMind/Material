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
	/**
		:name:	lineWidth
	*/
	public var lineWidth: CGFloat = 2.0
	
	/**
		:name:	init
	*/
	public required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialize()
	}
	
	/**
		:name:	init
	*/
	public required init(frame: CGRect) {
		super.init(frame: frame)
		initialize()
	}
	
	/**
		:name:	drawRect
	*/
    public override func drawRect(rect: CGRect) {
        prepareContext(rect)
        prepareBackgroundColorView()
        preparePlus()
    }
	
	//
	//	:name:	initialize
	//
    internal func initialize() {
        color = .redColor()
        pulseColor = .whiteColor()
        setTranslatesAutoresizingMaskIntoConstraints(false)
    }
	
	//
	//	:name:	prepareContext
	//
    private func prepareContext(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context);
        CGContextAddEllipseInRect(context, rect)
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        CGContextFillPath(context)
        CGContextRestoreGState(context);
    }
	
	//
	//	:name: prepareBackgroundColorView
	//
    // We need this view so we can use the masksToBounds
    // so the pulse doesn't animate off the button
    func prepareBackgroundColorView() {
        backgroundColorView = UIView()
        backgroundColorView!.frame = bounds
        backgroundColorView!.layer.cornerRadius = bounds.width / 2.0
        backgroundColorView!.backgroundColor = color
        backgroundColorView!.layer.masksToBounds = true
		backgroundColorView!.userInteractionEnabled = false
        insertSubview(backgroundColorView!, atIndex: 0)
    }
	
	//
	//	:name: preparePlus
	//
    // I make the + with two views because
    // The label is not actually vertically and horizontally aligned
    // Quick hack instead of subclassing UILabel and override drawTextInRect
    private func preparePlus() {
        prepareVerticalLine()
        prepareHorizontalLine()
    }
    
    private func prepareVerticalLine() {
        verticalLine = UIView(frame: CGRectMake(0, 0, lineWidth, CGRectGetHeight(backgroundColorView!.frame) / 3.0))
        verticalLine!.backgroundColor = UIColor.whiteColor()
        verticalLine!.center = backgroundColorView!.center
        backgroundColorView!.addSubview(verticalLine!)
    }
    
    private func prepareHorizontalLine() {
        horizontalLine = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(backgroundColorView!.frame) / 3.0, lineWidth))
        horizontalLine!.backgroundColor = UIColor.whiteColor()
        horizontalLine!.center = backgroundColorView!.center
        backgroundColorView!.addSubview(horizontalLine!)
    }
}
