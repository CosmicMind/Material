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

extension String {
  /**
   :name:	trim
   */
  public var trimmed: String {
    return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
  }
  
  /**
   :name:	lines
   */
  public var lines: [String] {
    return components(separatedBy: CharacterSet.newlines)
  }
  
  /**
   :name:	firstLine
   */
  public var firstLine: String? {
    return lines.first?.trimmed
  }
  
  /**
   :name:	lastLine
   */
  public var lastLine: String? {
    return lines.last?.trimmed
  }
  
  /**
   :name:	replaceNewLineCharater
   */
  public func replaceNewLineCharater(separator: String = " ") -> String {
    return components(separatedBy: CharacterSet.whitespaces).joined(separator: separator).trimmed
  }
  
  /**
   :name:	replacePunctuationCharacters
   */
  public func replacePunctuationCharacters(separator: String = "") -> String {
    return components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: separator).trimmed
  }
}
