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
import Material

class RemindersItemsViewController: UIViewController {
    /// A reference to a RemindersDataSource.
    internal var dataSource: RemindersDataSource!
    
    /// A reference to the dateFormatter.
    internal var dateFormatter: DateFormatter!
    
    /// A collectionView used to display entries.
    internal var collectionView: RemindersItemsCollectionView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(dataSource: RemindersDataSource) {
        super.init(nibName: nil, bundle: nil)
        self.dataSource = dataSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        prepareDateFormatter()
        prepareNavigationItem()
        prepareCollectionView()
    }
    
    private func prepareNavigationItem() {
        navigationItem.title = dataSource.list.title
        navigationItem.detail = dataSource.list.source.title
        navigationItem.titleLabel.textColor = Color.blueGrey.base
        navigationItem.detailLabel.textColor = Color.blueGrey.lighten1
    }
    
    /// Prepares the collectionView.
    private func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.bounds.width, height: 88)
        
        collectionView = RemindersItemsCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        view.layout(collectionView).edges()
    }
    
    /// Prepares the dateFormatter.
    private func prepareDateFormatter() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
}

/// UICollectionViewDelegate methods.
extension RemindersItemsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


/// CollectionViewDataSource methods.
extension RemindersItemsViewController: UICollectionViewDataSource {
    /// Determines the number of items in the collectionView.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    /// Returns the number of sections.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.items.count
    }
    
    /// Prepares the cells within the collectionView.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RemindersItemsCollectionViewCell", for: indexPath) as! RemindersItemsCollectionViewCell
        
        let item = dataSource.items[indexPath.section]
        cell.textLabel.text = item.title
        
        return cell
    }
}
