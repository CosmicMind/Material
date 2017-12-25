//
//  BaseButtonGroup.swift
//  Material
//
//  Created by Orkhan Alikhanov on 12/24/17.
//  Copyright © 2017 CosmicMind, Inc. All rights reserved.
//

import UIKit

open class BaseButtonGroup<T: Button>: View {
    
    /// Holds reference to buttons within the group.
    open var buttons: [T] = [] {
        didSet {
            oldValue.forEach {
                $0.removeFromSuperview()
                $0.removeTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
            }
            prepareButtons()
            grid.views = buttons
            grid.axis.rows = buttons.count
        }
    }
    
    /// Initializes group with the provided buttons.
    ///
    /// - Parameter buttons: Array of buttons.
    public convenience init(buttons: [T]) {
        self.init(frame: .zero)
        defer { self.buttons = buttons } // defer allows didSet to be called
    }
    
    open override func prepare() {
        super.prepare()
        grid.axis.direction = .vertical
        grid.axis.columns = 1
    }
    
    
    open override var intrinsicContentSize: CGSize { return sizeThatFits(bounds.size) }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = CGSize(width: size.width == 0 ? .greatestFiniteMagnitude : size.width, height: size.height == 0 ? .greatestFiniteMagnitude : size.height)
        let availableW = size.width - grid.contentEdgeInsets.left - grid.contentEdgeInsets.right - grid.layoutEdgeInsets.left - grid.layoutEdgeInsets.right
        var maxW: CGFloat = 0
        buttons.forEach { maxW = max(maxW, $0.sizeThatFits(.init(width: availableW, height: .greatestFiniteMagnitude)).width) }
        
        var h = grid.contentEdgeInsets.top + grid.contentEdgeInsets.bottom + grid.layoutEdgeInsets.top + grid.layoutEdgeInsets.bottom + CGFloat(buttons.count - 1) * grid.interimSpace
        buttons.forEach { h += $0.sizeThatFits(.init(width: maxW, height: .greatestFiniteMagnitude)).height }
        
        return CGSize(width: maxW + grid.contentEdgeInsets.left + grid.contentEdgeInsets.right + grid.layoutEdgeInsets.left + grid.layoutEdgeInsets.right, height: min(h, size.height))
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        grid.reload()
    }
    
    open func didTap(button: T, at index: Int) { }
    
    @objc
    private func didTap(_ sender: Button) {
        guard let sender = sender as? T,
            let index = buttons.index(of: sender)
            else { return }
        
        didTap(button: sender, at: index)
    }
}

private extension BaseButtonGroup {
    func prepareButtons() {
        buttons.forEach {
            addSubview($0)
            $0.removeTarget(nil, action: nil, for: .allEvents)
            $0.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
        }
    }
}
