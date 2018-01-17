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
        h = min(h, size.height)
        
        return CGSize(width: w, height: h)
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
        let insets = Constants.titleArea.insets
        var size = titleLabel.sizeThatFits(CGSize(width: width - insets.left - insets.right, height: .greatestFiniteMagnitude))
        size.width += insets.left + insets.right
        size.height += insets.top + insets.bottom
        return size
    }
    
    open func buttonAreaSizeThatFits(width: CGFloat) -> CGSize {
        guard !nonHiddenButtons.isEmpty else { return .zero }

        let isStacked = requiredButtonAreaWidth > width
        let buttonsHeight = Constants.button.height * CGFloat(isStacked ? nonHiddenButtons.count : 1)
        let buttonsInterim = isStacked ? CGFloat(nonHiddenButtons.count - 1) * Constants.button.interimStacked : 0
        let insets = isStacked ? Constants.buttonArea.insetsStacked : Constants.buttonArea.insets
        let h = buttonsInterim + buttonsHeight + insets.bottom + insets.top
        let w = min(width, isStacked ? requiredButtonAreaWidthForStacked : requiredButtonAreaWidth)
        
        return CGSize(width: w, height: h)
    }
    
    open func contentViewSizeThatFits(width: CGFloat) -> CGSize {
        guard !detailsLabel.isEmpty else { return .zero }
        let insets = titleLabel.isEmpty ? Constants.contentView.insetsNoTitle : Constants.contentView.insets
        var size = detailsLabel.sizeThatFits(CGSize(width: width - insets.left - insets.right, height: .greatestFiniteMagnitude))
        size.width += insets.left + insets.right
        size.height += insets.top + insets.bottom
        return size
    }
}

private struct Constants {
    struct titleArea {
        static let insets = UIEdgeInsets(top: 24, left: 24, bottom: 20, right: 24)
    }
    
    struct contentView {
        static let insets = UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 24)
        static let insetsNoTitle = UIEdgeInsets(top: 20, left: 24, bottom: 24, right: 24)
    }
    
    struct buttonArea {
        static let insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let insetsStacked = UIEdgeInsets(top: 6, left: 8, bottom: 14, right: 8)
    }
    
    struct button {
        static let insets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        static let minWidth: CGFloat = 64
        static let height: CGFloat = 36
        static let interimStacked: CGFloat = 12
        static let interim: CGFloat = 8
    }
}

private extension DialogView {
    func layoutTitleArea() {
        let size = CGSize(width: frame.width, height: titleAreaSizeThatFits(width: frame.width).height)
        titleArea.frame.size = size
        
        guard !titleLabel.isEmpty else { return }
        let rect = CGRect(origin: .zero, size: size)
        titleLabel.frame = UIEdgeInsetsInsetRect(rect, Constants.titleArea.insets)
    }
    
    func layoutButtonArea() {
        let width = frame.width
        buttonArea.frame.size.width = width
        buttonArea.frame.size.height = buttonAreaSizeThatFits(width: width).height

        let buttons = nonHiddenButtons
        guard !buttons.isEmpty else { return }
        
        let isStacked = requiredButtonAreaWidth > width
        if isStacked {
            let insets = Constants.buttonArea.insetsStacked
            buttons.forEach {
                let w = min($0.optimalWidth, width - insets.left - insets.right)
                $0.frame.size = CGSize(width: w, height: Constants.button.height)
                $0.frame.origin.x = width - insets.right - w
            }
            
            positiveButton.frame.origin.y = insets.top
            let belowPositive = positiveButton.isHidden ? insets.top : positiveButton.frame.maxY + Constants.button.interimStacked
            negativeButton.frame.origin.y = belowPositive
            neutralButton.frame.origin.y = negativeButton.isHidden ? belowPositive : negativeButton.frame.maxY + Constants.button.interimStacked
        } else {
            let insets = Constants.buttonArea.insets
            buttons.forEach {
                $0.frame.size = CGSize(width: $0.optimalWidth, height: Constants.button.height)
                $0.frame.origin.y = insets.top
            }

            neutralButton.frame.origin.x = insets.left
            positiveButton.frame.origin.x = width - insets.right - positiveButton.frame.width
            
            let maxX = positiveButton.isHidden ? width - insets.right : positiveButton.frame.minX - Constants.button.interim
            negativeButton.frame.origin.x = maxX - negativeButton.frame.width
        }
    }
    
    func layoutContentView() {
        let size = CGSize(width: frame.width, height: contentViewSizeThatFits(width: frame.width).height)
        contentView.frame.size = size
        guard !detailsLabel.isEmpty else { return }
        let rect = CGRect(origin: .zero, size: size)
        let insets = titleArea.frame.height == 0 ? Constants.contentView.insetsNoTitle : Constants.contentView.insets
        detailsLabel.frame = UIEdgeInsetsInsetRect(rect, insets)
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
        let size = CGSize(width: .greatestFiniteMagnitude, height: Constants.button.height)
        return max(Constants.button.minWidth, sizeThatFits(size).width)
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
        let insets = Constants.buttonArea.insets
        return buttonsWidth + insets.left + insets.right + CGFloat((buttons.count - 1)) * Constants.button.interim + additional
    }
    
    var requiredButtonAreaWidthForStacked: CGFloat {
        let insets = Constants.buttonArea.insetsStacked
        return insets.left + insets.right + nonHiddenButtons.reduce(0) {
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
        titleLabel.font = RobotoFont.bold(with: 20)
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
            $0.titleLabel?.font = RobotoFont.medium(with: 14)
            $0.contentEdgeInsets = Constants.button.insets
            $0.cornerRadiusPreset = .cornerRadius1
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
        // - 1 is to get rid of precision errors which makes divider appear even when scroll is at bottom
        return contentOffset.y >= (contentSize.height - frame.height - 1)
    }
}
