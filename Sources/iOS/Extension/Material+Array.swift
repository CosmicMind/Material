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

extension Array where Element: Equatable {
  /**
   Slices a out a segment of an array based on the start
   and end positions.
   - Parameter start: A start index.
   - Parameter end: An end index.
   - Returns: A segmented array based on the start and end
   indices.
   */
  public func slice(start: Int, end: Int?) -> [Element] {
    var e = end ?? count - 1
    if e >= count {
      e = count - 1
    }
    
    guard -1 < start else {
      fatalError("Range out of bounds for \(start) - \(end ?? 0), should be 0 - \(count).")
    }
    
    var diff = abs(e - start)
    guard count > diff else {
      return self
    }
    
    var ret = [Element]()
    while -1 < diff {
      ret.insert(self[start + diff], at: 0)
      diff -= 1
    }
    
    return ret
  }
}
