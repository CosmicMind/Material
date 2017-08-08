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

fileprivate var ChipItemKey: UInt8 = 0

@objc(ChipBarAlignment)
public enum ChipBarAlignment: Int {
    case top
    case bottom
    case hidden
}

extension UIViewController {
    /**
     A convenience property that provides access to the ChipBarController.
     This is the recommended method of accessing the ChipBarController
     through child UIViewControllers.
     */
    public var chipsController: ChipBarController? {
        return traverseViewControllerHierarchyForClassType()
    }
}

open class ChipBarController: TransitionController {
    /**
     A Display value to indicate whether or not to
     display the rootViewController to the full view
     bounds, or up to the toolbar height.
     */
    open var displayStyle = DisplayStyle.partial {
        didSet {
            layoutSubviews()
        }
    }
    
    /// The ChipBar used to switch between view controllers.
    @IBInspectable
    open let chipBar = ChipBar()
    
    /// The chipBar alignment.
    open var chipBarAlignment = ChipBarAlignment.bottom {
        didSet {
            layoutSubviews()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        chipBar.width = view.width
        
        switch displayStyle {
        case .partial:
            let h = chipBar.height
            container.y = h
            container.height = view.height - h
        case .full:
            container.frame = view.bounds
        }
        
        rootViewController.view.frame = container.bounds
    }
    
    open override func prepare() {
        super.prepare()
        prepareChipBar()
    }
}

fileprivate extension ChipBarController {
    /// Prepares the ChipBar.
    func prepareChipBar() {
        chipBar.depthPreset = .depth1
        view.addSubview(chipBar)
    }
}
