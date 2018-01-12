//
//  DialogBuilder.swift
//  Material
//
//  Created by Orkhan Alikhanov on 1/11/18.
//  Copyright © 2018 CosmicMind, Inc. All rights reserved.
//

import UIKit

public typealias Dialog = DialogBuilder<DialogView>
open class DialogBuilder<T: DialogView> {

    public init() {}
    open let controller = DialogController<T>()
    
    open func title(_ text: String?) -> DialogBuilder {
        dialogView.titleLabel.text = text
        return self
    }
    
    open func details(_ text: String?) -> DialogBuilder {
        dialogView.detailsLabel.text = text
        return self
    }
    
    open func isCancelable(_ value: Bool, handler: (() -> Void)? = nil) -> DialogBuilder {
        controller.isCancelable = value
        controller.canceledHandler = handler
        return self
    }
    
    open func shouldDismiss(handler: ((Button?) -> Bool)?) -> DialogBuilder {
        controller.shouldDismissHandler = handler
        return self
    }
    
    open func positiveButton(_ title: String?, handler: (() -> Void)?) -> DialogBuilder {
        dialogView.positiveButton.title = title
        controller.positiveHandler = handler
        return self
    }

    open func negativeButton(_ title: String?, handler: (() -> Void)?) -> DialogBuilder {
        dialogView.negativeButton.title = title
        controller.negativeHandler = handler
        return self
    }
    
    open func neutralButton(_ title: String?, handler: (() -> Void)?) -> DialogBuilder {
        dialogView.neutralButton.title = title
        controller.neutralHandler = handler
        return self
    }
    
    
    @discardableResult
    open func show(_ vc: UIViewController) -> DialogBuilder {
        vc.present(controller, animated: true, completion: nil)
        return self
    }
}

extension DialogBuilder {
    private var dialogView: T {
        return controller.dialogView
    }
}
