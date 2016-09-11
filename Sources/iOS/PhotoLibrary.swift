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

import Photos

@objc(PhotoLibraryMove)
public class PhotoLibraryMove: NSObject {
    /// An index that is being moved from.
    public private(set) var from: Int
    
    /// An index that is being moved to.
    public private(set) var to: Int
    
    /**
     An initializer that accepts a `from` and `to` Int value.
     - Parameter from: An Int.
     - Parameter to: An Int.
     */
    public init(from: Int, to: Int) {
        self.from = from
        self.to = to
    }
}

public struct PhotoLibraryFetchResultDataSource {
    /// A reference to the PHFetchResults.
    public internal(set) var fetchResult: PHFetchResult<PHObject>
    
    /// A reference to the objects associated with the PHFetchResult.
    public internal(set) var objects: [PHObject]
}

@objc(PhotoLibraryDelegate)
public protocol PhotoLibraryDelegate {
    /**
     A delegation method that is executed when the PhotoLibrary status is updated.
     - Parameter photoLibrary: A reference to the PhotoLibrary.
     - Parameter status: A reference to the PHAuthorizationStatus.
     */
    @objc
    optional func photoLibrary(photoLibrary: PhotoLibrary, status: PHAuthorizationStatus)
    
    /**
     A delegation method that is executed when the PhotoLibrary is authorized.
     - Parameter photoLibrary: A reference to the PhotoLibrary.
     */
    @objc
    optional func photoLibrary(authorized photoLibrary: PhotoLibrary)
    
    /**
     A delegation method that is executed when the PhotoLibrary is denied.
     - Parameter photoLibrary: A reference to the PhotoLibrary.
     */
    @objc
    optional func photoLibrary(denied photoLibrary: PhotoLibrary)
    
    /**
     A delegation method that is executed when the PhotoLibrary is not determined.
     - Parameter photoLibrary: A reference to the PhotoLibrary.
     */
    @objc
    optional func photoLibrary(notDetermined photoLibrary: PhotoLibrary)
    
    /**
     A delegation method that is executed when the PhotoLibrary is restricted.
     - Parameter photoLibrary: A reference to the PhotoLibrary.
     */
    @objc
    optional func photoLibrary(restricted photoLibrary: PhotoLibrary)
    
    /**
     A delegation method that is executed when the PhotoLibrary has changes,
     locally or remotely.
     - Parameter photoLibrary: A reference to the PhotoLibrary.
     - Parameter changeInfo: A reference to a PHChange object.
     */
    @objc
    optional func photoLibrary(photoLibrary: PhotoLibrary, didChange changeInfo: PHChange)
    
    /**
     A delegation method that is executed when changes are detected.
     - Parameter photoLibrary: A reference to the PhotoLibrary.
     - Parameter beforeChanges: A PHObject before changes.
     - Parameter afterChanges: A PHObject after changes.
     - Parameter assetContentChanged: A Bool that is true if the image or video content for this
     object has changed.
     - Parameter objectWasDeleted: A Bool that is true if the object was deleted.
     */
    @objc
    optional func photoLibrary(photoLibrary: PhotoLibrary, beforeChanges: PHObject, afterChanges: PHObject, assetContentChanged: Bool, objectWasDeleted: Bool)
    
    /**
     A delegation method that is executed when there is a change in the
     fetchResult object.
     - Parameter photoLibrary: A reference to the PhotoLibrary.
     - Parameter fetchBeforeChanges: A PHFetchResult<PHObject> before changes.
     - Parameter fetchAfterChanges: A PHFetchResult<PHObject> after changes.
     changes exist. True if yes, false otherwise.
     */
    @objc
    optional func photoLibrary(photoLibrary: PhotoLibrary, fetchBeforeChanges: PHFetchResult<PHObject>, fetchAfterChanges: PHFetchResult<PHObject>)
    
    /**
     A delegation method that is executed when there are moved objects.
     - Parameter photoLibrary: A reference to the PhotoLibrary.
     - Parameter removed indexes: An IndexSet of the removed indexes.
     - Parameter for objects: An Array of PHObjects that have been removed.
     */
    @objc
    optional func photoLibrary(photoLibrary: PhotoLibrary, removed indexes: IndexSet, for objects: [PHObject])
    
    /**
     A delegation method that is executed when there are newly inserted objects.
     - Parameter photoLibrary: A reference to the PhotoLibrary.
     - Parameter inserted indexes: An IndexSet of the inserted indexes.
     - Parameter for objects: An Array of PHObjects that have been inserted.
     */
    @objc
    optional func photoLibrary(photoLibrary: PhotoLibrary, inserted indexes: IndexSet, for objects: [PHObject])
    
    /**
     A delegation method that is executed when there are changed objects.
     - Parameter photoLibrary: A reference to the PhotoLibrary.
     - Parameter changed indexes: An IndexSet of the changed indexes.
     - Parameter for objects: An Array of PHObjects that have been changed.
     */
    @objc
    optional func photoLibrary(photoLibrary: PhotoLibrary, changed indexes: IndexSet, for objects: [PHObject])
    
    /**
     A delegation method that is executed describing the removed, inserted
     and changed indexes.
     - Parameter photoLibrary: A reference to the PhotoLibrary.
     - Parameter removedIndexes: An IndexSet of the changed indexes.
     - Parameter insertedIndexes: An IndexSet of the inserted indexes.
     - Parameter changedIndexes: An IndexSet of the changed indexes.
     - Parameter has moves: An Array of move coordinates.
     */
    @objc
    optional func photoLibrary(photoLibrary: PhotoLibrary, removedIndexes: IndexSet?, insertedIndexes: IndexSet?, changedIndexes: IndexSet?, has moves: [PhotoLibraryMove])
}

@objc(PhotoLibrary)
public class PhotoLibrary: NSObject {
    /// A reference to the PHCachingImageManager.
    public internal(set) lazy var cachingImageManager = PHCachingImageManager()
    
    /// A reference to all current PHFetchResults.
    public internal(set) lazy var fetchResultsDataSource = [String: PhotoLibraryFetchResultDataSource]()
    
    /// A reference to a PhotoLibraryDelegate.
    open weak var delegate: PhotoLibraryDelegate?
    
    /// The current PHAuthorizationStatus.
    public var authorizationStatus: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    /// Deinitializer that unregisters itself from watching changes in the PHPhotoLibrary.
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    /// An initializer that prepares the PhotoLibrary.
    public override init() {
        super.init()
        prepare()
    }
    
    /// Prepare the instance object.
    private func prepare() {
        prepareChangeObservers()
    }
    
    /// Prepares the PHPhotoLibrary change observation.
    private func prepareChangeObservers() {
        PHPhotoLibrary.shared().register(self)
    }
}

/// Authorization.
extension PhotoLibrary {
    /**
     A method to request authorization from the user to enable photo library access. In order
     for this to work, set the "Privacy - Photo Library Usage Description" value in the
     application's info.plist.
     - Parameter _ completion: A completion block that passes in a PHAuthorizationStatus
     enum that describes the response for the authorization request.
     */
    public func requestAuthorization(_ completion: ((PHAuthorizationStatus) -> Void)? = nil) {
        PHPhotoLibrary.requestAuthorization { [weak self, completion = completion] (status) in
            DispatchQueue.main.async { [weak self, completion = completion] in
                guard let s = self else {
                    return
                }
                
                switch status {
                case .authorized:
                    s.delegate?.photoLibrary?(photoLibrary: s, status: .authorized)
                    s.delegate?.photoLibrary?(authorized: s)
                    completion?(.authorized)
                    
                case .denied:
                    s.delegate?.photoLibrary?(photoLibrary: s, status: .denied)
                    s.delegate?.photoLibrary?(denied: s)
                    completion?(.denied)
                    
                case .notDetermined:
                    s.delegate?.photoLibrary?(photoLibrary: s, status: .notDetermined)
                    s.delegate?.photoLibrary?(notDetermined: s)
                    completion?(.notDetermined)
                    
                case .restricted:
                    s.delegate?.photoLibrary?(photoLibrary: s, status: .restricted)
                    s.delegate?.photoLibrary?(restricted: s)
                    completion?(.restricted)
                }
            }
        }
    }
}

/// Fetch.
extension PhotoLibrary {
    /**
     Fetches generic type T for a given PHFetchResult<T>.
     - Parameter fetchResult: A PHFetchResult<T>.
     - Parameter completion: A completion block.
     */
    internal func fetch<T: PHObject, U: PHFetchResult<T>>(caller: String, result: U, completion: (([T], U) -> Void)? = nil) -> [T] {
        var objects = [T]()
        
        result.enumerateObjects({ (collection, _, _) in
            objects.append(collection)
        })
        
        // Used in change observation.
        fetchResultsDataSource[caller] = PhotoLibraryFetchResultDataSource(fetchResult: result as! PHFetchResult<PHObject>, objects: objects)
        
        if Thread.isMainThread {
            completion?(objects, result)
        } else {
            DispatchQueue.main.async { [objects = objects, result = result, completion = completion] in
                completion?(objects, result)
            }
        }
    
        return objects
    }
}

/// PHCollectionList.
extension PhotoLibrary {
    /**
     A PHAssetCollectionTypeMoment collection type will be contained 
     by a PHCollectionListSubtypeMomentListCluster and a 
     PHCollectionListSubtypeMomentListYear. Non-moment PHAssetCollections 
     will only be contained by a single collection list.
     - Parameter _ collection: A PHCollection.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion callback.
     */
    public func fetchCollectionListsContaining(_ collection: PHCollection, options: PHFetchOptions?, completion: (([PHCollectionList], PHFetchResult<PHCollectionList>) -> Void)? = nil) -> [PHCollectionList] {
        return fetch(caller: #function, result: PHCollectionList.fetchCollectionListsContaining(collection, options: options), completion: completion)
    }
    
    /**
     Fetch PHCollectionLists based on a type and subtype.
     - Parameter with type: A PHCollectionListType.
     - Parameter subtype: A PHCollectionListSubtype.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion callback.
     */
    public func fetchCollectionList(with type: PHCollectionListType, subtype: PHCollectionListSubtype, options: PHFetchOptions?, completion: (([PHCollectionList], PHFetchResult<PHCollectionList>) -> Void)? = nil) -> [PHCollectionList] {
        return fetch(caller: #function, result: PHCollectionList.fetchCollectionLists(with: type, subtype: subtype, options: options), completion: completion)
    }
    
    /**
     Fetch collection lists of a single type matching the 
     provided local identifiers (type is inferred from the 
     local identifiers).
     - Parameter withLocalIdentifier identifiers: An Array 
     of String identifiers.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion callback.
     */
    public func fetchCollectionLists(withLocalIdentifiers identifiers: [String], options: PHFetchOptions?, completion: (([PHCollectionList], PHFetchResult<PHCollectionList>) -> Void)? = nil) -> [PHCollectionList] {
        return fetch(caller: #function, result: PHCollectionList.fetchCollectionLists(withLocalIdentifiers: identifiers, options: options), completion: completion)
    }
    
    /**
     Fetch asset collections of a single type and subtype 
     provided (use PHCollectionListSubtypeAny to match all 
     subtypes).
     - Parameter with collectionListType: A PHCollectionListType.
     - Parameter subtype: A PHCollectionListSubtype.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion callback.
     */
    public func fetchCollectionLists(with collectionListType: PHCollectionListType, subtype: PHCollectionListSubtype, options: PHFetchOptions?, completion: (([PHCollectionList], PHFetchResult<PHCollectionList>) -> Void)? = nil) -> [PHCollectionList] {
        return fetch(caller: #function, result: PHCollectionList.fetchCollectionLists(with: collectionListType, subtype: subtype, options: options), completion: completion)
    }
    
    /**
     Fetch moment lists containing a given moment.
     - Parameter with momentListSubtype: A PHCollectionListSubtype.
     - Parameter containingMoment moment: A PHAssetCollection.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion callback.
     */
    public func fetchMomentLists(with momentListSubtype: PHCollectionListSubtype, containingMoment moment: PHAssetCollection, options: PHFetchOptions?, completion: (([PHCollectionList], PHFetchResult<PHCollectionList>) -> Void)? = nil) -> [PHCollectionList] {
        return fetch(caller: #function, result: PHCollectionList.fetchMomentLists(with: momentListSubtype, containingMoment: moment, options: options), completion: completion)
    }
    
    /**
     Fetch moment lists.
     - Parameter with momentListSubtype: A PHCollectionListSubtype.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion callback.
     */
    public func fetchMomentLists(with momentListSubtype: PHCollectionListSubtype, options: PHFetchOptions?, completion: (([PHCollectionList], PHFetchResult<PHCollectionList>) -> Void)? = nil) -> [PHCollectionList] {
        return fetch(caller: #function, result: PHCollectionList.fetchMomentLists(with: momentListSubtype, options: options), completion: completion)
    }
}

/// PHCollection.
extension PhotoLibrary {
    /**
     Fetches PHCollections in a given PHCollectionList.
     - Parameter in collectionList: A PHCollectionList.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion callback.
     */
    public func fetchCollections(in collectionList: PHCollectionList, options: PHFetchOptions?, completion: (([PHCollection], PHFetchResult<PHCollection>) -> Void)? = nil) -> [PHCollection] {
        return fetch(caller: #function, result: PHCollection.fetchCollections(in: collectionList, options: options), completion: completion)
    }
    
    /**
     Fetches PHCollections based on a type and subtype.
     - Parameter with type: A PHCollectionListType.
     - Parameter subtype: A PHCollectionListSubtype.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion callback.
     */
    public func fetchTopLevelUserCollections(with options: PHFetchOptions?, completion: (([PHCollection], PHFetchResult<PHCollection>) -> Void)? = nil) -> [PHCollection] {
        return fetch(caller: #function, result: PHCollection.fetchTopLevelUserCollections(with: nil), completion: completion)
    }
}

/// PHAssetCollection.
extension PhotoLibrary {
    /**
     Fetch asset collections of a single type matching the provided 
     local identifiers (type is inferred from the local identifiers).
     - Parameter withLocalIdentifiers identifiers: An Array of Strings.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion block.
     */
    public func fetchAssetCollections(withLocalIdentifiers identifiers: [String], options: PHFetchOptions?, completion: (([PHAssetCollection], PHFetchResult<PHAssetCollection>) -> Void)? = nil) -> [PHAssetCollection] {
        return fetch(caller: #function, result: PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: identifiers, options: options), completion: completion)
    }
    
    /**
     Fetch asset collections of a single type and subtype provided 
     (use PHAssetCollectionSubtypeAny to match all subtypes).
     - Parameter with type: A PHAssetCollectionType.
     - Parameter subtype: A PHAssetCollectionSubtype.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion block.
     */
    public func fetchAssetCollections(with type: PHAssetCollectionType, subtype: PHAssetCollectionSubtype, options: PHFetchOptions?, completion: (([PHAssetCollection], PHFetchResult<PHAssetCollection>) -> Void)? = nil) -> [PHAssetCollection] {
        return fetch(caller: #function, result: PHAssetCollection.fetchAssetCollections(with: type, subtype: subtype, options: options), completion: completion)
    }
    
    /**
     Smart Albums are not supported, only Albums and Moments.
     - Parameter asset: A PHAsset.
     - Parameter with type: A PHAssetCollectionType.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion block.
     */
    public func fetchAssetCollectionsContaining(_ asset: PHAsset, with type: PHAssetCollectionType, options: PHFetchOptions?, completion: (([PHAssetCollection], PHFetchResult<PHAssetCollection>) -> Void)? = nil) -> [PHAssetCollection] {
        return fetch(caller: #function, result: PHAssetCollection.fetchAssetCollectionsContaining(asset, with: type, options: options), completion: completion)
    }
    
    /**
     AssetGroupURLs are URLs retrieved from ALAssetGroup's 
     ALAssetsGroupPropertyURL.
     - Parameter withALAssetGroupURLs assetGroupURLs: An Array 
     of URLs.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion block.
     */
    public func fetchAssetCollections(withALAssetGroupURLs assetGroupURLs: [URL], options: PHFetchOptions?, completion: (([PHAssetCollection], PHFetchResult<PHAssetCollection>) -> Void)? = nil) -> [PHAssetCollection] {
        return fetch(caller: #function, result: PHAssetCollection.fetchAssetCollections(withALAssetGroupURLs: assetGroupURLs, options: options), completion: completion)
    }
    
    /**
     Fetches moments in a given moment list.
     - Parameter inMomentList momentList: A PHCollectionList.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion block.
     */
    public func fetchMoments(inMomentList momentList: PHCollectionList, options: PHFetchOptions?, completion: (([PHAssetCollection], PHFetchResult<PHAssetCollection>) -> Void)? = nil) -> [PHAssetCollection] {
        return fetch(caller: #function, result: PHAssetCollection.fetchMoments(inMomentList: momentList, options: options), completion: completion)
    }
    
    /**
     Fetches moments.
     - Parameter with options: An optional PHFetchOptions object.
     - Parameter completion: A completion block.
     */
    public func fetchMoments(with options: PHFetchOptions?, completion: (([PHAssetCollection], PHFetchResult<PHAssetCollection>) -> Void)? = nil) -> [PHAssetCollection] {
        return fetch(caller: #function, result: PHAssetCollection.fetchMoments(with: options), completion: completion)
    }
}

/// PHAsset.
extension PhotoLibrary {
    /**
     Fetch the PHAssets in a given PHAssetCollection.
     - Parameter in assetCollection: A PHAssetCollection.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion block.
     */
    public func fetchAssets(in assetCollection: PHAssetCollection, options: PHFetchOptions?, completion: (([PHAsset], PHFetchResult<PHAsset>) -> Void)? = nil) -> [PHAsset] {
        return fetch(caller: #function, result: PHAsset.fetchAssets(in: assetCollection, options: options), completion: completion)
    }
    
    /**
     Fetch the PHAssets with a given Array of identifiers.
     - Parameter withLocalIdentifiers identifiers: A Array of
     String identifiers.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion block.
     */
    public func fetchAssets(withLocalIdentifiers identifiers: [String], options: PHFetchOptions?, completion: (([PHAsset], PHFetchResult<PHAsset>) -> Void)? = nil) -> [PHAsset] {
        return fetch(caller: #function, result: PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: options), completion: completion)
    }
    
    /**
     Fetch key assets.
     - Parameter in assetCollection: A PHAssetCollection.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion block.
     - Returns: An optional PHFetchResult<PHAsset> object.
     */
    public func fetchKeyAssets(in assetCollection: PHAssetCollection, options: PHFetchOptions?, completion: (([PHAsset], PHFetchResult<PHAsset>) -> Void)? = nil) -> PHFetchResult<PHAsset>? {
        guard let fetchResult = PHAsset.fetchKeyAssets(in: assetCollection, options: options) else {
            return nil
        }
        let _: [PHAsset] = fetch(caller: #function, result: fetchResult, completion: completion)
        return fetchResult
    }
    
    /**
     Fetch a burst asset with a given burst identifier.
     - Parameter withBurstIdentifier burstIdentifier: A 
     PHAssetCollection.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion block.
     */
    public func fetchAssets(withBurstIdentifier burstIdentifier: String, options: PHFetchOptions?, completion: (([PHAsset], PHFetchResult<PHAsset>) -> Void)? = nil) -> [PHAsset] {
        return fetch(caller: #function, result: PHAsset.fetchAssets(withBurstIdentifier: burstIdentifier, options: options), completion: completion)
    }
    
    /**
     Fetches PHAssetSourceTypeUserLibrary assets by default (use 
     includeAssetSourceTypes option to override).
     - Parameter with options: An optional PHFetchOptions object.
     - Parameter completion: A completion block.
     */
    public func fetchAssets(with options: PHFetchOptions?, completion: (([PHAsset], PHFetchResult<PHAsset>) -> Void)? = nil) -> [PHAsset] {
        return fetch(caller: #function, result: PHAsset.fetchAssets(with: options), completion: completion)
    }
    
    /**
     Fetch the PHAssets with a given media type.
     - Parameter in mediaType: A PHAssetMediaType.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion block.
     */
    public func fetchAssets(with mediaType: PHAssetMediaType, options: PHFetchOptions?, completion: (([PHAsset], PHFetchResult<PHAsset>) -> Void)? = nil) -> [PHAsset] {
        return fetch(caller: #function, result: PHAsset.fetchAssets(with: mediaType, options: options), completion: completion)
    }
    
    /**
     AssetURLs are URLs retrieved from ALAsset's 
     ALAssetPropertyAssetURL.
     - Parameter withALAssetURLs assetURLs: An Array of URLs.
     - Parameter options: An optional PHFetchOptions object.
     - Parameter completion: A completion block.
     */
    public func fetchAssets(withALAssetURLs assetURLs: [URL], options: PHFetchOptions?, completion: (([PHAsset], PHFetchResult<PHAsset>) -> Void)? = nil) -> [PHAsset] {
        return fetch(caller: #function, result: PHAsset.fetchAssets(withALAssetURLs: assetURLs, options: options), completion: completion)
    }
}

/// PHImageManager.
extension PhotoLibrary {
    /**
     Retrieves an optional UIImage for a given PHAsset that allows for a targetSize
     and contentMode.
     - Parameter for asset: A PHAsset.
     - Parameter targetSize: A CGSize.
     - Parameter contentMode: A PHImageContentMode.
     - Parameter options: A PHImageRequestOptions.
     - Parameter completion: A completion block.
     - Returns: A PHImageRequestID.
     */
    public func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, completion: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) -> PHImageRequestID {
        return PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: completion)
    }
    
    /**
     Retrieves an optional Data object for a given PHAsset.
     - Parameter for asset: A PHAsset.
     - Parameter options: A PHImageRequestOptions.
     - Parameter completion: A completion block.
     - Returns: A PHImageRequestID.
     */
    public func requestImageData(for asset: PHAsset, options: PHImageRequestOptions?, completion: @escaping (Data?, String?, UIImageOrientation, [AnyHashable: Any]?) -> Void) -> PHImageRequestID {
        return PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: completion)
    }
    
    /**
     Cancels an image request for a given PHImageRequestID.
     - Parameter for requestID: A PHImageRequestID.
     */
    public func cancelImageRequest(for requestID: PHImageRequestID) {
        PHImageManager.default().cancelImageRequest(requestID)
    }
    
    /**
     Requests a live photo representation of the asset. With
     oportunistic (or if no
     options are specified), the resultHandler block may be
     called more than once (the first call may occur before
     the method returns). The PHImageResultIsDegradedKey key
     in the result handler's info parameter indicates when a
     temporary low-quality live photo is provided.
     - Parameter for asset: A PHAsset.
     - Parameter targetSize: A CGSize.
     - Parameter contentMode: A PHImageContentMode.
     - Parameter options: A PHImageRequestOptions.
     - Parameter completion: A completion block.
     - Returns: A PHImageRequestID.
     */
    @available(iOS 9.1, *)
    public func requestLivePhoto(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHLivePhotoRequestOptions?, completion: @escaping (PHLivePhoto?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        return PHImageManager.default().requestLivePhoto(for: asset, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: completion)
    }
    
    /**
     For playback only.
     - Parameter forVideo asset: A PHAsset.
     - Parameter options: A PHImageRequestOptions.
     - Parameter completion: A completion block.
     - Returns: A PHImageRequestID.
     */
    public func requestPlayerItem(forVideo asset: PHAsset, options: PHVideoRequestOptions?, completion: @escaping (AVPlayerItem?, [AnyHashable : Any]?) -> Swift.Void) -> PHImageRequestID {
        return PHImageManager.default().requestPlayerItem(forVideo: asset, options: options, resultHandler: completion)
    }
    
    /**
     Export.
     - Parameter forVideo asset: A PHAsset.
     - Parameter options: A PHImageRequestOptions.
     - Parameter completion: A completion block.
     - Returns: A PHImageRequestID.
     */
    public func requestExportSession(forVideo asset: PHAsset, options: PHVideoRequestOptions?, exportPreset: String, completion: @escaping (AVAssetExportSession?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        return PHImageManager.default().requestExportSession(forVideo: asset, options: options, exportPreset: exportPreset, resultHandler: completion)
    }
    
    /**
     For all other requests.
     - Parameter forVideo asset: A PHAsset.
     - Parameter options: A PHImageRequestOptions.
     - Parameter completion: A completion block.
     - Returns: A PHImageRequestID.
     */
    public func requestAVAsset(forVideo asset: PHAsset, options: PHVideoRequestOptions?, completion: @escaping (AVAsset?, AVAudioMix?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        return PHImageManager.default().requestAVAsset(forVideo: asset, options: options, resultHandler: completion)
    }
}

/// PHPhotoLibraryChangeObserver extension.
extension PhotoLibrary: PHPhotoLibraryChangeObserver {
    /**
     A delegation method that is fired when changes are made in the photo library.
     - Parameter _ changeInstance: A PHChange obejct describing the changes in the
     photo library.
     */
    public func photoLibraryDidChange(_ changeInfo: PHChange) {
        DispatchQueue.main.async { [weak self, changeInfo = changeInfo] in
            guard let s = self else {
                return
            }
            
            s.delegate?.photoLibrary?(photoLibrary: s, didChange: changeInfo)
            
            for (_, var dataSource) in s.fetchResultsDataSource {
                for i in 0..<dataSource.objects.count {
                    let object = dataSource.objects[i]
                    
                    guard let details = changeInfo.changeDetails(for: object) else {
                        continue
                    }
                    
                    guard let afterChanges = details.objectAfterChanges else {
                        continue
                    }
                    
                    dataSource.objects[i] = afterChanges
                    
                    s.delegate?.photoLibrary?(photoLibrary: s, beforeChanges: details.objectBeforeChanges, afterChanges: afterChanges, assetContentChanged: details.assetContentChanged, objectWasDeleted: details.objectWasDeleted)
                }
                
                if let details = changeInfo.changeDetails(for: dataSource.fetchResult) {
                    s.delegate?.photoLibrary?(photoLibrary: s, fetchBeforeChanges: details.fetchResultBeforeChanges, fetchAfterChanges: details.fetchResultAfterChanges)
                    
                    dataSource.fetchResult = details.fetchResultAfterChanges

                    guard details.hasIncrementalChanges else {
                        continue
                    }

                    let removedIndexes = details.removedIndexes
                    let insertedIndexes = details.insertedIndexes
                    let changedIndexes = details.changedIndexes
                
                    if nil != removedIndexes {
                        s.delegate?.photoLibrary?(photoLibrary: s, removed: removedIndexes!, for: details.removedObjects)
                    }

                    if nil != insertedIndexes {
                        s.delegate?.photoLibrary?(photoLibrary: s, inserted: insertedIndexes!, for: details.insertedObjects)
                    }

                    if nil != changedIndexes {
                        s.delegate?.photoLibrary?(photoLibrary: s, changed: changedIndexes!, for: details.changedObjects)
                    }

                    var moves = [PhotoLibraryMove]()

                    if details.hasMoves {
                        details.enumerateMoves { (from, to) in
                            moves.append(PhotoLibraryMove(from: from, to: to))
                        }
                    }
                    
                    s.delegate?.photoLibrary?(photoLibrary: s, removedIndexes: removedIndexes, insertedIndexes: insertedIndexes, changedIndexes: changedIndexes, has: moves)
                }
            }
        }
    }
}

/// Requesting changes.
extension PhotoLibrary {
    /**
     Performes an asynchronous change to the PHPhotoLibrary database.
     - Parameter _ block: A transactional block that ensures that
     all changes to the PHPhotoLibrary are atomic.
     - Parameter completion: A completion block that is executed once the
     transaction has been completed.
     */
    public func performChanges(_ block: @escaping () -> Void, completion: ((Bool, Error?) -> Void)? = nil) {
        PHPhotoLibrary.shared().performChanges(block, completionHandler: completion)
    }
}
