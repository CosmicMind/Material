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
	private var contentSize: CGSize = CGSizeZero
	private var layoutItems: Array<(UICollectionViewLayoutAttributes, NSIndexPath)>?
	public var height: CGFloat = 88
	public var offset: CGFloat = 0
	
	public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
		let attributes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
		
		let w: CGFloat = collectionView!.bounds.width
		let r: CGFloat = CGFloat(indexPath.row)
		let h: CGFloat = CGFloat(height)
		
		attributes.frame = CGRectMake(0, r * CGFloat(h + (0 < r ? offset : 0)), w, h)
		
		return attributes
	}
	
	public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var layoutAttributes: Array<UICollectionViewLayoutAttributes> = Array<UICollectionViewLayoutAttributes>()
		for (attribute, _) in layoutItems! {
			if CGRectIntersectsRect(rect, attribute.frame) {
				layoutAttributes.append(attribute)
			}
		}
		return layoutAttributes
	}
	
	public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
		return newBounds.width != collectionView!.bounds.width
	}
	
	public override func collectionViewContentSize() -> CGSize {
		return contentSize
	}
	
	public override func prepareLayout() {
		let dataSource: MaterialCollectionViewDataSource = collectionView!.dataSource as! MaterialCollectionViewDataSource
		let items: Array<AnyObject> = dataSource.items()
		
		layoutItems = Array<(UICollectionViewLayoutAttributes, NSIndexPath)>()
		
		var indexPath: NSIndexPath?
		var count: Int = 0
		for _ in items {
			indexPath = NSIndexPath(forItem: count++, inSection: 0)
			layoutItems?.append((layoutAttributesForItemAtIndexPath(indexPath!)!, indexPath!))
		}
		
		let w: CGFloat = collectionView!.bounds.width
		contentSize = CGSizeMake(w, CGFloat(layoutItems!.count) * (height + offset))
	}
	
	public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
		return proposedContentOffset
	}
	
	internal func indexPathsOfItemsInRect(rect: CGRect) -> Array<NSIndexPath> {
		var paths: Array<NSIndexPath> = Array<NSIndexPath>()
		for (attribute, indexPath) in layoutItems! {
			if CGRectIntersectsRect(rect, attribute.frame) {
				paths.append(indexPath)
			}
		}
		return paths
	}
}
