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

/// Lays out provided radio buttons within itself.
///
/// Checking one radio button that belongs to a radio group unchecks any previously checked
/// radio button within the same group. Intially, all of the radio buttons are unchecked.
///
/// The buttons are laid out by `Grid` system, so that changing properites of grid instance
/// (e.g interimSpace) are reflected.
open class RadioButtonGroup: BaseButtonGroup<RadioButton> {
  
  /// Initializes RadioButtonGroup with an array of radio buttons each having
  /// title equal to corresponding string in the `titles` parameter.
  ///
  /// - Parameter titles: An array of title strings.
  public convenience init(titles: [String]) {
    let buttons = titles.map { RadioButton(title: $0) }
    self.init(buttons: buttons)
  }
  
  /// Returns selected radio button within the group.
  /// If none is selected (e.g in initial state), nil is returned.
  open var selectedButton: RadioButton? {
    return buttons.first { $0.isSelected }
  }
  
  /// Returns index of selected radio button within the group.
  /// If none is selected (e.g in initial state), -1 is returned.
  open var selectedIndex: Int {
    guard let b = selectedButton else { return -1 }
    return buttons.firstIndex(of: b)!
  }
  
  open override func didTap(button: RadioButton, at index: Int) {
    let isAnimating = buttons.reduce(false) { $0 || $1.isAnimating }
    guard !isAnimating else { return }
    
    buttons.forEach { $0.setSelected($0 == button, animated: true) }
  }
}
