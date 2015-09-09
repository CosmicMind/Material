//
// Copyright (C) 1615 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
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

public class ImageCardView : MaterialCardView, Comparable, Equatable {
    
    //
    //	:name:	showRevealButton
    //
    private struct revealOptions {
        private static var buttonWidth: CGFloat = 40
        private static var buttonHeight: CGFloat = 40
        private static var padding: CGFloat = 10
        private static var animationDuration: NSTimeInterval = 0.3
    }
    
    //
    //	:name:	showRevealButton
    //
    public var showRevealButton: FlatButton = FlatButton()
    
    //
    //	:name:	hideRevealButton
    //
    public var hideRevealButton: FlatButton = FlatButton()
    
    //
    //	:name:	reviewView
    //
    public var revealView: MaterialCardView = MaterialCardView()
    
    //
    //	:name:	revealed
    //
    private var revealed: Bool = false
    
    //
    //	:name:	backingView
    //
    internal lazy var backingView: UIView = UIView()
    
    //
    //	:name:	layoutConstraints
    //
    internal lazy var layoutConstraints: Array<NSLayoutConstraint> = Array<NSLayoutConstraint>()
    
    //
    //	:name:	views
    //
    internal lazy var views: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
    
    /**
    :name:	imageViewVerticalInset
    */
    public var imageViewVerticalInset: CGFloat = 0 {
        didSet {
            imageViewTopInset = imageViewVerticalInset
            imageViewBottomInset = imageViewVerticalInset
        }
    }
    
    /**
    :name:	imageViewTopInset
    */
    public var imageViewTopInset: CGFloat = 0
    
    /**
    :name:	imageViewBottomInset
    */
    public var imageViewBottomInset: CGFloat = 0
    
    /**
    :name:	imageViewHorizontalInset
    */
    public var imageViewHorizontalInset: CGFloat = 0 {
        didSet {
            imageViewLeftInset = imageViewHorizontalInset
            imageViewRightInset = imageViewHorizontalInset
        }
    }
    
    /**
    :name:	imageViewLeftInset
    */
    public var imageViewLeftInset: CGFloat = 0
    
    /**
    :name:	imageViewRightInset
    */
    public var imageViewRightInset: CGFloat = 0
    
    /**
    :name:	titleLabelVerticalInset
    */
    public var titleLabelVerticalInset: CGFloat = MaterialTheme.verticalInset {
        didSet {
            titleLabelBottomInset = titleLabelVerticalInset
        }
    }
    
    /**
    :name:	titleLabelBottomInset
    */
    public var titleLabelBottomInset: CGFloat = MaterialTheme.verticalInset
    
    /**
    :name:	titleLabelHorizontalInset
    */
    public var titleLabelHorizontalInset: CGFloat = MaterialTheme.horizontalInset {
        didSet {
            titleLabelLeftInset = titleLabelHorizontalInset
            titleLabelRightInset = titleLabelHorizontalInset
        }
    }
    
    /**
    :name:	titleLabelLeftInset
    */
    public var titleLabelLeftInset: CGFloat = MaterialTheme.horizontalInset
    
    /**
    :name:	titleLabelRightInset
    */
    public var titleLabelRightInset: CGFloat = MaterialTheme.horizontalInset
    
    /**
    :name:	detailLabelVerticalInset
    */
    public var detailLabelVerticalInset: CGFloat = MaterialTheme.verticalInset {
        didSet {
            detailLabelTopInset = detailLabelVerticalInset
            detailLabelBottomInset = detailLabelVerticalInset
        }
    }
    
    /**
    :name:	detailLabelTopInset
    */
    public var detailLabelTopInset: CGFloat = MaterialTheme.verticalInset
    
    /**
    :name:	detailLabelBottomInset
    */
    public var detailLabelBottomInset: CGFloat = MaterialTheme.verticalInset
    
    /**
    :name:	detailLabelHorizontalInset
    */
    public var detailLabelHorizontalInset: CGFloat = MaterialTheme.horizontalInset {
        didSet {
            detailLabelLeftInset = detailLabelHorizontalInset
            detailLabelRightInset = detailLabelHorizontalInset
        }
    }
    
    /**
    :name:	detailLabelLeftInset
    */
    public var detailLabelLeftInset: CGFloat = MaterialTheme.horizontalInset
    
    /**
    :name:	detailLabelRightInset
    */
    public var detailLabelRightInset: CGFloat = MaterialTheme.horizontalInset
    
    /**
    :name:	buttonVerticalInset
    */
    public var buttonVerticalInset: CGFloat = MaterialTheme.verticalInset {
        didSet {
            buttonTopInset = buttonVerticalInset
            buttonBottomInset = buttonVerticalInset
        }
    }
    
    /**
    :name:	buttonTopInset
    */
    public var buttonTopInset: CGFloat = MaterialTheme.verticalInset
    
    /**
    :name:	buttonBottomInset
    */
    public var buttonBottomInset: CGFloat = MaterialTheme.verticalInset
    
    /**
    :name:	buttonHorizontalInset
    */
    public var buttonHorizontalInset: CGFloat = MaterialTheme.horizontalInset {
        didSet {
            buttonLeftInset = buttonHorizontalInset
            buttonRightInset = buttonHorizontalInset
        }
    }
    
    /**
    :name:	buttonLeftInset
    */
    public var buttonLeftInset: CGFloat = MaterialTheme.horizontalInset
    
    /**
    :name:	buttonRightInset
    */
    public var buttonRightInset: CGFloat = MaterialTheme.horizontalInset
    
    /**
    :name:	shadow
    */
    public var shadow: Bool = true {
        didSet {
            false == shadow ? removeShadow() : prepareShadow()
        }
    }
    
    /**
    :name:	maximumImageViewHeight
    */
    public var maximumImageViewHeight: CGFloat = 200
    
    /**
    :name:	reveable
    */
    public var revealable: Bool? {
        didSet {
            if revealable! {
                prepareShowRevealButton()
                prepareRevealView()
                prepareHideRevealButton()
            }
        }
    }
    
    /**
    :name:	imageViewContainer
    */
    public private(set) var imageViewContainer: UIView?
    
    /**
    :name:	imageView
    */
    public var imageView: UIImageView? {
        didSet {
            if let t = imageView {
                // container
                if nil == imageViewContainer {
                    imageViewContainer = UIView()
                    imageViewContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
                    imageViewContainer!.backgroundColor = MaterialTheme.clear.color
                    backingView.addSubview(imageViewContainer!)
                }
                
                // text
                imageViewContainer!.addSubview(t)
                t.setTranslatesAutoresizingMaskIntoConstraints(false)
                t.contentMode = .ScaleAspectFill
                t.userInteractionEnabled = false
                t.clipsToBounds = true
                if nil != titleLabel {
                    titleLabelContainer!.backgroundColor = MaterialTheme.clear.color
                    titleLabel!.textColor = MaterialTheme.white.color
                    titleLabelContainer!.removeFromSuperview()
                    imageViewContainer!.addSubview(titleLabelContainer!)
                }
                prepareCard()
            } else {
                imageViewContainer?.removeFromSuperview()
            }
        }
    }
    
    /**
    :name:	titleLabelContainer
    */
    public private(set) var titleLabelContainer: UIView?
    
    /**
    :name:	titleLabel
    */
    public var titleLabel: UILabel? {
        didSet {
            if let t = titleLabel {
                // container
                if nil == titleLabelContainer {
                    titleLabelContainer = UIView()
                    titleLabelContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
                    backingView.addSubview(titleLabelContainer!)
                }
                
                // text
                titleLabelContainer!.addSubview(t)
                t.setTranslatesAutoresizingMaskIntoConstraints(false)
                t.backgroundColor = MaterialTheme.clear.color
                t.font = Roboto.medium
                t.numberOfLines = 1
                t.lineBreakMode = .ByTruncatingTail
                if nil == imageView {
                    titleLabelContainer!.backgroundColor = MaterialTheme.white.color
                    t.textColor = MaterialTheme.black.color
                } else {
                    titleLabelContainer!.backgroundColor = MaterialTheme.clear.color
                    t.textColor = MaterialTheme.white.color
                    titleLabelContainer!.removeFromSuperview()
                    imageViewContainer!.addSubview(titleLabelContainer!)
                }
                prepareCard()
            } else {
                titleLabelContainer?.removeFromSuperview()
            }
        }
    }
    
    /**
    :name:	maximumDetailLabelHeight
    */
    public var maximumDetailLabelHeight: CGFloat = 144
    
    /**
    :name:	detailLabelContainer
    */
    public private(set) var detailLabelContainer: UIView?
    
    /**
    :name:	detailLabel
    */
    public var detailLabel: UILabel? {
        didSet {
            if let l = detailLabel {
                // container
                if nil == detailLabelContainer {
                    detailLabelContainer = UIView()
                    detailLabelContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
                    detailLabelContainer!.backgroundColor = MaterialTheme.white.color
                    backingView.addSubview(detailLabelContainer!)
                }
                
                // text
                detailLabelContainer!.addSubview(l)
                l.setTranslatesAutoresizingMaskIntoConstraints(false)
                l.textColor = MaterialTheme.black.color
                l.backgroundColor = MaterialTheme.clear.color
                l.font = Roboto.light
                l.numberOfLines = 0
                l.lineBreakMode = .ByTruncatingTail
                prepareCard()
            } else {
                detailLabelContainer?.removeFromSuperview()
            }
        }
    }
    
    /**
    :name:	divider
    */
    public var divider: UIView? {
        didSet {
            if let d = divider {
                d.setTranslatesAutoresizingMaskIntoConstraints(false)
                d.backgroundColor = MaterialTheme.blueGrey.lighten5
                backingView.addSubview(d)
                prepareCard()
            } else {
                divider?.removeFromSuperview()
            }
        }
    }
    
    /**
    :name:	buttonsContainer
    */
    public private(set) var buttonsContainer: UIView?
    
    /**
    :name:	leftButtons
    */
    public var leftButtons: Array<MaterialButton>? {
        didSet {
            if let b = leftButtons {
                if nil == buttonsContainer {
                    buttonsContainer = UIView()
                    buttonsContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
                    buttonsContainer!.backgroundColor = MaterialTheme.white.color
                    backingView.addSubview(buttonsContainer!)
                }
                prepareCard()
            } else {
                buttonsContainer?.removeFromSuperview()
            }
        }
    }
    
    /**
    :name:	rightButtons
    */
    public var rightButtons: Array<MaterialButton>? {
        didSet {
            if let b = rightButtons {
                if nil == buttonsContainer {
                    buttonsContainer = UIView()
                    buttonsContainer!.setTranslatesAutoresizingMaskIntoConstraints(false)
                    buttonsContainer!.backgroundColor = MaterialTheme.white.color
                    backingView.addSubview(buttonsContainer!)
                }
                prepareCard()
            } else {
                buttonsContainer?.removeFromSuperview()
            }
        }
    }
    
    /**
    :name:	init
    */
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
    :name:	init
    */
    public convenience init?(imageView: UIImageView? = nil, titleLabel: UILabel? = nil, detailLabel: UILabel? = nil, divider: UIView? = nil, leftButtons: Array<MaterialButton>? = nil, rightButtons: Array<MaterialButton>? = nil) {
        self.init(frame: CGRectZero)
        prepareProperties(imageView, titleLabel: titleLabel, detailLabel: detailLabel, divider: divider, leftButtons: leftButtons, rightButtons: rightButtons)
    }
    
    /**
    :name:	init
    */
    public required init(frame: CGRect) {
        super.init(frame: CGRectZero)
    }
    
    //
    //	:name:	prepareProperties
    //
    internal func prepareProperties(imageView: UIImageView?, titleLabel: UILabel?, detailLabel: UILabel?, divider: UIView?, leftButtons: Array<MaterialButton>?, rightButtons: Array<MaterialButton>?) {
        self.imageView = imageView
        self.titleLabel = titleLabel
        self.detailLabel = detailLabel
        self.divider = divider
        self.leftButtons = leftButtons
        self.rightButtons = rightButtons
    }
    
    //
    //	:name:	prepareView
    //
    internal override func prepareView() {
        prepareBackingView()
        super.prepareView()
        prepareShadow()
        backgroundColor = MaterialTheme.blueGrey.darken1
    }
    
    //
    //	:name:	prepareBackingView
    //
    internal func prepareBackingView() {
        backingView.clipsToBounds = true
        addSubview(backingView)
        Layout.alignAllSides(self, child: backingView)
    }
    
    //
    //	:name:	prepareCard
    //
    internal override func prepareCard() {
        super.prepareCard()
        
        // deactivate and clear all constraints
        NSLayoutConstraint.deactivateConstraints(layoutConstraints)
        layoutConstraints.removeAll(keepCapacity: false)
        
        // detect all components and create constraints
        var verticalFormat: String = "V:|"
        
        // image
        if nil != imageViewContainer && nil != imageView {
            // clear for updated constraints
            imageViewContainer!.removeConstraints(imageViewContainer!.constraints())
            
            // container
            layoutConstraints += Layout.constraint("H:|[imageViewContainer]|", options: nil, metrics: nil, views: ["imageViewContainer": imageViewContainer!])
            verticalFormat += "[imageViewContainer]"
            views["imageViewContainer"] = imageViewContainer!
            
            // text
            Layout.expandToParentHorizontallyWithPad(imageViewContainer!, child: imageView!, left: imageViewLeftInset, right: imageViewRightInset)
            imageViewContainer!.addConstraints(Layout.constraint("V:|-(imageViewTopInset)-[imageView(maximumImageViewHeight)]-(imageViewBottomInset)-|", options: nil, metrics: ["imageViewTopInset": imageViewTopInset, "imageViewBottomInset": imageViewBottomInset, "maximumImageViewHeight": maximumImageViewHeight], views: ["imageView": imageView!]))
        }
        
        // title
        if nil != titleLabelContainer && nil != titleLabel {
            // clear for updated constraints
            titleLabelContainer!.removeConstraints(titleLabelContainer!.constraints())
            
            if nil == imageView {
                // container
                layoutConstraints += Layout.constraint("H:|[titleLabelContainer]|", options: nil, metrics: nil, views: ["titleLabelContainer": titleLabelContainer!])
                verticalFormat += "[titleLabelContainer]"
                views["titleLabelContainer"] = titleLabelContainer!
            } else {
                //container
                Layout.alignFromBottomLeft(imageViewContainer!, child: titleLabelContainer!)
                Layout.expandToParentHorizontally(imageViewContainer!, child: titleLabelContainer!)
            }
            
            // common text
            Layout.height(titleLabelContainer!, child: titleLabel!, height: 1.5 * titleLabel!.font.pointSize)
            Layout.expandToParentWithPad(titleLabelContainer!, child: titleLabel!, left: titleLabelLeftInset, bottom: titleLabelBottomInset, right: titleLabelRightInset)
        }
        
        // detail
        if nil != detailLabelContainer && nil != detailLabel {
            // clear for updated constraints
            detailLabelContainer!.removeConstraints(detailLabelContainer!.constraints())
            
            // container
            layoutConstraints += Layout.constraint("H:|[detailLabelContainer]|", options: nil, metrics: nil, views: ["detailLabelContainer": detailLabelContainer!])
            verticalFormat += "[detailLabelContainer]"
            views["detailLabelContainer"] = detailLabelContainer!
            
            // text
            Layout.expandToParentHorizontallyWithPad(detailLabelContainer!, child: detailLabel!, left: detailLabelLeftInset, right: detailLabelRightInset)
            detailLabelContainer!.addConstraints(Layout.constraint("V:|-(detailLabelTopInset)-[detailLabel(<=maximumDetailLabelHeight)]-(detailLabelBottomInset)-|", options: nil, metrics: ["detailLabelTopInset": detailLabelTopInset, "detailLabelBottomInset": detailLabelBottomInset, "maximumDetailLabelHeight": maximumDetailLabelHeight], views: ["detailLabel": detailLabel!]))
        }
        
        // buttons
        if nil != buttonsContainer && (nil != leftButtons || nil != rightButtons) {
            // clear for updated constraints
            buttonsContainer!.removeConstraints(buttonsContainer!.constraints())
            
            // divider
            if nil != divider {
                layoutConstraints += Layout.constraint("H:|[divider]|", options: nil, metrics: nil, views: ["divider": divider!])
                views["divider"] = divider!
                verticalFormat += "[divider(1)]"
            }
            
            //container
            layoutConstraints += Layout.constraint("H:|[buttonsContainer]|", options: nil, metrics: nil, views: ["buttonsContainer": buttonsContainer!])
            verticalFormat += "[buttonsContainer]"
            views["buttonsContainer"] = buttonsContainer!
            
            // leftButtons
            if nil != leftButtons {
                var horizontalFormat: String = "H:|"
                var buttonViews: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
                for var i: Int = 0, l: Int = leftButtons!.count; i < l; ++i {
                    let button: MaterialButton = leftButtons![i]
                    buttonsContainer!.addSubview(button)
                    buttonViews["button\(i)"] = button
                    horizontalFormat += "-(buttonLeftInset)-[button\(i)]"
                    Layout.expandToParentVerticallyWithPad(buttonsContainer!, child: button, top: buttonTopInset, bottom: buttonBottomInset)
                }
                buttonsContainer!.addConstraints(Layout.constraint(horizontalFormat, options: nil, metrics: ["buttonLeftInset": buttonLeftInset], views: buttonViews))
            }
            
            // rightButtons
            if nil != rightButtons {
                var horizontalFormat: String = "H:"
                var buttonViews: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
                for var i: Int = 0, l: Int = rightButtons!.count; i < l; ++i {
                    let button: MaterialButton = rightButtons![i]
                    buttonsContainer!.addSubview(button)
                    buttonViews["button\(i)"] = button
                    horizontalFormat += "[button\(i)]-(buttonRightInset)-"
                    Layout.expandToParentVerticallyWithPad(buttonsContainer!, child: button, top: buttonTopInset, bottom: buttonBottomInset)
                }
                buttonsContainer!.addConstraints(Layout.constraint(horizontalFormat + "|", options: nil, metrics: ["buttonRightInset": buttonRightInset], views: buttonViews))
            }
        }
        
        verticalFormat += "|"
        
        // combine constraints
        if 0 < layoutConstraints.count {
            layoutConstraints += Layout.constraint(verticalFormat, options: nil, metrics: nil, views: views)
            NSLayoutConstraint.activateConstraints(layoutConstraints)
        }
    }
    
    // MARK: REVEAL STUFF
    
    //
    //	:name:	prepareShowRevealButton
    //
    internal func prepareShowRevealButton() {
        showRevealButton.setTitle("Reveal", forState: .Normal)
        showRevealButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        showRevealButton.addTarget(self, action: "showReveal", forControlEvents: UIControlEvents.TouchUpInside)
        if leftButtons == nil {
            leftButtons = [showRevealButton]
        } else {
            rightButtons = [showRevealButton]
        }
    }
    
    //
    //	:name:	prepareRevealView
    //
    internal func prepareRevealView() {
        revealView.backgroundColor = MaterialTheme.teal.darken1
        revealView.pulseColor = UIColor.whiteColor()
        revealView.baseTransform = CGAffineTransformMakeScale(0.95, 0.95)
        revealView.setTranslatesAutoresizingMaskIntoConstraints(false)
        backingView.addSubview(revealView)
        backingView.addConstraint(NSLayoutConstraint(item: revealView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: backingView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        backingView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[revealView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["revealView" : revealView]))
        backingView.addConstraint(NSLayoutConstraint(item: revealView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: backingView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
    }
    
    //
    //	:name:	prepareHideRevealButton
    //
    internal func prepareHideRevealButton() {
        hideRevealButton.setImage(UIImage(named: "ic_close"), forState: .Normal)
        hideRevealButton.pulseColor = MaterialTheme.teal.darken4
        hideRevealButton.imageEdgeInsets = UIEdgeInsetsMake(0, -revealOptions.padding, 0, -revealOptions.padding)
        hideRevealButton.addTarget(self, action: "hideReveal", forControlEvents: UIControlEvents.TouchUpInside)
        hideRevealButton.setTranslatesAutoresizingMaskIntoConstraints(true)
        revealView.addSubview(hideRevealButton)
        Layout.alignFromTopRight(revealView, child: hideRevealButton, top: revealOptions.padding, right: revealOptions.padding)
    }
    
    //
    //	:name:	showReveal
    //
    internal func showReveal() {
        revealed = true
        UIView.animateWithDuration(revealOptions.animationDuration, animations: { () -> Void in
            self.revealView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
            self.hideRevealButton.frame = CGRectMake(
                CGRectGetMaxX(self.revealView.frame) - revealOptions.buttonWidth - revealOptions.padding,
                revealOptions.padding,
                revealOptions.buttonWidth,
                revealOptions.buttonHeight)
        })
    }
    
    //
    //	:name:	hideReveal
    //
    internal func hideReveal() {
        revealed = false
        UIView.animateWithDuration(revealOptions.animationDuration, animations: { () -> Void in
            self.revealView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)
        })
    }
    
    //
    //	:name:	touchesBegan:
    //
    public override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if !revealed {
            super.touchesBegan(touches, withEvent: event)
        }
    }
    
    //
    //	:name: touchesEnded:
    //
    public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if !revealed {
            super.touchesEnded(touches, withEvent: event)
        }
    }
    
    //
    //	:name:	touchesCancelled:
    //
    public override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        if !revealed {
            super.touchesCancelled(touches, withEvent: event)
        }
    }
    
}

public func ==(lhs: ImageCardView, rhs: ImageCardView) -> Bool {
    return lhs.tag == rhs.tag
}

public func <=(lhs: ImageCardView, rhs: ImageCardView) -> Bool {
    return lhs.tag <= rhs.tag
}

public func >=(lhs: ImageCardView, rhs: ImageCardView) -> Bool {
    return lhs.tag >= rhs.tag
}

public func >(lhs: ImageCardView, rhs: ImageCardView) -> Bool {
    return lhs.tag > rhs.tag
}

public func <(lhs: ImageCardView, rhs: ImageCardView) -> Bool {
    return lhs.tag < rhs.tag
}