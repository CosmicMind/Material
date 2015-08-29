////
////  RevealCard.swift
////  MaterialKit
////
////  Created by Adam Dahan on 2015-08-26.
////  Copyright (c) 2015 GraphKit Inc. All rights reserved.
////
//
//import UIKit
//
//public class ImageRevealCard : ImageCard {
//    
//    private lazy var revealView: UIView = UIView()
//    private lazy var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
//    private lazy var metrics: Dictionary <String, AnyObject> = Dictionary <String, AnyObject>()
//    private var topLayoutConstraint: NSLayoutConstraint!
//    private lazy var hideRevealViewButton: UIButton = UIButton()
//    
//    public required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    public required init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    internal override func initialize() {
//        prepareTapGestures()
//        prepareRevealView()
//        prepareHideRevealViewButton()
//        super.initialize()
//    }
//    
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        revealView.frame = CGRectMake(0, 0, bounds.width, bounds.height)
//        hideRevealViewButton.frame = CGRectMake(CGRectGetMaxX(revealView.frame) - 50, 10, 40, 40)
//    }
//    
//    private func prepareTapGestures() {
//        tapGesture.addTarget(self, action: "showRevealView")
//        imageView.userInteractionEnabled = true
//        addGestureRecognizer(tapGesture)
//    }
//    
//    private func prepareRevealView() {
//        revealView.backgroundColor = .whiteColor()
//        revealView.hidden = true
//        imageView.addSubview(revealView)
//    }
//    
//    private func prepareHideRevealViewButton() {
//        hideRevealViewButton.setImage(UIImage(named: "ic_clear"), forState: .Normal)
//        hideRevealViewButton.tintColor = .whiteColor()
//        hideRevealViewButton.addTarget(self, action: "hideRevealView", forControlEvents: UIControlEvents.TouchUpInside)
//        revealView.addSubview(hideRevealViewButton)
//    }
//    
//    internal func showRevealView() {
//        removeTapGestures()
//        revealView.hidden = false
//        revealView.frame = CGRectMake(0, bounds.height, bounds.width, bounds.height)
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            var frame = self.revealView.frame
//            frame.origin.y -= self.bounds.height
//            self.revealView.frame = frame
//        })
//    }
//    
//    internal func hideRevealView() {
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            var frame = self.revealView.frame
//            frame.origin.y = self.bounds.height
//            self.revealView.frame = frame
//        }) { (finished) -> Void in
//            self.revealView.hidden = true
//            self.prepareTapGestures()
//        }
//    }
//    
//    private func removeTapGestures() {
//        removeGestureRecognizer(tapGesture)
//    }
//}
//
//
//
