/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
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
*	*	Neither the name of Material nor the names of its
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

public class MaterialCollectionViewLayout : UICollectionViewLayout {
	/// A preset wrapper around contentInset.
	public var contentInsetPreset: MaterialEdgeInset = .None {
		didSet {
			contentInset = MaterialEdgeInsetToValue(contentInsetPreset)
		}
	}
	
	/// A wrapper around grid.contentInset.
	public var contentInset: UIEdgeInsets = UIEdgeInsetsZero
	
	/// Size of the content.
	private var contentSize: CGSize = CGSizeZero
	
	/// Layout attribute items.
	private var layoutItems: Array<(UICollectionViewLayoutAttributes, NSIndexPath)> = Array<(UICollectionViewLayoutAttributes, NSIndexPath)>()
	
	/// Used to calculate the dimensions of the cells.
	private var offset: CGPoint = CGPointZero
	
	/// Cell items.
	private var items: Array<Array<MaterialDataSourceItem>>?
	
	/// Scroll direction.
	public var scrollDirection: UICollectionViewScrollDirection = .Vertical
	
	/// Scale of the screen.
	public var scale: CGFloat = 2
	
	/// Spacing between items.
	public var spacing: CGFloat = 0
	
	/**
	Retrieves the index paths for the items within the passed in CGRect.
	- Parameter rect: A CGRect that acts as the bounds to find the items within.
	- Returns: An Array of NSIndexPath objects.
	*/
	public func indexPathsOfItemsInRect(rect: CGRect) -> Array<NSIndexPath> {
		var paths: Array<NSIndexPath> = Array<NSIndexPath>()
		for (attribute, indexPath) in layoutItems {
			if CGRectIntersectsRect(rect, attribute.frame) {
				paths.append(indexPath)
			}
		}
		return paths
	}
	
	public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
		let attributes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
		let item: MaterialDataSourceItem = items![indexPath.section][indexPath.item]
		
		switch scrollDirection {
		case .Vertical:
			attributes.frame = CGRectMake(contentInset.left, offset.y, collectionView!.bounds.width - contentInset.left - contentInset.right, nil == item.size?.height ? collectionView!.bounds.height : item.size!.height)
		case .Horizontal:
			attributes.frame = CGRectMake(offset.x, contentInset.top, nil == item.size?.width ? collectionView!.bounds.width : item.size!.width, collectionView!.bounds.height - contentInset.top - contentInset.bottom)
		}
		
		return attributes
	}
	
	public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var layoutAttributes: Array<UICollectionViewLayoutAttributes> = Array<UICollectionViewLayoutAttributes>()
		for (attribute, _) in layoutItems {
			if CGRectIntersectsRect(rect, attribute.frame) {
				layoutAttributes.append(attribute)
			}
		}
		return layoutAttributes
	}
	
	public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
		return .Vertical == scrollDirection ? newBounds.width != collectionView!.bounds.width : newBounds.height != collectionView!.bounds.height
	}
	
	public override func collectionViewContentSize() -> CGSize {
		return contentSize
	}
	
	public override func prepareLayout() {
		let dataSource: MaterialCollectionViewDataSource = collectionView!.dataSource as! MaterialCollectionViewDataSource
		
		items = dataSource.items()
		layoutItems.removeAll()
		
		offset.x = contentInset.left
		offset.y = contentInset.top
		
		var indexPath: NSIndexPath?
		
		for var i: Int = 0, l: Int = items!.count - 1; i <= l; ++i {
			let v: Array<MaterialDataSourceItem> = items![i]
			for var j: Int = 0, k: Int = v.count - 1; j <= k; ++j {
				let item: MaterialDataSourceItem = v[j]
				indexPath = NSIndexPath(forItem: j, inSection: i)
				layoutItems.append((layoutAttributesForItemAtIndexPath(indexPath!)!, indexPath!))
				
				offset.x += spacing
				offset.x += nil == item.size?.width ? 0 : item.size!.width
				
				offset.y += spacing
				offset.y += nil == item.size?.height ? 0 : item.size!.height
			}
		}
		
		offset.x += contentInset.right - spacing
		offset.y += contentInset.bottom - spacing
		
		contentSize = .Vertical == scrollDirection ? CGSizeMake(collectionView!.bounds.width, offset.y) : CGSizeMake(offset.x, collectionView!.bounds.height)
	}
	
	public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
		return proposedContentOffset
	}
}
