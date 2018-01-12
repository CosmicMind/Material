//
//  DialogController.swift
//  Material
//
//  Created by Orkhan Alikhanov on 1/11/18.
//  Copyright © 2018 CosmicMind, Inc. All rights reserved.
//

import UIKit

open class DialogController<T: DialogView>: UIViewController {
    open let dialogView = T()
    open var isCancelable = false
    
    open func prepare() {
        isMotionEnabled = true
        motionTransitionType = .fade
        modalPresentationStyle = .overFullScreen
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view = UIControl()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.33)
        view.layout(dialogView)
            .center()
        
        (view as? UIControl)?.addTarget(self, action: #selector(didTapView), for: .touchUpInside)
        dialogView.buttonArea.subviews.forEach {
            ($0 as? Button)?.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        }
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dialogView.maxSize = CGSize(width: Screen.width * 0.8, height: Screen.height * 0.9)
    }
        
    open var canceledHandler: (() -> Void)?
    open var shouldDismissHandler: ((Button?) -> Bool)?
    
    open var positiveHandler: (() -> Void)?
    open var negativeHandler: (() -> Void)?
    open var neutralHandler: (() -> Void)?
    
    @objc
    private func didTapView() {
        guard isCancelable else { return }
        dismiss(nil)
        canceledHandler?()
    }
    
    @objc
    private func didTapButton(_ sender: Button) {
        switch sender {
        case dialogView.positiveButton:
            positiveHandler?()
        case dialogView.negativeButton:
            negativeHandler?()
        case dialogView.neutralButton:
            neutralHandler?()
        default:
            break
        }
        dismiss(sender)
    }
    
    open func dismiss(_ button: Button?) {
        if shouldDismissHandler?(button) ?? true {
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
}
