/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Original Inspiration & Author
 * Copyright (c) 2016 Luke Zhao <me@lkzhao.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

public class MotionContext {
    /// A reference of motion identifiers to source views.
    internal var motionIdentifierToSourceView = [String: UIView]()
    
    /// A reference of motion identifiers to destination views.
    internal var motionIdentifierToDestinationView = [String: UIView]()
    
    /// A reference of the snapshot to source/destination view.
    internal var viewToSnapshot = [UIView: UIView]()
    
    /// A reference to the view to view alpha value.
    internal var viewToAlphas = [UIView: CGFloat]()
    
    /// A reference of view to transition target state.
    internal var viewToTargetState = [UIView: MotionTransitionState]()
    
    /// A reference of the superview to the subviews snapshots.
    internal var superviewToNoSnapshotSubviewMap = [UIView: [(Int, UIView)]]()
    
    /// A reference to the default coordinate space for transitions.
    internal var defaultCoordinateSpace = MotionCoordinateSpace.local
    
    /// The container view holding all of the animating views.
    public let container: UIView
    
    /// A flattened list of all views from the source view controller.
    public var fromViews: [UIView]!
    
    /// A flattened list of all views from the destination view controller.
    public var toViews: [UIView]!
    
    /**
     An initializer that accepts a container transition view.
     - Parameter container: A UIView.
     */
    internal init(container: UIView) {
        self.container = container
    }
}

internal extension MotionContext {
    /**
     Sets the fromViews and toViews within the transition context.
     - Parameter fromViews: An Array of UIViews.
     - Parameter toViews: An Array of UIViews.
     */
    func set(fromViews: [UIView], toViews: [UIView]) {
        self.fromViews = fromViews
        self.toViews = toViews
        map(views: fromViews, identifierMap: &motionIdentifierToSourceView)
        map(views: toViews, identifierMap: &motionIdentifierToDestinationView)
    }
    
    /**
     Maps the views to their respective identifier index.
     - Parameter views: An Array of UIViews.
     - Parameter identifierMap: A Dicionary of String to UIView pairs.
     */
    func map(views: [UIView], identifierMap: inout [String: UIView]) {
        for v in views {
            v.layer.removeAllAnimations()
            
            if container.convert(v.bounds, from: v).intersects(container.bounds) {
                if let i = v.motionIdentifier {
                    identifierMap[i] = v
                }
                
                if let i = v.motionTransitions {
                    viewToTargetState[v] = MotionTransitionState(transitions: i)
                }
            }
        }
    }
}

public extension MotionContext {
    /**
     A subscript that takes a given view and retrieves a
     MotionTransitionState if one exists.
     - Parameter view: A UIView.
     - Returns: An optional MotionTransitionState.
     */
    subscript(view: UIView) -> MotionTransitionState? {
        get {
            return viewToTargetState[view]
        }
        set {
            viewToTargetState[view] = newValue
        }
    }
}

public extension MotionContext {
    /**
     Retrieves a source view matching the motionIdentifier, nil if not found.
     - Parameter for motionIdentifier: A String.
     - Returns: An optional UIView.
     */
    func sourceView(for motionIdentifier: String) -> UIView? {
        return motionIdentifierToSourceView[motionIdentifier]
    }

    /**
     Retrieves a destination view matching the motionIdentifier, nil if not found.
     - Parameter for motionIdentifier: A String.
     - Returns: An optional UIView.
     */
    func destinationView(for motionIdentifier: String) -> UIView? {
        return motionIdentifierToDestinationView[motionIdentifier]
    }

    /**
     Retrieves the matching view with the same motionIdentifier found in the 
     source and destination view controllers.
     - Returns: An optional UIView.
     */
    func transitionPairedView(for view: UIView) -> UIView? {
        if let i = view.motionIdentifier {
            if view == sourceView(for: i) {
                return destinationView(for: i)
            
            } else if view == destinationView(for: i) {
                return sourceView(for: i)
            }
        }
        
        return nil
    }

    /**
     Retrieves the snapshot view for a given view.
     - Parameter for view: A UIView.
     - Returns: A UIView.
     */
    func snapshotView(for view: UIView) -> UIView {
        if let v = viewToSnapshot[view] {
            return v
        }

        var containerView = container
        let coordinateSpace = viewToTargetState[view]?.coordinateSpace ?? defaultCoordinateSpace
        
        switch coordinateSpace {
        case .local:
            containerView = view
            
            while containerView != container, nil == viewToSnapshot[containerView], let superview = containerView.superview {
                containerView = superview
            }
            
            if let snapshot = viewToSnapshot[containerView] {
                containerView = snapshot
            }
        case .sameParent:
            containerView = view.superview!
            
        case .global:
            break
        }

        unhide(view: view)

        // Capture a snapshot without the alpha & cornerRadius values.
        let oldCornerRadius = view.layer.cornerRadius
        view.layer.cornerRadius = 0
        
        let oldAlpha = view.alpha
        view.alpha = 1

        let snapshot: UIView
        let snapshotType: MotionSnapshotType = self[view]?.snapshotType ?? .optimized
        
        switch snapshotType {
        case .normal:
            snapshot = view.snapshotView(afterScreenUpdates: true)!
            
        case .layerRender:
            snapshot = view.slowSnapshotView()
        
        case .noSnapshot:
            if nil == superviewToNoSnapshotSubviewMap[view.superview!] {
                superviewToNoSnapshotSubviewMap[view.superview!] = []
            }
            
            superviewToNoSnapshotSubviewMap[view.superview!]!.append((view.superview!.subviews.index(of: view)!, view))
            snapshot = view
            
        case .optimized:
            #if os(tvOS)
                snapshot = view.snapshotView(afterScreenUpdates: true)!
            
            #else
                if #available(iOS 9.0, *), let stackView = view as? UIStackView {
                    snapshot = stackView.slowSnapshotView()
                
                } else if let imageView = view as? UIImageView, view.subviews.isEmpty {
                    let contentView = UIImageView(image: imageView.image)
                    contentView.frame = imageView.bounds
                    contentView.contentMode = imageView.contentMode
                    contentView.tintColor = imageView.tintColor
                    contentView.backgroundColor = imageView.backgroundColor
                    
                    let snapShotView = UIView()
                    snapShotView.addSubview(contentView)
                    snapshot = snapShotView
                
                } else if let navigationBar = view as? UINavigationBar, navigationBar.isTranslucent {
                    let newNavigationBar = UINavigationBar(frame: navigationBar.frame)
                    newNavigationBar.barStyle = navigationBar.barStyle
                    newNavigationBar.tintColor = navigationBar.tintColor
                    newNavigationBar.barTintColor = navigationBar.barTintColor
                    newNavigationBar.clipsToBounds = false

                    // Take a snapshot without the background.
                    navigationBar.layer.sublayers![0].opacity = 0
                    let realSnapshot = navigationBar.snapshotView(afterScreenUpdates: true)!
                    navigationBar.layer.sublayers![0].opacity = 1

                    newNavigationBar.addSubview(realSnapshot)
                    snapshot = newNavigationBar
                    
                } else if let effectView = view as? UIVisualEffectView {
                    snapshot = UIVisualEffectView(effect: effectView.effect)
                    snapshot.frame = effectView.bounds
                
                } else {
                    snapshot = view.snapshotView(afterScreenUpdates: true)!
                }
            #endif
        }

        #if os(tvOS)
            if let imageView = view as? UIImageView, imageView.adjustsImageWhenAncestorFocused {
                snapshot.frame = imageView.focusedFrameGuide.layoutFrame
            }
        #endif

        view.layer.cornerRadius = oldCornerRadius
        view.alpha = oldAlpha

        if .noSnapshot != snapshotType {
            snapshot.layer.allowsGroupOpacity = false

            if !(view is UINavigationBar), let contentView = snapshot.subviews.get(0) {
                /** 
                 The snapshot's contentView must have the cornerRadius value,
                 since the snapshot might not have maskToBounds set
                 */
                contentView.layer.cornerRadius = view.layer.cornerRadius
                contentView.layer.masksToBounds = true
            }

            snapshot.layer.cornerRadius = view.layer.cornerRadius
            snapshot.layer.zPosition = view.layer.zPosition
            snapshot.layer.opacity = view.layer.opacity
            snapshot.layer.isOpaque = view.layer.isOpaque
            snapshot.layer.anchorPoint = view.layer.anchorPoint
            snapshot.layer.masksToBounds = view.layer.masksToBounds
            snapshot.layer.borderColor = view.layer.borderColor
            snapshot.layer.borderWidth = view.layer.borderWidth
            snapshot.layer.transform = view.layer.transform
            snapshot.layer.contentsRect = view.layer.contentsRect
            snapshot.layer.contentsScale = view.layer.contentsScale

            if self[view]?.displayShadow ?? true {
                snapshot.layer.shadowRadius = view.layer.shadowRadius
                snapshot.layer.shadowOpacity = view.layer.shadowOpacity
                snapshot.layer.shadowColor = view.layer.shadowColor
                snapshot.layer.shadowOffset = view.layer.shadowOffset
                snapshot.layer.shadowPath = view.layer.shadowPath
            }
        }

        snapshot.frame = containerView.convert(view.bounds, from: view)
        snapshot.motionIdentifier = view.motionIdentifier

        hide(view: view)

        if let pairedView = transitionPairedView(for: view), let pairedSnapshot = viewToSnapshot[pairedView] {
            let siblingViews = pairedView.superview!.subviews
            let nextSiblings = siblingViews[siblingViews.index(of: pairedView)!+1..<siblingViews.count]
            
            containerView.addSubview(pairedSnapshot)
            containerView.addSubview(snapshot)
            
            for subview in pairedView.subviews {
                insertGlobalViewTree(view: subview)
            }
            
            for sibling in nextSiblings {
                insertGlobalViewTree(view: sibling)
            }
            
        } else {
            containerView.addSubview(snapshot)
        }
        
        containerView.addSubview(snapshot)
        
        viewToSnapshot[view] = snapshot
        
        return snapshot
    }

    /**
     Inserts the given view into the global context space.
     - Parameter view: A UIView.
     */
    func insertGlobalViewTree(view: UIView) {
        if .global == viewToTargetState[view]?.coordinateSpace, let snapshot = viewToSnapshot[view] {
            container.addSubview(snapshot)
        }
        
        for v in view.subviews {
            insertGlobalViewTree(view: v)
        }
    }

    /// Restores the transition subview map with its superview.
    func clean() {
        for (superview, subviews) in superviewToNoSnapshotSubviewMap {
            for (index, view) in subviews.reversed() {
                superview.insertSubview(view, at: index)
            }
        }
    }
}

internal extension MotionContext {
    /**
     Hides a given view.
     - Parameter view: A UIView.
     */
    func hide(view: UIView) {
        guard nil == viewToAlphas[view], .noSnapshot != self[view]?.snapshotType else {
            return
        }
        
        if view is UIVisualEffectView {
            view.isHidden = true
            viewToAlphas[view] = 1
        
        } else {
            viewToAlphas[view] = view.isOpaque ? .infinity : view.alpha
            view.alpha = 0
        }
    }
    
    /**
     Shows a given view that was hidden.
     - Parameter view: A UIView.
     */
    func unhide(view: UIView) {
        guard let oldAlpha = viewToAlphas[view] else {
            return
        }
        
        if view is UIVisualEffectView {
            view.isHidden = false
        
        } else if oldAlpha == .infinity {
            view.alpha = 1
            view.isOpaque = true
        
        } else {
            view.alpha = oldAlpha
        }
        
        viewToAlphas[view] = nil
    }
    
    /// Shows all given views that are hidden.
    func unhideAll() {
        for v in viewToAlphas.keys {
            unhide(view: v)
        }
        
        viewToAlphas.removeAll()
    }
    
    /**
     Show a given view and its subviews that are hidden.
     - Parameter rootView: A UIView.
     */
    func unhide(rootView: UIView) {
        unhide(view: rootView)
        
        for subview in rootView.subviews {
            unhide(rootView: subview)
        }
    }

    /// Removes all snapshots that are not using .useNoSnapshot.
    func removeAllSnapshots() {
        for (k, v) in viewToSnapshot {
            if k != v {
                v.removeFromSuperview()
            }
        }
    }
    
    /**
     Removes the snapshots for a given view and all its subviews.
     - Parameter rootView: A UIVIew.
     */
    func removeSnapshots(rootView: UIView) {
        if let v = viewToSnapshot[rootView], v != rootView {
            v.removeFromSuperview()
        }
        
        for v in rootView.subviews {
            removeSnapshots(rootView: v)
        }
    }
  
    /**
     Retrieves the snapshots for a given view and all its subviews.
     - Parameter rootView: A UIView.
     - Returns: An Array of UIViews.
     */
    func snapshots(rootView: UIView) -> [UIView] {
        var snapshots = [UIView]()
        
        for v in rootView.flattenedViewHierarchy {
            if let snapshot = viewToSnapshot[v] {
                snapshots.append(snapshot)
            }
        }
        
        return snapshots
    }
    
    /**
     Sets the alpha values for a given view and its subviews to the
     stored alpha value.
     - Parameter rootView: A UIView.
     */
    func loadViewAlpha(rootView: UIView) {
        if let storedAlpha = rootView.motionAlpha {
            rootView.alpha = storedAlpha
            rootView.motionAlpha = nil
        }
        
        for subview in rootView.subviews {
            loadViewAlpha(rootView: subview)
        }
    }
    
    /**
     Stores the alpha values for a given view and its subviews.
     - Parameter rootView: A UIView.
     */
    func storeViewAlpha(rootView: UIView) {
        rootView.motionAlpha = viewToAlphas[rootView]
        
        for subview in rootView.subviews {
            storeViewAlpha(rootView: subview)
        }
    }
}
