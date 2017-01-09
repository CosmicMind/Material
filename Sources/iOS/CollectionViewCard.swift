/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

class CardCollectionViewCell: CollectionViewCell {
    open var card: Card? {
        didSet {
            oldValue?.removeFromSuperview()
            if let v = card {
                contentView.addSubview(v)
            }
        }
    }
}

@objc(CollectionViewCard)
open class CollectionViewCard: Card {
    /// A reference to the dataSourceItems.
    open var dataSourceItems = [DataSourceItem]()
    
    /// An index of IndexPath to DataSourceItem.
    open var dataSourceItemsIndexPaths = [IndexPath: Any]()
    
    /// A reference to the collectionView.
    @IBInspectable
    open let collectionView = CollectionView()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        reload()
    }
    
    open override func prepare() {
        super.prepare()
        pulseAnimation = .none
        
        prepareCollectionView()
        prepareContentView()
    }
    
    open override func reload() {
        if 0 == collectionView.height {
            var h: CGFloat = 0
            var i: Int = 0
            for dataSourceItem in dataSourceItems {
                h += dataSourceItem.height ?? (dataSourceItems[i].data as? Card)?.height ?? 0
                i += 1
            }
            collectionView.height = h
        }
        
        collectionView.reloadData()
        
        super.reload()
    }
}

extension CollectionViewCard {
    /// Prepares the collectionView.
    fileprivate func prepareCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.interimSpacePreset = .none
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCollectionViewCell")
    }
    
    /// Prepares the contentView.
    fileprivate func prepareContentView() {
        contentView = collectionView
    }
}

extension CollectionViewCard: CollectionViewDelegate {}

extension CollectionViewCard: CollectionViewDataSource {
    @objc
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @objc
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceItems.count
    }
    
    @objc
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
        cell.pulseAnimation = .none
        
        guard let card = dataSourceItems[indexPath.item].data as? Card else {
            return cell
        }
        
        dataSourceItemsIndexPaths[indexPath] = card
        
        if .vertical == self.collectionView.scrollDirection {
            card.width = cell.width
        } else {
            card.height = cell.height
        }
        
        cell.card = card
        
        return cell
    }
}
