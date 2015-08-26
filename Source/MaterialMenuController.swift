//
//  MaterialMenuController.swift
//  MaterialKit
//
//  Created by Adam Dahan on 2015-08-24.
//  Copyright (c) 2015 GraphKit Inc. All rights reserved.
//

import Foundation
import UIKit

public struct MenuOptions {
    public static var leftViewWidth: CGFloat = 270.0
    public static var leftBezelWidth: CGFloat = 16.0
    public static var contentViewScale: CGFloat = 1.0
    public static var contentViewOpacity: CGFloat = 0.5
    public static var shadowOpacity: CGFloat = 0.0
    public static var shadowRadius: CGFloat = 0.0
    public static var shadowOffset: CGSize = CGSizeMake(0,0)
    public static var leftPanFromBezel: Bool = true
    public static var animationDuration: CGFloat = 0.4
    public static var rightViewWidth: CGFloat = 270.0
    public static var rightBezelWidth: CGFloat = 16.0
    public static var rightPanFromBezel: Bool = true
    public static var hideStatusBar: Bool = true
    public static var pointOfNoReturnWidth: CGFloat = 44.0
    public static var opacityViewBackgroundColor: UIColor = UIColor.blackColor()
}

public class MaterialMenuController: MaterialViewController, UIGestureRecognizerDelegate {
    
    public enum SlideAction {
        case Open
        case Close
    }
    
    struct PanInfo {
        var action: SlideAction
        var shouldBounce: Bool
        var velocity: CGFloat
    }
    
    var viewBasedAppearanceNO: Bool = NSBundle.mainBundle().objectForInfoDictionaryKey("UIViewControllerBasedStatusBarAppearance") as? Int == 0 ? true : false
    
    public var opacityView = UIView()
    public var mainContainerView = UIView()
    public var leftContainerView = UIView()
    public var rightContainerView =  UIView()
    
    public var mainViewController: UIViewController?
    public var leftViewController: UIViewController?
    public var rightViewController: UIViewController?

    public var leftPanGesture: UIPanGestureRecognizer?
    public var rightPanGesture: UIPanGestureRecognizer?

    public var leftTapGetsture: UITapGestureRecognizer?
    public var rightTapGesture: UITapGestureRecognizer?
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init(mainViewController: UIViewController, leftMenuViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        leftViewController = leftMenuViewController
        initView()
    }
    
    public convenience init(mainViewController: UIViewController, rightMenuViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        rightViewController = rightMenuViewController
        initView()
    }
    
    public convenience init(mainViewController: UIViewController, leftMenuViewController: UIViewController, rightMenuViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        leftViewController = leftMenuViewController
        rightViewController = rightMenuViewController
        initView()
    }
        
    func initView() {
        mainContainerView = UIView(frame: view.bounds)
        mainContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        mainContainerView.backgroundColor = UIColor.clearColor()
        mainContainerView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        view.insertSubview(mainContainerView, atIndex: 0)
        
        var opacityframe: CGRect = view.bounds
        var opacityOffset: CGFloat = 0
        opacityframe.origin.y = opacityframe.origin.y + opacityOffset
        opacityframe.size.height = opacityframe.size.height - opacityOffset
        opacityView = UIView(frame: opacityframe)
        opacityView.backgroundColor = MenuOptions.opacityViewBackgroundColor
        opacityView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        opacityView.layer.opacity = 0.0
        view.insertSubview(opacityView, atIndex: 1)
        
        var leftFrame: CGRect = view.bounds
        leftFrame.size.width = MenuOptions.leftViewWidth
        leftFrame.origin.x = leftMinOrigin();
        var leftOffset: CGFloat = 0
        leftFrame.origin.y = leftFrame.origin.y + leftOffset
        leftFrame.size.height = leftFrame.size.height - leftOffset
        leftContainerView = UIView(frame: leftFrame)
        leftContainerView.backgroundColor = UIColor.clearColor()
        leftContainerView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        view.insertSubview(leftContainerView, atIndex: 2)
        
        var rightFrame: CGRect = view.bounds
        rightFrame.size.width = MenuOptions.rightViewWidth
        rightFrame.origin.x = rightMinOrigin()
        var rightOffset: CGFloat = 0
        rightFrame.origin.y = rightFrame.origin.y + rightOffset;
        rightFrame.size.height = rightFrame.size.height - rightOffset
        rightContainerView = UIView(frame: rightFrame)
        rightContainerView.backgroundColor = UIColor.clearColor()
        rightContainerView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        view.insertSubview(rightContainerView, atIndex: 3)
        
        addLeftGestures()
        addRightGestures()
    }
    
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        mainContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        leftContainerView.hidden = true
        rightContainerView.hidden = true
        coordinator.animateAlongsideTransition(nil, completion: { (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.closeLeftNonAnimation()
            self.closeRightNonAnimation()
            self.leftContainerView.hidden = false
            self.rightContainerView.hidden = false
    
            if self.leftPanGesture != nil && self.leftPanGesture != nil {
                self.removeLeftGestures()
                self.addLeftGestures()
            }
            
            if self.rightPanGesture != nil && self.rightPanGesture != nil {
                self.removeRightGestures()
                self.addRightGestures()
            }
        })
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge.None
    }
    
    public override func viewWillLayoutSubviews() {
        setUpViewController(mainContainerView, targetViewController: mainViewController)
        setUpViewController(leftContainerView, targetViewController: leftViewController)
        setUpViewController(rightContainerView, targetViewController: rightViewController)
    }
    
    public override func openLeft() {
        setOpenWindowLevel()
        leftViewController?.beginAppearanceTransition(isLeftHidden(), animated: true)
        openLeftWithVelocity(0.0)
    }
    
    public override func openRight() {
        setOpenWindowLevel()
        
        //menuViewControllerのviewWillAppearを呼ぶため
        rightViewController?.beginAppearanceTransition(isRightHidden(), animated: true)
        openRightWithVelocity(0.0)
    }
    
    public override func closeLeft() {
        leftViewController?.beginAppearanceTransition(isLeftHidden(), animated: true)
        closeLeftWithVelocity(0.0)
        setCloseWindowLevel()
    }
    
    public override func closeRight() {
        rightViewController?.beginAppearanceTransition(isRightHidden(), animated: true)
        closeRightWithVelocity(0.0)
        setCloseWindowLevel()
    }
    
    public func addLeftGestures() {
        if (leftViewController != nil) {
            if leftPanGesture == nil {
                leftPanGesture = UIPanGestureRecognizer(target: self, action: "handleLeftPanGesture:")
                leftPanGesture!.delegate = self
                view.addGestureRecognizer(leftPanGesture!)
            }
            if leftTapGetsture == nil {
                leftTapGetsture = UITapGestureRecognizer(target: self, action: "toggleLeft")
                leftTapGetsture!.delegate = self
                view.addGestureRecognizer(leftTapGetsture!)
            }
        }
    }
    
    public func addRightGestures() {
        if (rightViewController != nil) {
            if rightPanGesture == nil {
                rightPanGesture = UIPanGestureRecognizer(target: self, action: "handleRightPanGesture:")
                rightPanGesture!.delegate = self
                view.addGestureRecognizer(rightPanGesture!)
            }
            if rightTapGesture == nil {
                rightTapGesture = UITapGestureRecognizer(target: self, action: "toggleRight")
                rightTapGesture!.delegate = self
                view.addGestureRecognizer(rightTapGesture!)
            }
        }
    }
    
    public func removeLeftGestures() {
        if leftPanGesture != nil {
            view.removeGestureRecognizer(leftPanGesture!)
            leftPanGesture = nil
        }
        if leftTapGetsture != nil {
            view.removeGestureRecognizer(leftTapGetsture!)
            leftTapGetsture = nil
        }
    }
    
    public func removeRightGestures() {
        if rightPanGesture != nil {
            view.removeGestureRecognizer(rightPanGesture!)
            rightPanGesture = nil
        }
        if rightTapGesture != nil {
            view.removeGestureRecognizer(rightTapGesture!)
            rightTapGesture = nil
        }
    }
    
    public func isTargetViewController() -> Bool {
        // Function to determine the target ViewController
        // Please to override it if necessary
        return true
    }
    
    struct LeftPanState {
        static var frameAtStartOfPan: CGRect = CGRectZero
        static var startPointOfPan: CGPoint = CGPointZero
        static var wasOpenAtStartOfPan: Bool = false
        static var wasHiddenAtStartOfPan: Bool = false
    }
    
    func handleLeftPanGesture(panGesture: UIPanGestureRecognizer) {
        
        if !isTargetViewController() {
            return
        }
        
        if isRightOpen() {
            return
        }
        
        switch panGesture.state {
        case .Began:
            LeftPanState.frameAtStartOfPan = leftContainerView.frame
            LeftPanState.startPointOfPan = panGesture.locationInView(view)
            LeftPanState.wasOpenAtStartOfPan = isLeftOpen()
            LeftPanState.wasHiddenAtStartOfPan = isLeftHidden()
            leftViewController?.beginAppearanceTransition(LeftPanState.wasHiddenAtStartOfPan, animated: true)
            addShadowToView(leftContainerView)
            setOpenWindowLevel()
        case .Changed:
            var translation: CGPoint = panGesture.translationInView(panGesture.view!)
            leftContainerView.frame = applyLeftTranslation(translation, toFrame: LeftPanState.frameAtStartOfPan)
            applyLeftOpacity()
            applyLeftContentViewScale()
        case .Ended:
            var velocity:CGPoint = panGesture.velocityInView(panGesture.view)
            var panInfo: PanInfo = panLeftResultInfoForVelocity(velocity)
            if panInfo.action == .Open {
                if !LeftPanState.wasHiddenAtStartOfPan {
                    leftViewController?.beginAppearanceTransition(true, animated: true)
                }
                openLeftWithVelocity(panInfo.velocity)
            } else {
                if LeftPanState.wasHiddenAtStartOfPan {
                    leftViewController?.beginAppearanceTransition(false, animated: true)
                }
                closeLeftWithVelocity(panInfo.velocity)
                setCloseWindowLevel()
            }
        default:
            break
        }
    }
    
    struct RightPanState {
        static var frameAtStartOfPan: CGRect = CGRectZero
        static var startPointOfPan: CGPoint = CGPointZero
        static var wasOpenAtStartOfPan: Bool = false
        static var wasHiddenAtStartOfPan: Bool = false
    }
    
    func handleRightPanGesture(panGesture: UIPanGestureRecognizer) {
        
        if !isTargetViewController() {
            return
        }
        
        if isLeftOpen() {
            return
        }
        
        switch panGesture.state {
        case UIGestureRecognizerState.Began:
            
            RightPanState.frameAtStartOfPan = rightContainerView.frame
            RightPanState.startPointOfPan = panGesture.locationInView(view)
            RightPanState.wasOpenAtStartOfPan =  isRightOpen()
            RightPanState.wasHiddenAtStartOfPan = isRightHidden()
            
            rightViewController?.beginAppearanceTransition(RightPanState.wasHiddenAtStartOfPan, animated: true)
            addShadowToView(rightContainerView)
            setOpenWindowLevel()
            
        case UIGestureRecognizerState.Changed:
            
            var translation: CGPoint = panGesture.translationInView(panGesture.view!)
            rightContainerView.frame = applyRightTranslation(translation, toFrame: RightPanState.frameAtStartOfPan)
            applyRightOpacity()
            applyRightContentViewScale()
            
        case UIGestureRecognizerState.Ended:
            
            var velocity: CGPoint = panGesture.velocityInView(panGesture.view)
            var panInfo: PanInfo = panRightResultInfoForVelocity(velocity)
            
            if panInfo.action == .Open {
                if !RightPanState.wasHiddenAtStartOfPan {
                    rightViewController?.beginAppearanceTransition(true, animated: true)
                }
                openRightWithVelocity(panInfo.velocity)
            } else {
                if RightPanState.wasHiddenAtStartOfPan {
                    rightViewController?.beginAppearanceTransition(false, animated: true)
                }
                closeRightWithVelocity(panInfo.velocity)
                setCloseWindowLevel()
            }
        default:
            break
        }
    }
    
    public func openLeftWithVelocity(velocity: CGFloat) {
        var xOrigin: CGFloat = leftContainerView.frame.origin.x
        var finalXOrigin: CGFloat = 0.0
        
        var frame = leftContainerView.frame;
        frame.origin.x = finalXOrigin;
        
        var duration: NSTimeInterval = Double(MenuOptions.animationDuration)
        if velocity != 0.0 {
            duration = Double(fabs(xOrigin - finalXOrigin) / velocity)
            duration = Double(fmax(0.1, fmin(1.0, duration)))
        }
        
        addShadowToView(leftContainerView)
        
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { [weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.leftContainerView.frame = frame
                strongSelf.opacityView.layer.opacity = Float(MenuOptions.contentViewOpacity)
                strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(MenuOptions.contentViewScale, MenuOptions.contentViewScale)
            }
            }) { [weak self](Bool) -> Void in
                if let strongSelf = self {
                    strongSelf.disableContentInteraction()
                    strongSelf.leftViewController?.endAppearanceTransition()
                }
        }
    }
    
    public func openRightWithVelocity(velocity: CGFloat) {
        
        var xOrigin: CGFloat = rightContainerView.frame.origin.x
        var finalXOrigin: CGFloat = CGRectGetWidth(view.bounds) - rightContainerView.frame.size.width
        
        var frame = rightContainerView.frame
        frame.origin.x = finalXOrigin
        
        var duration: NSTimeInterval = Double(MenuOptions.animationDuration)
        if velocity != 0.0 {
            duration = Double(fabs(xOrigin - CGRectGetWidth(view.bounds)) / velocity)
            duration = Double(fmax(0.1, fmin(1.0, duration)))
        }
        
        addShadowToView(rightContainerView)
        
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { [weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.rightContainerView.frame = frame
                strongSelf.opacityView.layer.opacity = Float(MenuOptions.contentViewOpacity)
                strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(MenuOptions.contentViewScale, MenuOptions.contentViewScale)
            }
            }) { [weak self](Bool) -> Void in
                if let strongSelf = self {
                    strongSelf.disableContentInteraction()
                    strongSelf.rightViewController?.endAppearanceTransition()
                }
        }
    }
    
    public func closeLeftWithVelocity(velocity: CGFloat) {
        
        var xOrigin: CGFloat = leftContainerView.frame.origin.x
        var finalXOrigin: CGFloat = leftMinOrigin()
        
        var frame: CGRect = leftContainerView.frame;
        frame.origin.x = finalXOrigin
        
        var duration: NSTimeInterval = Double(MenuOptions.animationDuration)
        if velocity != 0.0 {
            duration = Double(fabs(xOrigin - finalXOrigin) / velocity)
            duration = Double(fmax(0.1, fmin(1.0, duration)))
        }
        
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { [weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.leftContainerView.frame = frame
                strongSelf.opacityView.layer.opacity = 0.0
                strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }
            }) { [weak self](Bool) -> Void in
                if let strongSelf = self {
                    strongSelf.removeShadow(strongSelf.leftContainerView)
                    strongSelf.enableContentInteraction()
                    strongSelf.leftViewController?.endAppearanceTransition()
                }
        }
    }
    
    
    public func closeRightWithVelocity(velocity: CGFloat) {
        
        var xOrigin: CGFloat = rightContainerView.frame.origin.x
        var finalXOrigin: CGFloat = CGRectGetWidth(view.bounds)
        
        var frame: CGRect = rightContainerView.frame
        frame.origin.x = finalXOrigin
        
        var duration: NSTimeInterval = Double(MenuOptions.animationDuration)
        if velocity != 0.0 {
            duration = Double(fabs(xOrigin - CGRectGetWidth(view.bounds)) / velocity)
            duration = Double(fmax(0.1, fmin(1.0, duration)))
        }
        
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { [weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.rightContainerView.frame = frame
                strongSelf.opacityView.layer.opacity = 0.0
                strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }
            }) { [weak self](Bool) -> Void in
                if let strongSelf = self {
                    strongSelf.removeShadow(strongSelf.rightContainerView)
                    strongSelf.enableContentInteraction()
                    strongSelf.rightViewController?.endAppearanceTransition()
                }
        }
    }
    
    
    public override func toggleLeft() {
        if isLeftOpen() {
            closeLeft()
            setCloseWindowLevel()
        } else {
            openLeft()
        }
    }
    
    public func isLeftOpen() -> Bool {
        return leftContainerView.frame.origin.x == 0.0
    }
    
    public func isLeftHidden() -> Bool {
        return leftContainerView.frame.origin.x <= leftMinOrigin()
    }
    
    public override func toggleRight() {
        if isRightOpen() {
            closeRight()
            setCloseWindowLevel()
        } else {
            openRight()
        }
    }
    
    public func isRightOpen() -> Bool {
        return rightContainerView.frame.origin.x == CGRectGetWidth(view.bounds) - rightContainerView.frame.size.width
    }
    
    public func isRightHidden() -> Bool {
        return rightContainerView.frame.origin.x >= CGRectGetWidth(view.bounds)
    }
    
    public func changeMainViewController(mainViewController: UIViewController,  close: Bool) {
        removeViewController(self.mainViewController)
        self.mainViewController = mainViewController
        setUpViewController(mainContainerView, targetViewController: mainViewController)
        if (close) {
            closeLeft()
            closeRight()
        }
    }
    
    public func changeLeftViewController(leftViewController: UIViewController, closeLeft:Bool) {
        removeViewController(self.leftViewController)
        self.leftViewController = leftViewController
        setUpViewController(leftContainerView, targetViewController: leftViewController)
        if closeLeft {
            self.closeLeft()
        }
    }
    
    public func changeRightViewController(rightViewController: UIViewController, closeRight:Bool) {
        removeViewController(self.rightViewController)
        self.rightViewController = rightViewController;
        setUpViewController(rightContainerView, targetViewController: rightViewController)
        if closeRight {
            self.closeRight()
        }
    }
    
    private func leftMinOrigin() -> CGFloat {
        return  -MenuOptions.leftViewWidth
    }
    
    private func rightMinOrigin() -> CGFloat {
        return CGRectGetWidth(view.bounds)
    }
    
    
    private func panLeftResultInfoForVelocity(velocity: CGPoint) -> PanInfo {
        
        var thresholdVelocity: CGFloat = 1000.0
        var pointOfNoReturn: CGFloat = CGFloat(floor(leftMinOrigin())) + MenuOptions.pointOfNoReturnWidth
        var leftOrigin: CGFloat = leftContainerView.frame.origin.x
        
        var panInfo: PanInfo = PanInfo(action: .Close, shouldBounce: false, velocity: 0.0)
        panInfo.action = leftOrigin <= pointOfNoReturn ? .Close : .Open;
        
        if velocity.x >= thresholdVelocity {
            panInfo.action = .Open
            panInfo.velocity = velocity.x
        } else if velocity.x <= (-1.0 * thresholdVelocity) {
            panInfo.action = .Close
            panInfo.velocity = velocity.x
        }
        
        return panInfo
    }
    
    private func panRightResultInfoForVelocity(velocity: CGPoint) -> PanInfo {
        
        var thresholdVelocity: CGFloat = -1000.0
        var pointOfNoReturn: CGFloat = CGFloat(floor(CGRectGetWidth(view.bounds)) - MenuOptions.pointOfNoReturnWidth)
        var rightOrigin: CGFloat = rightContainerView.frame.origin.x
        
        var panInfo: PanInfo = PanInfo(action: .Close, shouldBounce: false, velocity: 0.0)
        panInfo.action = rightOrigin >= pointOfNoReturn ? .Close : .Open
        
        if velocity.x <= thresholdVelocity {
            panInfo.action = .Open
            panInfo.velocity = velocity.x
        } else if (velocity.x >= (-1.0 * thresholdVelocity)) {
            panInfo.action = .Close
            panInfo.velocity = velocity.x
        }
        
        return panInfo
    }
    
    private func applyLeftTranslation(translation: CGPoint, toFrame:CGRect) -> CGRect {
        
        var newOrigin: CGFloat = toFrame.origin.x
        newOrigin += translation.x
        
        var minOrigin: CGFloat = leftMinOrigin()
        var maxOrigin: CGFloat = 0.0
        var newFrame: CGRect = toFrame
        
        if newOrigin < minOrigin {
            newOrigin = minOrigin
        } else if newOrigin > maxOrigin {
            newOrigin = maxOrigin
        }
        
        newFrame.origin.x = newOrigin
        return newFrame
    }
    
    private func applyRightTranslation(translation: CGPoint, toFrame: CGRect) -> CGRect {
        
        var  newOrigin: CGFloat = toFrame.origin.x
        newOrigin += translation.x
        
        var minOrigin: CGFloat = rightMinOrigin()
        var maxOrigin: CGFloat = rightMinOrigin() - rightContainerView.frame.size.width
        var newFrame: CGRect = toFrame
        
        if newOrigin > minOrigin {
            newOrigin = minOrigin
        } else if newOrigin < maxOrigin {
            newOrigin = maxOrigin
        }
        
        newFrame.origin.x = newOrigin
        return newFrame
    }
    
    private func getOpenedLeftRatio() -> CGFloat {
        
        var width: CGFloat = leftContainerView.frame.size.width
        var currentPosition: CGFloat = leftContainerView.frame.origin.x - leftMinOrigin()
        return currentPosition / width
    }
    
    private func getOpenedRightRatio() -> CGFloat {
        
        var width: CGFloat = rightContainerView.frame.size.width
        var currentPosition: CGFloat = rightContainerView.frame.origin.x
        return -(currentPosition - CGRectGetWidth(view.bounds)) / width
    }
    
    private func applyLeftOpacity() {
        
        var openedLeftRatio: CGFloat = getOpenedLeftRatio()
        var opacity: CGFloat = MenuOptions.contentViewOpacity * openedLeftRatio
        opacityView.layer.opacity = Float(opacity)
    }
    
    
    private func applyRightOpacity() {
        var openedRightRatio: CGFloat = getOpenedRightRatio()
        var opacity: CGFloat = MenuOptions.contentViewOpacity * openedRightRatio
        opacityView.layer.opacity = Float(opacity)
    }
    
    private func applyLeftContentViewScale() {
        var openedLeftRatio: CGFloat = getOpenedLeftRatio()
        var scale: CGFloat = 1.0 - ((1.0 - MenuOptions.contentViewScale) * openedLeftRatio);
        mainContainerView.transform = CGAffineTransformMakeScale(scale, scale)
    }
    
    private func applyRightContentViewScale() {
        var openedRightRatio: CGFloat = getOpenedRightRatio()
        var scale: CGFloat = 1.0 - ((1.0 - MenuOptions.contentViewScale) * openedRightRatio)
        mainContainerView.transform = CGAffineTransformMakeScale(scale, scale)
    }
    
    private func addShadowToView(targetContainerView: UIView) {
        targetContainerView.layer.masksToBounds = false
        targetContainerView.layer.shadowOffset = MenuOptions.shadowOffset
        targetContainerView.layer.shadowOpacity = Float(MenuOptions.shadowOpacity)
        targetContainerView.layer.shadowRadius = MenuOptions.shadowRadius
        targetContainerView.layer.shadowPath = UIBezierPath(rect: targetContainerView.bounds).CGPath
    }
    
    private func removeShadow(targetContainerView: UIView) {
        targetContainerView.layer.masksToBounds = true
        mainContainerView.layer.opacity = 1.0
    }
    
    private func removeContentOpacity() {
        opacityView.layer.opacity = 0.0
    }
    
    
    private func addContentOpacity() {
        opacityView.layer.opacity = Float(MenuOptions.contentViewOpacity)
    }
    
    private func disableContentInteraction() {
        mainContainerView.userInteractionEnabled = false
    }
    
    private func enableContentInteraction() {
        mainContainerView.userInteractionEnabled = true
    }
    
    private func setOpenWindowLevel() {
        if (MenuOptions.hideStatusBar) {
            if viewBasedAppearanceNO {
                UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                if let window = UIApplication.sharedApplication().keyWindow {
                    window.windowLevel = UIWindowLevelStatusBar + 1
                }
            })
        }
    }
    
    private func setCloseWindowLevel() {
        if (MenuOptions.hideStatusBar) {
            if viewBasedAppearanceNO {
                UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                if let window = UIApplication.sharedApplication().keyWindow {
                    window.windowLevel = UIWindowLevelNormal
                }
            })
        }
    }
    
    private func setUpViewController(targetView: UIView, targetViewController: UIViewController?) {
        if let viewController = targetViewController {
            addChildViewController(viewController)
            viewController.view.frame = targetView.bounds
            targetView.addSubview(viewController.view)
            viewController.didMoveToParentViewController(self)
        }
    }
    
    private func removeViewController(viewController: UIViewController?) {
        if let _viewController = viewController {
            _viewController.willMoveToParentViewController(nil)
            _viewController.view.removeFromSuperview()
            _viewController.removeFromParentViewController()
        }
    }
    
    public func closeLeftNonAnimation(){
        setCloseWindowLevel()
        var finalXOrigin: CGFloat = leftMinOrigin()
        var frame: CGRect = leftContainerView.frame;
        frame.origin.x = finalXOrigin
        leftContainerView.frame = frame
        opacityView.layer.opacity = 0.0
        mainContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        removeShadow(leftContainerView)
        enableContentInteraction()
    }
    
    public func closeRightNonAnimation(){
        setCloseWindowLevel()
        var finalXOrigin: CGFloat = CGRectGetWidth(view.bounds)
        var frame: CGRect = rightContainerView.frame
        frame.origin.x = finalXOrigin
        rightContainerView.frame = frame
        opacityView.layer.opacity = 0.0
        mainContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        removeShadow(rightContainerView)
        enableContentInteraction()
    }
    
    //pragma mark – UIGestureRecognizerDelegate
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        var point: CGPoint = touch.locationInView(view)
        
        if gestureRecognizer == leftPanGesture {
            return slideLeftForGestureRecognizer(gestureRecognizer, point: point)
        } else if gestureRecognizer == rightPanGesture {
            return slideRightViewForGestureRecognizer(gestureRecognizer, withTouchPoint: point)
        } else if gestureRecognizer == leftTapGetsture {
            return isLeftOpen() && !isPointContainedWithinLeftRect(point)
        } else if gestureRecognizer == rightTapGesture {
            return isRightOpen() && !isPointContainedWithinRightRect(point)
        }
        
        return true
    }
    
    private func slideLeftForGestureRecognizer( gesture: UIGestureRecognizer, point:CGPoint) -> Bool{
        return isLeftOpen() || MenuOptions.leftPanFromBezel && isLeftPointContainedWithinBezelRect(point)
    }
    
    private func isLeftPointContainedWithinBezelRect(point: CGPoint) -> Bool{
        var leftBezelRect: CGRect = CGRectZero
        var tempRect: CGRect = CGRectZero
        var bezelWidth: CGFloat = MenuOptions.leftBezelWidth
        
        CGRectDivide(view.bounds, &leftBezelRect, &tempRect, bezelWidth, CGRectEdge.MinXEdge)
        return CGRectContainsPoint(leftBezelRect, point)
    }
    
    private func isPointContainedWithinLeftRect(point: CGPoint) -> Bool {
        return CGRectContainsPoint(leftContainerView.frame, point)
    }
    
    private func slideRightViewForGestureRecognizer(gesture: UIGestureRecognizer, withTouchPoint point: CGPoint) -> Bool {
        return isRightOpen() || MenuOptions.rightPanFromBezel && isRightPointContainedWithinBezelRect(point)
    }
    
    private func isRightPointContainedWithinBezelRect(point: CGPoint) -> Bool {
        var rightBezelRect: CGRect = CGRectZero
        var tempRect: CGRect = CGRectZero
        //CGFloat bezelWidth = rightContainerView.frame.size.width;
        var bezelWidth: CGFloat = CGRectGetWidth(view.bounds) - MenuOptions.rightBezelWidth
        
        CGRectDivide(view.bounds, &tempRect, &rightBezelRect, bezelWidth, CGRectEdge.MinXEdge)
        
        return CGRectContainsPoint(rightBezelRect, point)
    }
    
    private func isPointContainedWithinRightRect(point: CGPoint) -> Bool {
        return CGRectContainsPoint(rightContainerView.frame, point)
    }
}

extension UIViewController {
    public func materialMenuController() -> MaterialMenuController? {
        var viewController: UIViewController? = self
        while viewController != nil {
            if viewController is MaterialMenuController {
                return viewController as? MaterialMenuController
            }
            viewController = viewController?.parentViewController
        }
        return nil;
    }
    
    public func toggleLeft() {
        materialMenuController()?.toggleLeft()
    }
    
    public func toggleRight() {
        materialMenuController()?.toggleRight()
    }
    
    public func openLeft() {
        materialMenuController()?.openLeft()
    }
    
    public func openRight() {
        materialMenuController()?.openRight()
    }
    
    public func closeLeft() {
        materialMenuController()?.closeLeft()
    }
    
    public func closeRight() {
        materialMenuController()?.closeRight()
    }
}

