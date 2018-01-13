//
//  DialogView.swift
//  Material
//
//  Created by Orkhan Alikhanov on 1/10/18.
//  Copyright © 2018 CosmicMind, Inc. All rights reserved.
//

import UIKit

open class DialogView: UIView {
    open let titleArea = UIView()
    open let titleLabel = UILabel()
    open let detailsLabel = UILabel()
    
    open private(set) lazy var scrollView: UIScrollView = {
        class DialogScrollView: UIScrollView {
            weak var dialogView: DialogView?
            
            override func layoutSubviews() {
                super.layoutSubviews()
                dialogView?.layoutDividers()
            }
        }
        let scrollView = DialogScrollView()
        scrollView.dialogView = self
        return scrollView
    }()
    
    open let contentView = UIView()
    open let buttonArea = UIView()
    
    open let neutralButton = Button()
    open let positiveButton = Button()
    open let negativeButton = Button()
    
    /// Maximum size of the dialog
    open var maxSize = CGSize(width: 200, height: 300) {
        didSet {
            guard oldValue != maxSize else { return }
            invalidateIntrinsicContentSize()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    open func prepare() {
        backgroundColor = Color.grey.lighten5
        depthPreset = .depth5
        prepareTitleArea()
        prepareTitleLabel()
        prepareScrollView()
        prepareContentView()
        prepareDetailsLabel()
        prepareButtonArea()
        prepareButtons()
    }
    
    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(maxSize)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var w: CGFloat = 0
        func setW(_ newW: CGFloat) {
            w = max(w, newW)
            w = min(w, size.width)
        }
        
        setW(titleAreaSizeThatFits(width: size.width).width)
        setW(buttonAreaSizeThatFits(width: size.width).width)
        setW(contentViewSizeThatFits(width: size.width).width)
        
        var h: CGFloat = 0
        h += titleAreaSizeThatFits(width: w).height
        h += buttonAreaSizeThatFits(width: w).height
        h += contentViewSizeThatFits(width: w).height
        
        return CGSize(width: w, height: min(h, size.height))
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutTitleArea()
        layoutButtonArea()
        layoutContentView()
        layoutScrollView()
        layoutDividers()
        
        // Position button area
        buttonArea.frame.origin.y = scrollView.frame.maxY
    }
    
    /// Override this if you are using custom view in title area
    open func titleAreaSizeThatFits(width: CGFloat) -> CGSize {
        guard !titleLabel.isEmpty else { return .zero }
        var size = titleLabel.sizeThatFits(CGSize(width: width - 24 - 24, height: .greatestFiniteMagnitude))
        size.width += 24 + 24
        size.height += 24 + 20
        return size
    }
    
    open func buttonAreaSizeThatFits(width: CGFloat) -> CGSize {
        guard !nonHiddenButtons.isEmpty else { return .zero }

        let isStacked = requiredButtonAreaWidth > width
        let w = min(width, isStacked ? requiredButtonAreaWidthForStacked : requiredButtonAreaWidth)
        let h = isStacked ? CGFloat(8 + nonHiddenButtons.count * 48) : 52
        return CGSize(width: w, height: h)
    }
    
    open func contentViewSizeThatFits(width: CGFloat) -> CGSize {
        guard !detailsLabel.isEmpty else { return .zero }
        var size = detailsLabel.sizeThatFits(CGSize(width: width - 24 - 24, height: .greatestFiniteMagnitude))
        size.width += 24 + 24
        let additional: CGFloat = titleLabel.isEmpty ? 20 : 0 // if no title area, will be pushed 20 points below
        size.height += 24 + 0 + additional
        return size
    }
}

private extension DialogView {
    func layoutTitleArea() {
        let size = CGSize(width: frame.width, height: titleAreaSizeThatFits(width: frame.width).height)
        titleArea.frame.size = size
        
        guard !titleLabel.isEmpty else { return }
        titleLabel.frame = CGRect(x: 24, y: 24, width: size.width - 24 - 24, height: size.height - 24 - 20)
    }
    
    func layoutButtonArea() {
        let width = frame.width
        buttonArea.frame.size.width = width
        buttonArea.frame.size.height = buttonAreaSizeThatFits(width: width).height

        let buttons = nonHiddenButtons
        guard !buttons.isEmpty else { return }
        
        let isStacked = requiredButtonAreaWidth > width
        if isStacked {
            buttons.forEach {
                let w = min($0.optimalWidth, width - 8 - 8)
                $0.frame.size = CGSize(width: w, height: 36)
                $0.frame.origin.x = width - 8 - w
            }
            
            positiveButton.frame.origin.y = 6
            let belowPositive = positiveButton.isHidden ? 6 : positiveButton.frame.maxY + 6 + 6
            negativeButton.frame.origin.y = belowPositive
            neutralButton.frame.origin.y = negativeButton.isHidden ? belowPositive : (negativeButton.frame.maxY + 6 + 6)
        } else {
            buttons.forEach {
                $0.frame.size = CGSize(width: $0.optimalWidth, height: 36)
                $0.frame.origin.y = 8
            }

            neutralButton.frame.origin.x = 8
            positiveButton.frame.origin.x = width - 8 - positiveButton.frame.width
            negativeButton.frame.origin.x = (positiveButton.isHidden ? width : positiveButton.frame.minX) - 8 - negativeButton.frame.width
        }
    }
    
    func layoutContentView() {
        let size = CGSize(width: frame.width, height: contentViewSizeThatFits(width: frame.width).height)
        contentView.frame.size = size
        guard !detailsLabel.isEmpty else { return }
        let additional: CGFloat = titleArea.frame.height == 0 ? 20 : 0 // if no title area, push 20 points below
        detailsLabel.frame = CGRect(x: 24, y: additional, width: size.width - 24 - 24, height: size.height - 24)
    }
    
    func layoutScrollView() {
        let h = titleArea.frame.height + buttonArea.frame.height
        let allowed = min(frame.height - h, contentView.frame.height)

        scrollView.frame.size = CGSize(width: frame.width, height: max(allowed, 0))
        scrollView.frame.origin.y = titleArea.frame.maxY

        scrollView.contentSize = contentView.frame.size
    }
    
    /// Lays out dividers
    ///
    /// This method is also called (by scrollView) when scrolling happens
    func layoutDividers() {
        let isScrollable = contentView.frame.height > scrollView.frame.height
        
        titleArea.isDividerHidden = titleArea.frame.height == 0 || !isScrollable || scrollView.isAtTop
        buttonArea.isDividerHidden =  buttonArea.frame.height == 0 || !isScrollable || scrollView.isAtBottom
        
        titleArea.layoutDivider()
        buttonArea.layoutDivider()
    }
}


private extension Button {
    var optimalWidth: CGFloat {
        return max(64, sizeThatFits(CGSize(width: .max, height: 36)).width)
    }
}

private extension UILabel {
    var isEmpty: Bool {
        let empty = text?.isEmpty ?? true
        isHidden = empty
        return empty
    }
}

private extension DialogView {
    var requiredButtonAreaWidth: CGFloat {
        let buttons = nonHiddenButtons
        guard !buttons.isEmpty else { return 0 }
    
        let buttonsWidth: CGFloat = buttons.reduce(0) { $0 + $1.optimalWidth }
        let additional: CGFloat = neutralButton.isHidden ? 0 : 8 // additional spacing for neutral button
        return buttonsWidth + CGFloat(buttons.count * 8) + additional
    }
    
    var requiredButtonAreaWidthForStacked: CGFloat {
        return 8 + 8 + nonHiddenButtons.reduce(0) {
            max($0, $1.optimalWidth)
        }
    }
    
    var nonHiddenButtons: [Button] {
        positiveButton.isHidden = positiveButton.title(for: .normal)?.isEmpty ?? true
        negativeButton.isHidden = negativeButton.title(for: .normal)?.isEmpty ?? true
        neutralButton.isHidden = neutralButton.title(for: .normal)?.isEmpty ?? true
        return [positiveButton, negativeButton, neutralButton].filter { !$0.isHidden }
    }
}

private extension DialogView {
    func prepareTitleArea() {
        addSubview(titleArea)
        titleArea.dividerColor = Color.darkText.dividers
        titleArea.dividerThickness = 1
        titleArea.dividerAlignment = .bottom
    }
    
    func prepareTitleLabel() {
        titleArea.addSubview(titleLabel)
        titleLabel.font = RobotoFont.bold(with: 19)
        titleLabel.textColor = Color.darkText.primary
        titleLabel.numberOfLines = 0
    }
    
    func prepareButtonArea() {
        addSubview(buttonArea)
        buttonArea.dividerColor = Color.darkText.dividers
        buttonArea.dividerThickness = 1
        buttonArea.dividerAlignment = .top
    }
    
    func prepareButtons() {
        [positiveButton, negativeButton, neutralButton].forEach {
            buttonArea.addSubview($0)
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
    }
    
    func prepareScrollView() {
        addSubview(scrollView)
    }
    
    func prepareContentView() {
        scrollView.addSubview(contentView)
    }
    
    func prepareDetailsLabel() {
        contentView.addSubview(detailsLabel)
        detailsLabel.numberOfLines = 0
        detailsLabel.textColor = Color.darkText.secondary
    }
}

private extension UIScrollView {
    var isAtTop: Bool {
        return contentOffset.y <= 0
    }
    
    var isAtBottom: Bool {
        return contentOffset.y >= (contentSize.height - frame.height - 1)
    }
}
