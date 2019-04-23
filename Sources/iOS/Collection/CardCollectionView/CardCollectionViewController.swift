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

extension UIViewController {
  /**
   A convenience property that provides access to the CardCollectionViewController.
   This is the recommended method of accessing the CardCollectionViewController
   through child UIViewControllers.
   */
  public var cardCollectionViewController: CardCollectionViewController? {
    return traverseViewControllerHierarchyForClassType()
  }
}

open class CardCollectionViewController: ViewController {
  /// A reference to a Reminder.
  public let collectionView = CollectionView()
  
  open var dataSourceItems = [DataSourceItem]()
  
  /// An index of IndexPath to DataSourceItem.
  open var dataSourceItemsIndexPaths = [IndexPath: Any]()
  
  open override func prepare() {
    super.prepare()
    prepareCollectionView()
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    layoutCollectionView()
  }
}

extension CardCollectionViewController {
  /// Prepares the collectionView.
  fileprivate func prepareCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCollectionViewCell")
    view.addSubview(collectionView)
    layoutCollectionView()
  }
}

extension CardCollectionViewController {
  /// Sets the frame for the collectionView.
  fileprivate func layoutCollectionView() {
    collectionView.frame = view.bounds
  }
}

extension CardCollectionViewController: CollectionViewDelegate {}

extension CardCollectionViewController: CollectionViewDataSource {
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
    
    guard let card = dataSourceItems[indexPath.item].data as? Card else {
      return cell
    }
    
    dataSourceItemsIndexPaths[indexPath] = card
    
    card.frame = cell.bounds
    
    cell.card = card
    
    return cell
  }
}

