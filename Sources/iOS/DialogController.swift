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
        
    open var didCancelHandler: (() -> Void)?
    open var shouldDismissHandler: ((T, Button?) -> Bool)?
    
    open var didTapPositiveButtonHandler: (() -> Void)?
    open var didTapNegativeButtonHandler: (() -> Void)?
    open var didTapNeutralButtonHandler: (() -> Void)?
    
    @objc
    private func didTapView() {
        guard isCancelable else { return }
        dismiss(nil)
        didCancelHandler?()
    }
    
    @objc
    private func didTapButton(_ sender: Button) {
        switch sender {
        case dialogView.positiveButton:
            didTapPositiveButtonHandler?()
        case dialogView.negativeButton:
            didTapNegativeButtonHandler?()
        case dialogView.neutralButton:
            didTapNeutralButtonHandler?()
        default:
            break
        }
        dismiss(sender)
    }
    
    open func dismiss(_ button: Button?) {
        if shouldDismissHandler?(dialogView, button) ?? true {
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
