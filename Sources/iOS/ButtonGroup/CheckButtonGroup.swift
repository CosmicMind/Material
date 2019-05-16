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

/// Lays out provided check buttons within itself.
///
/// Unlike RadioButtonGroup, checking one check button that belongs to a check group *does not* unchecks any previously checked
/// check button within the same group. Intially, all of the check buttons are unchecked.
///
/// The buttons are laid out by `Grid` system, so that changing properites of grid instance
/// (e.g interimSpace) are reflected.
open class CheckButtonGroup: BaseButtonGroup<CheckButton> {
  
  /// Initializes CheckButtonGroup with an array of check buttons each having
  /// title equal to corresponding string in the `titles` parameter.
  ///
  /// - Parameter titles: An array of title strings
  public convenience init(titles: [String]) {
    let buttons = titles.map { CheckButton(title: $0) }
    self.init(buttons: buttons)
  }
  
  /// Returns all selected check buttons within the group
  /// or empty array if none is seleceted.
  open var selecetedButtons: [CheckButton] {
    return buttons.filter { $0.isSelected }
  }
  
  /// Returns indexes of all selected check buttons within the group
  /// or empty array if none is seleceted.
  open var selectedIndices: [Int] {
    return selecetedButtons.map { buttons.firstIndex(of: $0)! }
  }
  
  open override func didTap(button: CheckButton, at index: Int) {
    button.setSelected(!button.isSelected, animated: true)
  }
}

