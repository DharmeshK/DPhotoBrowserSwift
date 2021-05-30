//
//  DPhoto.swift
//  DPhotoBrowserSwift
//
//  Created by DK on 30/05/21.
//  Original obj-c created by Michael Waterfall 2013
//
//

import UIKit
import Photos
import SDWebImage

var PHInvalidImageRequestID = PHImageRequestID(0)

public class DPhoto: Photo {
    
    public var caption = ""
    public var emptyImage = true
    public var isVideo = false
    public var underlyingImage: UIImage?
    
    private let uuid = UUID().uuidString
    private var image: UIImage?
    private var photoURL: URL?
    private var asset: PHAsset?
    private var assetTargetSize = CGSize.zero
    
    private var loadingInProgress = false
    private var operation: SDWebImageDownloadToken?
    private var assetRequestID = PHInvalidImageRequestID
    
    //MARK: - Init
    
    public init() {}
    
    public convenience init(image: UIImage) {
        self.init()
        self.image = image
    }
    
    public convenience init(url: URL, caption: String) {
        self.init()
        self.photoURL = url
        self.caption = caption
    }
    
    public convenience init(url: URL) {
        self.init()
        self.photoURL = url
    }
    
    public convenience init(asset: PHAsset, targetSize: CGSize) {
        self.init()
        
        self.asset = asset
        assetTargetSize = targetSize
        isVideo = asset.mediaType == PHAssetMediaType.video
    }
    
    public convenience init(videoURL: URL) {
        self.init()
        
        self.videoURL = videoURL
        isVideo = true
        emptyImage = true
    }
    
    //MARK: - Video
    
    private var videoURL: URL?
    
    public func setVideoURL(url: URL?) {
        videoURL = url
        isVideo = true
    }
    
    public func getVideoURL(completion: @escaping (URL?) -> ()) {
        if let vurl = videoURL {
            completion(vurl)
        }
        else
        if let a = asset {
            if a.mediaType == PHAssetMediaType.video {
                let options = PHVideoRequestOptions()
                options.isNetworkAccessAllowed = true
                
                PHImageManager.default().requestAVAsset(forVideo: a,
                                                        options: options)
                { asset, audioMix, info in
                    if let urlAsset = asset as? AVURLAsset {
                        completion(urlAsset.url)
                    }
                    else {
                        completion(nil)
                    }
                }
            }
        }
        return completion(nil)
    }
    
    //MARK: - Photo Protocol Methods
    
    public func loadUnderlyingImageAndNotify() {
        assert(Thread.current.isMainThread, "This method must be called on the main thread.")
        
        if loadingInProgress {
            return
        }
        
        loadingInProgress = true
        
        //try {
        if underlyingImage != nil {
            imageLoadingComplete()
        }
        else {
            performLoadUnderlyingImageAndNotify()
        }
        //}
        //catch (NSException exception) {
        //    underlyingImage = nil
        //    loadingInProgress = false
        //    imageLoadingComplete()
        //}
    }
    
    // Set the underlyingImage
    public func performLoadUnderlyingImageAndNotify() {
        // Get underlying image
        if let img = image {
            // We have UIImage!
            underlyingImage = img
            imageLoadingComplete()
        }
        else
        if let purl = photoURL {
            // Check what type of url it is
            
//            if purl.scheme?.lowercased() == "assets-library" {
//                // Load from assets library
//                performLoadUnderlyingImageAndNotifyWithAssetsLibraryURL(url: purl)
//            }
//            else
            if purl.isFileURL {
                // Load from local file async
                performLoadUnderlyingImageAndNotifyWithLocalFileURL(url: purl)
            }
            else {
                // Load async from web (using SDWebImage)
                performLoadUnderlyingImageAndNotifyWithWebURL(url: purl)
            }
        }
        else
        if let a = asset {
            // Load from photos asset
            performLoadUnderlyingImageAndNotifyWithAsset(asset: a, targetSize: assetTargetSize)
        }
        else {
            // Image is empty
            imageLoadingComplete()
        }
    }
    
    func cancelDownload() {
        operation?.cancel()
    }
    
    // Load from local file
    private func performLoadUnderlyingImageAndNotifyWithWebURL(url: URL) {
        cancelDownload()
        
        /*
         progress: { receivedSize, expectedSize in
         if expectedSize > 0 {
         NotificationCenter.default.postNotificationName(
         DPhoto_PROGRESS_NOTIFICATION,
         object: [
         "progress": Float(receivedSize) / Float(expectedSize),
         "photo": self
         ])
         }
         },
         */
        operation = SDWebImageDownloader.shared.downloadImage(with: url, completed: { imageInstance, data, error, isDownloaded in
            DispatchQueue.main.async {
                if let ii = imageInstance {
                    self.underlyingImage = ii
                }
                self.imageLoadingComplete()
            }
        })
    }
    
    // Load from local file
    private func performLoadUnderlyingImageAndNotifyWithLocalFileURL(url: URL) {
        DispatchQueue.global(qos: .default).async {
            self.underlyingImage = UIImage(contentsOfFile: url.path)
            DispatchQueue.main.async {
                self.imageLoadingComplete()
            }
        }
    }
    
    // Load from asset library async
//    private func performLoadUnderlyingImageAndNotifyWithAssetsLibraryURL(url: URL) {
//        DispatchQueue.global(qos: .default).async {
//            let assetslibrary = ALAssetsLibrary()
//            assetslibrary.asset(
//                for: url,
//                resultBlock: { asset in
//                    let rep = asset?.defaultRepresentation()
//                    if let cgImage = rep?.fullScreenImage().takeRetainedValue() {
//                        self.underlyingImage = UIImage(cgImage: cgImage)
//                    }
//
//                    DispatchQueue.main.async {
//                        self.imageLoadingComplete()
//                    }
//                },
//                failureBlock: { error in
//                    self.underlyingImage = nil
//                    //DLog(@"Photo from asset library error: %@",error)
//                    DispatchQueue.main.async {
//                        self.imageLoadingComplete()
//                    }
//                })
//        }
//    }
    
    // Load from photos library
    private func performLoadUnderlyingImageAndNotifyWithAsset(asset: PHAsset, targetSize: CGSize) {
        let imageManager = PHImageManager.default()
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.resizeMode = .fast
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        options.progressHandler = { progress, error, stop, info in
            let dict:[String : Any] = [
                "progress" : progress,
                "photo" : self
            ]
            
            NotificationCenter.default.post(name: .DPhoto_PROGRESS_NOTIFICATION, object: dict)
        }
        
        assetRequestID = imageManager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: PHImageContentMode.aspectFit,
            options: options,
            resultHandler: { result, info in
                DispatchQueue.main.async {
                    self.underlyingImage = result
                    self.imageLoadingComplete()
                }
            })
    }
    
    // Release if we can get it again from path or url
    public func unloadUnderlyingImage() {
        loadingInProgress = false
        underlyingImage = nil
    }
    
    private func imageLoadingComplete() {
        assert(Thread.current.isMainThread, "This method must be called on the main thread.")
        
        // Complete so notify
        loadingInProgress = false
        
        // Notify on next run loop
        DispatchQueue.main.async {
            self.postCompleteNotification()
        }
    }
    
    private func postCompleteNotification() {
        NotificationCenter.default.post(name: .DPhoto_LOADING_DID_END_NOTIFICATION, object: self)
    }
    
    public func cancelAnyLoading() {
        if let op = operation {
            op.cancel()
            loadingInProgress = false
        }
        else
        if assetRequestID != PHInvalidImageRequestID {
            PHImageManager.default().cancelImageRequest(assetRequestID)
            assetRequestID = PHInvalidImageRequestID
        }
    }
    
    public func equals(photo: Photo) -> Bool {
        if let p = photo as? DPhoto {
            return uuid == p.uuid
        }
        
        return false
    }
}
