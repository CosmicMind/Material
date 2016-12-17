/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit

open class CollectionViewLayout: UICollectionViewLayout {
	/// Used to calculate the dimensions of the cells.
	open var offset = CGPoint.zero
	
	/// The size of items.
	open var itemSize = CGSize.zero
	
	/// A preset wrapper around contentEdgeInsets.
	open var contentEdgeInsetsPreset = EdgeInsetsPreset.none {
		didSet {
			contentEdgeInsets = EdgeInsetsPresetToValue(preset: contentEdgeInsetsPreset)
		}
	}
	
	/// A wrapper around grid.contentEdgeInsets.
	open var contentEdgeInsets = EdgeInsets.zero
	
	/// Size of the content.
	open fileprivate(set) var contentSize = CGSize.zero
	
	/// Layout attribute items.
	open fileprivate(set) lazy var layoutItems = [(UICollectionViewLayoutAttributes, NSIndexPath)]()
	
	/// Cell data source items.
	open fileprivate(set) var dataSourceItems: [DataSourceItem]?
	
	/// Scroll direction.
	open var scrollDirection = UICollectionViewScrollDirection.vertical
	
	/// A preset wrapper around interimSpace.
	open var interimSpacePreset = InterimSpacePreset.none {
		didSet {
            interimSpace = InterimSpacePresetToValue(preset: interimSpacePreset)
		}
	}
	
	/// Spacing between items.
	open var interimSpace: InterimSpace = 0
	
    open override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
	/**
	Retrieves the index paths for the items within the passed in CGRect.
	- Parameter rect: A CGRect that acts as the bounds to find the items within.
	- Returns: An Array of NSIndexPath objects.
	*/
	open func indexPathsOfItemsInRect(rect: CGRect) -> [NSIndexPath] {
		var paths = [NSIndexPath]()
		for (attribute, indexPath) in layoutItems {
			if rect.intersects(attribute.frame) {
				paths.append(indexPath)
			}
		}
		return paths
	}
	
	open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
		let item = dataSourceItems![indexPath.item]
		
		if 0 < itemSize.width && 0 < itemSize.height {
            attributes.frame = CGRect(x: offset.x, y: offset.y, width: itemSize.width - contentEdgeInsets.left - contentEdgeInsets.right, height: itemSize.height - contentEdgeInsets.top - contentEdgeInsets.bottom)
		} else if .vertical == scrollDirection {
            attributes.frame = CGRect(x: contentEdgeInsets.left, y: offset.y, width: collectionView!.bounds.width - contentEdgeInsets.left - contentEdgeInsets.right, height: item.height ?? collectionView!.bounds.height)
		} else {
            attributes.frame = CGRect(x: offset.x, y: contentEdgeInsets.top, width: item.width ?? collectionView!.bounds.width, height: collectionView!.bounds.height - contentEdgeInsets.top - contentEdgeInsets.bottom)
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
        
        prepareLayoutForItems(dataSourceItems: dataSource.dataSourceItems)
	}
	
	open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
		return proposedContentOffset
	}
	
	fileprivate func prepareLayoutForItems(dataSourceItems: [DataSourceItem]) {
		self.dataSourceItems = dataSourceItems
		layoutItems.removeAll()
		
		offset.x = contentEdgeInsets.left
		offset.y = contentEdgeInsets.top
		
		for i in 0..<dataSourceItems.count {
			let item = dataSourceItems[i]
			let indexPath = IndexPath(item: i, section: 0)
			layoutItems.append((layoutAttributesForItem(at: indexPath)!, indexPath as NSIndexPath))
			
			offset.x += interimSpace
			offset.x += item.width ?? itemSize.width
			
			offset.y += interimSpace
			offset.y += item.height ?? itemSize.height
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
