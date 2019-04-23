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

open class CollectionViewLayout: UICollectionViewLayout {
  /// Used to calculate the dimensions of the cells.
  public var offset = CGPoint.zero
  
  /// The size of items.
  public var itemSize = CGSize.zero
  
  /// A preset wrapper around contentEdgeInsets.
  public var contentEdgeInsetsPreset = EdgeInsetsPreset.none {
    didSet {
      contentEdgeInsets = EdgeInsetsPresetToValue(preset: contentEdgeInsetsPreset)
    }
  }
  
  /// A wrapper around grid.contentEdgeInsets.
  public var contentEdgeInsets = EdgeInsets.zero
  
  /// Size of the content.
  public fileprivate(set) var contentSize = CGSize.zero
  
  /// Layout attribute items.
  public fileprivate(set) lazy var layoutItems = [(UICollectionViewLayoutAttributes, NSIndexPath)]()
  
  /// Cell data source items.
  public fileprivate(set) var dataSourceItems: [DataSourceItem]?
  
  /// Scroll direction.
  public var scrollDirection = UICollectionView.ScrollDirection.vertical
  
  /// A preset wrapper around interimSpace.
  public var interimSpacePreset = InterimSpacePreset.none {
    didSet {
      interimSpace = InterimSpacePresetToValue(preset: interimSpacePreset)
    }
  }
  
  /// Spacing between items.
  public var interimSpace: InterimSpace = 0
  
  open override var collectionViewContentSize: CGSize {
    return contentSize
  }
}

extension CollectionViewLayout {
  /**
   Retrieves the index paths for the items within the passed in CGRect.
   - Parameter rect: A CGRect that acts as the bounds to find the items within.
   - Returns: An Array of NSIndexPath objects.
   */
  public func indexPathsOfItems(in rect: CGRect) -> [NSIndexPath] {
    var paths = [NSIndexPath]()
    
    for (attribute, indexPath) in layoutItems {
      guard rect.intersects(attribute.frame) else {
        continue
      }
      
      paths.append(indexPath)
    }
    
    return paths
  }
}

extension CollectionViewLayout {
  /**
   Prepares the layout for the given data source items.
   - Parameter for dataSourceItems: An Array of DataSourceItems.
   */
  fileprivate func prepareLayout(for dataSourceItems: [DataSourceItem]) {
    self.dataSourceItems = dataSourceItems
    layoutItems.removeAll()
    
    offset.x = contentEdgeInsets.left
    offset.y = contentEdgeInsets.top
    
    for i in 0..<dataSourceItems.count {
      let item = dataSourceItems[i]
      let indexPath = IndexPath(item: i, section: 0)
      layoutItems.append((layoutAttributesForItem(at: indexPath)!, indexPath as NSIndexPath))
      
      offset.x += interimSpace
      offset.y += interimSpace
      
      if nil != item.width {
        offset.x += item.width!
      } else if let v = item.data as? UIView, 0 < v.bounds.width {
        offset.x += v.bounds.width
      } else {
        offset.x += itemSize.width
      }
      
      if nil != item.height {
        offset.y += item.height!
      } else if let v = item.data as? UIView, 0 < v.bounds.height {
        offset.y += v.bounds.height
      } else {
        offset.y += itemSize.height
      }
    }
    
    offset.x += contentEdgeInsets.right - interimSpace
    offset.y += contentEdgeInsets.bottom - interimSpace
    
    if 0 < itemSize.width && 0 < itemSize.height {
      contentSize = CGSize(width: offset.x, height: offset.y)
    } else if .vertical == scrollDirection {
      contentSize = CGSize(width: collectionView!.bounds.width, height: offset.y)
    } else {
      contentSize = CGSize(width: offset.x, height: collectionView!.bounds.height)
    }
  }
}

extension CollectionViewLayout {
  open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    let dataSourceItem = dataSourceItems![indexPath.item]
    
    if 0 < itemSize.width && 0 < itemSize.height {
      attributes.frame = CGRect(x: offset.x, y: offset.y, width: itemSize.width - contentEdgeInsets.left - contentEdgeInsets.right, height: itemSize.height - contentEdgeInsets.top - contentEdgeInsets.bottom)
    } else if .vertical == scrollDirection {
      if let h = dataSourceItem.height {
        attributes.frame = CGRect(x: contentEdgeInsets.left, y: offset.y, width: collectionView!.bounds.width - contentEdgeInsets.left - contentEdgeInsets.right, height: h)
        
      } else if let v = dataSourceItem.data as? UIView, 0 < v.bounds.height {
        v.updateConstraintsIfNeeded()
        v.updateConstraints()
        v.setNeedsLayout()
        v.layoutIfNeeded()
        
        attributes.frame = CGRect(x: contentEdgeInsets.left, y: offset.y, width: collectionView!.bounds.width - contentEdgeInsets.left - contentEdgeInsets.right, height: v.bounds.height)
        
      } else {
        attributes.frame = CGRect(x: contentEdgeInsets.left, y: offset.y, width: collectionView!.bounds.width - contentEdgeInsets.left - contentEdgeInsets.right, height: collectionView!.bounds.height)
      }
    } else {
      if let w = dataSourceItem.width {
        attributes.frame = CGRect(x: offset.x, y: contentEdgeInsets.top, width: w, height: collectionView!.bounds.height - contentEdgeInsets.top - contentEdgeInsets.bottom)
        
      } else if let v = dataSourceItem.data as? UIView, 0 < v.bounds.width {
        v.updateConstraintsIfNeeded()
        v.updateConstraints()
        v.setNeedsLayout()
        v.layoutIfNeeded()
        
        attributes.frame = CGRect(x: offset.x, y: contentEdgeInsets.top, width: v.bounds.width, height: collectionView!.bounds.height - contentEdgeInsets.top - contentEdgeInsets.bottom)
        
      } else {
        attributes.frame = CGRect(x: offset.x, y: contentEdgeInsets.top, width: collectionView!.bounds.width, height: collectionView!.bounds.height - contentEdgeInsets.top - contentEdgeInsets.bottom)
      }
    }
    
    return attributes
  }
  
  open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    for (attribute, _) in layoutItems {
      if rect.intersects(attribute.frame) {
        layoutAttributes.append(attribute)
      }
    }
    return layoutAttributes
  }
  
  open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return .vertical == scrollDirection ? newBounds.width != collectionView!.bounds.width : newBounds.height != collectionView!.bounds.height
  }
  
  open override func prepare() {
    guard let dataSource = collectionView?.dataSource as? CollectionViewDataSource else {
      return
    }
    
    prepareLayout(for: dataSource.dataSourceItems)
  }
  
  open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
    return proposedContentOffset
  }
}
