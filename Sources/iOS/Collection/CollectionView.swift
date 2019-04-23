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

open class CollectionView: UICollectionView {
  /// A preset wrapper around contentEdgeInsets.
  open var contentEdgeInsetsPreset: EdgeInsetsPreset {
    get {
      return (collectionViewLayout as? CollectionViewLayout)!.contentEdgeInsetsPreset
    }
    set(value) {
      (collectionViewLayout as? CollectionViewLayout)!.contentEdgeInsetsPreset = value
    }
  }
  
  open var contentEdgeInsets: EdgeInsets {
    get {
      return (collectionViewLayout as? CollectionViewLayout)!.contentEdgeInsets
    }
    set(value) {
      (collectionViewLayout as? CollectionViewLayout)!.contentEdgeInsets = value
    }
  }
  
  /// Scroll direction.
  open var scrollDirection: UICollectionView.ScrollDirection {
    get {
      return (collectionViewLayout as? CollectionViewLayout)!.scrollDirection
    }
    set(value) {
      (collectionViewLayout as? CollectionViewLayout)!.scrollDirection = value
    }
  }
  
  /// A preset wrapper around interimSpace.
  open var interimSpacePreset: InterimSpacePreset {
    get {
      return (collectionViewLayout as? CollectionViewLayout)!.interimSpacePreset
    }
    set(value) {
      (collectionViewLayout as? CollectionViewLayout)!.interimSpacePreset = value
    }
  }
  
  /// Spacing between items.
  @IBInspectable
  open var interimSpace: InterimSpace {
    get {
      return (collectionViewLayout as? CollectionViewLayout)!.interimSpace
    }
    set(value) {
      (collectionViewLayout as? CollectionViewLayout)!.interimSpace = value
    }
  }
  
  /**
   An initializer that initializes the object with a NSCoder object.
   - Parameter aDecoder: A NSCoder instance.
   */
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepare()
  }
  
  /**
   An initializer that initializes the object.
   - Parameter frame: A CGRect defining the view's frame.
   - Parameter collectionViewLayout: A UICollectionViewLayout reference.
   */
  public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    prepare()
  }
  
  /**
   An initializer that initializes the object.
   - Parameter collectionViewLayout: A UICollectionViewLayout reference.
   */
  public init(collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: .zero, collectionViewLayout: layout)
    prepare()
  }
  
  /**
   An initializer that initializes the object.
   - Parameter frame: A CGRect defining the view's frame.
   */
  public init(frame: CGRect) {
    let layout = CollectionViewLayout()
    super.init(frame: frame, collectionViewLayout: layout)
    prepare()
  }
  
  /// A convenience initializer that initializes the object.
  public init() {
    let layout = CollectionViewLayout()
    super.init(frame: .zero, collectionViewLayout: layout)
    prepare()
  }
  
  /**
   Prepares the view instance when intialized. When subclassing,
   it is recommended to override the prepare method
   to initialize property values and other setup operations.
   The super.prepare method should always be called immediately
   when subclassing.
   */
  open func prepare() {
    backgroundColor = .white
    contentScaleFactor = Screen.scale
    register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
  }
}
