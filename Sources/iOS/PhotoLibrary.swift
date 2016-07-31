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

@objc(PhotoLibraryDelegate)
public protocol PhotoLibraryDelegate {
    /**
     A delegation method that is executed when the PhotoLibrary status is updated.
     - Parameter photoLibrary: A reference to the PhotoLibrary.
     - Parameter status: A reference to the AuthorizationStatus.
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
     Get changes objects in album.
     - Parameter photoLibrary: A reference to the PhotoLibrary.
     - Parameter object: A PHObject instance.
     */
    @objc
    optional func photoLibrary(photoLibrary: PhotoLibrary, afterChanges object: PHObject)
}

@objc(PhotoLibrary)
public class PhotoLibrary: NSObject {
    /// A reference to a PhotoLibraryDelegate.
    public weak var delegate: PhotoLibraryDelegate?
    
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
    
    /// A method used to prepare the instance object.
    public func prepare() {
        prepareChangeObservers()
    }
    
    /// A method used to enable change observation.
    public func prepareChangeObservers() {
        PHPhotoLibrary.shared().register(self)
    }
    
    /**
     A method to request authorization from the user to enable photo library access. In order
     for this to work, set the "Privacy - Photo Library Usage Description" value in the
     application's info.plist.
     - Parameter _ completion: A completion block that passes in a PHAuthorizationStatus
     enum that describes the response for the authorization request.
     */
    public func requestAuthorization(_ completion: ((PHAuthorizationStatus) -> Void)? = nil) {
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
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
    
    public func moments(in momentList: PHCollectionList, options: PHFetchOptions?) -> [PHAssetCollection] {
        var v = [PHAssetCollection]()
        PHAssetCollection.fetchMoments(inMomentList: momentList, options: options).enumerateObjects(options: EnumerationOptions.concurrent) { (collection, _, _) in
            v.append(collection)
        }
        return v
    }
    
    public func fetch(with type: PHAssetCollectionType, subtype: PHAssetCollectionSubtype, options: PHFetchOptions?) -> PHFetchResult<PHAssetCollection> {
        let result = PHAssetCollection.fetchAssetCollections(with: type, subtype: subtype, options: options)
        return result
    }
    
    public func performChanges(_ changeBlock: () -> Void, completionHandler: ((Bool, NSError?) -> Void)? = nil) {
        PHPhotoLibrary.shared().performChanges(changeBlock, completionHandler: completionHandler)
    }
    
    public func assets(in album: PHAssetCollection, options: PHFetchOptions?) -> [PHAsset] {
        var v = [PHAsset]()
        PHAsset.fetchAssets(in: album, options: options).enumerateObjects(options: []) { (asset, _, _) in
            v.append(asset)
        }
        return v
    }
    
    public func image(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, completion: (UIImage?, [NSObject: AnyObject]?) -> Void) -> PHImageRequestID {
        return PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: completion)
    }
    
    public func data(for asset: PHAsset, options: PHImageRequestOptions?, completion: (Data?, String?, UIImageOrientation, [NSObject: AnyObject]?) -> Void) -> PHImageRequestID {
        return PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: completion)
    }
    
    public func cancel(for requestID: PHImageRequestID) {
        PHImageManager.default().cancelImageRequest(requestID)
    }
}

/// Albums.
extension PhotoLibrary {
    /**
     Creates an album with a given title.
     - Parameter album title: A String.
     - Returns: A PHObjectPlaceholder.
     */
    public func create(album title: String) -> PHObjectPlaceholder {
        return PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title).placeholderForCreatedAssetCollection
    }
}

/// PHPhotoLibraryChangeObserver extension.
extension PhotoLibrary: PHPhotoLibraryChangeObserver {
    /**
     A delegation method that is fired when changes are made in the photo library.
     - Parameter _ changeInstance: A PHChange obejct describing the changes in the
     photo library.
     */
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        delegate?.photoLibrary?(photoLibrary: self, didChange: changeInstance)
    }
}
