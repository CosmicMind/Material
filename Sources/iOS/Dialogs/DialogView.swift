/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
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

private struct Constants {
  struct titleArea {
    static let insets = UIEdgeInsets(top: 24, left: 24, bottom: 20, right: 24)
  }
  
  struct contentArea {
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

private class DialogScrollView: UIScrollView {
  /// A weak reference to DialogView.
  weak var dialogView: DialogView?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    dialogView?.layoutDividers()
  }
}

open class DialogView: View, Themeable {
  /// A container view for title area.
  public let titleArea = UIView()
  
  /// A container view for button area.
  public let buttonArea = UIView()
  
  /// A container view for content area.
  public let contentArea = UIView()
  
  /// A scroll view containing contentArea.
  public let scrollView: UIScrollView = DialogScrollView()
  
  /// A UILabel.
  public let titleLabel = UILabel()
  
  /// A UILabel.
  public let detailsLabel = UILabel()
  
  /// A Button.
  public let neutralButton = FlatButton()
  
  /// A Button.
  public let positiveButton = FlatButton()
  
  /// A Button.
  public let negativeButton = FlatButton()
  
  /// Maximum size of the dialog.
  open var maxSize = CGSize(width: 200, height: 300) {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  open override func prepare() {
    super.prepare()
    
    depthPreset = .depth5
    cornerRadiusPreset = .cornerRadius2
    prepareTitleArea()
    prepareTitleLabel()
    prepareScrollView()
    prepareContentArea()
    prepareDetailsLabel()
    prepareButtonArea()
    prepareButtons()
    applyCurrentTheme()
  }
  
  open override var intrinsicContentSize: CGSize {
    return sizeThatFits(maxSize)
  }
  
  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    var w: CGFloat = 0
    func setMaxWidth(_ width: CGFloat) {
      w = max(w, width)
      w = min(w, size.width)
    }
    
    setMaxWidth(titleAreaSizeThatFits(width: size.width).width)
    setMaxWidth(buttonAreaSizeThatFits(width: size.width).width)
    setMaxWidth(contentAreaSizeThatFits(width: size.width).width)
    
    var h: CGFloat = 0
    h += titleAreaSizeThatFits(width: w).height
    h += buttonAreaSizeThatFits(width: w).height
    h += contentAreaSizeThatFits(width: w).height
    h = min(h, size.height)
    
    return CGSize(width: w, height: h)
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    
    layoutTitleArea()
    layoutButtonArea()
    layoutContentArea()
    layoutScrollView()
    layoutDividers()
    
    /// Position button area after having correct sizes.
    buttonArea.frame.origin.y = scrollView.frame.maxY
  }
  
  /**
   Calculates the size for title area that best fits the specified width.
   - Parameter width: A CGFloat.
   - Returns: Calculated CGSize.
   */
  open func titleAreaSizeThatFits(width: CGFloat) -> CGSize {
    guard !titleLabel.isEmpty else {
      return .zero
    }
    
    let insets = Constants.titleArea.insets
    var size = titleLabel.sizeThatFits(CGSize(width: width - insets.left - insets.right, height: .greatestFiniteMagnitude))
    size.width += insets.left + insets.right
    size.height += insets.top + insets.bottom
    return size
  }
  
  /**
   Calculates the size for button area that best fits the specified width.
   - Parameter width: A CGFloat.
   - Returns: Calculated CGSize.
   */
  open func buttonAreaSizeThatFits(width: CGFloat) -> CGSize {
    guard !nonHiddenButtons.isEmpty else {
      return .zero
    }
    
    let isStacked = requiredButtonAreaWidth > width
    let buttonsHeight = Constants.button.height * CGFloat(isStacked ? nonHiddenButtons.count : 1)
    let buttonsInterim = isStacked ? CGFloat(nonHiddenButtons.count - 1) * Constants.button.interimStacked : 0
    let insets = isStacked ? Constants.buttonArea.insetsStacked : Constants.buttonArea.insets
    let h = buttonsInterim + buttonsHeight + insets.bottom + insets.top
    let w = min(width, isStacked ? requiredButtonAreaWidthForStacked : requiredButtonAreaWidth)
    return CGSize(width: w, height: h)
  }
  
  /**
   Calculates the size for content area that best fits the specified width.
   - Parameter width: A CGFloat.
   - Returns: Calculated CGSize.
   */
  open func contentAreaSizeThatFits(width: CGFloat) -> CGSize {
    guard !detailsLabel.isEmpty else {
      return .zero
    }
    
    let insets = titleLabel.isEmpty ? Constants.contentArea.insetsNoTitle : Constants.contentArea.insets
    var size = detailsLabel.sizeThatFits(CGSize(width: width - insets.left - insets.right, height: .greatestFiniteMagnitude))
    size.width += insets.left + insets.right
    size.height += insets.top + insets.bottom
    return size
  }
  
  /**
   Applies the given theme.
   - Parameter theme: A Theme.
   */
  open func apply(theme: Theme) {
    backgroundColor = theme.surface
    titleLabel.textColor = theme.onSurface.withAlphaComponent(0.87)
    detailsLabel.textColor = theme.onSurface.withAlphaComponent(0.60)
    
    titleArea.dividerColor = theme.onSurface.withAlphaComponent(0.12)
    buttonArea.dividerColor = theme.onSurface.withAlphaComponent(0.12)
  }
}

private extension DialogView {
  /// Prepares titleArea.
  func prepareTitleArea() {
    addSubview(titleArea)
    titleArea.dividerColor = Color.darkText.dividers
    titleArea.dividerThickness = 1
    titleArea.dividerAlignment = .bottom
  }
  
  /// Prepares titleTitle.
  func prepareTitleLabel() {
    titleArea.addSubview(titleLabel)
    titleLabel.font = Theme.font.bold(with: 20)
    titleLabel.textColor = Color.darkText.primary
    titleLabel.numberOfLines = 0
  }
  
  /// Prepares buttonArea.
  func prepareButtonArea() {
    addSubview(buttonArea)
    buttonArea.dividerColor = Color.darkText.dividers
    buttonArea.dividerThickness = 1
    buttonArea.dividerAlignment = .top
  }
  
  /// Prepares buttons.
  func prepareButtons() {
    [positiveButton, negativeButton, neutralButton].forEach {
      buttonArea.addSubview($0)
      $0.titleLabel?.font = Theme.font.medium(with: 14)
      $0.contentEdgeInsets = Constants.button.insets
      $0.cornerRadiusPreset = .cornerRadius1
    }
  }
  
  /// Prepares scrollView.
  func prepareScrollView() {
    (scrollView as! DialogScrollView).dialogView = self
    addSubview(scrollView)
  }
  
  /// Prepares contentArea.
  func prepareContentArea() {
    scrollView.addSubview(contentArea)
  }
  
  /// Prepares detailsLabel.
  func prepareDetailsLabel() {
    contentArea.addSubview(detailsLabel)
    detailsLabel.font = Theme.font.regular(with: detailsLabel.fontSize)
    detailsLabel.numberOfLines = 0
    detailsLabel.textColor = Color.darkText.secondary
  }
}

private extension DialogView {
  /// Layout the titleArea.
  func layoutTitleArea() {
    let size = CGSize(width: frame.width, height: titleAreaSizeThatFits(width: frame.width).height)
    titleArea.frame.size = size
    
    guard !titleLabel.isEmpty else {
      return
    }
    
    let rect = CGRect(origin: .zero, size: size)
    titleLabel.frame = rect.inset(by: Constants.titleArea.insets)
  }
  
  /// Layout the buttonArea.
  func layoutButtonArea() {
    let width = frame.width
    buttonArea.frame.size.width = width
    buttonArea.frame.size.height = buttonAreaSizeThatFits(width: width).height
    
    let buttons = nonHiddenButtons
    guard !buttons.isEmpty else {
      return
    }
    
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
  
  /// Layout the contentArea.
  func layoutContentArea() {
    let size = CGSize(width: frame.width, height: contentAreaSizeThatFits(width: frame.width).height)
    contentArea.frame.size = size
    guard !detailsLabel.isEmpty else {
      return
    }
    
    let rect = CGRect(origin: .zero, size: size)
    let insets = titleArea.frame.height == 0 ? Constants.contentArea.insetsNoTitle : Constants.contentArea.insets
    detailsLabel.frame = rect.inset(by: insets)
  }
  
  /// Layout the scrollView.
  func layoutScrollView() {
    let h = titleArea.frame.height + buttonArea.frame.height
    let allowed = min(frame.height - h, contentArea.frame.height)
    
    scrollView.frame.size = CGSize(width: frame.width, height: max(allowed, 0))
    scrollView.frame.origin.y = titleArea.frame.maxY
    
    scrollView.contentSize = contentArea.frame.size
  }
  
  /**
   Layout the dividers.
   This method is also called (by scrollView) when scrolling happens
   */
  func layoutDividers() {
    let isScrollable = contentArea.frame.height > scrollView.frame.height
    
    titleArea.isDividerHidden = titleArea.frame.height == 0 || !isScrollable || scrollView.isAtTop
    buttonArea.isDividerHidden =  buttonArea.frame.height == 0 || !isScrollable || scrollView.isAtBottom
    
    titleArea.layoutDivider()
    buttonArea.layoutDivider()
  }
}

private extension DialogView {
  /// Required width to fit content of buttonArea.
  var requiredButtonAreaWidth: CGFloat {
    let buttons = nonHiddenButtons
    guard !buttons.isEmpty else {
      return 0
    }
    
    let buttonsWidth: CGFloat = buttons.reduce(0) { $0 + $1.optimalWidth }
    let additional: CGFloat = neutralButton.isHidden ? 0 : 8 // additional spacing for neutral button
    let insets = Constants.buttonArea.insets
    return buttonsWidth + insets.left + insets.right + CGFloat((buttons.count - 1)) * Constants.button.interim + additional
  }
  
  /// Required width to fit statcked content of buttonArea.
  var requiredButtonAreaWidthForStacked: CGFloat {
    let insets = Constants.buttonArea.insetsStacked
    return insets.left + insets.right + nonHiddenButtons.reduce(0) {
      max($0, $1.optimalWidth)
    }
  }
  
  /// Non-hidden buttons within buttonArea.
  var nonHiddenButtons: [Button] {
    positiveButton.isHidden = positiveButton.title(for: .normal)?.isEmpty ?? true
    negativeButton.isHidden = negativeButton.title(for: .normal)?.isEmpty ?? true
    neutralButton.isHidden = neutralButton.title(for: .normal)?.isEmpty ?? true
    return [positiveButton, negativeButton, neutralButton].filter { !$0.isHidden }
  }
}

private extension UIScrollView {
  /// Checks if scroll view is at the top.
  var isAtTop: Bool {
    return contentOffset.y <= 0
  }
  
  /// Checks if scroll view is at the bottom.
  var isAtBottom: Bool {
    /// -1 is used to get rid of precision errors
    /// make divider appear even when scroll is at the bottom.
    return contentOffset.y >= (contentSize.height - frame.height - 1)
  }
}

private extension Button {
  /// Optimal width for dialog button.
  var optimalWidth: CGFloat {
    let size = CGSize(width: .greatestFiniteMagnitude, height: Constants.button.height)
    return max(Constants.button.minWidth, sizeThatFits(size).width)
  }
}

private extension UILabel {
  /// Checks if label is empty.
  var isEmpty: Bool {
    let empty = text?.isEmpty ?? true
    isHidden = empty
    return empty
  }
}
