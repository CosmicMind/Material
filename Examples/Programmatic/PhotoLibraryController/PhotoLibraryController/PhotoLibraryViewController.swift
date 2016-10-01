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
import Photos

public struct PhotoLibraryDataSource {
    /// A reference to a PHAssetCollection returned from the fetchResult.
    public private(set) var collection: PHAssetCollection
    
    /// A reference to an Array of PHAssets for the PHAssetCollection.
    public private(set) var assets: [PHAsset]
}

class PhotoLibraryViewController: PhotoLibraryController {
    /// A collectionView used to display entries.
    internal var collectionView: PhotoLibraryCollectionView!
    
    /// A reference to the images cache.
    internal lazy var images = [IndexPath: PHAsset]()
    
    /// A reference to the current collection.
    internal var currentDataSource: PhotoLibraryDataSource?
    
    /// The assets used in the album.
    public private(set) var dataSourceItems = [PhotoLibraryDataSource]() {
        willSet {
            guard .authorized == photoLibrary.authorizationStatus else {
                return
            }
            
            photoLibrary.cachingImageManager.stopCachingImagesForAllAssets()
        }
        
        didSet {
            guard .authorized == photoLibrary.authorizationStatus else {
                return
            }
            
            for dataSource in dataSourceItems {
                photoLibrary.cachingImageManager.startCachingImages(for: dataSource.assets, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil)
            }
        }
    }
    
    open override func prepare() {
        super.prepare()
        view.backgroundColor = Color.grey.lighten5
        
        prepareCollectionView()
        
        photoLibrary.requestAuthorization()
    }
    
    /**
     Fetch all the PHAssetCollections asynchronously based on a type and subtype.
     - Parameter type: A PHAssetCollectionType.
     - Parameter subtype: A PHAssetCollectionSubtype.
     - Parameter completion: A completion block.
     */
    internal func fetchAssetCollections(with type: PHAssetCollectionType, subtype: PHAssetCollectionSubtype, completion: @escaping ([PhotoLibraryDataSource]) -> Void) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let s = self else {
                return
            }
            
            let options = PHFetchOptions()
            options.includeHiddenAssets = true
            options.includeAllBurstAssets = true
            options.wantsIncrementalChangeDetails = true
            
            s.photoLibrary.fetchAssetCollections(with: type, subtype: subtype, options: options) { [weak self, completion = completion] (assetCollections, _) in
                guard let s = self else {
                    return
                }
                
                assetCollections.forEach { [weak self] (assetCollection) in
                    guard let s = self else {
                        return
                    }
                    
                    let options = PHFetchOptions()
                    let descriptor = NSSortDescriptor(key: "creationDate", ascending: false)
                    options.sortDescriptors = [descriptor]
                    options.includeHiddenAssets = true
                    options.includeAllBurstAssets = true
                    options.wantsIncrementalChangeDetails = true
                    
                    s.photoLibrary.fetchAssets(in: assetCollection, options: options) { [weak self] (assets, _) in
                        guard let s = self else {
                            return
                        }
                        s.dataSourceItems.append(PhotoLibraryDataSource(collection: assetCollection, assets: assets))
                    }
                }
                
                completion(s.dataSourceItems)
            }
        }
    }
    
    /// Prepares the collectionView.
    internal func prepareCollectionView() {
        let columns: CGFloat = .phone == Device.userInterfaceIdiom ? 3 : 11
        let w: CGFloat = (view.bounds.width - (columns - 1)) / columns
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: w, height: w)
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 44)
        layout.sectionHeadersPinToVisibleBounds = true
        
        collectionView = PhotoLibraryCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        view.layout(collectionView).edges()
    }
    
    /// Prepares dataSourceItems.
    internal func prepareDataSource(dataSource: PhotoLibraryDataSource) {
        DispatchQueue.main.async { [weak self] in
            guard let s = self else {
                return
            }
            s.collectionView.reloadData()
        }
    }
    
    /// Prepares the collection.
    internal func prepareCollection() {
        dataSourceItems.removeAll()
        
        fetchAssetCollections(with: .moment, subtype: .any) { [weak self] (assetCollections) in
            guard let s = self else {
                return
            }
            
            for dataSource in assetCollections {
                print(dataSource.collection.localizedTitle, dataSource.assets.count)
            }
            
            if let v = assetCollections.first {
                s.currentDataSource = v
                s.prepareDataSource(dataSource: v)
            }
        }
    }
}

extension PhotoLibraryViewController {
    func photoLibrary(photoLibrary: PhotoLibrary, didChange changeInfo: PHChange) {
        print("Did Change", changeInfo)
    }
    
    func photoLibrary(authorized photoLibrary: PhotoLibrary) {
        print("Authorized")
        prepareCollection()
    }
    
    func photoLibrary(denied photoLibrary: PhotoLibrary) {
        print("Denied")
    }
    
    func photoLibrary(notDetermined photoLibrary: PhotoLibrary) {
        print("notDetermined")
    }
    
    func photoLibrary(restricted photoLibrary: PhotoLibrary) {
        print("restricted")
    }
    
    func photoLibrary(photoLibrary: PhotoLibrary, status: PHAuthorizationStatus) {
        print("Status", status)
    }
    
    func photoLibrary(photoLibrary: PhotoLibrary, beforeChanges: PHObject, afterChanges: PHObject, assetContentChanged: Bool, objectWasDeleted: Bool) {
        print("Before", beforeChanges, "After", afterChanges, "Content Change", assetContentChanged, "Was Deleted", objectWasDeleted)
    }
    
    func photoLibrary(photoLibrary: PhotoLibrary, fetchBeforeChanges: PHFetchResult<PHObject>, fetchAfterChanges: PHFetchResult<PHObject>) {
        print("Fetch Before", fetchBeforeChanges, "Fetch After", fetchAfterChanges, "Has Incremental Changes")
    }
    
    func photoLibrary(photoLibrary: PhotoLibrary, removed indexes: IndexSet, for objects: [PHObject]) {
        print("Removed", indexes, objects)
    }
    
    func photoLibrary(photoLibrary: PhotoLibrary, inserted indexes: IndexSet, for objects: [PHObject]) {
        print("Inserted", indexes, objects)
    }
    
    func photoLibrary(photoLibrary: PhotoLibrary, changed indexes: IndexSet, for objects: [PHObject]) {
        print("Changed", indexes, objects)
    }
    
    func photoLibrary(photoLibrary: PhotoLibrary, removedIndexes: IndexSet?, insertedIndexes: IndexSet?, changedIndexes: IndexSet?, has moves: [PhotoLibraryMove]) {
        print("Removed", removedIndexes, "Inserted", insertedIndexes, "Changed", changedIndexes, "Moves", moves)
        
        if nil == removedIndexes && nil == insertedIndexes && nil == changedIndexes {
            return
        }
        
        prepareCollection()
    }
}

/// UICollectionViewDelegate methods.
extension PhotoLibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoLibraryCollectionViewCell", for: indexPath) as! PhotoLibraryCollectionViewCell
        
        let dataSource = dataSourceItems[indexPath.section]
        let asset = dataSource.assets[indexPath.item]
        
        print("Did Select DataSource:", dataSource, "Asset:", asset)
    }
}

/// CollectionViewDataSource methods.
extension PhotoLibraryViewController: UICollectionViewDataSource {
    /// Determines the number of items in the collectionView.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceItems[section].assets.count
    }
    
    /// Returns the number of sections.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSourceItems.count
    }
    
    /// Prepares the cells within the collectionView.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoLibraryCollectionViewCell", for: indexPath) as! PhotoLibraryCollectionViewCell
        
        let dataSource = dataSourceItems[indexPath.section]
        let asset = dataSource.assets[indexPath.item]
        
        if 0 != cell.tag {
            photoLibrary.cancelImageRequest(for: PHImageRequestID(cell.tag))
        }
        
        guard let itemSize = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize else {
            return cell
        }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true
        
        // Progress handler, called in an arbitrary serial queue. Only called
        // when the data is not available locally and is retrieved from iCloud.
        options.progressHandler = { (progress, error, stop, info) in
            print("Downloading from iCloud", progress, error, stop, info)
        }
        
        cell.tag = Int(photoLibrary.requestImage(for: asset, targetSize: itemSize, contentMode: .aspectFit, options: options) { (image, info) in
            cell.image = image
        })
        
        return cell
    }
    
    /// Prepares the header within the collectionView.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "PhotoLibraryCollectionReusableView", for: indexPath) as! PhotoLibraryCollectionReusableView
        
        let dataSource = dataSourceItems[indexPath.section]
        
        reusableview.toolbar.title = dataSource.collection.localizedTitle
        
        return reusableview
    }
}
