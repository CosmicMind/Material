/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import Motion

enum PanTransitionState {
    case normal
    case slidingLeft
    case slidingRight
}

extension UIViewController {
    /**
     A convenience property that provides access to the PanController.
     This is the recommended method of accessing the PanController
     through child UIViewControllers.
     */
    public var panController: PanController? {
        var viewController: UIViewController? = self
        while nil != viewController {
            if viewController is PanController {
                return viewController as? PanController
            }
            viewController = viewController?.parent
        }
        return nil
    }
}

open class PanController: UIViewController {
    /// A reference to the pan gesture recognizer.
    fileprivate var panGestureRecognizer: UIPanGestureRecognizer!
    
    /// The pan transition state.
    fileprivate var panTransitionState: PanTransitionState = .normal
    
    /// A reference to the next view controller being loaded.
    fileprivate var loadingViewController: UIViewController?
    
    /// A reference to the loading index within the view controllers.
    fileprivate var loadingIndex: Int?
    
    /// A reference to the currently selected view controller index value.
    @IBInspectable
    open var selectedIndex = 0
    
    /// An Array of UIViewControllers.
    open var viewControllers: [UIViewController] {
        didSet {
            oldValue.forEach { [weak self] in
                self?.removeViewController(viewController: $0)
            }
        }
    }
    
    /**
     An initializer that initializes the object with a NSCoder object.
     - Parameter aDecoder: A NSCoder instance.
     */
    public required init?(coder aDecoder: NSCoder) {
        viewControllers = []
        super.init(coder: aDecoder)
    }
    
    /**
     An initializer that accepts an Array of UIViewControllers.
     - Parameter viewControllers: An Array of UIViewControllers.
     */
    public init(viewControllers: [UIViewController], selectedIndex: Int = 0) {
        self.viewControllers = viewControllers
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutSubviews()
    }
    
    /**
     To execute in the order of the layout chain, override this
     method. `layoutSubviews` should be called immediately, unless you
     have a certain need.
     */
    open func layoutSubviews() {
    }
    
    /**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
    open func prepare() {
        view.contentScaleFactor = Screen.scale
        preparePanGestureRecognizer()
        prepareViewController(at: selectedIndex)
    }
}

extension PanController {
    /// Prepares the pan gesture recognizer.
    fileprivate func preparePanGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    /**
     Loads a view controller based on its index in the viewControllers Array
     and adds it as a child view controller.
     - Parameter at index: An Int for the viewControllers index.
     */
    fileprivate func prepareViewController(at index: Int) {
        let v = viewControllers[index]
        
        guard !childViewControllers.contains(v) else {
            return
        }
        
        addChildViewController(v)
        view.addSubview(v.view)
        v.didMove(toParentViewController: self)
        v.view.frame = view.bounds
        v.view.clipsToBounds = true
        v.view.contentScaleFactor = Screen.scale
    }
}

extension PanController {
    /**
     Removes the view controller as a child view controller with
     the given index.
     - Parameter at index: An Int for the view controller position.
     */
    fileprivate func removeViewController(at index: Int) {
        let v = viewControllers[index]
        
        guard childViewControllers.contains(v) else {
            return
        }
        
        removeViewController(viewController: v)
    }
    
    /**
     Removes a given view controller from the childViewControllers array.
     - Parameter at index: An Int for the view controller position.
     */
    fileprivate func removeViewController(viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}

extension PanController {
    @objc
    func handlePanGesture() {
        let tx = panGestureRecognizer.translation(in: nil).x
        let vx = panGestureRecognizer.velocity(in: nil).x
        
        switch panGestureRecognizer.state {
        case .began, .changed:
            let nextState: PanTransitionState
            
            if .normal == panTransitionState {
                nextState = vx < 0 ? .slidingLeft : .slidingRight
            } else {
                nextState = tx < 0 ? .slidingLeft : .slidingRight
            }
            
            if nil == loadingIndex {
                loadingIndex = .slidingLeft == panTransitionState ? selectedIndex - 1 : selectedIndex + 1
            }
            
            guard let i = loadingIndex, -1 < i && i < viewControllers.count else {
                loadingIndex = nil
                return
            }
            
            if nextState != panTransitionState {
                Motion.shared.cancel(isAnimated: false)
                
                loadingViewController = PanController(viewControllers: viewControllers, selectedIndex: i)
                
                panTransitionState = nextState
                motionReplaceViewController(with: loadingViewController!)
            } else {
                let progress = abs(Double(tx / view.bounds.width))
                
                Motion.shared.update(elapsedTime: progress)
                
                if .slidingLeft == panTransitionState, let v = loadingViewController {
                    Motion.shared.apply(transitions: [.translate(x: view.bounds.width + tx)], to: v.view)
                } else {
                    Motion.shared.apply(transitions: [.translate(x: tx)], to: view)
                }
            }
        default:
            let progress = (tx + vx) / view.bounds.width
            
            if (progress < 0) == (.slidingLeft == panTransitionState) && 0.3 < abs(progress) {
                Motion.shared.end()
            } else {
                Motion.shared.cancel()
            }
            
            panTransitionState = .normal
            loadingViewController = nil
            loadingIndex = nil
        }
    }
}

